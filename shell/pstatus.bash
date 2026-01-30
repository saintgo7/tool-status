# Project Status Auto-Display for bash
# Add to ~/.bashrc: source ~/03_TOOLS/project-status/shell/pstatus.bash

PSTATUS_HOME="${PSTATUS_HOME:-$HOME/03_TOOLS/project-status}"

_pstatus_auto() {
    # Quick check if current directory is a project
    if [[ -d ".git" ]] || [[ -f "go.mod" ]] || [[ -f "package.json" ]] || \
       [[ -f "requirements.txt" ]] || [[ -f "Cargo.toml" ]] || \
       [[ -f "pom.xml" ]] || [[ -f "docker-compose.yml" ]]; then

        # Display brief summary (hide errors)
        if [[ -x "$PSTATUS_HOME/bin/pstatus-brief" ]]; then
            "$PSTATUS_HOME/bin/pstatus-brief" 2>/dev/null
        fi
    fi
}

# Register PROMPT_COMMAND hook
if [[ -z "$PROMPT_COMMAND" ]]; then
    PROMPT_COMMAND="_pstatus_auto"
else
    # Merge with existing PROMPT_COMMAND
    PROMPT_COMMAND="$PROMPT_COMMAND; _pstatus_auto"
fi

# Aliases
alias pst='pstatus'
alias pstb='pstatus-brief'
