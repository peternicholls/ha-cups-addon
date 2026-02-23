#!/usr/bin/with-contenv bashio
#
# BACKWARD-COMPAT ENTRYPOINT
# This script is retained for use cases where s6-overlay is not the process
# supervisor (e.g. direct Docker invocation). Under normal addon operation,
# config.yaml has 'init: false' and s6-overlay is the runtime; this file is
# not invoked.
#
# All configuration logic lives in cups-config.sh (the canonical source of
# truth). This script delegates to it to prevent drift, then handles the
# responsibilities that s6-overlay normally splits across separate services:
#   - cups-server/run: waits for Avahi socket and launches cupsd
#

# Delegate all CUPS/Avahi configuration to the canonical script
/usr/bin/with-contenv /bin/bash /usr/share/cups-config.sh

# Legacy flag retained for any tooling that may poll for it
touch /var/run/avahi_configured

# Wait for Avahi daemon socket (cups-server/run does this in s6 path)
until [ -e /var/run/avahi-daemon/socket ]; do
  sleep 1s
done

bashio::log.info "Starting CUPS server..."
cupsd -f
