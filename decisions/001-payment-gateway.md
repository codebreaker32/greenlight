# Decision 001: Add a second payment gateway

> Example record for the demo. In the real flow, vote-agent writes this file.

- id: 001
- proposer: Bhawna
- status: approved
- decided: 2026-11-06
- idea room: idea-001-payment-gateway
- idea: ideas/001/idea.md

## Idea
Add a second payment gateway at checkout, so customers can pay with a provider we don't support yet.

## Review verdicts
- Policy: ⚠ Needs a security review and a PCI DSS compliant provider (POL-SEC-01)
- Conflict: ⚠ Aman's payment-service refactor changes payment-service/gateway/ until Nov 20
- Impact: Aman high (his service and refactor), Alex medium (second settlement source), Riya low (refund steps change)
- Feasibility: ✅ About 2 weeks, easier on the refactor's shared interface

## Participants
- Bhawna: proposer, weight 1
- Aman: joined, weight 4 (high impact + senior)
- Alex: joined, weight 2 (medium impact)
- Riya: joined, weight 1 (low impact)

## Votes
- Aman: approve (after the refactor)
- Alex: approve
- Riya: changes: add the new refund steps to the support playbook before launch
- Bhawna: approve
- Total: approve 7 · reject 0 · changes 1 (of 8)

## Decision
Approved. Build the second gateway after the payment-service refactor, on its shared payment interface.

## Reasons
- Customers are asking for this provider
- Waiting for the refactor removes the clash and makes the work smaller
- Policy concerns are handled by a security review before launch

## Timeline
- 2026-11-06 10:02 proposed
- 2026-11-06 10:05 reviewed
- 2026-11-06 10:07 room opened
- 2026-11-06 10:21 vote closed

## Action items
- Aman: finish the refactor and share the payment interface (by Nov 20)
- Bhawna: pick a PCI DSS compliant provider and book the security review (by Nov 22)
- Bhawna: build the gateway on the shared interface (Nov 23 to Dec 6)
- Alex: add the second settlement source to reconciliation v2 (by Dec 19)
- Riya: add the new refund steps to the support playbook (before launch)
