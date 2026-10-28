#!/usr/bin/env bash

current_pid=""
watcher_pid=""

start_command() {
  serie &
  current_pid=$!
}

stop_command() {
    if [[ -n "$current_pid" ]]; then
        kill -TERM "$current_pid" 2>/dev/null || true
        wait "$current_pid" 2>/dev/null || true
        current_pid=""
    fi
}

cleanup() {
    trap - INT TERM EXIT

    stop_command

    if [[ -n "$watcher_pid" ]]; then
        kill "$watcher_pid" 2>/dev/null || true
        wait "$watcher_pid" 2>/dev/null || true
    fi

    exit 0
}

trap cleanup INT TERM EXIT

coproc WATCHER {
    exec inotifywait -m -r \
        -e create,modify,delete,move \
        --format '%w%f' .git
}

watcher_pid=$WATCHER_PID
watcher_fd=${WATCHER[0]}

start_command

while IFS= read -r -u "$watcher_fd" _; do
    stop_command
    start_command
done

cleanup
