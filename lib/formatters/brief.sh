#!/usr/bin/env bash

# Brief format - one line summary

format_brief() {
    local project_name="$1"
    local project_types="$2"
    shift 2

    # Parse collected data from arguments (simple variable approach)
    local git_branch="" git_modified="" git_untracked=""
    local docker_services="" docker_running=""
    local devlog_number="" devlog_date=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            git_branch=*) git_branch="${1#*=}" ;;
            git_modified=*) git_modified="${1#*=}" ;;
            git_untracked=*) git_untracked="${1#*=}" ;;
            docker_services=*) docker_services="${1#*=}" ;;
            docker_running=*) docker_running="${1#*=}" ;;
            devlog_number=*) devlog_number="${1#*=}" ;;
            devlog_date=*) devlog_date="${1#*=}" ;;
        esac
        shift
    done

    # Format: [ProjectName] Type | Git: branch [changes] | Other
    local output="[$project_name]"

    # Project type
    local type_str=""
    if [[ "$project_types" == *"golang"* ]]; then
        type_str="Go"
    elif [[ "$project_types" == *"nodejs"* ]]; then
        type_str="Node.js"
    elif [[ "$project_types" == *"python"* ]]; then
        type_str="Python"
    elif [[ "$project_types" == *"rust"* ]]; then
        type_str="Rust"
    elif [[ "$project_types" == *"java"* ]]; then
        type_str="Java"
    elif [[ "$project_types" == *"git"* ]]; then
        type_str="Git Repo"
    else
        type_str="Directory"
    fi
    output+=" $type_str"

    # Git information
    if [[ -n "$git_branch" ]]; then
        output+=" | Git: $git_branch"
        [[ -n "$git_modified" && "$git_modified" -gt 0 ]] 2>/dev/null && output+=" [M$git_modified]"
        [[ -n "$git_untracked" && "$git_untracked" -gt 0 ]] 2>/dev/null && output+=" [U$git_untracked]"
    else
        output+=" | Git: Not initialized"
    fi

    # Docker information (if available)
    if [[ -n "$docker_services" ]]; then
        output+=" | Docker: ${docker_running:-0}/$docker_services"
    fi

    # Dev log (if available)
    if [[ -n "$devlog_number" ]]; then
        output+=" | Log: #$devlog_number ($devlog_date)"
    fi

    echo "$output"
}
