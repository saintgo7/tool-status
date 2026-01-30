#!/bin/bash

# Package script - Create distribution archive for other servers
# Creates a tar.gz file that can be easily transferred and installed

VERSION=$(cat VERSION)
PACKAGE_NAME="pstatus-${VERSION}"
PACKAGE_FILE="${PACKAGE_NAME}.tar.gz"

echo "========================================================================"
echo "Universal Project Status Display - Packaging"
echo "========================================================================"
echo "Version: $VERSION"
echo "Package: $PACKAGE_FILE"
echo ""

# Create temporary directory for packaging
TEMP_DIR=$(mktemp -d)
PACKAGE_DIR="$TEMP_DIR/$PACKAGE_NAME"

echo "Creating package directory..."
mkdir -p "$PACKAGE_DIR"

# Copy all necessary files
echo "Copying files..."
cp -r bin lib shell "$PACKAGE_DIR/"
cp install.sh README.md LICENSE VERSION .gitignore "$PACKAGE_DIR/"

# Set permissions
echo "Setting permissions..."
chmod +x "$PACKAGE_DIR/bin/"*
chmod +x "$PACKAGE_DIR/lib/core/"*.sh
chmod +x "$PACKAGE_DIR/lib/collectors/"*.sh
chmod +x "$PACKAGE_DIR/lib/formatters/"*.sh
chmod +x "$PACKAGE_DIR/install.sh"

# Create tarball
echo "Creating tarball..."
cd "$TEMP_DIR"
tar czf "$PACKAGE_FILE" "$PACKAGE_NAME"

# Move to current directory
mv "$PACKAGE_FILE" "$OLDPWD/"
cd "$OLDPWD"

# Cleanup
rm -rf "$TEMP_DIR"

echo ""
echo "========================================================================"
echo "Package created successfully!"
echo "========================================================================"
echo "File: $PACKAGE_FILE"
echo "Size: $(du -h "$PACKAGE_FILE" | cut -f1)"
echo ""
echo "Transfer to another server:"
echo "  scp $PACKAGE_FILE user@server:/tmp/"
echo ""
echo "Install on remote server:"
echo "  ssh user@server"
echo "  cd /tmp"
echo "  tar xzf $PACKAGE_FILE"
echo "  cd $PACKAGE_NAME"
echo "  ./install.sh"
echo ""
echo "========================================================================"
