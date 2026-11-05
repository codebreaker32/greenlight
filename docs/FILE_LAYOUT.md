# File layout

Greenlight keeps all shared context in files. Switch context stops at the room, so agents share what they know by reading and writing these files, never by reading someone's personal room.

On the VM the repo is at `~/work/greenlight/`. Agents read and write there.

```
people/<name>.md              one file per person: role, seniority, team, current work, Slack username
demo-data/policies/*.md       company rules (read by rules-agent)
demo-data/projects/*.md       ongoing work: owner, services, files, dates (read by rules-agent and impact-agent)
demo-data/sample-ideas.md     ideas to type in the demo (big one + small one)
ideas/<id>/idea.md            the refined idea (written by juno)
ideas/<id>/review.md          the combined review + impact levels + small/big verdict (written by juno)
decisions/<id>-<slug>.md      the final decision record (written by vote-agent, or by juno for fast-track)
agents/<name>.md              role instructions for each Switch agent
templates/greenlight.template.yaml   Switch template (agents + rooms)
docs/VOTING.md                how joining and voting work
docs/DECISION_FORMAT.md       the decision record format
docs/DEMO_SCRIPT.md           the 3-minute demo
```

## IDs and names

- Idea IDs are 3 digits, counting up: `001`, `002`, … Juno picks the next free number in `ideas/`.
- The slug is 2–4 lowercase words joined by `-`, e.g. `payment-gateway`.
- The idea room in Slack is `idea-<id>-<slug>`, e.g. `idea-001-payment-gateway`.
- Decision file: `decisions/001-payment-gateway.md`.

## Who writes what

| File | Written by | Read by |
|---|---|---|
| `people/*`, `demo-data/*` | us (by hand) | all agents |
| `ideas/<id>/idea.md` | juno | rules-agent, impact-agent, vote-agent |
| `ideas/<id>/review.md` | juno | vote-agent |
| `decisions/*` | vote-agent (juno for fast-track) | juno (questions about past decisions) |

## Privacy rule

`people/*.md` holds only work facts (role, team, projects). Nothing said in a personal room is written to these files. `ideas/<id>/idea.md` holds only what the proposer agreed to share when the idea room was opened.
