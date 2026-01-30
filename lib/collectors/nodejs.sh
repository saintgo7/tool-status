#!/bin/bash

# Node.js project information collector

collect_nodejs_info() {
    [[ ! -f "package.json" ]] && return 1

    local name version scripts dependencies

    # Use jq if available, otherwise use grep/sed
    if command -v jq >/dev/null 2>&1; then
        name=$(jq -r '.name // "unknown"' package.json)
        version=$(jq -r '.version // "0.0.0"' package.json)
        scripts=$(jq -r '.scripts | keys[]' package.json 2>/dev/null | wc -l | tr -d ' ')
    else
        name=$(grep '"name"' package.json | head -1 | sed 's/.*"name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
        version=$(grep '"version"' package.json | head -1 | sed 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
        scripts=$(grep -c '"[^"]*"[[:space:]]*:' package.json 2>/dev/null || echo 0)
    fi

    # Count dependencies from package-lock.json
    if [[ -f "package-lock.json" ]]; then
        dependencies=$(grep -c '"resolved":' package-lock.json 2>/dev/null || echo 0)
    else
        dependencies=0
    fi

    echo "name=$name"
    echo "version=$version"
    echo "scripts=$scripts"
    echo "dependencies=$dependencies"
}
