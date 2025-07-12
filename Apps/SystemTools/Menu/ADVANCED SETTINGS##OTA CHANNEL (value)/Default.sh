#!/bin/sh

channel=$(basename "$0" .sh)
[ "$channel" = "Default" ] && channel="stable"

updatedir="/mnt/SDCARD/System/updates"
mkdir -p "$updatedir"

echo "$channel" > "$updatedir/ota_channel.txt"
sync

/mnt/SDCARD/System/usr/trimui/scripts/infoscreen.sh -m "OTA channel set to \"${channel}\"."

/mnt/SDCARD/System/usr/trimui/scripts/mainui_state_update.sh "OTA CHANNEL" "$channel"