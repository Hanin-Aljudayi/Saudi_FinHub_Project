"""
Saudi FinHub — Synapse Data Validation
=======================================

Runs the relationship validation query against Synapse Serverless and
prints the result. This confirms that every fact row has a matching
dimension row (no orphan keys).

Requires:
    pip install pyodbc

Environment:
    Set SYNAPSE_PASSWORD or use Azure CLI authentication.

Not part of production. Production validation runs in the Synapse
workspace. See synapse/validation/relationship_checks.sql.
"""

import os
import sys

import pyodbc

SYNAPSE_SERVER = "sfh-synapse-ondemand.sql.azuresynapse.net"
SYNAPSE_DATABASE = "SaudiFinHubServerless"

VALIDATION_QUERY = """
SELECT
    (SELECT COUNT(*) FROM dw.Fact_Stock_Market f
     LEFT JOIN dw.DimDate d ON f.date_key = d.date_key
     WHERE d.date_key IS NULL) AS missing_stock_dates,

    (SELECT COUNT(*) FROM dw.Fact_Currency f
     LEFT JOIN dw.DimDate d ON f.date_key = d.date_key
     WHERE d.date_key IS NULL) AS missing_currency_dates,

    (SELECT COUNT(*) FROM dw.Fact_Currency f
     LEFT JOIN dw.DimCurrency c ON f.currency_key = c.currency_key
     WHERE c.currency_key IS NULL) AS missing_currency_keys,

    (SELECT COUNT(*) FROM dw.Fact_Economic f
     LEFT JOIN dw.DimDate d ON f.date_key = d.date_key
     WHERE d.date_key IS NULL) AS missing_economic_dates;
"""


def build_connection_string() -> str:
    """Build an ODBC connection string using Azure AD authentication."""
    driver = "{ODBC Driver 18 for SQL Server}"
    return (
        f"DRIVER={driver};"
        f"SERVER={SYNAPSE_SERVER};"
        f"DATABASE={SYNAPSE_DATABASE};"
        f"Authentication=ActiveDirectoryInteractive;"
        f"Encrypt=yes;"
        f"TrustServerCertificate=no;"
    )


def run_validation() -> int:
    """Run the validation query and print the result. Returns 0 on success."""
    print("Connecting to Synapse Serverless...")
    with pyodbc.connect(build_connection_string()) as conn:
        cursor = conn.cursor()
        print("Running relationship validation...")
        cursor.execute(VALIDATION_QUERY)

        row = cursor.fetchone()
        columns = [c[0] for c in cursor.description]
        results = dict(zip(columns, row))

        print("\nResult:")
        print("-" * 40)
        all_ok = True
        for name, value in results.items():
            status = "OK" if value == 0 else "FAIL"
            if value != 0:
                all_ok = False
            print(f"  {name:30s} {value:>6}  {status}")

        print("-" * 40)
        if all_ok:
            print("All relationships are valid.")
            return 0
        print("Validation failed — orphan keys found.")
        return 1


if __name__ == "__main__":
    try:
        sys.exit(run_validation())
    except Exception as exc:
        print(f"Error: {exc}", file=sys.stderr)
        sys.exit(2)
