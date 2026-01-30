#!/bin/bash

# Git information collector

collect_git_info() {
    [[ ! -d ".git" ]] && return 1

    local branch modified untracked remote last_commit

    branch=$(git branch --show-current 2>/dev/null || echo "detached")
    modified=$(git status --porcelain 2>/dev/null | grep -c "^ M")
    untracked=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
    remote=$(git remote get-url origin 2>/dev/null || echo "none")
    last_commit=$(git log -1 --pretty=format:"%h - %s" 2>/dev/null)

    echo "branch=$branch"
    echo "modified=$modified"
    echo "untracked=$untracked"
    echo "remote=$remote"
    echo "last_commit=$last_commit"
}
