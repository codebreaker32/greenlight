# Sample ideas for the demo

## Big change (full flow: review, invites, vote)

Bhawna, in her personal room with Juno:

> Can I add another payment gateway? Some customers want to pay with a provider we don't support yet.

Expected reviews:
- rules-agent
  - Policy ⚠: needs a security review and a PCI DSS compliant provider (POL-SEC-01)
  - Conflict ⚠: Aman's payment-service refactor changes `payment-service/gateway/` until Nov 20
- impact-agent
  - Impact: Aman high (his refactor and service), Alex medium (second settlement source), Riya low (refund steps change for new-gateway orders)
  - Feasibility ✅: about 2 weeks, easier after the refactor's shared interface
- Result: big change, so a vote is needed

## Small change (fast path: no room, no vote)

Bhawna, in her personal room with Juno:

> Can I fix the typo on the checkout button? It says "Procede to payment".

Expected reviews:
- rules-agent: Policy ✅ (own team only, POL-CHG-02), Conflict ✅ (checkout redesign is Bhawna's own project)
- impact-agent: Impact: nobody medium or high; Riya low at most (screenshots in the support playbook). Feasibility ✅: under an hour
- Result: small change. Juno says go ahead and asks whether to let Riya know.
