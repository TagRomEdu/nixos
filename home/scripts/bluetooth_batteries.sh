#!/usr/bin/env bash

OUT="/tmp/bluetooth_batteries"
> "$OUT"

bluetoothctl devices | while read -r _ addr name; do
    info=$(bluetoothctl info "$addr" 2>/dev/null)

    connected=""
    battery=""
    icon="bluetooth"

    while IFS=: read -r key value; do
        key=$(echo "$key" | xargs)
        value=$(echo "$value" | xargs)

        case "$key" in
            Connected)
                connected="$value"
                ;;
            "Battery Percentage")
                battery=$(echo "$value" | sed -n 's/.*(\([0-9]\+\)).*/\1/p')
                ;;
            Icon)
                icon="$value"
                ;;
        esac
    done <<< "$info"

    [[ "$connected" != "yes" ]] && continue
    [[ -z "$battery" ]] && battery="—"

    echo "$icon|$name|$battery" >> "$OUT"
done
