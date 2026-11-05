# agents/

Role instructions for the 4 Switch agents. Each file holds the **role sections only**. The standing rules (Slack only, threads, platform) are already in the agent's file on the VM.

## How to apply (on the VM)

| Repo file | Paste **below** the existing sections of |
|---|---|
| `agents/juno.md` | `~/work/agents/juno/CLAUDE.md` |
| `agents/rules-agent.md` | `~/work/agents/rules-agent/CLAUDE.md` |
| `agents/impact-agent.md` | `~/work/agents/impact-agent/AGENTS.md` (OpenCode) |
| `agents/vote-agent.md` | `~/work/agents/vote-agent/CLAUDE.md` |

Then, in Slack: `/reset @juno`, `/reset @rules-agent`, `/reset @impact-agent`, `/reset @vote-agent`.

## Shared rules (already repeated inside each file)

- Write a literal `@name` **only** to hand work to another agent. Everywhere else, names go without `@`.
- Use bullets, never markdown tables, in chat.
- Verdict lines start with `✅ OK:`, `⚠ Needs attention:` or `❌ Blocker:`.
- Shared context lives in files under `~/work/greenlight/`. Never read or quote a personal room.
- If a tool returns an error, quote the exact error text. Never guess.
