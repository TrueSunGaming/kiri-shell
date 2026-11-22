#!/usr/bin/env sh

# detects crashes when monitors change

pkill quickshell
pkill qs

project_dir="$(dirname "$0")/.."
qs -p $project_dir &
qs_pid=$!

sleep 1
hyprctl eval 'hl.monitor({ output = "DP-5", disabled = true })' >/dev/null
sleep 1
hyprctl reload >/dev/null
sleep 1

if ! kill -0 "$qs_pid" 2>/dev/null; then
    wait "$qs_pid"
    exit_code=$?
    echo "Test failed (exit code: $exit_code)" >&2
else
    echo "Test passed"
fi

pkill qs
pkill quickshell