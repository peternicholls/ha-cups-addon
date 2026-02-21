#!/usr/bin/with-contenv bashio

bashio::log.info "Configuring CUPS and Avahi..."

hostname=$(bashio::info.hostname)

# Get all possible hostnames from configuration
result=$(bashio::api.supervisor GET /core/api/config true || true)
internal=$(bashio::jq "$result" '.internal_url // empty' | cut -d'/' -f3 | cut -d':' -f1)
external=$(bashio::jq "$result" '.external_url // empty' | cut -d'/' -f3 | cut -d':' -f1)

if [ -z "$internal" ] || [ -z "$external" ]; then
    bashio::log.warning "Could not determine internal/external URLs from HA config; ServerAlias may be incomplete"
fi

# Build template variables
config=$(jq --arg internal "$internal" --arg external "$external" --arg hostname "$hostname" \
    '{internal: $internal, external: $external, hostname: $hostname}' \
    /data/options.json)

# Render Avahi config before Avahi daemon starts
echo "$config" | tempio \
    -template /usr/share/avahi-daemon.conf.tempio \
    -out /etc/avahi/avahi-daemon.conf

# Set up /data/cups persistent storage on first run, then symlink /etc/cups to it
if [ ! -L /etc/cups ]; then
    if [ ! -d /data/cups ]; then
        if ! cp -R /etc/cups /data/cups; then
            bashio::log.error "Failed to initialize persistent CUPS configuration under /data/cups; aborting."
            exit 1
        fi
    fi

    rm -rf /etc/cups
    ln -s /data/cups /etc/cups
fi

# Render CUPS config (always refresh so hostname/URL changes are picked up)
echo "$config" | tempio \
    -template /usr/share/cupsd.conf.tempio \
    -out /etc/cups/cupsd.conf

bashio::log.info "CUPS configuration completed."
