#!/bin/bash

# Quick Install Script
# Usage: curl -fsSL https://raw.githubusercontent.com/saintgo7/tool-status/main/quick-install.sh | bash
# Supports macOS and Linux with automatic OS and shell detection

set -e

INSTALL_DIR="${INSTALL_DIR:-$HOME/03_TOOLS/project-status}"
REPO_URL="https://github.com/saintgo7/tool-status"
VERSION="1.1.0"

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Darwin*) echo "macos" ;;
        Linux*)  echo "linux" ;;
        *)       echo "unknown" ;;
    esac
}

OS=$(detect_os)

echo "========================================================================"
echo "Universal Project Status Display - Quick Install"
echo "========================================================================"
echo "OS: $OS"
echo "Installing to: $INSTALL_DIR"
echo ""

# Check if git is available
if command -v git >/dev/null 2>&1; then
    echo "Using git to clone repository..."

    # Remove existing directory if it exists
    if [[ -d "$INSTALL_DIR" ]]; then
        echo "Removing existing installation..."
        rm -rf "$INSTALL_DIR"
    fi

    # Clone repository
    git clone "$REPO_URL" "$INSTALL_DIR"
    cd "$INSTALL_DIR"
else
    echo "Git not found. Using curl to download..."

    # Create directory
    mkdir -p "$INSTALL_DIR"
    cd "$INSTALL_DIR"

    # Download and extract
    curl -fsSL "${REPO_URL}/archive/main.tar.gz" | tar xz --strip-components=1
fi

# Run installer
echo ""
echo "Running installer..."
./install.sh

echo ""
echo "========================================================================"
echo "Quick Install Complete!"
echo "========================================================================"
echo ""

# OS and Shell specific final instructions
SHELL_NAME=$(basename "$SHELL")
PATH_LINE="export PATH=\"\$HOME/03_TOOLS/project-status/bin:\$PATH\""

if [[ "$OS" == "macos" ]]; then
    if [[ "$SHELL_NAME" == "zsh" ]] || [[ -f "$HOME/.zshrc" ]]; then
        echo "macOS with zsh detected. Enable auto-display with:"
        echo ""
        echo "  echo 'source $INSTALL_DIR/shell/pstatus.zsh' >> ~/.zshrc"
        echo "  echo '$PATH_LINE' >> ~/.zshrc"
        echo "  source ~/.zshrc"
    else
        echo "macOS with bash detected. Enable auto-display with:"
        echo ""
        echo "  echo 'source $INSTALL_DIR/shell/pstatus.bash' >> ~/.bash_profile"
        echo "  echo '$PATH_LINE' >> ~/.bash_profile"
        echo "  source ~/.bash_profile"
    fi
elif [[ "$OS" == "linux" ]]; then
    if [[ "$SHELL_NAME" == "zsh" ]] || [[ -f "$HOME/.zshrc" ]]; then
        echo "Linux with zsh detected. Enable auto-display with:"
        echo ""
        echo "  echo 'source $INSTALL_DIR/shell/pstatus.zsh' >> ~/.zshrc"
        echo "  echo '$PATH_LINE' >> ~/.zshrc"
        echo "  source ~/.zshrc"
    else
        echo "Linux with bash detected. Enable auto-display with:"
        echo ""
        echo "  echo 'source $INSTALL_DIR/shell/pstatus.bash' >> ~/.bashrc"
        echo "  echo '$PATH_LINE' >> ~/.bashrc"
        echo "  source ~/.bashrc"
    fi
fi

echo ""
echo "Test it now:"
echo "  cd ~/your-project"
echo "  $INSTALL_DIR/bin/pstatus"
echo ""
echo "========================================================================"
