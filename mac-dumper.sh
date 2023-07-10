#!/bin/bash

network_devices="switch02 repeater-lounge repeater-bedroom1 repeater-street-north repeater-street-south repeater-hof-north"

for box in $network_devices; do
# Also note that EOF is surrounded by single-quotes, so that bash recognizes the heredoc as a nowdoc,
# turning off local variable interpolation so that the command text will be passed as-is to ssh.
ssh -q -o LogLevel=quiet root@$box.imagilan <<'EOF'
for interface in `ls /sys/class/net`
do
  echo "$(cat /proc/sys/kernel/hostname)","${interface}","$(cat /sys/class/net/$interface/address)"
done
EOF
done
