#!/bin/bash

# Universal Project Status Display Installer
# Installs the pstatus system to ~/03_TOOLS/project-status

INSTALL_DIR="${INSTALL_DIR:-$HOME/03_TOOLS/project-status}"

echo "========================================================================"
echo "Universal Project Status Display - Installation"
echo "========================================================================"
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

echo ""
echo "========================================================================"
echo "Installation Complete!"
echo "========================================================================"
echo ""
echo "To enable auto-display on directory change:"
echo ""
echo "For zsh (~/.zshrc):"
echo "  echo 'source $INSTALL_DIR/shell/pstatus.zsh' >> ~/.zshrc"
echo "  source ~/.zshrc"
echo ""
echo "For bash (~/.bashrc):"
echo "  echo 'source $INSTALL_DIR/shell/pstatus.bash' >> ~/.bashrc"
echo "  source ~/.bashrc"
echo ""
echo "Manual commands:"
echo "  pstatus        - Show detailed project status"
echo "  pstatus-brief  - Show brief summary"
echo "  pst            - Alias for pstatus"
echo "  pstb           - Alias for pstatus-brief"
echo ""
echo "Test it:"
echo "  cd ~/01_DEV/your-project"
echo "  pstatus"
echo ""
echo "========================================================================"
