#!/bin/sh
# Copy the web app into www/ for the native app (Capacitor). The web site itself stays at the repo root.
set -e
cd "$(dirname "$0")/.."
rm -rf www && mkdir -p www
cp index.html manifest.webmanifest lib-bg-paper.jpg icon-r*.png www/
cp -R vendor www/
echo "www/ ready"
