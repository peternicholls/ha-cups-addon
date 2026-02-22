[![Builder](https://github.com/peternicholls/ha-cups-addon-x86/actions/workflows/builder.yml/badge.svg)](https://github.com/peternicholls/ha-cups-addon-x86/actions/workflows/builder.yml)
[![GitHub Release](https://img.shields.io/github/v/release/peternicholls/ha-cups-addon-x86)](https://github.com/peternicholls/ha-cups-addon-x86/releases/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/peternicholls/ha-cups-addon-x86/blob/main/LICENSE)
# CUPS Home Assistant Addon (x86 update)

[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fpeternicholls%2Fha-cups-addon-x86)

# Description

A CUPS (Common UNIX Printing System) server with a variety of included drivers, USB support, support for the Home Assistant installation's TLS certificate, and mDNS broadcasting enabled. This was created primarily to support Home Assistant installations on devices with x86 architecture, such as AMD/Intel-based thin clients. The installed driver packages focus on HP and Brother printer support. Avahi has been configured to support AirPrint via reflector mode.

This has been tested with Home Assistant Core **2023.9**.

# Considerations

* **SSL must be disabled within the CUPS portal to prevent 502 Bad Gateway errors.** This has already been set within the default cupsd.conf.

* The CUPS portal can be viewed at http://localhost:631 (e.g. http://homeassistant:631). HA Ingress support is patchy due to non-SSL, so expect the sidebar panel functionality to not work (blank pages, etc).

* The default admin login credentials are username = "print" and password = "print". This can be altered within the Dockerfile as required.

* USB printers should be connected to the host device prior to starting this addon. If disconnected/connected during runtime, simply restart the addon.

# Acknowledgements

This project was forked from [niallr/ha-cups-addon](https://github.com/niallr/ha-cups-addon) for x86/amd64 compatibility and refactored for reliability.

The cupsd.conf and Dockerfile were modified from https://github.com/lemariva/wifi-cups-server

Some of the Avahi and D-Bus code is modified from https://github.com/marthoc/docker-homeseer
