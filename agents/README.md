# agents/

Role instructions for the 4 Switch agents. Each file holds the **role sections only**. The standing rules (Slack only, threads) are in each agent's own file on the VM, and that file **loads** the role file from this repo, so the repo is the single source of truth.

## How it's wired on the VM

| Agent | VM file | Loads |
|---|---|---|
| juno | `~/work/agents/juno/CLAUDE.md` | `@/home/aman/work/greenlight/agents/juno.md` (Claude Code import) |
| rules-agent | `~/work/agents/rules-agent/CLAUDE.md` | `@/home/aman/work/greenlight/agents/rules-agent.md` |
| vote-agent | `~/work/agents/vote-agent/CLAUDE.md` | `@/home/aman/work/greenlight/agents/vote-agent.md` |
| impact-agent (OpenCode) | `~/work/agents/impact-agent/AGENTS.md` + `opencode.json` | `instructions: ["/home/aman/work/greenlight/agents/impact-agent.md"]` |

**To update an agent:** change its file here, merge to `main`, then on the VM run `cd ~/work/greenlight && git pull`, and in Slack run `/reset @<agent>`.

## Shared rules (already repeated inside each file)

- Write a literal `@name` **only** to hand work to another agent. Everywhere else, names go without `@`.
- Use bullets, never markdown tables, in chat.
- Verdict lines start with `✅ OK:`, `⚠ Needs attention:` or `❌ Blocker:`.
- Greenlight's own files are in `/home/aman/work/greenlight/`. The demo company (Parcelwise) is in `/home/aman/work/demo/parcelwise/`. Never read or quote a personal room.
- If a tool returns an error, quote the exact error text. Never guess.
