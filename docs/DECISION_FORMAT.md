# Decision record format

Every idea ends with one file: `decisions/<id>-<slug>.md`. This is the "main project" record. Juno reads these files to answer questions about past decisions. The agent that writes it also commits and pushes it, so it shows up on GitHub.

- **Written by:** vote-agent (approved / rejected / changes) or Juno (fast-track)
- **Filled example:** [decisions/001-payment-gateway.md](../decisions/001-payment-gateway.md)

## Template

```
# Decision <id>: <title>

- id: <id>
- proposer: <name>
- status: approved | rejected | changes | fast-track
- decided: <YYYY-MM-DD>
- idea room: idea-<id>-<slug>
- idea: ideas/<id>/idea.md

## Idea
<2-3 sentences>

## Review verdicts
- Policy: ✅/⚠/❌ <one line>
- Conflict: ✅/⚠/❌ <one line>
- Impact: <name> high|medium|low, ...
- Feasibility: ✅/⚠/❌ <estimate>

## Participants
- <name>: joined, weight <n> (<why>)
- <name>: declined / no answer

## Votes
- <name>: approve | reject: <reason> | changes: <what>
- Total: approve <w> · reject <w> · changes <w> (of <total>)

## Decision
<one line: what was decided>

## Reasons
- <bullet>

## Timeline
- <YYYY-MM-DD HH:MM> proposed
- <...> reviewed
- <...> room opened
- <...> vote closed

## Action items
- <who>: <what> (by <date>)
```

For **fast-track**, the "Participants" and "Votes" sections say `none (small change)`, and "Reasons" lists why the change counted as small.

## Post in #greenlight

Vote-agent posts a short version in the common room. It uses bullets, no tables, and names without `@`:

```
Decision 001: Add a second payment gateway: APPROVED (7 of 8 weight)
- Start after Bhawna's provider refactor (Nov 18) and the change freeze (Nov 20–30)
- Security review + PCI DSS provider required
- Actions: Aman picks the provider and books the security review, Bhawna builds it on the shared interface, Alex adds the second payout file to reconciliation, Riya updates refund steps
- Full record: decisions/001-payment-gateway.md
```
