#!/bin/bash

# Universal Project Status Display Installer
# Installs the pstatus system to ~/03_TOOLS/project-status
# Supports macOS and Linux with automatic shell detection

INSTALL_DIR="${INSTALL_DIR:-$HOME/03_TOOLS/project-status}"

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Darwin*) echo "macos" ;;
        Linux*)  echo "linux" ;;
        *)       echo "unknown" ;;
    esac
}

# Detect shell
detect_shell() {
    if [[ -n "$ZSH_VERSION" ]]; then
        echo "zsh"
    elif [[ -n "$BASH_VERSION" ]]; then
        echo "bash"
    else
        basename "$SHELL"
    fi
}

OS=$(detect_os)
CURRENT_SHELL=$(detect_shell)

echo "========================================================================"
echo "Universal Project Status Display - Installation"
echo "========================================================================"
echo "OS: $OS"
echo "Shell: $CURRENT_SHELL"
echo "Installing to: $INSTALL_DIR"
echo ""

# Check if already in the target directory
if [[ "$PWD" == "$INSTALL_DIR" ]]; then
    echo "Already in the installation directory. Skipping file copy."
else
    # Create directory structure
    echo "Creating directory structure..."
    mkdir -p "$INSTALL_DIR"/{bin,lib/{core,collectors,formatters},config,shell}

    # Copy files (if not already there)
    if [[ -d "./bin" ]]; then
        echo "Copying executable files..."
        cp -r bin/* "$INSTALL_DIR/bin/" 2>/dev/null || true
    fi

    if [[ -d "./lib" ]]; then
        echo "Copying library files..."
        cp -r lib/* "$INSTALL_DIR/lib/" 2>/dev/null || true
    fi

    if [[ -d "./shell" ]]; then
        echo "Copying shell integration files..."
        cp -r shell/* "$INSTALL_DIR/shell/" 2>/dev/null || true
    fi
fi

# Set executable permissions
echo "Setting executable permissions..."
chmod +x "$INSTALL_DIR/bin/"* 2>/dev/null || true
chmod +x "$INSTALL_DIR/lib/core/"*.sh 2>/dev/null || true
chmod +x "$INSTALL_DIR/lib/collectors/"*.sh 2>/dev/null || true
chmod +x "$INSTALL_DIR/lib/formatters/"*.sh 2>/dev/null || true

# Add to PATH
echo ""
echo "Adding to PATH..."
PATH_LINE="export PATH=\"\$HOME/03_TOOLS/project-status/bin:\$PATH\""

echo ""
echo "========================================================================"
echo "Installation Complete!"
echo "========================================================================"
echo ""

# Provide OS and Shell specific instructions
if [[ "$OS" == "macos" ]]; then
    # macOS typically uses zsh (Catalina+)
    if [[ "$CURRENT_SHELL" == "zsh" ]] || [[ -f "$HOME/.zshrc" ]]; then
        echo "Detected macOS with zsh. To enable auto-display:"
        echo ""
        echo "  echo 'source $INSTALL_DIR/shell/pstatus.zsh' >> ~/.zshrc"
        echo "  echo '$PATH_LINE' >> ~/.zshrc"
        echo "  source ~/.zshrc"
        echo ""
    else
        echo "Detected macOS with bash. To enable auto-display:"
        echo ""
        echo "  echo 'source $INSTALL_DIR/shell/pstatus.bash' >> ~/.bash_profile"
        echo "  echo '$PATH_LINE' >> ~/.bash_profile"
        echo "  source ~/.bash_profile"
        echo ""
    fi
elif [[ "$OS" == "linux" ]]; then
    # Linux typically uses bash
    if [[ "$CURRENT_SHELL" == "zsh" ]] || [[ -f "$HOME/.zshrc" ]]; then
        echo "Detected Linux with zsh. To enable auto-display:"
        echo ""
        echo "  echo 'source $INSTALL_DIR/shell/pstatus.zsh' >> ~/.zshrc"
        echo "  echo '$PATH_LINE' >> ~/.zshrc"
        echo "  source ~/.zshrc"
        echo ""
    else
        echo "Detected Linux with bash. To enable auto-display:"
        echo ""
        echo "  echo 'source $INSTALL_DIR/shell/pstatus.bash' >> ~/.bashrc"
        echo "  echo '$PATH_LINE' >> ~/.bashrc"
        echo "  source ~/.bashrc"
        echo ""
    fi
else
    echo "Unknown OS. Manual configuration required:"
    echo ""
    echo "For zsh (~/.zshrc):"
    echo "  echo 'source $INSTALL_DIR/shell/pstatus.zsh' >> ~/.zshrc"
    echo "  echo '$PATH_LINE' >> ~/.zshrc"
    echo ""
    echo "For bash (~/.bashrc or ~/.bash_profile):"
    echo "  echo 'source $INSTALL_DIR/shell/pstatus.bash' >> ~/.bashrc"
    echo "  echo '$PATH_LINE' >> ~/.bashrc"
    echo ""
fi

echo "Manual commands (available after adding to PATH):"
echo "  pstatus        - Show detailed project status"
echo "  pstatus-brief  - Show brief summary"
echo "  pst            - Alias for pstatus"
echo "  pstb           - Alias for pstatus-brief"
echo ""
echo "Test it (without PATH, use full path):"
echo "  cd ~/your-project"
echo "  $INSTALL_DIR/bin/pstatus"
echo ""
echo "========================================================================"
