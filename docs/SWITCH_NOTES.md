# Switch notes: setup, gotchas, spike results

Findings from issue #1. Everything here was tried on our setup (Switch Console v0.40.1, server 0.31.0, Slack, GCP VM).

## Our setup

| Piece | Where | Notes |
|---|---|---|
| Switch Console (desktop app) | Laptop (Windows) | Must be open for agent sessions to start on demand (per Switch docs) |
| Switch server | `greenlight-vm` (GCP, e2-standard-4, Ubuntu 24.04), onboarded as a **remote host** over SSH alias `greenlight` | Docker Compose stack in `~/.switchdash/switch-server/`: gateway, switch-core, Mattermost, Postgres |
| Messaging app | Slack (Socket Mode, app created from Switch's manifest) | Bot token `xoxb-…` + app token `xapp-…` + workspace id `T…` |
| Agents | Run on the VM, folders in `~/work/agents/<name>` | All "Who can talk to your agent: Anyone", auto mode on, bypass off, can-manage-agents off |

| Agent | Provider | Model / auth |
|---|---|---|
| `juno` | Claude Code | Claude subscription (signed in on the VM) |
| `rules-agent` | Claude Code | Claude subscription |
| `vote-agent` | Claude Code | Claude subscription |
| `impact-agent` | OpenCode 1.19.5 | Claude model via `ANTHROPIC_API_KEY` (stored in `~/.local/share/opencode/auth.json` on the VM, mode 600) |

## Gotchas we hit (and fixes)

1. **The Switch server does not restart after a VM reboot.** Containers have restart policy `no`. After `gcloud compute instances start …`, start the server from Switch Console.
2. **Providers on the VM showed as "not installed".** Claude Code and OpenCode were installed under `~/.local/bin`, which non-login SSH sessions don't have on PATH. Fix: `sudo ln -sf ~/.local/bin/claude /usr/local/bin/claude` (same for `opencode`).
3. **Console's provider list reflects the laptop**, not the remote host ("OpenCode Ready" came from the laptop's install). Choose **Run location = Greenlight VM** in the agent form.
4. **Slack needs two tokens.** The app-level token (`xapp-`, scope `connections:write`) comes from *Basic Information → App-Level Tokens*. The bot token (`xoxb-`) only exists **after installing the app** (*Install App → Install to Workspace*). Create the app from Switch's manifest so scopes, events and Socket Mode are right.
5. **"Anyone" is stored as `addressing_policy = null`** in the `agents` table. Null means open (`addressing_policy_for("anyone")` returns `None` in switch-core). Not a bug.
6. **Leave "Can manage agents" off.** It lets an agent create agents and change other agents' settings as the owner. Juno doesn't need it: inviting agents and adding users only requires room membership (`agent_core.invite_agent_to_room` / `add_users_to_room`).
7. **"Persistent memory" (Advanced configuration) doesn't apply to normal sessions.** It's written as Claude Code subagent config only. Keep it off; Greenlight's memory lives in repo files.
8. **Agent-to-agent handoff = a literal `@name` in a message.** This works (spike C). Agent instructions must write names *without* `@` everywhere except deliberate handoffs, or agents re-trigger each other.

9. **Leaving a private Slack channel can archive it.** When the only human member left the personal room `dm-aman.bihari.ug23-juno`, Slack archived the channel. A later `add_users_to_room` failed with Slack error `is_archived` (switch-core log: `Failed to invite Slack user … 'error': 'is_archived'`), while Switch still listed the room as active. **Don't leave personal or idea rooms.** Mute or hide them. Recovery: archive the Switch room and create a new one (Slack may keep the old channel name reserved).
10. **Agents may misreport tool errors.** Juno said Slack "couldn't find your account", but the real error was `is_archived`. Check the server log: `ssh greenlight 'docker logs --since 1h switchdash-remote-switch-1 2>&1 | grep -i -E "error|failed" | tail'`. Agent instructions should say: quote the exact error a tool returns.
11. **On Slack, look people up by username, not email.** `add_users_to_room` resolves names from Switch's `external_users` table (the Slack handle recorded when the person first messaged, e.g. `aman.bihari.ug23`), and otherwise does an exact username/email match in the Slack directory. Our app has no `users:read.email` scope, so email matching never succeeds.

Useful VM commands:
```bash
ssh greenlight 'docker ps --format "{{.Names}}: {{.Status}}"'            # server containers
ssh greenlight 'pgrep -fa "claude|opencode" | grep -c stream-json'        # live agent sessions
ssh greenlight 'opencode auth list'                                       # OpenCode credentials
```

## Spike results

Run each in Slack, in the common room (e.g. `#greenlight`) where `juno` has been invited. Note what happened.

| Spike | What to type in Slack | Pass if | Result |
|---|---|---|---|
| **C. Visible handoff** | `@juno ask rules-agent and impact-agent to each say hello and name the tool they run on` | Juno tags both; both reply in the room | ✅ Nov 5: both replied (Claude Code, OpenCode) |
| **A. Personal room** | `@juno create a private one-to-one room for just me and you (channel_type direct), then say hi there` | A private channel `dm-<you>-juno` appears; in it, plain messages (no `@`) get answers | ✅ Nov 5: `dm-aman.bihari.ug23-juno` created after confirmation; answers without `@`. Re-check threads after `/reset @juno` |
| **B. Consent invite** | `@juno create a private room named idea-test with only me in it. Then ask <teammate's Slack name> in this room whether they accept an invite to it, and add them with add_users_to_room only if they reply "accept"` | Room created with only you; teammate is added **only after** typing "accept" | ⚠️ Partial: username lookup works (`aman.bihari.ug23` → `U0C…`); email doesn't. Invite failed with Slack `is_archived` (channel archived after its only member left). Re-test with Bhawna on a fresh room |
| **D. Close a room** | In `idea-test`: `@juno archive this room` | Room is archived in Switch and the Slack channel is archived | ⬜ |
| **D2. Names** | `@juno what username do you see for me and for <teammate>?` | The names Juno sees are the ones `create_room` / `add_users_to_room` accept (A and B succeeded using them) | ✅ Juno sees `aman.bihari.ug23`; that name resolves for `add_users_to_room` |

Anything that fails: write the exact error Juno reports here; it decides the fallback in `docs/KICKOFF.md` §4.
