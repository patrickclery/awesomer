#!/bin/bash
# Deploy deploy/ from the awesomer repo to its live locations (homelab docker/awesomer/ holds an identical copy).
#   /opt/awesomer         docker-compose.yml for the awesomer-postgres container
#   /etc/systemd/system   awesomer-postgres.service, awesomer-sync-snapshots.{service,timer}
# Never touches /opt/awesomer/.env.
set -euo pipefail
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEPLOY_DIR=/opt/awesomer

sudo mkdir -p "$DEPLOY_DIR"
sudo rsync -a --delete --exclude .env --exclude host --exclude deploy.sh --exclude README.md --exclude .env.example \
  "$REPO_DIR/" "$DEPLOY_DIR/"
for u in awesomer-postgres.service awesomer-sync-snapshots.service awesomer-sync-snapshots.timer; do
  sudo install -m 0644 "$REPO_DIR/host/$u" "/etc/systemd/system/$u"
done
sudo systemctl daemon-reload
[ -f "$DEPLOY_DIR/.env" ] || echo "NOTE: $DEPLOY_DIR/.env missing -- copy .env.example and fill POSTGRES_PASSWORD"
echo "deployed. start with: sudo systemctl enable --now awesomer-postgres awesomer-sync-snapshots.timer"
