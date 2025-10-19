# Arch Linux Installation Guide for Odoo

This directory contains scripts and package lists for installing Odoo dependencies on Arch Linux.

## Files

- **archinstall.sh** - Main installation script
- **packages.txt** - List of required Arch Linux packages

## Quick Start

1. Run the installation script:
   ```bash
   ./archinstall.sh
   ```

2. Install Python dependencies:
   ```bash
   pip install -r ../requirements.txt
   ```

## Usage

### Install all packages
```bash
./archinstall.sh
```

### List packages without installing
```bash
./archinstall.sh --list
```

### Show help
```bash
./archinstall.sh --help
```

## Package Manager Support

The script automatically detects and uses the best available package manager:
1. **yay** (preferred) - Supports AUR packages
2. **paru** - Alternative AUR helper
3. **pacman** - Fallback (official repos only)

If you don't have an AUR helper installed, install yay first:
```bash
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

## AUR Packages

Some packages are only available in the AUR and require yay or paru:
- python-ofxparse
- python-rjsmin

## Notes

- The script uses `--needed` flag to skip already-installed packages
- System packages are installed first, then you can install Python packages via pip
- Some Python packages may have both system packages and pip versions available
- The script is equivalent to Debian's `setup/debinstall.sh`

## Troubleshooting

If you encounter issues:
1. Make sure your system is up to date: `sudo pacman -Syu`
2. Check if specific packages are available: `yay -Ss package-name`
3. Some packages might have different names - check the AUR if a package isn't found
4. You can manually edit `packages.txt` to add or remove packages

## PostgreSQL Setup

After installation, you may need to initialize and start PostgreSQL:
```bash
sudo -u postgres initdb --locale=en_US.UTF-8 -D /var/lib/postgres/data
sudo systemctl enable postgresql
sudo systemctl start postgresql
```
