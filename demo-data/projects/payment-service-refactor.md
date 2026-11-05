# Project: payment-service refactor

- owner: Aman (Payments backend)
- status: in progress, this sprint
- dates: Nov 3 to Nov 20
- service: `payment-service`
- files being changed: `payment-service/gateway/`, `payment-service/refunds/`, `payment-service/api/charge.ts`

## What it does

Splits the single gateway client into a shared payment interface, so later gateways plug in without touching core code.

## Clash notes

- Any other change to `payment-service/gateway/` before Nov 20 will clash.
- A new gateway built **after** the refactor can use the new shared interface.
