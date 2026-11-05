# Demo script (3 minutes)

The story: Bhawna (checkout developer) wants to add a payment gateway. Aman (senior backend, project owner), Alex (finance) and Riya (support) are affected.

## Before recording

- [ ] Switch Console is open, and the server is running on the VM
- [ ] Warm up all 4 agents, so viewers don't see "Starting a session to handle this — one moment.":
  - `@juno ping`
  - `@rules-agent ping`
  - `@impact-agent ping`
  - `@vote-agent ping`
- [ ] `people/*.md` has real Slack usernames for everyone in the demo
- [ ] Delete any old `ideas/001/` and `decisions/001-*` from the VM checkout (keep the repo's example)
- [ ] Screens ready: Bhawna's Slack, plus one other person's Slack, side by side

## Script

| Time | Screen | What to type / show | Voice-over |
|---|---|---|---|
| 0:00 | Title | — | "Ideas either get built without asking, or die in DMs. Greenlight fixes that, on Switch." |
| 0:15 | Bhawna's personal room | `Can I add another payment gateway? Some customers want to pay with a provider we don't support yet.` | "Bhawna asks Juno privately." |
| 0:30 | Same | Juno shows a summary → `yes` | "Only this summary leaves her private room." |
| 0:40 | `idea-001-payment-gateway` | Juno tags `@rules-agent @impact-agent`, and both reply | "Two agents, on two runtimes, review it in the open." |
| 1:05 | Same | Juno: "Aman, Alex and Riya are affected. Invite them?" → `yes` | "Big change, so Juno asks before inviting anyone." |
| 1:20 | Aman's personal room | Juno: "You're invited…" → `accept` (same for Alex and Riya) | "Each person consents in their own room." |
| 1:40 | Idea room | Juno explains the impact per person | "Everyone sees how it affects *them*." |
| 2:00 | Idea room | `@vote-agent vote approve` (Aman, Alex, Bhawna), `@vote-agent vote changes: add refund steps to the playbook first` (Riya) | "Votes are weighted: Aman's service is hit hardest." |
| 2:25 | Idea room → `#greenlight` | Result: approved 7 of 8; the decision post appears in #greenlight; the room is archived | "Decision, reasons and action items are saved." |
| 2:40 | GitHub | `decisions/001-payment-gateway.md` | "And it's in the repo for everyone." |
| 2:50 | Personal room | `Can I fix the typo on the checkout button?` → fast track | "Small changes skip the meeting entirely." |
| 3:00 | End | Repo link | — |

## Fallbacks during recording

- An agent doesn't answer: tag it again with the same text.
- Not enough real people: Bhawna and Aman vote, then show the rest from the example decision file.
