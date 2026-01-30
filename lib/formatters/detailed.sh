#!/usr/bin/env bash

# Detailed format - comprehensive project status

format_detailed() {
    local project_name="$1"
    local project_types="$2"
    shift 2

    # Parse collected data from arguments
    local git_branch="" git_modified="" git_untracked="" git_remote="" git_last_commit=""
    local go_module="" go_version="" go_dependencies=""
    local node_name="" node_version="" node_scripts="" node_dependencies=""
    local docker_services="" docker_running=""
    local devlog_number="" devlog_title="" devlog_date="" devlog_file=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            git_branch=*) git_branch="${1#*=}" ;;
            git_modified=*) git_modified="${1#*=}" ;;
            git_untracked=*) git_untracked="${1#*=}" ;;
            git_remote=*) git_remote="${1#*=}" ;;
            git_last_commit=*) git_last_commit="${1#*=}" ;;
            go_module=*) go_module="${1#*=}" ;;
            go_version=*) go_version="${1#*=}" ;;
            go_dependencies=*) go_dependencies="${1#*=}" ;;
            node_name=*) node_name="${1#*=}" ;;
            node_version=*) node_version="${1#*=}" ;;
            node_scripts=*) node_scripts="${1#*=}" ;;
            node_dependencies=*) node_dependencies="${1#*=}" ;;
            docker_services=*) docker_services="${1#*=}" ;;
            docker_running=*) docker_running="${1#*=}" ;;
            devlog_number=*) devlog_number="${1#*=}" ;;
            devlog_title=*) devlog_title="${1#*=}" ;;
            devlog_date=*) devlog_date="${1#*=}" ;;
            devlog_file=*) devlog_file="${1#*=}" ;;
        esac
        shift
    done

    echo "========================================================================"
    echo "Project Status Report"
    echo "========================================================================"
    echo "Project: $project_name"
    echo "Types: $project_types"
    echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
    echo ""

    # [1] Git Repository
    if [[ -n "$git_branch" ]]; then
        echo "[1] Git Repository"
        echo "------------------------------------------------------------------------"
        echo "Branch: $git_branch"
        echo "Modified: ${git_modified:-0} files"
        echo "Untracked: ${git_untracked:-0} files"
        echo "Remote: ${git_remote:-none}"
        echo "Last Commit: $git_last_commit"
        echo ""
    fi

    # [2] Language-specific information
    if [[ "$project_types" == *"golang"* ]]; then
        echo "[2] Go Project"
        echo "------------------------------------------------------------------------"
        echo "Module: $go_module"
        echo "Go Version: $go_version"
        echo "Dependencies: $go_dependencies"
        echo ""
    elif [[ "$project_types" == *"nodejs"* ]]; then
        echo "[2] Node.js Project"
        echo "------------------------------------------------------------------------"
        echo "Name: $node_name"
        echo "Version: $node_version"
        echo "Scripts: $node_scripts"
        echo "Dependencies: $node_dependencies"
        echo ""
    fi

    # [3] Docker Environment
    if [[ "$project_types" == *"docker"* ]]; then
        echo "[3] Docker Environment"
        echo "------------------------------------------------------------------------"
        echo "Services: $docker_services"
        echo "Running: ${docker_running:-0}"
        echo ""
    fi

    # [4] Development Log
    if [[ "$project_types" == *"devlog"* ]]; then
        echo "[4] Development Log"
        echo "------------------------------------------------------------------------"
        echo "Latest: #$devlog_number - $devlog_title"
        echo "Date: $devlog_date"
        echo "File: $devlog_file"
        echo ""
    fi

    echo "========================================================================"
    echo "Quick Actions:"

    # Suggest actions based on project type
    if [[ "$project_types" == *"makefile"* ]]; then
        echo "  make help        - Show available commands"
    fi

    if [[ "$project_types" == *"nodejs"* ]]; then
        echo "  npm run          - Show available scripts"
    fi

    if [[ "$project_types" == *"docker"* ]] && [[ "${data[docker_running]:-0}" -eq 0 ]]; then
        echo "  docker-compose up -d    - Start containers"
    fi

    echo "========================================================================"
}
