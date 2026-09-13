# Saudi_FinHub_Project

## Input Schema - Mashael
The cleaned stock dataset is validated using the following schema:

- `symbol`: string, required
- `date`: datetime, required
- `open`: float, required, greater than 0
- `high`: float, required, greater than 0
- `low`: float, required, greater than 0
- `close`: float, required, greater than 0
- `adj_close`: float, required, greater than 0
- `volume`: integer, required, greater than or equal to 0

The dataset covers the period from 2013-01-01 to 2026-03-31 and includes five stock symbols: 1120, 1211, 2010, 2280, and 7010.

All rows passed the validation checks, so no rows were rejected.