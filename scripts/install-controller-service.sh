#!/usr/bin/env bash
# Install the Switch agent controller as a systemd user service so it starts on every VM boot.
# Same command Switch Console uses (host-scripts.ts systemdUnit); requires `loginctl enable-linger`.
set -euo pipefail
D=$HOME/.local/state/switch
DD=$(ls -d $D/agent-controller/console-* | head -1)
SID=${DD##*/console-}
BUNDLE=$(ls -t $D/sdk-host/agent-controller-*.mjs | head -1)
SHARED=$(ls -t $D/sdk-host/shared-host-*.mjs | head -1)
U=switch-agent-controller-$SID.service
mkdir -p ~/.config/systemd/user
cat > ~/.config/systemd/user/$U <<EOF
[Unit]
Description=Switch agents controller (Switch Console, server $SID)
After=network-online.target
Wants=network-online.target

[Service]
ExecStart="/usr/bin/node" "$BUNDLE" "run" "--data-dir" "$DD" "--shared-host-bundle" "$SHARED" "--updated-by-console"
Environment="PATH=$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin"
Environment=SWITCH_CONTROLLER_LOG_LEVEL=info
Restart=on-failure
RestartSec=5
RestartPreventExitStatus=2 3 4 5 6

[Install]
WantedBy=default.target
EOF
systemctl --user daemon-reload
systemctl --user enable "$U"
# Stop any controller started by hand, then start the service.
pkill -TERM -f "^/usr/bin/node .*agent-controller-.*\.mjs run" || true
for i in $(seq 1 20); do pgrep -f "^/usr/bin/node .*agent-controller-.*\.mjs run" >/dev/null || break; sleep 1; done
systemctl --user start "$U"
sleep 12
echo "unit: $U"
echo "enabled: $(systemctl --user is-enabled $U)  active: $(systemctl --user is-active $U)"
journalctl --user -u "$U" --no-pager -n 40 | grep -E "Connected to Switch|controller connection|agents controller starting" | cut -c1-200 | tail -4
