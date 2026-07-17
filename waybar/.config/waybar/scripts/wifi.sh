#!/bin/bash

# Show notification that search started
notify-send "WiFi" "Scanning for networks..." -t 1000 &

# Get list of saved (known) wifi connection profiles
saved=$(nmcli -t -f NAME,TYPE con show | grep ':802-11-wireless$' | cut -d: -f1)

# Get the currently connected SSID
active=$(nmcli -t -f ACTIVE,SSID dev wifi 2>/dev/null | grep '^yes:' | cut -d: -f2-)

# Get list of available WiFi networks sorted by signal strength (descending)
# Extract SSID and SIGNAL, sort by signal (highest first), remove duplicates keeping strongest
# Color indicator for signal strength + star (★) for previously saved networks
networks=$(nmcli -t -f SIGNAL,SSID dev wifi list --rescan yes 2>/dev/null | \
    grep -v '^--' | \
    sort -t: -k1 -rn | \
    awk -F: -v saved="$saved" -v active="$active" '
    BEGIN { n = split(saved, arr, "\n"); for (i = 1; i <= n; i++) if (arr[i] != "") known[arr[i]] = 1 }
    !seen[$2]++ && NF==2 && $2 != "" {
        signal=$1
        ssid=$2
        if (signal >= 61) {
            indicator = "🟢"
        } else if (signal >= 21) {
            indicator = "🟡"
        } else {
            indicator = "🔴"
        }
        # Currently connected network uses a green tick instead of the signal indicator
        if (ssid == active) {
            indicator = "✅"
        }
        # Known networks get sort key 0 (top), unknown get 1; keep signal order within each group
        if (ssid in known) {
            printf "0\t%05d\t%s 🔑 %s\n", signal, indicator, ssid
        } else {
            printf "1\t%05d\t%s %s\n", signal, indicator, ssid
        }
    }' | sort -t$'\t' -k1,1 -k2,2rn | cut -f3-)

if [ -z "$networks" ]; then
    notify-send "WiFi" "No networks found" -u critical
    exit 1
fi

# Count networks found and show notification
count=$(echo "$networks" | wc -l)
notify-send "WiFi" "Found $count network(s)" -t 2000

# Show rofi menu
selected=$(echo "$networks" | rofi -dmenu -p "Connect to WiFi:" -theme-str 'window {width: 18em;} element-icon {enabled: false;} element-text {padding: 0;}')

if [ -z "$selected" ]; then
    exit 0
fi

# Get SSID: strip leading indicator (signal emoji or green tick) and optional key marker
ssid=$(echo "$selected" | sed -E 's/^(🟢|🟡|🔴|✅) (🔑 )?//')

# If already connected, drop and reconnect (debug tool)
current=$(nmcli -t -f name c show --active | grep -m1 ".*")
if [ "$current" = "$ssid" ]; then
    notify-send "WiFi" "Reconnecting to $ssid..." -t 2000
    nmcli con down "$ssid" 2>/dev/null
    sleep 3
    if nmcli con up "$ssid" 2>/dev/null; then
        notify-send "WiFi" "Reconnected to $ssid ✅" -t 3000
    else
        notify-send "WiFi" "Failed to reconnect to $ssid" -u critical -t 3000
    fi
    exit 0
fi

# Try to connect to existing connection first
notify-send "WiFi" "Connecting to $ssid..." -t 2000
if nmcli con up "$ssid" 2>/dev/null; then
    notify-send "WiFi" "Connected to $ssid ✅" -t 3000
    exit 0
fi

# Need a password - prompt and retry on failure
prompt="WiFi Password for $ssid:"
while true; do
    password=$(rofi -dmenu -p "$prompt" -theme-str 'window {width: 30em;}')

    # User cancelled
    if [ -z "$password" ]; then
        exit 0
    fi

    notify-send "WiFi" "Connecting to $ssid..." -t 2000

    # Try to connect; capture error output
    if nmcli dev wifi connect "$ssid" password "$password" 2>/tmp/wifi-err; then
        notify-send "WiFi" "Connected to $ssid ✓" -t 3000
        exit 0
    fi

    # Connection failed - clean up the bad profile so the next try is fresh
    nmcli con delete "$ssid" 2>/dev/null

    notify-send "WiFi" "Wrong password or failed to connect. Try again." -u critical -t 3000
    prompt="Wrong password, retry for $ssid:"
done
