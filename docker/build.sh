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
# The container writes into .awesomer-build/staging. Only after it exits 0 is
# staging swapped into web/out, with two renames on the same filesystem, so
# web/out is always either the old tree or the complete new one (D-07).
#
# Exit codes:
#   0   build succeeded, web/out replaced
#   64  DATABASE_URL host is not localhost/127.0.0.1 (from the entrypoint)
#   69  network awesomer_default missing, awesomer-postgres not healthy, or
#       docker compose could not list the build project's containers
#   73  staging not writable inside the container (from the entrypoint)
#   74  build succeeded but the swap into web/out failed; web/out kept
#   75  refused: another build holds the lock, the nightly unit is running
#       (checked before the build and again right before the swap), UTC time
#       is inside 10:30-11:45, or a previous build container remains
#   77  run as root, or as a user other than 1000:1000 (the container's uid)
#   *   any other code is the compose run's own (1 = build failed, web/out kept)
#
# Test seams: AWESOMER_BUILD_NOW_UTC_HHMM overrides the clock (HHMM, UTC),
# AWESOMER_BUILD_NIGHTLY_UNIT overrides the nightly unit name.
set -euo pipefail
cd "$(dirname "$0")/.."

COMPOSE_FILE=docker-compose.build.yml
STAGING=.awesomer-build/staging
PREVIOUS=.awesomer-build/previous
NIGHTLY_UNIT="${AWESOMER_BUILD_NIGHTLY_UNIT:-awesomer-sync-snapshots.service}"
NOW="${AWESOMER_BUILD_NOW_UTC_HHMM:-$(date -u +%H%M)}"
LOCK="${XDG_RUNTIME_DIR:-/tmp}/awesomer-build.lock"

refuse() {
  echo "docker/build.sh: $2" >&2
  exit "$1"
}

# The nightly is Type=oneshot, so it sits in "activating" for its whole run and
# `systemctl is-active` exits non-zero then. Check ActiveState instead, and
# treat a failed query as busy (fail closed). A unit that is not loaded also
# counts as busy: systemctl reports a missing unit as "inactive" with rc 0, so
# a renamed unit or a typo in AWESOMER_BUILD_NIGHTLY_UNIT would otherwise pass.
# Sets NIGHTLY_WHY to the reason when it returns 0.
nightly_busy() {
  local load state
  NIGHTLY_WHY="its state could not be read"
  load=$(systemctl show -p LoadState --value "$NIGHTLY_UNIT") || return 0
  if [ "$load" != loaded ]; then
    NIGHTLY_WHY="unit not found (LoadState=${load:-empty})"
    return 0
  fi
  state=$(systemctl show -p ActiveState --value "$NIGHTLY_UNIT") || return 0
  case "$state" in
    inactive | failed) return 1 ;;
    *)
      NIGHTLY_WHY="it is running (ActiveState=$state)"
      return 0
      ;;
  esac
}

# Replaces web/out with the staged export. Both renames stay on one
# filesystem; mv -T refuses to nest into an existing directory. On any
# failure web/out is restored or never moved.
swap_in() {
  if [ ! -f "$STAGING/index.html" ]; then
    echo "docker/build.sh: $STAGING/index.html missing; not swapping" >&2
    return 1
  fi
  rm -rf "$PREVIOUS" || return 1
  mv -T web/out "$PREVIOUS" || return 1
  if ! mv -T "$STAGING" web/out; then
    mv -T "$PREVIOUS" web/out
    return 1
  fi
  mkdir -p "$STAGING"
  rm -rf "$PREVIOUS" || echo "docker/build.sh: warning: could not remove $PREVIOUS" >&2
}

# 1. Never as root: web/out must stay owned by the nightly's user.
if [ "$(id -u)" -eq 0 ]; then
  refuse 77 "refusing to run as root: web/out must stay owned by the nightly's user"
fi
# The container runs as the fixed user: "1000:1000" in the compose file, so
# the export is only owned by the invoking (nightly) user when that is 1000:1000.
if [ "$(id -u):$(id -g)" != "1000:1000" ]; then
  refuse 77 "the build container runs as 1000:1000 but you are $(id -u):$(id -g); web/out would end up owned by another user"
fi

# 2. One build at a time. fd 9 stays open, so the lock is held through the run.
exec 9>"$LOCK"
if ! flock -n 9; then
  refuse 75 "another build is running (lock $LOCK)"
fi

# 3. Not while the nightly is running (it also writes web/out).
if nightly_busy; then
  refuse 75 "$NIGHTLY_UNIT: $NIGHTLY_WHY; refusing (wait for it to finish, or fix the unit name)"
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

# 7. No leftover container from an earlier interrupted run. A failed query
#    (daemon down, api/.env missing) refuses rather than reading as "none".
if ! leftover=$(docker compose -f "$COMPOSE_FILE" ps -a -q); then
  refuse 69 "could not list awesomer-build containers (docker compose ps failed; is api/.env present?)"
fi
if [ -n "$leftover" ]; then
  refuse 75 "a previous awesomer-build container still exists; inspect it with docker compose -f $COMPOSE_FILE ps -a"
fi

# Create the bind source and swap target as the invoking user
# (compose uses create_host_path: false).
mkdir -p web/out "$STAGING"
before=$(stat -c %Y web/out)
echo "docker/build.sh: preflight passed; web/out mtime before run: $before"

rc=0
docker compose -f "$COMPOSE_FILE" run --rm --build builder || rc=$?

if [ "$rc" -ne 0 ]; then
  echo "docker/build.sh: build failed (exit $rc); web/out left as it was" >&2
  exit "$rc"
fi

# Re-check right before the swap: the nightly may have started during the
# build (a manual start or a Persistent=true catch-up). It rebuilds web/out,
# sanity-checks it and publishes it, so never swap under it.
if nightly_busy; then
  refuse 75 "$NIGHTLY_UNIT: $NIGHTLY_WHY at the pre-swap re-check; web/out left as it was, export kept in $STAGING"
fi

if ! swap_in; then
  refuse 74 "build succeeded but swapping $STAGING into web/out failed; web/out left as it was"
fi
echo "docker/build.sh: web/out updated: $(ls web/out/r | wc -l) repo pages, $(ls web/out/l | wc -l) list pages (not deployed)"
