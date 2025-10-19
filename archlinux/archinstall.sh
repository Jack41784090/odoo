#!/bin/bash
#
# Install Arch Linux packages needed to run Odoo.
# This script uses yay (or pacman) to install dependencies.

set -e

# Handle virtual environment if active
if [ -n "$VIRTUAL_ENV" ]; then
    echo -e "${YELLOW}Detected active virtual environment at: $VIRTUAL_ENV${NC}"
    echo -e "${YELLOW}Installing build tools in venv to avoid AUR build issues...${NC}"
    pip install --quiet build installer setuptools wheel
    echo -e "${GREEN}Build tools installed in venv.${NC}"
    echo ""
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Determine which package manager to use
if command -v yay &> /dev/null; then
    PKG_MANAGER="yay"
    INSTALL_CMD="yay -S --needed --noconfirm"
elif command -v paru &> /dev/null; then
    PKG_MANAGER="paru"
    INSTALL_CMD="paru -S --needed --noconfirm"
else
    PKG_MANAGER="pacman"
    INSTALL_CMD="sudo pacman -S --needed --noconfirm"
    echo -e "${YELLOW}Warning: yay or paru not found. Using pacman (AUR packages will be skipped).${NC}"
fi

echo -e "${GREEN}Using package manager: $PKG_MANAGER${NC}"

if [ "$1" = "-l" ] || [ "$1" = "--list" ]; then
    echo "Packages that would be installed:"
    grep -v '^#' "$(dirname "$0")/packages.txt" | grep -v '^$' | sort
    exit 0
fi

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Install Arch Linux packages needed to run Odoo."
    echo ""
    echo "Options:"
    echo "  -l, --list     List packages without installing"
    echo "  -h, --help     Show this help message"
    echo ""
    echo "Note: This script will use yay/paru if available, otherwise pacman."
    echo "      Some packages may only be available in AUR."
    exit 0
fi

# Update package database
echo -e "${GREEN}Updating package database...${NC}"
if [ "$PKG_MANAGER" = "pacman" ]; then
    sudo pacman -Sy
else
    $PKG_MANAGER -Sy
fi

# Read packages from packages.txt and install
script_dir=$(dirname "$(realpath "$0")")
packages_file="$script_dir/packages.txt"

if [ ! -f "$packages_file" ]; then
    echo -e "${RED}Error: packages.txt not found at $packages_file${NC}"
    exit 1
fi

# Extract package names (ignore comments and empty lines)
packages=$(grep -v '^#' "$packages_file" | grep -v '^$' | tr '\n' ' ')

if [ -z "$packages" ]; then
    echo -e "${RED}Error: No packages found in packages.txt${NC}"
    exit 1
fi

echo -e "${GREEN}Installing packages...${NC}"
echo "Packages: $packages"
echo ""

# Install packages
$INSTALL_CMD $packages

echo ""
echo -e "${GREEN}Package installation complete!${NC}"
echo ""
echo -e "${YELLOW}Note: You may still need to install additional Python packages via pip:${NC}"
echo "  pip install -r requirements.txt"
echo ""
echo -e "${YELLOW}Some packages may need to be installed from AUR:${NC}"
echo "  - python-ofxparse"
echo "  - python-rjsmin"
