# Decision 001: Add a second payment gateway

> Example record for the demo, based on the Parcelwise demo company. In the real flow, vote-agent writes this file and pushes it.

- id: 001
- proposer: Aman
- status: approved
- decided: 2026-11-06
- idea room: idea-001-payment-gateway
- idea: ideas/001/idea.md

## Idea
Add a second payment gateway at checkout, so customers can pay with a provider Parcelwise doesn't support yet (for example UPI-friendly providers).

## Review verdicts
- Policy: ⚠ Security review + PCI DSS Level 1 provider (security-review.md, pci-dss.md); Finance approval for a new vendor, 2% fee rule still OPEN (vendor-approval.md)
- Conflict: ⚠ Bhawna's provider refactor (PR #2) changes payment-gateway/ and checkout until Nov 18; change freeze Nov 20–30 (change-freeze.md)
- Impact: Bhawna high (owns payment-gateway/, refactor PR #2), Dev medium (second payout file to reconcile), Riya low (refund steps change)
- Feasibility: ⚠ About 2 weeks on the shared interface; start after Nov 18 and after the freeze

## Participants
- Aman: proposer, weight 1
- Bhawna: joined, weight 4 (high impact + lead)
- Dev: joined, weight 2 (medium impact)
- Riya: joined, weight 1 (low impact)

## Votes
- Bhawna: approve (after the refactor and the freeze)
- Dev: approve
- Riya: changes: add the new refund steps to the support playbook before launch
- Aman: approve
- Total: approve 7 · reject 0 · changes 1 (of 8)

## Decision
Approved. Build the second gateway on the refactor's shared payment interface, starting after the Nov 20–30 change freeze.

## Reasons
- Customers are asking for another way to pay
- Waiting for the refactor removes the clash and makes the work smaller
- Policy concerns are handled by a security review, a PCI DSS Level 1 provider and Finance approval before launch

## Open questions settled in the room
- Which gateway: shortlist Razorpay and PayU; Aman compares fees and UPI support
- When: after the freeze (Dec 1 start)
- 2% vendor rule: still open; Dev to confirm with the founders before the contract

## Timeline
- 2026-11-06 10:02 proposed
- 2026-11-06 10:05 reviewed
- 2026-11-06 10:07 room opened
- 2026-11-06 10:21 vote closed

## Action items
- Bhawna: finish the refactor and merge PR #2 (by Nov 18)
- Aman: pick a PCI DSS Level 1 provider and book the security review (by Nov 22)
- Dev: approve the vendor and confirm the 2% rule (by Nov 28)
- Aman + Bhawna: build the gateway on the shared interface (Dec 1 to Dec 12)
- Dev: add the second payout file to reconciliation (by Dec 19)
- Riya: add the new refund steps to the support playbook (before launch)
