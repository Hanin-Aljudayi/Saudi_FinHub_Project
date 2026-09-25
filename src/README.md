# Python Source — Not Used

This folder is intentionally empty.

## Why

The production pipeline runs in **Azure Data Factory**:

- `adf/pipeline/PL_MAIN_ORCHESTRATE.json`
- `adf/pipeline/PL_Currency_Ingestion.json`
- `adf/pipeline/PL_Stock.json`
- `adf/pipeline/PL_Economic.json`

The production transformations run in **ADF Data Flows**:

- `adf/dataflow/DF_Currency_Transform.json`
- `adf/dataflow/DF_Stock_Transform.json`
- `adf/dataflow/DF_Economic_Transform.json`

The production query layer runs in **Synapse Serverless**:

- `synapse/views/data_model.sql`

## Where the exploration lives

The data exploration that informed the pipeline design is in:

- `notebooks/` — profiling, cleaning, and transformation experiments

## Where the project is documented

- `README.md` — project overview and architecture
- `config.yaml` — sources, paths, and pipeline references

## What this folder is not

- It is not a Python implementation of the pipeline.
- It is not a fallback for ADF.
- It is not used by any deployed component.
