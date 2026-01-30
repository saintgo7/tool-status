#!/bin/bash

# Docker environment information collector

collect_docker_info() {
    [[ ! -f "docker-compose.yml" ]] && return 1

    local services running

    # Count services from docker-compose.yml
    services=$(grep "^  [a-z]" docker-compose.yml | grep -v "^  #" | wc -l | tr -d ' ')

    # Count running containers (project name based)
    if command -v docker >/dev/null 2>&1; then
        local project_name=$(basename "$PWD" | tr '[:upper:]' '[:lower:]' | tr '_' '-')
        running=$(docker ps --filter name="$project_name" --format "{{.Names}}" 2>/dev/null | wc -l | tr -d ' ')
    else
        running=0
    fi

    echo "services=$services"
    echo "running=$running"
}
