# Tests — Not Used

This folder is intentionally empty.

## Why

There is no Python code in this project to test. The production pipeline
runs in Azure Data Factory, and its validation is handled by:

- **ADF Data Flow** validation rules — see `adf/dataflow/DF_Currency_Transform.json`
- **Synapse relationship checks** — see `synapse/validation/relationship_checks.sql`

## Where verification happens

| Layer | Verification method |
|---|---|
| ADF transformations | Conditional Split routes bad rows to the rejected sink |
| ADF pipeline execution | ADF Monitor — activity status and row counts |
| Synapse data integrity | `relationship_checks.sql` — all counters must return 0 |

## What this folder is not

- It is not a Python test suite.
- It is not used by any deployed component.
