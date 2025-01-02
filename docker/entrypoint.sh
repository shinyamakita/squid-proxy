#!/bin/bash
set -e

# Initialize SSL DB
mkdir -p /var/spool/squid/ssl_db
chown -R proxy:proxy /var/spool/squid
chmod 700 /var/spool/squid/ssl_db

# Create required directories
mkdir -p /var/run/squid/cache
chown -R proxy:proxy /var/run/squid

# replace proxy ip address
PROXY_IP=${PROXY_IP:-"127.0.0.1"}
sed -i "s/PROXY_IP_PLACEHOLDER/${PROXY_IP}/" /etc/squid/squid.conf

# # Initialize cache directories
squid -z

# log directory
mkdir -p /var/log/squid
chown -R proxy:proxy /var/log/squid
chmod -R 750 /var/log/squid

# Start Squid
# exec /usr/sbin/squid-openssl -N -f /etc/squid/squid.conf
exec squid -d 2 -N -f /etc/squid/squid.conf
