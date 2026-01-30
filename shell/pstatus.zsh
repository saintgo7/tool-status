# Project Status Auto-Display for zsh
# Add to ~/.zshrc: source ~/03_TOOLS/project-status/shell/pstatus.zsh

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

# Register chpwd hook
autoload -U add-zsh-hook
add-zsh-hook chpwd _pstatus_auto

# Run on initial load
_pstatus_auto

# Aliases
alias pst='pstatus'
alias pstb='pstatus-brief'
