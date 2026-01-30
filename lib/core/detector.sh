#!/bin/bash

# Project type detector
# Detects project types based on file markers

detect_project_type() {
    local types=()

    # Language detection (priority order)
    [[ -f "go.mod" ]] && types+=("golang")
    [[ -f "Cargo.toml" ]] && types+=("rust")
    [[ -f "pom.xml" || -f "build.gradle" ]] && types+=("java")
    [[ -f "pyproject.toml" || -f "requirements.txt" ]] && types+=("python")
    [[ -f "package.json" ]] && types+=("nodejs")

    # Meta information
    [[ -d ".git" ]] && types+=("git")
    [[ -f "docker-compose.yml" || -f "Dockerfile" ]] && types+=("docker")
    [[ -d "docs/dev-log" || -d "docs/dev-logs" ]] && types+=("devlog")
    [[ -f "CLAUDE.md" ]] && types+=("claude")
    [[ -f "Makefile" ]] && types+=("makefile")

    # Output comma-separated list
    IFS=',' echo "${types[*]}"
}

is_project_dir() {
    # Always return true - show info for all directories
    return 0
}

get_project_name() {
    # Extract project name from current directory
    basename "$PWD"
}
