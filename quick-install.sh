#!/bin/bash

# Quick Install Script
# Usage: curl -fsSL https://raw.githubusercontent.com/user/project-status/main/quick-install.sh | bash

set -e

INSTALL_DIR="${INSTALL_DIR:-$HOME/03_TOOLS/project-status}"
REPO_URL="https://github.com/saintgo7/tool-status"
VERSION="1.0.0"

echo "========================================================================"
echo "Universal Project Status Display - Quick Install"
echo "========================================================================"
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

# Detect shell and provide integration instructions
echo ""
echo "========================================================================"
echo "Installation Complete!"
echo "========================================================================"
echo ""

SHELL_NAME=$(basename "$SHELL")

if [[ "$SHELL_NAME" == "zsh" ]]; then
    echo "Detected zsh. To enable auto-display:"
    echo "  echo 'source $INSTALL_DIR/shell/pstatus.zsh' >> ~/.zshrc"
    echo "  source ~/.zshrc"
elif [[ "$SHELL_NAME" == "bash" ]]; then
    echo "Detected bash. To enable auto-display:"
    echo "  echo 'source $INSTALL_DIR/shell/pstatus.bash' >> ~/.bashrc"
    echo "  source ~/.bashrc"
else
    echo "Unknown shell: $SHELL_NAME"
    echo "Please manually add to your shell config:"
    echo "  source $INSTALL_DIR/shell/pstatus.bash"
fi

echo ""
echo "Test it now:"
echo "  cd ~/your-project"
echo "  $INSTALL_DIR/bin/pstatus"
echo ""
echo "========================================================================"
