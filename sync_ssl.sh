#!/bin/bash
# Sync Let's Encrypt SSL certificates to Docker Nginx container
# Author: ratiolin
# Usage: ./sync_ssl.sh

set -e

# ====== Configurable Variables ======
DOMAIN="example.com"
LE_LIVE_DIR="/etc/letsencrypt/live/${DOMAIN}"
TARGET_DIR="/opt/nginx/ssl"
NGINX_CONTAINER="nginx"
# ====================================

echo ">>> Checking certificate directory..."
if [ ! -d "$LE_LIVE_DIR" ]; then
  echo "Certificate directory not found: $LE_LIVE_DIR"
  exit 1
fi

echo ">>> Preparing target directory..."
mkdir -p "$TARGET_DIR"

echo ">>> Syncing certificates..."
cp -L "${LE_LIVE_DIR}/fullchain.pem" "${TARGET_DIR}/fullchain.pem"
cp -L "${LE_LIVE_DIR}/privkey.pem"   "${TARGET_DIR}/privkey.pem"

echo ">>> Reloading Nginx container..."
docker exec "$NGINX_CONTAINER" nginx -s reload

echo ">>> SSL sync completed successfully."
