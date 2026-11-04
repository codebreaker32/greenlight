# Greenlight — project context for Claude Code

Greenlight: idea management on Switch (github.com/sandbox-quantum/switch). A person refines an idea privately
with a personal agent → 4 review agents (policy, conflict, impact, feasibility; ✅/⚠/❌) → with the proposer's
permission, affected people are invited (consent in their personal room, then add_users_to_room) to a combined
room → room agent explains per-person impact → typed vote (approve/reject/changes; majority of participants,
quorum, owner breaks ties) → archive_room → decision saved to decisions/<id>-<slug>.md and posted to the common room.

Hackathon: Flip the Switch, Track 01 Business Workflow. Deadline Nov 7 2026 23:59 IST.
Judging: Switch central 30%, reproducible 25%, creativity 25%, README+video 20%.

Hard constraints (verified in Switch source):
- No invite links; no reactions visible to agents; no custom !commands → everything is typed @agent messages.
- Context stops at the room → share context via files (people/, ideas/, decisions/), never by reading personal rooms.
- Literal @name in agent output re-addresses that agent → write names without @ in summaries.
- Agents cannot create agents; addressing must be "anyone"; the task-delegation protocol is not ready, so don't use it.
- No scheduler, no message edits; Slack shows markdown tables as raw text → use bullets.
- Templates: follow examples/agent-templates/support-desk.template.yaml in the Switch repo.

Rules: never commit secrets (.env is gitignored). Don't start implementation work outside an assigned issue.
Full brief: docs/KICKOFF.md
