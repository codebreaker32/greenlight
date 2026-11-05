# agents/

Role instructions for the 4 Switch agents. Each file holds the **role sections only**. The standing rules (Slack only, threads) are in each agent's own file on the VM, and that file **loads** the role file from this repo, so the repo is the single source of truth.

## How it's wired on the VM

Each agent's instruction file on the VM (`~/work/agents/<name>/CLAUDE.md`, or `AGENTS.md` for impact-agent, which runs on OpenCode) has the standing rules at the top. Below them, `scripts/sync-agent-roles.sh` copies in the role file from this repo.

**To update an agent:** change its file here and merge to `main`. Then, on the VM:
```
cd ~/work/greenlight && git pull && scripts/sync-agent-roles.sh
```
In Slack, run `/reset @<agent>` so a new session reads it.

(The role text is copied in rather than `@`-imported, because Claude Code won't auto-load imports from outside the agent's folder in headless sessions.)

## Shared rules (already repeated inside each file)

- Write a literal `@name` **only** to hand work to another agent. Everywhere else, names go without `@`.
- Use bullets, never markdown tables, in chat.
- Verdict lines start with `✅ OK:`, `⚠ Needs attention:` or `❌ Blocker:`.
- Greenlight's own files are in `/home/aman/work/greenlight/`. The demo company (Parcelwise) is in `/home/aman/work/demo/parcelwise/`. Never read or quote a personal room.
- If a tool returns an error, quote the exact error text. Never guess.
