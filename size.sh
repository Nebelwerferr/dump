#!/bin/bash

echo "Disk free space :"

monitored_disks=("/dev/sda2" "/dev/sda1")

df -h --output=source,size,avail,pcent,target -x tmpfs -x devtmpfs | tail -n +2 | while read -r line; do
    device=$(echo "$line" | awk '{print $1}')
    size=$(echo "$line" | awk '{print $2}')
    avail=$(echo "$line" | awk '{print $3}')
    used_percent=$(echo "$line" | awk '{print $4}' | tr -d '%')
    mountpoint=$(echo "$line" | awk '{print $5}')

    free_percent=$((100 - used_percent))

    varname=$(echo "$mountpoint" | sed 's|/|_|g' | sed 's|^-||' | sed 's|[^a-zA-Z0-9_]|_|g')
    varname="FREE_${varname}"

    declare "$varname=$free_percent"

    echo "Mount: $mountpoint"
    echo "  Disk: $device"
    echo "  Size: $size"
    echo "  Free Space : $avail (${free_percent}%)"
    echo "  Variables : $varname=$free_percent"
    echo ""

    if [[ " ${monitored_disks[*]} " == *" $device "* ]]; then
        if [ "$free_percent" -le 10 ]; then
            echo "WARNING : $device mount on $mountpoint under 10% free space : ($free_percent%)"
            echo "Stop all the download process"

            downloaders=("wget" "curl" "aria2c" "dd")

            for proc in "${downloaders[@]}"; do
                pkill -f "$proc" && echo " Proc $proc stop"
            done
        fi
    fi
done
