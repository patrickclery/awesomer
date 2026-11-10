#!/bin/sh
#
# Entrypoint for the awesomer-build image (docker-compose.build.yml).
#
# 1. Rewrites only the host part of DATABASE_URL to DATABASE_HOST_OVERRIDE
#    (the live Postgres container on the awesomer_default network).
# 2. Runs the strict static build (api/scripts/build-static-site.js).
# 3. Only after that exits 0, replaces the contents of /output (host web/out)
#    with the fresh export (D-07). On any failure /output is left untouched.
#
# It never deploys or pushes anything (D-08) and never prints the connection
# string; only the target host is logged.
set -eu

: "${DATABASE_URL:?DATABASE_URL is not set; is the api env file listed under env_file?}"

if [ -n "${DATABASE_HOST_OVERRIDE:-}" ]; then
  DATABASE_URL="$(printf '%s' "$DATABASE_URL" | sed \
    -e "s#@localhost:#@${DATABASE_HOST_OVERRIDE}:#" \
    -e "s#@localhost/#@${DATABASE_HOST_OVERRIDE}/#" \
    -e "s#@127\.0\.0\.1:#@${DATABASE_HOST_OVERRIDE}:#" \
    -e "s#@127\.0\.0\.1/#@${DATABASE_HOST_OVERRIDE}/#")"
  export DATABASE_URL
  case "$DATABASE_URL" in
    *"@${DATABASE_HOST_OVERRIDE}:"* | *"@${DATABASE_HOST_OVERRIDE}/"*) ;;
    *)
      echo "build-entrypoint: DATABASE_URL host was not rewritten to ${DATABASE_HOST_OVERRIDE} (expected localhost or 127.0.0.1 after the @)" >&2
      exit 64
      ;;
  esac
  echo "build-entrypoint: database host -> ${DATABASE_HOST_OVERRIDE}"
fi

# Fail fast before a multi-minute build if the output mount is not writable.
if ! touch /output/.awesomer-build-write-test 2>/dev/null; then
  echo "build-entrypoint: /output (host web/out) is not writable by uid $(id -u)" >&2
  exit 73
fi
rm -f /output/.awesomer-build-write-test

cd /app/api
# A non-zero exit stops here (set -e), leaving /output untouched.
node scripts/build-static-site.js

find /output -mindepth 1 -delete
cp -a /app/web/out/. /output/
echo "web/out updated: $(ls /output/r | wc -l) repo pages, $(ls /output/l | wc -l) list pages"
