#!/bin/sh

# Env defaults
SOCKS_USER=${SOCKS_USER:-proxyuser}
SOCKS_PASS=${SOCKS_PASS:-changeme}

# Enable Dante auth if sockd.conf exists
if [ -f /etc/sockd.conf ]; then
  sed -i 's/^socksmethod: *none/socksmethod: username/' /etc/sockd.conf
  sed -i '/^[[:space:]]*socks pass {/a \ \ \ \ socksmethod: username' /etc/sockd.conf 2>/dev/null || \
    sed -i 's/^[[:space:]]*socks pass {/&\\n    socksmethod: username/' /etc/sockd.conf
  sed -i 's/__IFNAME__/wg0/g' /etc/sockd.conf
fi

# Create user
adduser -DHS -G nogroup -s /sbin/nologin "$SOCKS_USER" 2>/dev/null || true
echo "$SOCKS_USER:$SOCKS_PASS" | chpasswd

# Original init
exec /original-init-or-previous-entrypoint
