/*
===========================================================
Saudi FinHub - Old Warehouse Cleanup
===========================================================

Purpose:
    Remove the old Warehouse objects so the new Data Model
    can be built from a clean environment.

Deleted:
    1. Old DW fact tables
    2. Old DW dimension tables
    3. Old staging tables
    4. Old DW schema
    5. Old STG schema

NOT deleted:
    - Synapse Workspace
    - Dedicated SQL Pool
    - ADLS data
    - ADF pipelines
    - System schemas
===========================================================
*/

/*
-----------------------------------------------------------
1. Drop old Fact Tables
-----------------------------------------------------------
*/

DROP TABLE dw.FactCurrencyDaily;
DROP TABLE dw.FactCurrencyQuarterly;
DROP TABLE dw.FactEconomicQuarterly;
DROP TABLE dw.FactStockDaily;
DROP TABLE dw.FactStockQuarterly;

/*
-----------------------------------------------------------
2. Drop old Dimension Tables
-----------------------------------------------------------
*/
DROP TABLE dw.DimCompany;
DROP TABLE dw.DimCurrency;
DROP TABLE dw.DimDate;
DROP TABLE dw.DimQuarter;

/*
-----------------------------------------------------------
3. Drop old Staging Tables
-----------------------------------------------------------
*/

DROP TABLE stg.CurrencyDaily;
DROP TABLE stg.CurrencyQuarterly;
DROP TABLE stg.EconomicQuarterly;
DROP TABLE stg.StockDaily;
DROP TABLE stg.StockQuarterly;
/*
-----------------------------------------------------------
4. Drop old Warehouse Schemas
-----------------------------------------------------------
The tables above must be removed before their schemas
can be dropped.
*/

DROP SCHEMA stg;
DROP SCHEMA dw;
/*
===========================================================
Cleanup completed
The Warehouse is now ready to be rebuilt from scratch
based on the new Data Model
===========================================================
*/