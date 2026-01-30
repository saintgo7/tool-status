#!/bin/bash

# Go project information collector

collect_golang_info() {
    [[ ! -f "go.mod" ]] && return 1

    local module go_version dependencies

    module=$(grep "^module " go.mod | awk '{print $2}')
    go_version=$(grep "^go " go.mod | awk '{print $2}')

    # Count dependencies from go.sum
    if [[ -f "go.sum" ]]; then
        dependencies=$(wc -l < go.sum | tr -d ' ')
    else
        dependencies=0
    fi

    echo "module=$module"
    echo "go_version=$go_version"
    echo "dependencies=$dependencies"
}
