#!/bin/bash

# Cross-platform utility functions

# Detect operating system
detect_os() {
    case "$(uname -s)" in
        Darwin*) echo "macos" ;;
        Linux*)  echo "linux" ;;
        *)       echo "unknown" ;;
    esac
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Get file modification time (cross-platform)
file_mtime() {
    local file="$1"
    if [[ "$(detect_os)" == "macos" ]]; then
        stat -f %m "$file" 2>/dev/null
    else
        stat -c %Y "$file" 2>/dev/null
    fi
}

# Color output (optional, TTY only)
color_echo() {
    local color="$1"
    shift
    if [[ -t 1 ]]; then  # Only in TTY
        case "$color" in
            red)    echo -e "\033[31m$*\033[0m" ;;
            green)  echo -e "\033[32m$*\033[0m" ;;
            yellow) echo -e "\033[33m$*\033[0m" ;;
            blue)   echo -e "\033[34m$*\033[0m" ;;
            *)      echo "$*" ;;
        esac
    else
        echo "$*"
    fi
}

# Parse JSON value without jq
json_value() {
    local json="$1"
    local key="$2"
    echo "$json" | grep -o "\"$key\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" | \
                    sed "s/\"$key\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\"/\1/"
}
