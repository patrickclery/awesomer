#!/usr/bin/env bash
#
# Gate bundle for the containerized static build (docker-compose.build.yml).
#
# Usage: bash docker/verify-build.sh <mode>
#   static              read-only shape checks on the build files (seconds)
#   image               builds awesomer-build:local and checks its contents
#   infra               read-only: deploy/ and the live Postgres are untouched
#   output [since-epoch] read-only: host web/out looks like a good export
#   failure             one run against an unresolvable DB host; web/out must stay
#                       (the container only ever writes .awesomer-build/staging)
#   all                 static + image + infra (no build container is started)
#
# Exit codes: 0 all gates passed, 1 a gate failed, 2 usage, 75 failure mode refused.
#
# This script never reads the api env file and never prints env values. Every
# rendering of the build file uses --services or --no-env-resolution with jq
# picking specific keys; container output goes to a log under TMPDIR and only its
# tail is printed when a gate fails.
set -uo pipefail
cd "$(dirname "$0")/.." || exit 2

COMPOSE_FILE=docker-compose.build.yml
DOCKERFILE=docker/build.Dockerfile
ENTRYPOINT_SH=docker/build-entrypoint.sh
BUILD_SCRIPT=api/scripts/build-static-site.js
PROJECT=awesomer-build
NIGHTLY_UNIT=awesomer-sync-snapshots.service
FROM_LINE='FROM node:22-bookworm-slim@sha256:5ec23b7c622b00547753bc6ffd78085dd868a68aeb41c8e0a1418f033e13d96d'

PASSED=0
FAILED=0
pass() { echo "PASS $1 $2"; PASSED=$((PASSED + 1)); }
fail() { echo "FAIL $1 $2"; FAILED=$((FAILED + 1)); }
check() {
  # check ID msg command...
  local id=$1 msg=$2
  shift 2
  if "$@" >/dev/null 2>&1; then pass "$id" "$msg"; else fail "$id" "$msg"; fi
}

dc() { docker compose -f "$COMPOSE_FILE" "$@"; }
cfg_json() { docker compose -f "$COMPOSE_FILE" config --no-env-resolution --format json 2>/dev/null; }
jq_cfg() { cfg_json | jq -e "$1" >/dev/null 2>&1; }

log_file() { echo "${TMPDIR:-/tmp}/awesomer-verify-$1.log"; }
# Redacts anything that looks like a connection URL before printing.
show_log_tail() { [ -f "$1" ] && tail -n 20 "$1" | sed -E 's#postgres(ql)?://[^[:space:]]*#<redacted-url>#g'; }

# Empty-output checks must fail closed: a probe that errors (daemon down,
# env file missing, permission denied) prints nothing, which must not count
# as "nothing found". Each one captures output and status separately.
no_build_container() {
  local out
  out=$(docker ps -aq --filter "label=com.docker.compose.project=$PROJECT") || return 1
  [ -z "$out" ]
}
no_project_container() {
  local out
  out=$(dc ps -a -q) || return 1
  [ -z "$out" ]
}

nightly_guard() {
  # Type=oneshot: "activating" while running, which is-active reports as
  # not active. A failed query refuses too.
  local state
  state=$(systemctl show -p ActiveState --value "$NIGHTLY_UNIT") || state=unknown
  case "$state" in
    inactive | failed) ;;
    *)
      echo "verify-build: $NIGHTLY_UNIT is $state; refusing to start a build container"
      exit 75
      ;;
  esac
  local hhmm
  hhmm=$(date -u +%H%M)
  if [ $((10#$hhmm)) -ge 1030 ] && [ $((10#$hhmm)) -lt 1145 ]; then
    echo "verify-build: UTC time $hhmm is inside the 10:30-11:45 nightly window; refusing"
    exit 75
  fi
}

# ---------------------------------------------------------------------------
# static
# ---------------------------------------------------------------------------
mode_static() {
  # S1 exactly one service, builder
  check S1 "services are exactly: builder" test "$(dc config --services 2>/dev/null)" = builder

  # S2 project name, and it is the first non-comment key
  if jq_cfg '.name == "awesomer-build"' &&
    [ "$(awk '!/^#/ && NF {print; exit}' "$COMPOSE_FILE")" = "name: awesomer-build" ]; then
    pass S2 "project name awesomer-build is the first key"
  else
    fail S2 "project name awesomer-build is the first key"
  fi

  # S3 builder shape
  check S3 "builder shape (user, init, network, bind, env_file, environment)" jq_cfg '
    .services.builder as $b
    | $b.user == "1000:1000"
    and $b.init == true
    and $b.ports == null
    and $b.expose == null
    and $b.network_mode == null
    and ($b.networks | keys) == ["awesomer-db"]
    and .networks["awesomer-db"].external == true
    and .networks["awesomer-db"].name == "awesomer_default"
    and ($b.volumes | length) == 1
    and $b.volumes[0].type == "bind"
    and ($b.volumes[0].source | endswith("/.awesomer-build/staging"))
    and $b.volumes[0].target == "/output"
    and $b.volumes[0].bind.create_host_path == false
    and ($b.env_file | length) == 1
    and ($b.env_file[0].path | endswith("/api/.env"))
    and $b.environment.BASE_PATH == "/awesomer"
    and $b.environment.PORT == "4000"
    and $b.environment.DATABASE_HOST_OVERRIDE == "awesomer-postgres"'

  # S4 (D-03/D-04) one service, no proxy/cache/db service
  check S4 "one service; none named or imaged caddy/redis/postgres" jq_cfg '
    (.services | length) == 1
    and ([.services | to_entries[] | (.key + " " + (.value.image // ""))
          | ascii_downcase | test("caddy|redis|postgres")] | any | not)'

  # S5 (D-01 safety) the build project owns no container
  check S5 "build project owns no container (ps -a empty)" no_project_container

  # S6 (D-08) build script only rebuilds, and its API listens on loopback only
  if grep -q 'rebuildStaticSite()' "$BUILD_SCRIPT" &&
    grep -qF "app.listen(port, '127.0.0.1')" "$BUILD_SCRIPT" &&
    [ "$(grep -Ec '\.(run|deploy|commit)[A-Za-z]*\(' "$BUILD_SCRIPT")" = 0 ] &&
    node --check "$BUILD_SCRIPT" >/dev/null 2>&1; then
    pass S6 "build script calls rebuildStaticSite() only, listens on 127.0.0.1, parses"
  else
    fail S6 "build script calls rebuildStaticSite() only, listens on 127.0.0.1, parses"
  fi

  # S7 (D-09/D-10) Dockerfile shape
  if [ "$(grep -cxF "$FROM_LINE" "$DOCKERFILE")" = 1 ] &&
    [ "$(grep -c '^USER node$' "$DOCKERFILE")" = 1 ] &&
    [ "$(grep -c '^ENTRYPOINT \["/usr/local/bin/build-entrypoint.sh"\]$' "$DOCKERFILE")" = 1 ] &&
    ! grep -qE '^[A-Z]+ .*[[:space:]]#' "$DOCKERFILE" &&
    [ "$(grep -Ec 'dist/main\.js|standalone|server\.js' "$DOCKERFILE")" = 0 ]; then
    pass S7 "Dockerfile: pinned FROM, USER node, ENTRYPOINT, no trailing comments, dist/src entry"
  else
    fail S7 "Dockerfile: pinned FROM, USER node, ENTRYPOINT, no trailing comments, dist/src entry"
  fi

  # S8 (D-11) no root-level Dockerfile or compose file
  local f present=0
  for f in Dockerfile docker-compose.yml compose.yaml compose.yml; do
    [ -e "$f" ] && present=1
  done
  if [ -z "$(git ls-files Dockerfile docker-compose.yml compose.yaml compose.yml)" ] && [ $present = 0 ]; then
    pass S8 "no root Dockerfile/docker-compose.yml/compose.yaml/compose.yml"
  else
    fail S8 "no root Dockerfile/docker-compose.yml/compose.yaml/compose.yml"
  fi

  # S9 .dockerignore is an allowlist that keeps secrets and caches out
  local s9=1 rule
  [ "$(awk '!/^#/ && NF {print; exit}' .dockerignore)" = '*' ] || s9=0
  [ "$(grep -E '^!' .dockerignore | LC_ALL=C sort | paste -sd' ')" = '!api !docker !web' ] || s9=0
  for rule in '**/.env*' api/node_modules api/dist api/src/generated web/node_modules web/.next web/out web/data; do
    grep -qxF "$rule" .dockerignore || s9=0
  done
  if [ $s9 = 1 ]; then pass S9 ".dockerignore allowlist (*, !api !web !docker, secret/cache exclusions)"; else
    fail S9 ".dockerignore allowlist (*, !api !web !docker, secret/cache exclusions)"; fi

  # S10 entrypoint: sh, strict, no tracing, copies only the export
  if [ "$(head -1 "$ENTRYPOINT_SH")" = '#!/bin/sh' ] &&
    grep -qx 'set -eu' "$ENTRYPOINT_SH" &&
    ! grep -qE 'set -[a-z]*x|set -o xtrace' "$ENTRYPOINT_SH" &&
    grep -qF 'cp -a /app/web/out/. /output/' "$ENTRYPOINT_SH"; then
    pass S10 "entrypoint: #!/bin/sh, set -eu, no xtrace, copies /app/web/out"
  else
    fail S10 "entrypoint: #!/bin/sh, set -eu, no xtrace, copies /app/web/out"
  fi

  # S11 (D-07) build.sh swaps staging into web/out by rename, never by copy
  if grep -qF 'mv -T "$STAGING" web/out' docker/build.sh &&
    grep -qx 'STAGING=.awesomer-build/staging' docker/build.sh &&
    bash -n docker/build.sh 2>/dev/null; then
    pass S11 "build.sh renames .awesomer-build/staging into web/out and parses"
  else
    fail S11 "build.sh renames .awesomer-build/staging into web/out and parses"
  fi
}

# ---------------------------------------------------------------------------
# image
# ---------------------------------------------------------------------------
img() { docker run --rm --entrypoint sh awesomer-build:local -c "$1"; }
no_env_in_image() {
  local out
  out=$(img "find /app -path '*/node_modules' -prune -o -name '.env*' -print") || return 1
  [ -z "$out" ]
}

mode_image() {
  local log
  log=$(log_file image)
  if dc build builder >"$log" 2>&1; then
    pass I1 "image awesomer-build:local builds"
  else
    fail I1 "image awesomer-build:local builds"
    show_log_tail "$log"
    return
  fi
  check I2 "compiled API, generated client and build script present" img '
    test -f /app/api/dist/src/main.js &&
    test -f /app/api/dist/src/app.module.js &&
    test -f /app/api/dist/src/sync/sync.service.js &&
    test -f /app/api/dist/src/generated/prisma/client.js &&
    test -f /app/api/scripts/build-static-site.js'
  check I3 "no env file baked into /app" no_env_in_image
  check I4 "no host build output (web/.next, web/out, web/data) in the image" img \
    '! test -e /app/web/.next && ! test -e /app/web/out && ! test -e /app/web/data'
  check I5 "no git binary in the image (D-08)" img '! command -v git'
  check I6 "default uid is 1000" test "$(img 'id -u' 2>/dev/null)" = 1000
  check I7 "/app holds exactly api and web" test "$(img 'ls -A /app' 2>/dev/null | paste -sd' ')" = 'api web'
}

# ---------------------------------------------------------------------------
# infra
# ---------------------------------------------------------------------------
mode_infra() {
  if git diff --quiet HEAD -- deploy/ && [ -z "$(git status --porcelain -- deploy/)" ]; then
    pass F1 "deploy/ unchanged and clean"
  else
    fail F1 "deploy/ unchanged and clean"
  fi
  if cmp -s deploy/host/awesomer-sync-snapshots.service /etc/systemd/system/awesomer-sync-snapshots.service &&
    cmp -s deploy/host/awesomer-sync-snapshots.timer /etc/systemd/system/awesomer-sync-snapshots.timer &&
    cmp -s deploy/host/awesomer-postgres.service /etc/systemd/system/awesomer-postgres.service &&
    cmp -s deploy/docker-compose.yml /opt/awesomer/docker-compose.yml; then
    pass F2 "deploy/ matches the live systemd units and /opt/awesomer"
  else
    fail F2 "deploy/ matches the live systemd units and /opt/awesomer"
  fi
  check F3 "awesomer-postgres healthy and still in compose project awesomer" test \
    "$(docker inspect -f '{{.State.Health.Status}} {{index .Config.Labels "com.docker.compose.project"}}' awesomer-postgres 2>/dev/null)" \
    = "healthy awesomer"
  check F4 "network awesomer_default exists" docker network inspect awesomer_default
  check F5 "no awesomer-build container exists" no_build_container
}

# ---------------------------------------------------------------------------
# output
# ---------------------------------------------------------------------------
all_owned_by_me() {
  local out
  [ -d "$1" ] || return 1
  out=$(find "$1" ! -user "$(id -u)" -print -quit) || return 1
  [ -z "$out" ]
}

mode_output() {
  local since=${1:-} idx=web/out/index.html
  check O1 "index.html >= 50000 bytes" test "$(stat -c %s "$idx" 2>/dev/null || echo 0)" -ge 50000
  check O2 "web/out/r has >= 5000 entries" test "$(ls web/out/r 2>/dev/null | wc -l)" -ge 5000
  check O3 "web/out/l has >= 25 entries" test "$(ls web/out/l 2>/dev/null | wc -l)" -ge 25
  check O4 "index.html references /awesomer/_next/" grep -q '/awesomer/_next/' "$idx"
  check O5 "every file under web/out is owned by uid $(id -u)" all_owned_by_me web/out
  check O6 "no awesomer-build container remains" no_build_container
  if [ -n "$since" ]; then
    check O7 "index.html is newer than $since" test "$(stat -c %Y "$idx" 2>/dev/null || echo 0)" -gt "$since"
  fi
}

# ---------------------------------------------------------------------------
# failure
# ---------------------------------------------------------------------------
mode_failure() {
  nightly_guard
  local log idx=web/out/index.html before after rc
  log=$(log_file failure)
  before=$(stat -c %Y "$idx" 2>/dev/null || echo missing)
  mkdir -p .awesomer-build/staging
  dc run --rm -e DATABASE_HOST_OVERRIDE=nonexistent-host.invalid builder >"$log" 2>&1
  rc=$?
  after=$(stat -c %Y "$idx" 2>/dev/null || echo missing)
  local before_failed=$FAILED
  check X1 "build against an unresolvable DB host exits non-zero (rc=$rc)" test "$rc" -ne 0
  check X2 "web/out/index.html mtime unchanged" test "$before" = "$after"
  check X3 "log lacks 'export staged:'/'web/out updated:'" bash -c '! grep -Eq "export staged:|web/out updated:" "$1"' _ "$log"
  check X4 "log contains no connection URL" bash -c '! grep -Eq "postgres(ql)?://" "$1"' _ "$log"
  check X5 "no awesomer-build container remains" no_build_container
  [ "$FAILED" -gt "$before_failed" ] && show_log_tail "$log"
}

# ---------------------------------------------------------------------------
MODE=${1:-}
case "$MODE" in
  static) mode_static ;;
  image) mode_image ;;
  infra) mode_infra ;;
  output) mode_output "${2:-}" ;;
  failure) mode_failure ;;
  all)
    mode_static
    mode_image
    mode_infra
    ;;
  *)
    echo "usage: bash docker/verify-build.sh static|image|infra|output [since-epoch]|failure|all" >&2
    exit 2
    ;;
esac

echo "verify-build $MODE: $PASSED passed, $FAILED failed"
[ "$FAILED" -eq 0 ]
