# Sample ideas for the demo

Both ideas are about the [Parcelwise](https://github.com/codebreaker32/parcelwise) demo company. Aman proposes them in his personal room with Juno.

## Big change (full flow: review, invites, vote)

> Can I add another payment gateway? Some customers want to pay with a provider we don't support yet, like a UPI-friendly one.

Expected reviews:
- rules-agent
  - Policy ⚠: security review + PCI DSS Level 1 provider (`policies/security-review.md`, `pci-dss.md`); Finance approval for a new vendor, and the 2% fee rule is still OPEN (`vendor-approval.md`)
  - Conflict ⚠: Bhawna's provider refactor (open PR #2) changes `payment-gateway/` and checkout until Nov 18; change freeze on `payment-gateway/` Nov 20–30
- impact-agent
  - Impact: Bhawna high (owns `payment-gateway/`, refactor PR #2), Alex medium (second payout file to reconcile), Riya low (refund steps change for new-gateway orders). Dev isn't listed: the mobile app pays through web checkout.
  - Feasibility ⚠: about 2 weeks on the shared interface; start after the refactor and the freeze
- Result: big change, so invites and a vote are needed. Open questions for the room: which gateway, when, who maintains it (`parcelwise/docs/open-questions.md`).

## Small change (fast path: no room, no vote)

> Can I fix the typo on the checkout pay button? It says "Procede to payment".

Expected reviews:
- rules-agent: Policy ✅ (no rule applies; the Nov 20–30 freeze hasn't started), Conflict ✅ (the checkout redesign is Aman's own project)
- impact-agent: Impact: nobody medium or high (`frontend/` is Aman's own folder); Riya low at most (screenshots in the support playbook). Feasibility ✅: under an hour
- Result: small change. Juno says go ahead and asks whether to let Riya know.
