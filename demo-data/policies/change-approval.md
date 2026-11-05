# Policy: cross-team change approval

- id: POL-CHG-02
- owner: Engineering leads

## Rules

1. A change that touches **another team's service or process** needs agreement from that team before work starts.
2. A change that only touches your own team's code (copy, styling, small bug fixes) needs **no** extra approval.
3. Decisions must be written down where the whole project can find them (in Greenlight: `decisions/`).

## What a reviewer should say

- Touches another team, no agreement yet: ⚠ Needs attention (that is what the Greenlight vote is for)
- Only touches your own team: ✅ OK
