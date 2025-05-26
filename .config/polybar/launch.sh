#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Launch bar1 and bar2
echo "---" | tee -a /tmp/polybar1.log

for m in $(polybar --list-monitors | cut -d":" -f1); do
    MONITOR=$m polybar top -r >>/tmp/polybar1.log 2>&1 & disown
done

echo "Bars launched..."