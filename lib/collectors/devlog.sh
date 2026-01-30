#!/bin/bash

# Development log information collector

collect_devlog_info() {
    local log_dir=""

    # Find dev log directory
    if [[ -d "docs/dev-log/ko" ]]; then
        log_dir="docs/dev-log/ko"
    elif [[ -d "docs/dev-logs" ]]; then
        log_dir="docs/dev-logs"
    elif [[ -d "docs/dev-log" ]]; then
        log_dir="docs/dev-log"
    else
        return 1
    fi

    # Find latest .md file
    local latest_log=$(ls -t "$log_dir"/*.md 2>/dev/null | head -1)
    [[ -z "$latest_log" ]] && return 1

    local filename=$(basename "$latest_log")
    local number=$(echo "$filename" | grep -o "^[0-9]*")
    local date=$(echo "$filename" | grep -o "[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}")

    # Extract title (## Title or # Title)
    local title=$(grep -m1 "^##* 제목\|^##* Title\|^##* Summary\|^# Dev Log" "$latest_log" | head -1 | sed 's/^#*[[:space:]]*//' | sed 's/[:#].*$//')

    echo "number=$number"
    echo "date=$date"
    echo "title=$title"
    echo "file=$filename"
}
