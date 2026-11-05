# Policy: payments security

- id: POL-SEC-01
- owner: Security team

## Rules

1. Any new payment provider or gateway needs a **security review** before it goes live.
2. The provider must be **PCI DSS compliant** (Level 1 for card data). Ask for the provider's attestation of compliance.
3. Card data must never be stored by us. Use the provider's hosted fields or tokens.
4. API keys for providers live in the secrets manager, never in code or config files.

## What a reviewer should say

- New gateway, no security review planned: ⚠ Needs attention
- Provider is not PCI DSS compliant, or we would store card data: ❌ Blocker
