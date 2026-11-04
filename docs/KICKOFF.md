# Greenlight — Kickoff Brief (read this first)

> **What this file is:** the single starting document for building Greenlight on the Google Cloud VM. It condenses the team's design document (*Greenlight_Project_Document.pdf*, 11 pages), the research we did beforehand, and constraints we checked in Switch's source code.
> **How to use it:** copy it into the new `greenlight` repo as `docs/KICKOFF.md`, and paste the short version (§12) into `CLAUDE.md` so Claude Code on the VM picks it up automatically.
> **Status:** design is locked. **No implementation has started.** The next step is the repo plus two preliminary issues (§10).
> **Hackathon:** Flip the Switch (WeMakeDevs × DevTools Academy × Switch). **Track 01: Best Business Workflow.** Submissions close **Nov 7, 2026, 11:59 PM IST**. The design doc says to lock the MVP by the night of Nov 5.

---

## 1. The idea in plain words

**Greenlight is idea management where agents review proposals and the affected people decide together.**

Someone has an idea, say *"Can I add another payment gateway?"*. Today they either just build it and later find it breaks a policy or clashes with someone's work, or they ask around in DMs and meetings and the idea dies or the decision gets lost.

With Greenlight:
1. The person refines the idea **privately** with their personal agent.
2. **Four review agents** check it: **Policy, Conflict, Impact, Feasibility**. Each check gets ✅ OK, ⚠ Needs attention, or ❌ Blocker.
3. Greenlight works out **who is affected** and, **with the proposer's permission**, opens a **combined room** with them.
4. Each affected person is invited and **accepts or declines**. Declining doesn't block anything.
5. The **room agent** explains the change and **how it affects each person by name**.
6. People discuss and **vote** (approve, reject, or request changes). A majority of those participating decides. A minimum number of votes is required, and the project owner breaks ties.
7. The room closes, and **the decision, reasons, timeline and action items are saved to the main project**.

**Demo story (under 3 minutes):** Priya (checkout developer) asks her personal agent about adding a payment gateway. The reviews come back: Policy ⚠ (needs security review / PCI DSS), Conflict ⚠ (Sam's team is changing `payment-service` this sprint), Impact: Sam (backend), Alex (finance), Riya (support), Feasibility ✅ (about 2 weeks). Priya agrees to open a room. The room agent tells each person how they're affected: *"Sam, your refactor will need a shared payment interface. Alex, reconciliation gets a second source. Riya, refund steps change."* They agree to schedule it after Sam's refactor and vote 3 approve, 1 changes. The decision and action items are posted to the main project room.

## 2. Team decisions so far

- **Two people.** We split the work ourselves. **Ignore the 4-person "Team split" table (§12) in the PDF.**
- Process: create the GitHub repo named **`greenlight`**, then open **two issues** for the preliminary work, one per member (§10). Each of us is assigned one and starts our own part.
- **Development happens on a Google Cloud VM**, with Claude Code installed there. ("Cloud" in our notes means Claude Code.)

## 3. Rooms (from the design doc, adapted to how Switch actually works)

| Room | Who's in it | Purpose | How it maps to Switch |
|---|---|---|---|
| **Personal room** | 1 person + personal agent | Draft and refine ideas privately | A one-to-one room. Create it with `create_room(channel_type="direct", …)` on Slack, or as a private channel with one user (works on every platform) |
| **Shared room** *(nice to have)* | 2 people + agent | Quick private collaboration | `create_room(channel_type="channel_private", user_names=[a, b])` |
| **Combined room** (one per idea) | Proposer + affected people who accepted + room agent | Explanation, discussion, vote | Created **with only the proposer**. Each person is added with `add_users_to_room` **after they accept**. Closed with `archive_room` |
| **Review room** *(our addition)* | The 4 review agents (+ personal agent) | Where reviews run, keeping noise out of the other rooms | A private channel. The personal agent posts the idea and mentions all four reviewers by name |
| **Common room** (main project) | Whole team | Final decisions, updates, history | A normal channel. The room agent posts the decision here, and the decision file is written to the repo |

## 4. Switch facts that change the design (checked against the Switch source)

Switch repo: https://github.com/sandbox-quantum/switch. Paths below are inside that repo.

1. **There are no invite links in Switch.** An agent can add people directly with `add_users_to_room` (`core/switch_core/bridges/agent/operations/definitions.py`, around line 1448). → We build the consent step: the agent asks each affected person *in their personal room* ("You're invited to idea-12: accept or decline?"), and only on "accept" adds them to the combined room. This meets the "only after they accept" privacy rule.
2. **Agents cannot see emoji reactions** (`core/switch_core/clients/consumer.py`: `on_reaction` does nothing). → **Votes are typed**, e.g. `@greenlight-room vote approve` / `reject` / `changes: <reason>`. 👍/👎 can only be decoration.
3. **Custom `!commands` are not possible.** Unknown `!` commands are rejected (`core/switch_core/bridges/agent/commands.py`). → Everything is an `@agent …` message or plain text in a one-to-one room.
4. **Context does not cross rooms on its own.** From Switch's docs: *"Context stops at the room… Sessions don't pool what they know."* (`docs/official/using/shared-context.md`). → The design doc's "context merging" is **our job**. Store each person's context as files (e.g. `people/<name>.md`, `ideas/<id>/review.md`) in the agents' working directory or the repo. The room agent reads **only** the profiles of members who accepted, plus the review summary.
5. **An agent can read any room it belongs to without joining it** (`read_context(room_id=…)`, definitions.py around line 700). That's useful, but the room agent must **never** read personal rooms. Keep that boundary in the agent instructions.
6. **In a one-to-one room with exactly one agent, every message is addressed to that agent automatically** (`core/switch_core/delivery/addressing.py`). Personal rooms need no `@`.
7. **New agents only respond to their owner by default.** Set `addressing: anyone` so every teammate can talk to them (see `examples/agent-templates/support-desk.template.yaml`). The owner sets this in the Gateway or in the template.
8. **A literal `@agent-name` in an agent's own message re-addresses that agent.** That's how agents hand work to each other (good for kicking off reviewers), but summaries must write names **without** `@`, or they'll trigger agents by accident.
9. **Handoffs work by agents addressing each other in a shared room.** Switch's formal task-delegation protocol is "present but not ready", so build nothing on it.
10. **Agents cannot create agents.** All agents (personal, 4 reviewers, room) are created in Switch Console or from an agent template, ahead of time.
11. **Each addressed room starts its own Claude Code session.** 4 reviewers + room agent + personal agents means several concurrent sessions, which costs tokens. Over SSH, the remote host's sshd `MaxSessions` (default 10) can cap this; raise it on the VM if needed.
12. **Platform choice:** Teams doesn't support agent-created one-to-one rooms. Telegram can't do them either. **Slack** is the safest for the demo. **Mattermost** comes up automatically when Switch Console sets up a remote host (fastest start), but there agents can't open DMs, so use private channels for personal rooms. Discord's code supports it, but its docs are inconsistent.
13. **Template format:** the YAML sketch in the PDF (§9) is not the real schema. Real templates have `version`, `params`, `agents:` (with `provider`, `location`, `directory`, `addressing`, `instructions`), `rooms`/`group`/`links`, and per-room `kickoff`. **Copy the shape of `examples/agent-templates/support-desk.template.yaml`** (agents plus linked rooms in one file) and `examples/room-templates/red-blue-workroom.template.yaml` (params, `{$creator}`, kickoff).
14. **There is no scheduler**, so reminders and vote deadlines have to be triggered by a message. Agents **can't edit** messages they already posted. **Slack and Telegram show markdown tables as raw text**, so use bullet lists.

## 5. Running on the Google Cloud VM

Switch Console is a **desktop app**. It does **not** run on a headless VM. The supported setup:

```
 Laptop (Switch Console, GUI)  ──SSH──►  GCP VM (Ubuntu 24.04)
                                          ├─ Switch server (Docker, installed by Console)
                                          ├─ Mattermost (auto, optional) or bridge to Slack
                                          ├─ Agents: Claude Code sessions (personal, 4 reviewers, room)
                                          └─ greenlight repo checkout (our code + agent working dirs)
```

**VM spec (from Switch's docs, `docs/official/deploy/host-remotely.md`):** Ubuntu 22.04 or 24.04, x86_64 or arm64, at least 2 vCPU, 4 GB RAM, 20 GB disk (use e2-standard-2 or larger; e2-standard-4 is safer with several agent sessions). SSH key access with `sudo`. Docker installed. **Not Windows.**

**Setup order:**
1. Create the VM (Ubuntu 24.04), add your SSH key, and install Docker, git, Node.js 20+ and the GitHub CLI (`gh`).
2. On your **laptop**, add a `Host greenlight-vm` entry to `~/.ssh/config` and check that `ssh greenlight-vm` works.
3. On the laptop, install Switch Console (https://github.com/sandbox-quantum/switch/releases/latest). In **Settings → Remote hosts → Add host**, pick `greenlight-vm`, and let it install what's missing.
4. **Add a server** on that remote host. Console sets up the server and Mattermost. Optionally connect Slack (`docs/official/deploy/messaging-apps/slack.md`).
5. **Set up agent providers** (Claude Code login or API key) and **onboard agents** with location = the VM.
6. Run the **smoke test** (`docs/official/getting-started/smoke-test.md`): one agent answers in one room.
7. On the VM, install Claude Code for development, clone the `greenlight` repo, and put §12 in `CLAUDE.md`.
8. Optional, for Claude Code on the VM: `claude mcp add switch-docs --transport http https://docs.switchagents.ai/mcp` (Switch's docs MCP server, listed on the hackathon resources page).

**Alternative:** self-host the server with Docker Compose on the VM (`ghcr.io/sandbox-quantum/standalone-compose`; you **must** pin a version, see `docs/official/deploy/self-host.md`), then point Console at it as an "existing server".

**Security:** never commit API keys, Slack tokens or agent keys. Agent API keys are shown **once** at registration. Store them in `.env` (gitignored) or GCP Secret Manager. Restrict the VM firewall to SSH plus whatever the bridge needs.

## 6. What Switch provides vs. what we build (design doc §8, refined)

| Switch provides | We build |
|---|---|
| Rooms bridged to Slack/Mattermost/Discord | Room-creation logic (personal, combined, review, common) |
| Agent identities and addressing | Consent-based invites (ask in personal room, then `add_users_to_room`) |
| Room history and `read_context` | Context merging via `people/*.md` and `ideas/<id>/*.md` files |
| Room instructions, documents and templates | Agent instructions for personal, 4 reviewers and room agent; typed voting and consensus rules |
| Sender identity on every message | Vote tallying, quorum, tie-break, room close (`archive_room`) |
| The GitHub service connection (optional) | Saving decisions to the main project (decision file + post in common room) |

## 7. Agents (all `addressing: anyone`)

| Agent | Lives in | Job | Output |
|---|---|---|---|
| `greenlight-personal` | Every personal room (one agent identity serving everyone in their own one-to-one room is simplest for the MVP) | Refine the idea with the person; when ready, post it to the review room mentioning the 4 reviewers; relay the combined summary; ask permission to open a room; handle invite accept/decline | `ideas/<id>/idea.md` |
| `greenlight-policy` | Review room | Check against `demo-data/policies/*` | ✅/⚠/❌ + one-line reasons |
| `greenlight-conflict` | Review room | Check against `demo-data/projects/*` (ongoing work, files being changed) | ✅/⚠/❌ + who and what clashes |
| `greenlight-impact` | Review room | Who and what is affected (teams, users, costs), using `people/*` | List of affected people + how |
| `greenlight-feasibility` | Review room | Effort, skills, timeline | ✅/⚠/❌ + estimate |
| `greenlight-room` | Combined rooms + common room | Explain the change per person, run the typed vote, enforce quorum and tie-break, close the room, post the decision | `decisions/<id>-<slug>.md` + a post in the common room |

**Cheaper fallback** if 4 parallel sessions are too slow or costly: one `greenlight-review` agent with 4 Claude Code subagents (`include_subagents` exists on `invite_agent_to_room`). This scores lower on "Use of Switch", so use it only if needed.

## 7b. Multi-agent plan on Claude only (decided Nov 4)

We only have a **Claude subscription** and an **Anthropic API key**. No Codex, no Copilot. "Multi-agent" means separate agents with their own roles and identities, running on two agent runtimes inside Switch plus one on GitHub.

| Agent(s) | Runtime | Auth | When |
|---|---|---|---|
| `greenlight-personal`, `greenlight-room` | **Claude Code** | Claude subscription (sign in via Switch Console) | MVP |
| 2 of the 4 reviewers (e.g. `greenlight-conflict`, `greenlight-feasibility`) | **OpenCode** (open source, supported natively by Switch) configured with a Claude model | `ANTHROPIC_API_KEY` | MVP (cheap: only a provider setting) |
| The other 2 reviewers | Claude Code | Subscription | MVP |
| `greenlight-builder` (replaces Copilot) | Claude Code, in its own work room | Subscription | Stretch |
| `greenlight-ci` (GitHub-side agent) | **GitHub Actions** with `anthropics/claude-code-action` | `ANTHROPIC_API_KEY` as a repo secret | Stretch |

**Stretch flow, from idea to merged code:** approved decision → the room agent opens a GitHub issue from `decisions/<id>.md` → `greenlight-builder` opens a PR → `greenlight-ci` checks the PR against the decision → posts ✅/❌ back into the Slack room.
- **Preferred way to post the result:** as its own Switch agent, via `POST /agents/{agent_id}/message` with `{room_id, content}`. This needs no live connection (`docs/official/internals/agent-protocol.md`). It requires the Switch API to be reachable from GitHub runners: open a port on the VM, ideally with HTTPS.
- **Fallback:** the Action comments on the PR, and the room agent reads it with `gh` when someone asks.

**Cost control:** use a smaller Claude model (e.g. Haiku) for reviewers and a stronger one for the room agent, which also spreads load across subscription and API rate limits. Set a monthly spending limit in the Anthropic Console. **Dropped:** Codex (needs OpenAI) and the Copilot coding agent (needs a paid plan; not assignable on the repo as of Nov 4).

## 8. MVP scope (design doc §10)

**Must have:** personal room with the personal agent → 4 reviews merged into one summary → permission prompt → combined room with consent-based invites → room agent explaining per-person impact → typed vote → room closes → decision posted to the common room and saved.

**Nice to have:** shared two-person rooms; revision loop ("changes" vote → re-review → new vote); decision history search; a manager overview of open ideas; (from our research) appending each decision as a one-line rule to the repo's `AGENTS.md`, so coding agents follow it later.

**Demo data we write ourselves:** `demo-data/policies/` (security review, PCI DSS), `demo-data/projects/` (Sam's `payment-service` refactor this sprint), `people/` (Priya, Sam, Alex, Riya: role, team, current work), and one `payment-service` stub if needed.

## 9. Open questions (design doc §13), with our suggested answers

| Question | Suggested answer | Why |
|---|---|---|
| Which chat app for the demo? | **Slack** (Mattermost as fallback, since it comes free with a remote host) | Teams can't do agent-created one-to-one rooms; Slack is familiar to judges |
| Where does "main project" data live? | **The git repo**: `decisions/<id>-<slug>.md` + a post in the common room | Reproducible ("clone and run" is in the rubric) and readable in the README |
| Where do policy docs and ongoing projects come from? | **Sample files we write** in `demo-data/` | Deterministic demo |
| Majority vote or owner veto? | **Majority of participants, a minimum quorum, owner breaks ties** (as in the doc). Veto as a later option | Matches the design; keep it simple |

## 10. GitHub repo and the two preliminary issues

Create the repo (public, since judges must be able to clone it):

```bash
gh repo create greenlight --public --description "Idea management where agents review proposals and the affected people decide together. Built on Switch." --clone
```

**Issue 1: Preliminary: Switch platform setup on the GCP VM and feasibility spikes**
- [ ] Provision the GCP VM (Ubuntu 24.04, ≥2 vCPU / 4 GB, Docker, git, Node 20+, gh); SSH alias works from the laptop
- [ ] Switch Console on the laptop → onboard the VM as a remote host → server running
- [ ] Choose and connect the chat app (Slack preferred; Mattermost fallback) and create the common room
- [ ] Smoke test: one Claude Code agent with `addressing: anyone` answers both members in the common room
- [ ] **Spike A:** the agent creates a personal room for a real member (`create_room` direct or a private channel with one user) and they can chat without `@`
- [ ] **Spike B:** the agent creates a combined room with only the proposer, then `add_users_to_room` adds a second member after a typed "accept"
- [ ] **Spike C:** the agent posts one message mentioning 2+ agents by name and both start (the handoff to reviewers works)
- [ ] **Spike D:** `archive_room` closes a room cleanly; the sender name on messages matches what `create_room`/`add_users_to_room` accept
- [ ] Write the findings in `docs/SWITCH_NOTES.md` (what worked, exact commands, gotchas)

**Issue 2: Preliminary: agent design, demo data and decision format**
- [ ] Write the instructions for all 6 agents (§7) in `agents/<name>.md`, including output formats (✅/⚠/❌ lines, no markdown tables, names without `@`)
- [ ] Define the file layout: `people/`, `ideas/<id>/{idea,review}.md`, `decisions/`, `demo-data/{policies,projects}/`
- [ ] Write the demo data for the payment-gateway story (Priya, Sam, Alex, Riya; policies; ongoing projects)
- [ ] Define the vote grammar and rules (approve, reject, changes; quorum; tie-break; who counts as participating)
- [ ] Define the decision record format (`decisions/<id>-<slug>.md`: idea, review verdicts, participants, votes, decision, reasons, timeline, action items)
- [ ] Draft the Switch template (agents + rooms) following `examples/agent-templates/support-desk.template.yaml`
- [ ] Outline the README (problem, flow diagram, how Switch is used, setup steps, limits) and the 3-minute demo script

*(The two of us decide who takes which. After these, we open implementation issues.)*

## 11. Hackathon rules that affect us

- **Judging (DevTools Academy page):** Use of Switch **30%** ("would it stop working without it?"), Technical execution **25%** ("could someone clone the repo and reproduce it?"), Creativity & impact **25%**, Presentation **20%** (demo video + README).
- Switch **must be central**, and the **README must show how Switch is used**.
- Submit: **repo + demo video + README** before Nov 7, 11:59 PM IST. Submit early.
- Existing agents and templates are allowed, but the **Switch setup and the workflow must be built during the hackathon**.
- AI coding tools are allowed; we must **understand and be able to explain** what we submit.
- **No multiple accounts.** For the 4-person demo, use real friends as Sam, Alex and Riya, not fake accounts.
- Optional side tracks: **Best Blog** (AirPods; "how a first-time Switch user builds this"); `#HowISwitch` posts.
- Help: WeMakeDevs Discord, Switch Discord, and the docs at https://docs.switchagents.ai.

## 12. Short version for `CLAUDE.md` on the VM

```markdown
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
- Claude only: Claude Code (subscription) + OpenCode with ANTHROPIC_API_KEY for 2 reviewers. Stretch: greenlight-builder
  (Claude Code) and greenlight-ci (GitHub Actions + anthropics/claude-code-action). No Codex/Copilot. See docs/KICKOFF.md §7b.

Rules: never commit secrets (.env is gitignored). Don't start implementation work outside an assigned issue.
Full brief: docs/KICKOFF.md
```

## 13. Sources

- Team design document: *Greenlight_Project_Document.pdf* (11 pages)
- Hackathon: https://www.wemakedevs.org/hackathons/switch · rules: https://www.wemakedevs.org/hackathons/switch/rules · rubric: https://www.devtoolsacademy.com/hackathons/flip-the-switch
- Switch repo: https://github.com/sandbox-quantum/switch. Docs used: `docs/official/using/shared-context.md`, `docs/official/internals/identity-and-access.md`, `docs/official/internals/agent-protocol.md`, `docs/official/deploy/host-remotely.md`, `docs/official/deploy/self-host.md`, `docs/official/getting-started/*`, `switch-expert/knowledge/{CONCEPTS,PATTERNS,GOTCHAS,RECIPES}.md`. Source used: `core/switch_core/bridges/agent/operations/definitions.py`, `core/switch_core/delivery/addressing.py`, `core/switch_core/clients/consumer.py`, `core/switch_core/bridges/agent/commands.py`
- Switch docs site: https://docs.switchagents.ai
