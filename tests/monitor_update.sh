#!/usr/bin/env sh

# detects crashes when monitors change

{
    just kill
    hyprctl reload

    just run_built
    qs_pid=$(cat /tmp/kiri-shell.pid)

    sleep 1
    hyprctl eval 'hl.monitor({ output = "DP-5", disabled = true })'
    sleep 1
    hyprctl reload
    sleep 1
} >/dev/null 2>&1

if ! kill -0 "$qs_pid" 2>/dev/null; then
    wait "$qs_pid"
    exit_code=$?
    echo "Test failed (exit code: $exit_code)" >&2
else
    exit_code=0
    echo "Test passed"
fi

kill "$qs_pid"
rm -f /tmp/kiri-shell.pid

if [ "$exit_code" -eq 0 ]; then
    exit 0
else
    exit 1
fi