# Project Status Auto-Display for zsh
# Add to ~/.zshrc: source ~/03_TOOLS/project-status/shell/pstatus.zsh

PSTATUS_HOME="${PSTATUS_HOME:-$HOME/03_TOOLS/project-status}"

_pstatus_auto() {
    # Display brief summary for all directories (hide errors)
    if [[ -x "$PSTATUS_HOME/bin/pstatus-brief" ]]; then
        "$PSTATUS_HOME/bin/pstatus-brief" 2>/dev/null
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
