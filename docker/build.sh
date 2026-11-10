#!/usr/bin/env bash
#
# Guarded operator entry for the containerized static build:
#
#   docker compose -f docker-compose.build.yml run --rm --build builder
#
# Builds host web/out only. It never deploys (D-08); the nightly timer remains
# the deploy path. Every check below only inspects live infra: no container,
# network or unit is started, stopped or removed by the preflight.
#
# Exit codes:
#   0   build succeeded, web/out replaced
#   64  DATABASE_URL host is not localhost/127.0.0.1 (from the entrypoint)
#   69  network awesomer_default missing or awesomer-postgres not healthy
#   73  web/out not writable inside the container (from the entrypoint)
#   75  refused: another build holds the lock, the nightly unit is active,
#       UTC time is inside 10:30-11:45, or a previous build container remains
#   77  run as root
#   *   any other code is the compose run's own (1 = build failed, web/out kept)
#
# Test seams: AWESOMER_BUILD_NOW_UTC_HHMM overrides the clock (HHMM, UTC),
# AWESOMER_BUILD_NIGHTLY_UNIT overrides the nightly unit name.
set -euo pipefail
cd "$(dirname "$0")/.."

COMPOSE_FILE=docker-compose.build.yml
NIGHTLY_UNIT="${AWESOMER_BUILD_NIGHTLY_UNIT:-awesomer-sync-snapshots.service}"
NOW="${AWESOMER_BUILD_NOW_UTC_HHMM:-$(date -u +%H%M)}"
LOCK="${XDG_RUNTIME_DIR:-/tmp}/awesomer-build.lock"

refuse() {
  echo "docker/build.sh: $2" >&2
  exit "$1"
}

# 1. Never as root: web/out must stay owned by the nightly's user.
if [ "$(id -u)" -eq 0 ]; then
  refuse 77 "refusing to run as root: web/out must stay owned by the nightly's user"
fi

# 2. One build at a time. fd 9 stays open, so the lock is held through the run.
exec 9>"$LOCK"
if ! flock -n 9; then
  refuse 75 "another build is running (lock $LOCK)"
fi

# 3. Not while the nightly is running (it also writes web/out).
if systemctl is-active --quiet "$NIGHTLY_UNIT"; then
  refuse 75 "$NIGHTLY_UNIT is active; wait for it to finish"
fi

# 4. Not inside the window around the 11:00 UTC timer (Persistent=true, ~26 min run).
if [ $((10#$NOW)) -ge 1030 ] && [ $((10#$NOW)) -le 1144 ]; then
  refuse 75 "inside the nightly window (10:30-11:45 UTC, timer fires 11:00 UTC); try later"
fi

# 5-6. The live database must be reachable on its network.
if ! docker network inspect awesomer_default >/dev/null 2>&1; then
  refuse 69 "network awesomer_default missing; is awesomer-postgres.service running?"
fi
health=$(docker inspect -f '{{.State.Health.Status}}' awesomer-postgres 2>/dev/null || true)
if [ "$health" != "healthy" ]; then
  refuse 69 "awesomer-postgres is not healthy"
fi

# 7. No leftover container from an earlier interrupted run.
if [ -n "$(docker compose -f "$COMPOSE_FILE" ps -a -q 2>/dev/null)" ]; then
  refuse 75 "a previous awesomer-build container still exists; inspect it with docker compose -f $COMPOSE_FILE ps -a"
fi

# Create the bind source as the invoking user (compose uses create_host_path: false).
mkdir -p web/out
before=$(stat -c %Y web/out)
echo "docker/build.sh: preflight passed; web/out mtime before run: $before"

rc=0
docker compose -f "$COMPOSE_FILE" run --rm --build builder || rc=$?

if [ "$rc" -eq 0 ]; then
  echo "docker/build.sh: web/out ready (not deployed)"
else
  echo "docker/build.sh: build failed (exit $rc); web/out left as it was" >&2
fi
exit "$rc"
