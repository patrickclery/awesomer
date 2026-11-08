# deploy/

Host config for the nightly sync worker. The worker is a systemd timer, not a container: the timer starts a oneshot service that runs the Node pipeline from `api/`. The only container is Postgres.

For install, enable and run checks, see [Running on a host (systemd)](../INSTALL.md#running-on-a-host-systemd).

| File | Lives on the host at | What it is |
|------|----------------------|------------|
| `host/awesomer-sync-snapshots.service` | `/etc/systemd/system/` | Oneshot that runs `scripts/run-daily-pipeline.js` from `api/` |
| `host/awesomer-sync-snapshots.timer` | `/etc/systemd/system/` | Daily 11:00 UTC trigger, `Persistent=true` |
| `host/awesomer-postgres.service` | `/etc/systemd/system/` | Brings up the Postgres compose stack in `/opt/awesomer` |
| `docker-compose.yml` | `/opt/awesomer/` | `postgres:18-alpine` on `127.0.0.1:5432` |
| `.env.example` | template for `/opt/awesomer/.env` | Placeholder `POSTGRES_PASSWORD`; the real file is root-only and never committed |
| `deploy.sh` | not installed | Run from the checkout: copies the files above into place, then `daemon-reload` |

## Drift check

Run from the repository root. No output means the repo copy and the host are in sync:

```bash
cmp deploy/host/awesomer-sync-snapshots.service /etc/systemd/system/awesomer-sync-snapshots.service
cmp deploy/host/awesomer-sync-snapshots.timer /etc/systemd/system/awesomer-sync-snapshots.timer
cmp deploy/host/awesomer-postgres.service /etc/systemd/system/awesomer-postgres.service
cmp deploy/docker-compose.yml /opt/awesomer/docker-compose.yml
```

An identical copy of these files lives in the private homelab repo at `docker/awesomer/`. Update both together, or a reinstall from the stale copy silently reverts a fix.

## Known issue: Postgres readiness

`awesomer-postgres.service` runs `docker compose up -d`, which returns once the container is created, not once Postgres accepts connections. `After=` therefore lets the sync service start against a database that is still starting, most likely on the `Persistent=true` catch-up at boot. The oneshot has no `Restart=`, so a failed connect loses that day's run. The fix is deferred so the checked-in units stay identical to the live ones. At the next live change, switch to `ExecStart=/usr/bin/docker compose up -d --wait --wait-timeout 240`, which blocks until the compose healthcheck passes, and update the homelab copy in the same change.

## Caution

`deploy.sh` rsyncs this whole directory into `/opt/awesomer` with `--delete`. It excludes the secret file, `host/`, `deploy.sh`, `README.md` and `.env.example`, but any other file added here lands on the host, and anything in `/opt/awesomer` not present here is deleted. Keep the directory to these files, and never commit a real secret file.
