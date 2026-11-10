# syntax=docker/dockerfile:1
#
# One-shot build image for docker-compose.build.yml.
#
# Carries the intent of D-09/D-10: the generated Prisma client lives inside
# api/src/ and is compiled by nest build, the compiled entry is under
# dist/src/, and the web app is built as a static export by the runtime build
# step (SyncService.rebuildStaticSite()), not as a Next server.
#
# bookworm-slim is chosen to match the host's glibc, where the nightly runs.
FROM node:22-bookworm-slim@sha256:5ec23b7c622b00547753bc6ffd78085dd868a68aeb41c8e0a1418f033e13d96d

WORKDIR /app
RUN chown node:node /app
USER node

# Dependencies first for layer caching. NODE_ENV is deliberately left unset:
# npm ci must install the devDependencies that nest, tsc and tailwind need.
COPY --chown=node:node api/package.json api/package-lock.json api/
# --legacy-peer-deps is still required for the @nestjs/cli peerOptional
# @swc/cli conflict (RESEARCH Context Drift).
RUN cd api && npm ci --legacy-peer-deps --no-audit --no-fund

COPY --chown=node:node web/package.json web/package-lock.json web/
RUN cd web && npm ci --no-audit --no-fund

COPY --chown=node:node api/ api/
COPY --chown=node:node web/ web/

# prisma generate first: nest build compiles the generated client under
# api/src/generated/prisma/.
RUN cd api && npx prisma generate && npm run build \
 && test -f dist/src/main.js && test -f dist/src/generated/prisma/client.js

COPY --chown=node:node --chmod=0755 docker/build-entrypoint.sh /usr/local/bin/build-entrypoint.sh

# rebuildStaticSite resolves web/ as process.cwd()/../web
WORKDIR /app/api
ENTRYPOINT ["/usr/local/bin/build-entrypoint.sh"]
