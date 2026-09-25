# Synapse Serverless SQL

SQL scripts for the Synapse Serverless SQL pool.

## Structure

- `cleanup/00_cleanup_old_warehouse.sql` — one-time cleanup of the deleted Dedicated Pool schemas
- `views/data_model.sql` — creates `dw.DimDate`, `dw.DimCurrency`, `dw.Fact_Stock_Market`, `dw.Fact_Currency`, `dw.Fact_Economic`
- `validation/relationship_checks.sql` — confirms fact/dimension integrity

## Connection

- Endpoint: `sfh-synapse-ondemand.sql.azuresynapse.net`
- Database: `SaudiFinHubServerless`
- Authentication: Entra ID

## Deployment order

1. Run `cleanup/00_cleanup_old_warehouse.sql` (only once — obsolete after the Dedicated Pool is gone).
2. Run `views/data_model.sql` to create or recreate the views.
3. Run `validation/relationship_checks.sql` to verify relationships.

All four validation counters must return `0`.
