# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

CrossMix-OS is a custom operating system firmware for the TrimUI Smart Pro handheld gaming device. It's built as an enhanced version of the stock TrimUI OS, featuring additional emulators, apps, themes, and configuration tools.

## Architecture

### Directory Structure

- `Apps/` - Core applications and tools that run on the device
  - Each app has its own directory with a `launch.sh` script
  - Menu systems use nested directories with `##` separators for hierarchical navigation
  - SQLite databases (`*_cache7.db`) are used for menu caching and state management

- `System/` - Core system binaries, libraries, and configuration files
  - `bin/` - System binaries and utilities
  - `lib/` - Shared libraries
  - `etc/` - Configuration files including `crossmix.json`
  - `usr/trimui/scripts/` - System utility scripts

- `Emus/` - Emulator configurations and launchers
  - Each emulator has a `config.json` with rompath, label, and supported extensions

- `Themes/`, `Icons/`, `Backgrounds/` - Customization assets
  - Support preview images and themed variants

- `RetroArch/` - RetroArch emulation frontend with cores and configurations

- `Roms/` - ROM storage directories for different console systems

### App Architecture

Apps follow a consistent pattern:
- `launch.sh` - Main executable script that sets up environment and launches the app
- Menu-based apps use SQLite databases for navigation and state persistence
- Configuration stored in `/mnt/SDCARD/System/etc/crossmix.json`

### Key Components

- **SystemTools** (`Apps/SystemTools/`) - Central configuration hub with hierarchical menus for system settings, emulator options, and customization
- **EmuCleaner** (`Apps/EmuCleaner/`) - Automatically shows/hides emulators based on ROM availability  
- **BootLogo** (`Apps/BootLogo/`) - Manages custom boot screen images
- **Scraper** (`Apps/Scraper/`) - Downloads game artwork and metadata

## Development Commands

### Testing Apps
```bash
# Test an app launch script directly on device
/mnt/SDCARD/Apps/[AppName]/launch.sh

# Rebuild SystemTools menu cache
/mnt/SDCARD/Apps/SystemTools/launch.sh -rebuildmenu

# Run EmuCleaner silently
/mnt/SDCARD/Apps/EmuCleaner/launch.sh -s
```

### Release Process
The project has two GitHub Actions workflows:

**Stable Releases** (`.github/workflows/CrossMix Release.yml`):
- Triggered on version tags (e.g., `v1.3.0`)
- Extracts RetroArch cores from 7z archives
- Cleans development files from the release
- Creates compressed release packages
- Publishes draft releases for manual review

**Canary Releases** (`.github/workflows/CrossMix Canary.yml`):
- Triggered on every push to main branch
- Creates pre-release builds with format `v1.3.0-canary.20241212-1245.abc123`
- Compatible with existing OTA update system
- Automatically cleans up old canary releases (keeps latest 5)
- Can be skipped with `[skip ci]` or `[skip canary]` in commit message

### Configuration Management
- Main config: `/mnt/SDCARD/System/etc/crossmix.json`
- Theme config: `/mnt/UDISK/system.json` 
- OTA channel: `/mnt/SDCARD/System/updates/ota_channel.txt` (stable, canary)
- Database files: `*_cache7.db` (auto-generated, can be deleted to rebuild)

## Shell Script Conventions

- All scripts start with `#!/bin/sh` for POSIX compatibility
- CPU performance optimization is standard: set governor to "performance" and min frequency to 1416000
- Environment setup includes custom PATH and LD_LIBRARY_PATH for system binaries
- Use `jq` for JSON manipulation and `sqlite3` for database operations
- File synchronization with `sync` after important operations
- Info screens use `/mnt/SDCARD/System/usr/trimui/scripts/infoscreen.sh`

## Menu System

The SystemTools app implements a sophisticated menu system:
- Hierarchical navigation using `##` separators in directory names
- Dynamic menu generation based on available themes, icons, and backgrounds
- State management for toggleable options with `(state)` and `(value)` suffixes
- SQLite database caching for performance
- Image thumbnails and previews for visual selection

## File Patterns

- `.launch` files - Game shortcuts that don't count as ROMs
- `preview*.png` - Preview images for themes/icons (support themed variants with `_$CrossMix_Style` suffix)
- `*_cache7.db` - SQLite database files for menu/ROM caching
- `config.json` - Emulator configuration files