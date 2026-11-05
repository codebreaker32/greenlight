# ideas/

Juno creates one folder per idea: `ideas/<id>/`.

## `idea.md`

```
# Idea <id>: <title>

- proposer: <name>
- created: <YYYY-MM-DD HH:MM>
- idea room: idea-<id>-<slug>

## What
<2-4 sentences, in the proposer's words, refined with Juno>

## Why
<1-2 sentences>
```

## `review.md`

```
# Review for idea <id>

## rules-agent
- Policy: ✅/⚠/❌ <one line>
- Conflict: ✅/⚠/❌ <one line>

## impact-agent
- Impact: <name> high|medium|low|none (<why>), ...
- Feasibility: ✅/⚠/❌ <estimate>

## Verdict
- size: small | big
- blockers: <none | list>
- affected (to invite): <names with medium/high, plus low if the proposer agreed>

## Participants
- <proposer>: proposer
- <name>: accepted
- <name>: declined
```

## `votes.md`

Vote-agent keeps the running tally here (one line per participant: name, weight, vote, reason).
