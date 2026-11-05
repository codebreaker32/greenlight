# Project: finance reconciliation v2

- owner: Alex (Finance)
- status: planned
- dates: Dec 1 to Dec 19
- service: `finance-reports`
- files being changed: `finance-reports/reconciliation/`

## What it does

Rebuilds the daily reconciliation report so it can read settlement files from more than one payment provider.

## Clash notes

- Today the report reads **one** settlement source. A second gateway adds a second source that must be reconciled by hand until v2 ships.
