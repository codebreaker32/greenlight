#!/usr/bin/env bash
# Greenlight: don't post the "session starting" notice at all.
# When an agent picks up a message, Switch already marks it with a 👀 reaction and
# shows a "Working… / Worked for Ns" card in the thread, so the text notice is noise.
# It's posted from two places, both patched here (safe to re-run):
#   1. switch-core (server): delivery/recipient.py, _STARTING_SESSION_MESSAGE auto-reply
#   2. the agent runner on this VM: announceSessionStart() in ~/.local/state/switch/sdk-host/*.mjs
# Re-run after a Switch server update/reinstall or after Switch Console reinstalls the runner.
set -euo pipefail
CONTAINER="${CONTAINER:-switchdash-remote-switch-1}"

# 1. server
docker exec -i "$CONTAINER" python - <<'PY'
import switch_core.delivery.recipient as r
path = r.__file__; src = open(path, encoding="utf-8").read()
old = "        if unavailable is not None:\n            await self._post_auto_reply("
new = "        if unavailable is not None and unavailable != _STARTING_SESSION_MESSAGE:  # Greenlight: no start notice\n            await self._post_auto_reply("
if new in src: print("server: already patched")
elif src.count(old) == 1:
    open(path, "w", encoding="utf-8").write(src.replace(old, new)); print("server: patched", path)
else: raise SystemExit("server: code not found; Switch may have changed. Nothing patched.")
PY
docker restart "$CONTAINER" >/dev/null && echo "server: restarted $CONTAINER"

# 2. agent runner on this VM
python3 - <<'PY'
import glob, os, shutil
head = "async function announceSessionStart(input) {\n"
patched = head + "  return; // Greenlight: no session-start notice (the 👀 reaction is enough)\n"
for f in glob.glob(os.path.expanduser("~/.local/state/switch/sdk-host/*.mjs")):
    if f.endswith(".orig"): continue
    s = open(f, encoding="utf-8").read()
    if patched in s: print("runner: already patched", os.path.basename(f)[:30]); continue
    if s.count(head) != 1: print("runner: function not found in", os.path.basename(f)[:30]); continue
    if not os.path.exists(f + ".orig"): shutil.copy2(f, f + ".orig")
    open(f, "w", encoding="utf-8").write(s.replace(head, patched)); print("runner: patched", os.path.basename(f)[:30])
PY
for f in ~/.local/state/switch/sdk-host/*.mjs; do node --check "$f"; done && echo "runner: syntax ok"
U=$(systemctl --user list-unit-files --no-legend "switch-agent-controller-*" | cut -d" " -f1)
[ -n "$U" ] && systemctl --user restart "$U" && echo "runner: restarted $U"
