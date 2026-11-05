#!/usr/bin/env bash
# Copy each agent's role file from this repo into its instruction file on the VM.
# The VM files keep their standing rules (Platform, Rooms and threads) at the top;
# everything from the "## Role" marker down is replaced with the repo's role file.
# Run after every `git pull`, then `/reset @<agent>` in Slack.
# (Claude Code won't auto-load @imports from outside an agent's folder in headless
# sessions, so the role text is copied in rather than imported.)
set -euo pipefail
REPO="$(cd "$(dirname "$0")/.." && pwd)"
AGENTS_DIR="${AGENTS_DIR:-$HOME/work/agents}"
MARKER="## Role (synced from the greenlight repo by scripts/sync-agent-roles.sh; edit it there)"

for a in juno rules-agent vote-agent impact-agent; do
  file="$AGENTS_DIR/$a/CLAUDE.md"; [ "$a" = impact-agent ] && file="$AGENTS_DIR/$a/AGENTS.md"
  role="$REPO/agents/$a.md"
  [ -f "$file" ] || { echo "skip $a: $file not found"; continue; }
  [ -f "$role" ] || { echo "skip $a: $role not found"; continue; }
  # keep everything above the first "## Role" heading (standing rules)
  head_part="$(awk '/^## Role/{exit} {print}' "$file")"
  { printf '%s\n\n%s\n\n' "$head_part" "$MARKER"; cat "$role"; } > "$file.tmp"
  mv "$file.tmp" "$file"
  echo "synced $a -> $file ($(wc -l < "$file") lines)"
done
