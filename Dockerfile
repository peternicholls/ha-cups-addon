ARG BUILD_FROM
FROM $BUILD_FROM

LABEL io.hass.version="1.0" io.hass.type="addon" io.hass.arch="armhf|aarch64|i386|amd64"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# printer-driver-brlaser specifically called out for Brother printer support
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    sudo \
    locales \
    cups \
    avahi-daemon \
    libnss-mdns \
    dbus \
    colord \
    printer-driver-all-enforce \
    openprinting-ppds \
    hpijs-ppds \
    hp-ppd  \
    hplip \
    printer-driver-brlaser \
    cups-pdf \
    cups-filters \
    cups-browsed \
    nginx \
    gnupg2 \
    lsb-release \
    nano \
    samba \
    bash-completion \
    procps \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /etc/nginx/sites-enabled /etc/nginx/sites-available \
    && rm -f /etc/nginx/conf.d/*.conf

COPY rootfs /

# Allow sudo group passwordless sudo (admin user is created at runtime by cups-config.sh)
RUN sed -i '/%sudo[[:space:]]/ s/ALL[[:space:]]*$/NOPASSWD:ALL/' /etc/sudoers

# CUPS default port — matches config.yaml ports and cupsd.conf.tempio
EXPOSE 631
RUN find /etc/s6-overlay/s6-rc.d -type f \( -name 'run' -o -name 'up' \) -print0 | xargs -0 -r chmod a+x \
    && chmod a+x /usr/share/cups-config.sh
