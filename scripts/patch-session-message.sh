#!/usr/bin/env bash
# Replace Switch's "Starting a session…" line with Greenlight's message.
# Switch posts this line under an agent's name when the agent is addressed and its
# session is still starting. It's hard-coded in switch-core
# (core/switch_core/delivery/recipient.py, _STARTING_SESSION_MESSAGE), so we patch
# the running container. Re-run after the Switch server is updated or its
# containers are recreated. Safe to run repeatedly.
set -euo pipefail
CONTAINER="${CONTAINER:-switchdash-remote-switch-1}"
NEW_MESSAGE="${NEW_MESSAGE:-☕ Waking up… grabbing a coffee, back in a sec.}"

docker exec -i -e NEW_MESSAGE="$NEW_MESSAGE" "$CONTAINER" python - <<'PY'
import os, re, switch_core.delivery.recipient as r
path = r.__file__
src = open(path, encoding="utf-8").read()
new = os.environ["NEW_MESSAGE"].replace("\\", "\\\\").replace('"', '\\"')
pattern = r'^_STARTING_SESSION_MESSAGE = ".*"$'
if not re.search(pattern, src, flags=re.M):
    raise SystemExit("constant not found; Switch may have changed. Nothing patched.")
out = re.sub(pattern, f'_STARTING_SESSION_MESSAGE = "{new}"', src, count=1, flags=re.M)
if out == src:
    print("already patched:", path)
else:
    open(path, "w", encoding="utf-8").write(out)
    print("patched:", path)
PY

docker restart "$CONTAINER" >/dev/null
echo "restarted $CONTAINER"
