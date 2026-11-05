# Demo script (3 minutes)

The story happens at **Parcelwise**, a demo company ([repo](https://github.com/codebreaker32/parcelwise)). Aman (frontend developer) wants to add a payment gateway. Bhawna (backend lead and project owner, mid-way through a provider refactor), Dev (finance, demo) and Riya (support, demo) are affected. Ideas to type: [`SAMPLE_IDEAS.md`](SAMPLE_IDEAS.md).

## Before recording

- [ ] Server and agent controller are running on the VM (both start on boot; check `docs/SWITCH_NOTES.md` gotcha 12)
- [ ] Warm up all 4 agents, so viewers don't see the session-start line ("☕ Waking up… grabbing a coffee, back in a sec."):
  - `@juno ping`
  - `@rules-agent ping`
  - `@impact-agent ping`
  - `@vote-agent ping`
- [ ] Parcelwise `team/people.yml` has a real `slack` username for everyone who should vote (Aman, Bhawna, and the demo accounts for Dev `smrtamy23` and Riya `bhawnanautiyalll`)
- [ ] Delete any old `ideas/001/` and `decisions/001-*` from the VM checkout (keep the repo's example)
- [ ] Screens ready: Aman's Slack and Bhawna's Slack side by side, plus incognito windows for the Dev and Riya demo accounts

## Script

| Time | Screen | What to type / show | Voice-over |
|---|---|---|---|
| 0:00 | Title | — | "Ideas either get built without asking, or die in DMs. Greenlight fixes that, on Switch." |
| 0:15 | Aman's personal room | `Can I add another payment gateway? Some customers want to pay with a provider we don't support yet.` | "Aman asks Juno privately." |
| 0:30 | Same | Juno shows a summary → `yes` | "Only this summary leaves his private room." |
| 0:40 | `idea-001-payment-gateway` | Juno tags `@rules-agent @impact-agent`, and both reply | "Two agents, on two runtimes, review it in the open, against the real repo: policies, CODEOWNERS and an open PR." |
| 1:05 | Same | Juno: "Bhawna, Dev and Riya are affected. Invite them?" → `yes` | "Big change, so Juno asks before inviting anyone." |
| 1:20 | Bhawna's personal room | Juno: "You're invited…" → `accept` (Dev and Riya the same, from their demo accounts) | "Each person consents in their own room." |
| 1:40 | Idea room | Juno explains the impact per person | "Everyone sees how it affects *them*." |
| 2:00 | Idea room | `@vote-agent vote approve` (Bhawna, Dev, Aman), `@vote-agent vote changes: add refund steps to the playbook first` (Riya) | "Votes are weighted: Bhawna's service is hit hardest." |
| 2:25 | Idea room → `#greenlight` | Result: approved; the decision post appears in #greenlight; the room is archived | "Decision, reasons and action items are saved." |
| 2:40 | GitHub | `decisions/001-payment-gateway.md`, pushed by vote-agent | "And it's in the repo for everyone." |
| 2:50 | Personal room | `Can I fix the typo on the checkout pay button?` → fast track | "Small changes skip the meeting entirely." |
| 3:00 | End | Repo link | — |

## Fallbacks during recording

- An agent doesn't answer: tag it again with the same text.
- Not enough real people: Aman and Bhawna vote, then show the rest from the example decision file.
