[![Builder](https://github.com/peternicholls/ha-cups-addon-x86/actions/workflows/builder.yml/badge.svg)](https://github.com/peternicholls/ha-cups-addon-x86/actions/workflows/builder.yml)
[![GitHub Release](https://img.shields.io/github/v/release/peternicholls/ha-cups-addon-x86)](https://github.com/peternicholls/ha-cups-addon-x86/releases/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/peternicholls/ha-cups-addon-x86/blob/main/LICENSE)

# CUPS Print Server - Home Assistant Addon

[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fpeternicholls%2Fha-cups-addon-x86)

## Description

A CUPS (Common UNIX Printing System) print server addon for Home Assistant, with printer drivers, USB support, AirPrint discovery, and a configurable web UI. Designed primarily for x86/amd64 installations (Intel/AMD-based systems), but multi-arch builds are available for aarch64, armv7, armhf, and i386.

Tested with Home Assistant OS **17.1** and Home Assistant Core **2026.2**.

## Features

- **AirPrint support** - Printers are automatically discoverable by iOS and macOS devices via cups-browsed and Avahi mDNS
- **Web UI** - CUPS administration interface accessible via the Home Assistant sidebar
- **Configurable options** - Admin username, password, log level, and default paper size are all configurable from the addon settings
- **USB printer support** - Connect USB printers to the host before starting the addon
- **Driver packages** - Includes HP (HPLIP), Brother, Gutenprint, and other common printer drivers via cups-filters
- **Runtime user creation** - Admin user is created at startup from the addon configuration, not baked into the image
- **Logging to HA** - CUPS logs are written to stdout and visible in the Home Assistant log viewer

## Installation

1. Click the badge above to add this repository to your Home Assistant instance, or manually add `https://github.com/peternicholls/ha-cups-addon-x86` in **Settings → Add-ons → Add-on store → Repositories**.
2. Install the **CUPS Print Server** addon.
3. Configure the options (see below).
4. Start the addon.
5. Open the web UI via the sidebar to add printers.

## Configuration

| Option | Default | Description |
|--------|---------|-------------|
| `admin_user` | `print` | CUPS admin username |
| `admin_password` | `print` | CUPS admin password |
| `cups_log_level` | `warn` | Log verbosity: `warn`, `info`, or `debug` |
| `default_paper_size` | `A4` | Default paper size: `A4` or `Letter` |

It is recommended to change the default admin password before exposing the addon.

## Notes

- **USB printers** should be connected to the host before starting the addon. Reconnecting during runtime requires an addon restart.
- The CUPS web UI is accessible at `http://homeassistant.local:631` or via the HA sidebar. The sidebar uses HA ingress which works best with HTTP (SSL is disabled by default to prevent 502 errors).
- AirPrint discovery relies on the addon being on the same network segment as your devices (host networking is enabled).

## Acknowledgements

This project was forked from [niallr/ha-cups-addon](https://github.com/niallr/ha-cups-addon) and significantly extended.

The original cupsd.conf and Dockerfile were adapted from [lemariva/wifi-cups-server](https://github.com/lemariva/wifi-cups-server).

Avahi and D-Bus configuration adapted from [marthoc/docker-homeseer](https://github.com/marthoc/docker-homeseer).
