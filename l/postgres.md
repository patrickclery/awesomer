# awesome-postgres

> A curated list of awesome PostgreSQL software, libraries, tools and resources, inspired by awesome-mysql

[Home](../README.md) | [Live site ↗](https://patrickclery.com/awesomer/l/postgres/) | [Source ↗](https://github.com/dhamaniasad/awesome-postgres)

## Top 10 Trending

| # | Repo | Stars | 7d | 30d | 90d |
|---|------|-------|----|-----|-----|
| 1 | [PostgREST](../r/postgrest~postgrest.md) | 27,046 | +71 | +342 | +435 |
| 2 | [CloudNativePG operator](../r/cloudnative-pg~cloudnative-pg.md) | 8,528 | +43 | +200 | +309 |
| 3 | [Pigsty](../r/vonng~pigsty.md) | 5,056 | +37 |  |  |
| 4 | [pgweb](../r/sosedoff~pgweb.md) | 9,336 | +31 | +56 | +75 |
| 5 | [pg_search](../r/paradedb~paradedb.md) | 8,710 | +30 | +104 | +207 |
| 6 | [Teable](../r/teableio~teable.md) | 21,182 | +30 | +117 | +212 |
| 7 | [wal-g](../r/wal-g~wal-g.md) | 4,048 | +29 | +63 | +81 |
| 8 | [atlas](../r/ariga~atlas.md) | 8,335 | +28 | +112 | +198 |
| 9 | [pgBoss](../r/timgit~pg-boss.md) | 3,446 | +28 |  |  |
| 10 | [Patroni](../r/zalando~patroni.md) | 8,391 | +24 | +94 |  |

## Table of Contents

- [Backups](#backups)
- [CLI](#cli)
- [Distributions](#distributions)
- [Extensions](#extensions)
- [GUI](#gui)
- [High-Availability](#high-availability)
- [Kubernetes](#kubernetes)
- [Language bindings](#language-bindings)
- [Monitoring](#monitoring)
- [Optimization](#optimization)
- [Platforms](#platforms)
- [Security](#security)
- [Server](#server)
- [Tutorials](#tutorials)
- [Utilities](#utilities)
- [Work Queues](#work-queues)

## Backups

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [wal-g](../r/wal-g~wal-g.md) | Archival and Restoration for databases in the Cloud | 4,048 | +29 |
| [pgbackweb](../r/eduardolat~pgbackweb.md) | 🐘 Effortless PostgreSQL backups with a user-friendly web interface! 🌐💾 | 2,571 | +11 |
| [pghoard](../r/aiven~pghoard.md) | PostgreSQL® backup and restore service | 1,410 | +6 |
| [pg\_probackup](../r/postgrespro~pg_probackup.md) | Backup and recovery manager for PostgreSQL | 786 | +1 |
| [OmniPITR](../r/omniti-labs~omnipitr.md) | Advanced WAL File Management Tools for PostgreSQL | 179 | +0 |
| [pg-backups-to-s3](../r/saicheg~pg-backups-to-s3.md) | Small tool to create your postgresql backups on regular bases and upload them to S3   | 19 | +0 |
| [pg\_back](../r/orgrim~pg_back.md) | Simple backup tool for PostgreSQL | 563 | +0 |
| [pgbackup-sidecar](../r/musab520~pgbackup-sidecar.md) | `pgbackup-sidecar` is a lightweight Docker sidecar container designed to automate regular backups of a PostgreSQL databa | 5 | +0 |
| [postgres-backup-oss](../r/isaced~postgres-backup-oss.md) | A handy Docker container to periodically backup PostgreSQL to Alibaba Cloud Object Storage Service (OSS) | 1 | +0 |
| [wal-e](../r/wal-e~wal-e.md) | Continuous Archiving for Postgres | 3,470 | +0 |

[Back to top](#awesome-postgres)

## CLI

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [atlas](../r/ariga~atlas.md) | Declarative schema migrations with schema-as-code workflows | 8,335 | +28 |
| [pgcli](../r/dbcli~pgcli.md) | Postgres CLI with autocompletion and syntax highlighting | 13,131 | +11 |
| [sabiql](../r/riii111~sabiql.md) | A fast PostgreSQL TUI written in Rust — driver-less, vim-first, with ER diagrams. No database drivers, no setup, just ps | 173 | +9 |
| [schemaspy](../r/schemaspy~schemaspy.md) | Database documentation built easy | 3,575 | +6 |
| [pg-schema-diff](../r/stripe~pg-schema-diff.md) | Go library for diffing Postgres schemas and generating SQL migrations | 841 | +5 |
| [MigrationPilot](../r/mickelsamuel~migrationpilot.md) | Know exactly what your PostgreSQL migration will do to production — before you merge. | 3 | +0 |
| [pgplan](../r/jacobarthurs~pgplan.md) | Compare and analyze PostgreSQL EXPLAIN plans from the CLI | 12 | +0 |
| [pgsh](../r/sastraxi~pgsh.md) | Branch your PostgreSQL Database like Git | 600 | +0 |
| [psql2csv](../r/fphilipe~psql2csv.md) | Run a query in psql and output the result as CSV. | 186 | +0 |

[Back to top](#awesome-postgres)

## Distributions

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Pigsty](../r/vonng~pigsty.md) | Enterprise-Grade OSS PostgreSQL Distribution with HA, PITR, IaC, Monitor, 12 kernel forks and 460 PG extensions. Best-of | 5,056 | +37 |

[Back to top](#awesome-postgres)

## Extensions

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [pg_search](../r/paradedb~paradedb.md) | Simple, Elastic-quality search for Postgres | 8,710 | +30 |
| [AGE](../r/apache~age.md) | Graph database optimized for fast analysis and real-time data processing. It is provided as an extension to PostgreSQL. | 4,463 | +19 |
| [Citus](../r/citusdata~citus.md) | Distributed PostgreSQL as an extension | 12,451 | +11 |
| [pg\_partman](../r/pgpartman~pg_partman.md) | Partition management extension for PostgreSQL | 2,683 | +10 |
| [pg_cron](../r/citusdata~pg_cron.md) | Run periodic jobs in PostgreSQL | 3,767 | +8 |
| [HypoPG](../r/hypopg~hypopg.md) | Hypothetical Indexes for PostgreSQL | 1,641 | +4 |
| [pgRouting](../r/pgrouting~pgrouting.md) | Repository contains pgRouting library. Development branch is "develop", stable branch is "master" | 1,390 | +3 |
| [pg\_squeeze](../r/cybertec-postgresql~pg_squeeze.md) | A PostgreSQL extension for automatic bloat cleanup | 667 | +2 |
| [pglogical](../r/2ndquadrant~pglogical.md) | Logical Replication extension for PostgreSQL 17, 16, 15, 14, 13, 12, 11, 10, 9.6, 9.5, 9.4 (Postgres), providing much fa | 1,216 | +2 |
| [pgMemento](../r/pgmemento~pgmemento.md) | Audit trail with schema versioning for PostgreSQL using transaction-based logging | 406 | +2 |
| [pg\_stat\_monitor](../r/percona~pg_stat_monitor.md) | Query Performance Monitoring Tool for PostgreSQL | 573 | +1 |
| [cstore\_fdw](../r/citusdata~cstore_fdw.md) | Columnar storage extension for Postgres built as a foreign data wrapper. Check out https://github.com/citusdata/citus fo | 1,786 | +0 |
| [pg\_barcode](../r/btouchard~pg_barcode.md) | PostgreSQL SVG QRcode & Datamatrix generator | 1 | +0 |
| [pg\_paxos](../r/citusdata~pg_paxos.md) | Basic implementation of Paxos and Paxos-based table replication for a cluster of PostgreSQL nodes | 309 | +0 |
| [pg\_shard](../r/citusdata~pg_shard.md) | ATTENTION: pg_shard is superseded by Citus, its more powerful replacement | 1,063 | +0 |
| [PG\_Themis](../r/cossacklabs~pg_themis.md) | Postgres Themis plugin | 33 | +0 |
| [pgcat](../r/kingluo~pgcat.md) | Enhanced PostgreSQL logical replication | 386 | +0 |
| [plpgsql\_check](../r/okbob~plpgsql_check.md) | plpgsql_check is a linter tool (does source code static analyze) for the PostgreSQL language plpgsql (the native languag | 752 | +0 |
| [zomboDB](../r/zombodb~zombodb.md) | Making Postgres and Elasticsearch work together like it's 2023 | 4,735 | +0 |

[Back to top](#awesome-postgres)

## GUI

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [pgweb](../r/sosedoff~pgweb.md) | Cross-platform client for PostgreSQL databases | 9,336 | +31 |
| [Teable](../r/teableio~teable.md) | ✨ The Next Gen Airtable Alternative: No-Code Postgres | 21,182 | +30 |
| [Redash](../r/getredash~redash.md) | Make Your Company Data Driven. Connect to any data source, easily visualize, dashboard and share your data. | 28,544 | +22 |
| [PgManage](../r/commandprompt~pgmanage.md) | Web tool for database management | 1,006 | +2 |
| [Postbird](../r/paxa~postbird.md) | Open source PostgreSQL GUI client for macOS, Linux and Windows | 1,623 | +1 |
| [temBoard](../r/dalibo~temboard.md) | PostgreSQL Remote Control | 760 | +1 |
| [phpPgAdmin](../r/phppgadmin~phppgadmin.md) | the premier web-based administration tool for postgresql | 845 | +0 |

[Back to top](#awesome-postgres)

## High-Availability

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Patroni](../r/zalando~patroni.md) | A template for PostgreSQL High Availability with Etcd, Consul, ZooKeeper, or Kubernetes | 8,391 | +24 |
| [autobase](../r/vitabaks~autobase.md) | Automated database platform for PostgreSQL® - Your own DBaaS. | 4,148 | +12 |
| [Spock](../r/pgedge~spock.md) | Logical multi-master PostgreSQL replication | 704 | +4 |
| [pgrwl](../r/hashmap-kz~pgrwl.md) | Cloud-Native PostgreSQL WAL receiver. Stream, compress, encrypt, upload, retain and monitor your WAL archive. | 102 | +3 |
| [repmgr](../r/2ndquadrant~repmgr.md) | A lightweight replication manager for PostgreSQL (Postgres) | 1,691 | +1 |
| [Stolon](../r/sorintlab~stolon.md) | PostgreSQL cloud native High Availability and more. | 4,816 | +1 |
| [BDR](../r/2ndquadrant~bdr.md) | Bi-Directional Multi-Master Replication (BDR) for PostgreSQL, deprecated, please visit 2ndQuadrant website for latest BD | 360 | +0 |
| [PAF](../r/clusterlabs~paf.md) | PostgreSQL Automatic Failover: High-Availibility for Postgres, based on Pacemaker and Corosync. | 347 | +0 |
| [pg-status](../r/krylosov-aa~pg-status.md) | A microservice (sidecar) that helps instantly determine the status of your PostgreSQL hosts including whether they are a | 67 | +0 |
| [pglookout](../r/aiven~pglookout.md) | PostgreSQL replication monitoring and failover daemon | 189 | +0 |
| [SkyTools](../r/pgq~skytools-legacy.md) | Obsolete, see https://github.com/pgq/ for maintained code. | 250 | +0 |
| [pg_auto_failover](../r/citusdata~pg_auto_failover.md) | Postgres extension and service for automated failover and high-availability | 1,341 | -1 |

[Back to top](#awesome-postgres)

## Kubernetes

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [CloudNativePG operator](../r/cloudnative-pg~cloudnative-pg.md) | CloudNativePG is a comprehensive platform designed to seamlessly manage PostgreSQL databases within Kubernetes environme | 8,528 | +43 |
| [StackGres Operator](../r/ongres~stackgres.md) | StackGres Operator, Full Stack PostgreSQL on Kubernetes // !! Mirror repository of https://gitlab.com/ongresinc/stackgre | 1,391 | +5 |
| [Crunchy Operator](../r/crunchydata~postgres-operator.md) | Production PostgreSQL for Kubernetes, from high availability Postgres clusters to full-scale database-as-a-service. | 4,399 | +3 |
| [Percona PostgreSQL Operator](../r/percona~percona-postgresql-operator.md) | Percona Operator for PostgreSQL | 362 | +2 |
| [Percona Everest Operator](../r/percona~everest-operator.md) | OpenEverest Operator | 41 | +1 |
| [Kubegres Operator](../r/reactive-tech~kubegres.md) | Kubegres is a Kubernetes operator allowing to deploy one or many clusters of PostgreSql instances and manage databases r | 1,354 | +0 |
| [Zalando Operator](../r/zalando~postgres-operator.md) | Postgres operator creates and manages PostgreSQL clusters running in Kubernetes | 5,146 | -1 |

[Back to top](#awesome-postgres)

## Language bindings

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [pq](../r/lib~pq.md) | Go PostgreSQL driver for database/sql | 9,871 | +13 |
| [node-postgres](../r/brianc~node-postgres.md) | PostgreSQL client for node.js. | 13,120 | +11 |
| [pg.zig](../r/karlseguin~pg.zig.md) | Native PostgreSQL driver / client for Zig | 542 | +11 |
| [Npgsql](../r/npgsql~npgsql.md) | Npgsql is the .NET data provider for PostgreSQL. | 3,680 | +6 |
| [rust-postgresql](../r/sfackler~rust-postgres.md) | Native PostgreSQL driver for the Rust programming language | 3,932 | +6 |
| [clj-postgresql](../r/remodoy~clj-postgresql.md) | PostgreSQL helpers for Clojure projects | 162 | +0 |
| [luapgsql](../r/arcapos~luapgsql.md) | Lua binding for PostgreSQL | 120 | +0 |
| [pg](../r/ged~ruby-pg.md) | A PostgreSQL client library for Ruby | 856 | +0 |
| [postgrex](../r/elixir-ecto~postgrex.md) | PostgreSQL driver for Elixir | 1,208 | +0 |
| [Postmodern](../r/marijnh~postmodern.md) | A Common Lisp PostgreSQL programming interface | 429 | +0 |
| [RPostgres](../r/r-dbi~rpostgres.md) | A DBI-compliant interface to PostgreSQL | 337 | +0 |
| [zapatos](../r/jawj~zapatos.md) | Zero-abstraction Postgres for TypeScript: a non-ORM database library | 1,401 | +0 |

[Back to top](#awesome-postgres)

## Monitoring

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [coroot](../r/coroot~coroot.md) | Coroot is an open-source observability and APM tool with AI-powered Root Cause Analysis. It combines metrics, logs, trac | 7,585 | +12 |
| [postgres_exporter](../r/wrouesnel~postgres_exporter.md) | A PostgreSQL metric exporter for Prometheus | 3,502 | +8 |
| [PMM](../r/percona~pmm.md) | Percona Monitoring and Management: an open source database monitoring, observability and management tool | 1,012 | +6 |
| [pg_exporter](../r/vonng~pg_exporter.md) | Advanced PostgreSQL & Pgbouncer Metrics Exporter for Prometheus | 345 | +2 |
| [Check\_postgres](../r/bucardo~check_postgres.md) | Nagios check_postgres plugin for checking status of PostgreSQL databases | 598 | +1 |
| [check\_pgactivity](../r/opmdg~check_pgactivity.md) | Nagios remote agent | 181 | +0 |
| [dexter](../r/ankane~dexter.md) | The automatic indexer for Postgres | 2,075 | +0 |
| [Instrumental](../r/instrumental~instrumentald.md) | Instrumental System and Service Daemon | 15 | +0 |
| [libzbxpgsql](../r/cavaliercoder~libzbxpgsql.md) | Monitor PostgreSQL with Zabbix | 155 | +0 |
| [pg_ash](../r/nikolays~pg_ash.md) | Active Session History for PostgreSQL — wait event sampling with zero bloat (pg_cron + PGQ-style partition rotation) | 219 | +0 |
| [pg\_view](../r/zalando~pg_view.md) | Get a detailed, real-time view of your PostgreSQL database and system metrics | 505 | +0 |
| [pgwatch2](../r/cybertec-postgresql~pgwatch2.md) | PostgreSQL metrics monitor/dashboard | 1,844 | +0 |
| [Pome](../r/rach~pome.md) | A Postgres Metrics Dashboard | 1,076 | +0 |

[Back to top](#awesome-postgres)

## Optimization

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [PgHero](../r/ankane~pghero.md) | A performance dashboard for Postgres | 8,851 | +13 |
| [pgtune](../r/le0pard~pgtune.md) | Pgtune - tuning PostgreSQL config by your hardware | 2,701 | +7 |
| [PEV2](../r/dalibo~pev2.md) | Postgres Explain Visualizer 2 | 3,460 | +5 |
| [aqo](../r/postgrespro~aqo.md) | Adaptive query optimization for PostgreSQL | 491 | +1 |
| [TimescaleDB Tune](../r/timescale~timescaledb-tune.md) | A tool for tuning TimescaleDB for better performance by adjusting settings to match your system's CPU and memory resourc | 500 | +1 |
| [pg_flame](../r/mgartner~pg_flame.md) | A flamegraph generator for Postgres EXPLAIN ANALYZE output. | 1,617 | +0 |
| [pg_web_stats](../r/kirs~pg_web_stats.md) | Web UI to view pg_stat_statements | 97 | +0 |
| [pgassistant](../r/beh74~pgassistant-community.md) | A PostgreSQL assistant for developers Understand, optimize, and improve your PostgreSQL database with ease. | 29 | +0 |
| [pgconfig.org](../r/sebastianwebber~pgconfig.md) | Web Based PostgreSQL configuration tool | 88 | +0 |
| [pgtune](../r/gregs1104~pgtune.md) | PostgreSQL configuration wizard | 1,085 | +0 |

[Back to top](#awesome-postgres)

## Platforms

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Atlas4D](../r/crisbez~atlas4d-base.md) | Self-hosted 4D spatiotemporal AI platform built on PostgreSQL, PostGIS, TimescaleDB, H3 and pgvector, with anomaly & thr | 13 | +1 |

[Back to top](#awesome-postgres)

## Security

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Acra](../r/cossacklabs~acra.md) | Database security suite. Database proxy with field-level encryption, search through encrypted data, SQL injections preve | 1,473 | +2 |

[Back to top](#awesome-postgres)

## Server

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Apache Cloudberry](../r/apache~cloudberry.md) | One advanced and mature open-source MPP (Massively Parallel Processing) database. Open source alternative to Greenplum D | 1,211 | +8 |

[Back to top](#awesome-postgres)

## Tutorials

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [pg-utils](../r/dataegret~pg-utils.md) | Useful PostgreSQL utilities | 1,206 | +2 |
| [postgresDBSamples](../r/morenoh149~postgresdbsamples.md) | Sample databases for postgres | 549 | +1 |
| [SQL Syntax Cheat Sheet](../r/mergisi~sql-syntax-cheat-sheet.md) | A comprehensive SQL syntax cheat sheet for quick reference, covering essential commands, functions, operators, and conce | 39 | +1 |
| [pagila](../r/xzilla~pagila.md) | The PostgreSQL Sample Database | 73 | +0 |

[Back to top](#awesome-postgres)

## Utilities

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [PostgREST](../r/postgrest~postgrest.md) | REST API for any Postgres database | 27,046 | +71 |
| [Hasura GraphQL Engine](../r/hasura~graphql-engine.md) | Blazing fast, instant realtime GraphQL APIs on all your data with fine grained access control, also trigger webhooks on  | 31,968 | +16 |
| [pgroll](../r/xataio~pgroll.md) | PostgreSQL zero-downtime migrations made easy | 6,452 | +10 |
| [PostGraphile](../r/graphile~postgraphile.md) | 🔮 Graphile's Crystal Monorepo; home to Grafast, PostGraphile, pg-introspection, pg-sql2 and much more! | 12,921 | +7 |
| [pgloader](../r/dimitri~pgloader.md) | Migrate to PostgreSQL in a single command! | 6,403 | +6 |
| [pg_timetable](../r/cybertec-postgresql~pg_timetable.md) | pg_timetable: Advanced scheduling for PostgreSQL | 1,350 | +4 |
| [ERAlchemy](../r/alexis-benoist~eralchemy.md) | Entity Relation Diagrams generation tool | 1,407 | +3 |
| [diesel-guard](../r/ayarotsky~diesel-guard.md) | Linter for dangerous Postgres migration patterns in Diesel and SQLx. Prevents   downtime caused by unsafe schema changes | 112 | +2 |
| [GatewayD](../r/gatewayd-io~gatewayd.md) | database gateway for building data-driven applications | 282 | +2 |
| [pgbadger](../r/darold~pgbadger.md) | A fast PostgreSQL Log Analyzer | 4,002 | +2 |
| [pREST](../r/prest~prest.md) | PostgreSQL ➕ REST, low-code, simplify and accelerate development, ⚡ instant, realtime, high-performance on any Postgres  | 4,548 | +2 |
| [RegreSQL](../r/dimitri~regresql.md) | Regression Testing your SQL queries | 354 | +2 |
| [bemi](../r/bemihq~bemi.md) | Automatic data change tracking for PostgreSQL | 391 | +1 |
| [pg\_activity](../r/dalibo~pg_activity.md) | pg_activity is a top like application for PostgreSQL server activity monitoring. | 3,012 | +1 |
| [pgCenter](../r/lesovsky~pgcenter.md) | Command-line admin tool for observing and troubleshooting Postgres. | 1,601 | +1 |
| [pgMonitor](../r/crunchydata~pgmonitor.md) | PostgreSQL Monitoring, Metrics Collection and Alerting Resources from Crunchy Data | 702 | +1 |
| [pgsync](../r/ankane~pgsync.md) | Sync data from one Postgres database to another | 3,448 | +1 |
| [PGXN client](../r/pgxn~pgxnclient.md) | A command line client for the PostgreSQL Extension Network | 159 | +1 |
| [sqitch](../r/sqitchers~sqitch.md) | Sensible database change management | 3,125 | +1 |
| [ZSON](../r/postgrespro~zson.md) | ZSON is a PostgreSQL extension for transparent JSONB compression | 569 | +1 |
| [ldap2pg](../r/dalibo~ldap2pg.md) | 🐘 👥 Manage PostgreSQL roles and privileges from YAML or LDAP | 231 | +0 |
| [migra](../r/djrobstep~migra.md) | DEPRECATED: Like diff but for PostgreSQL schemas | 3,050 | +0 |
| [mysql-postgresql-converter](../r/lanyrd~mysql-postgresql-converter.md) | Lanyrd's MySQL to PostgreSQL conversion script | 1,309 | +0 |
| [NServiceBus.Transport.PostgreSql](../r/particular~nservicebus.sqlserver.md) | SQL Server Transport for NServiceBus | 47 | +0 |
| [pg_chameleon](../r/the4thdoctor~pg_chameleon.md) | MySQL to PostgreSQL replica system | 435 | +0 |
| [pg_docs_bot](../r/mchristofides~pg_docs_bot.md) | A browser extension (Chrome and Firefox) for getting to the current Postgres docs by default. | 18 | +0 |
| [pg_insights](../r/lob~pg_insights.md) | A collection of convenient SQL for monitoring Postgres database health. | 309 | +0 |
| [pg_migrate](../r/jwdeitch~pg_migrate.md) | Manage postgres schema, triggers, procedures, and views | 32 | +0 |
| [pg-differ](../r/multum~pg-differ.md) | Node.js migration tool for PostgreSQL | 40 | +0 |
| [pg-formatter](../r/gajus~pg-formatter.md) | A PostgreSQL SQL syntax beautifier. | 84 | +0 |
| [pg-safe-migrate](../r/defnotwig~pg-safe-migrate.md) | Safety-first PostgreSQL migration engine for Node.js — advisory locks, drift detection, checksum verification, 10 lint r | 1 | +0 |
| [pg-spot-operator](../r/pg-spot-ops~pg-spot-operator.md) | Stateful Postgres on cheap Spot VMs | 59 | +0 |
| [pgclimb](../r/lukasmartinelli~pgclimb.md) | Export data from PostgreSQL into different data formats | 392 | +0 |
| [pgcmp](../r/cbbrowne~pgcmp.md) | Tool for comparing Postgres database schemas | 46 | +0 |
| [pgfutter](../r/lukasmartinelli~pgfutter.md) | Import CSV and JSON into PostgreSQL the easy way | 1,345 | +0 |
| [pglistend](../r/kabirbaidhya~pglistend.md) | pglistend - A lightweight PostgreSQL LISTEN Daemon using Node.js/Systemd | 30 | +0 |
| [pgmigrate](../r/yandex~pgmigrate.md) | Simple tool to evolve PostgreSQL schema easily. | 666 | +0 |
| [pgspot](../r/timescale~pgspot.md) | Spot vulnerabilities in postgres SQL scripts | 133 | +0 |
| [planter](../r/achiku~planter.md) | Generate PlantUML ER diagram textual description from PostgreSQL tables | 558 | +0 |
| [postgresql-metrics](../r/spotify~postgresql-metrics.md) | Tool that extracts and provides metrics on your PostgreSQL database | 599 | +0 |
| [Pyrseas](../r/perseas~pyrseas.md) | Provides utilities for Postgres database schema versioning. | 407 | +0 |
| [sqlcheck](../r/jarulraj~sqlcheck.md) | Automatically identify anti-patterns in SQL queries | 2,520 | +0 |
| [yoke](../r/nanopack~yoke.md) | Postgres high-availability cluster with auto-failover and automated cluster recovery. | 1,341 | +0 |

[Back to top](#awesome-postgres)

## Work Queues

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [pgBoss](../r/timgit~pg-boss.md) | Queueing jobs in Postgres from Node.js like a boss | 3,446 | +28 |
| [pgmq](../r/pgmq~pgmq.md) | A lightweight message queue. Like AWS SQS and RSMQ but on Postgres. | 4,817 | +24 |
| [river](../r/riverqueue~river.md) | Fast and reliable background jobs in Go | 5,062 | +17 |
| [BeanQueue](../r/launchplatform~bq.md) | BeanQueue, a lightweight Python task queue framework based on SQLAlchemy, PostgreSQL SKIP LOCKED queries and NOTIFY / LI | 27 | +0 |

[Back to top](#awesome-postgres)

---
*Updated: 2026-04-29 | [View live site ↗](https://patrickclery.com/awesomer/l/postgres/)*
