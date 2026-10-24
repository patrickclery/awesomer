# awesome-postgres

> A curated list of awesome PostgreSQL software, libraries, tools and resources, inspired by awesome-mysql

[Home](../README.md) | [Live site ↗](https://patrickclery.com/awesomer/l/postgres/) | [Source ↗](https://github.com/dhamaniasad/awesome-postgres)

## Top 10 Trending

| # | Repo | Stars | 7d | 30d | 90d |
|---|------|-------|----|-----|-----|
| 1 | [pg_search](../r/paradedb~paradedb.md) | 9,437 | +33 | +134 | +345 |
| 2 | [Pigsty](../r/vonng~pigsty.md) | 5,850 | +26 | +181 | +483 |
| 3 | [Teable](../r/teableio~teable.md) | 21,920 | +25 | +103 | +443 |
| 4 | [pgBoss](../r/timgit~pg-boss.md) | 4,084 | +23 | +100 | +308 |
| 5 | [CloudNativePG operator](../r/cloudnative-pg~cloudnative-pg.md) | 9,482 | +21 | +139 | +488 |
| 6 | [river](../r/riverqueue~river.md) | 5,808 | +20 | +102 | +430 |
| 7 | [AGE](../r/apache~age.md) | 4,911 | +19 | +60 | +223 |
| 8 | [pgmq](../r/pgmq~pgmq.md) | 5,350 | +17 | +58 | +320 |
| 9 | [atlas](../r/ariga~atlas.md) | 8,794 | +16 | +48 | +229 |
| 10 | [Redash](../r/getredash~redash.md) | 28,850 | +15 | +40 | +156 |

## Table of Contents

- [Backups](#backups)
- [CLI](#cli)
- [Distributions](#distributions)
- [Docker images](#docker-images)
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
| [wal-g](../r/wal-g~wal-g.md) | Archival and Restoration for databases in the Cloud | 4,317 | +8 |
| [OmniPITR](https://github.com/omniti-labs/omnipitr) | Advanced WAL File Management Tools for PostgreSQL | 179 | +0 |
| [pg-backups-to-s3](https://github.com/Saicheg/pg-backups-to-s3) | Small tool to create your postgresql backups on regular bases and upload them to S3   | 19 | +0 |
| [pg\_back](../r/orgrim~pg_back.md) | Simple backup tool for PostgreSQL | 566 | +0 |
| [pg\_probackup](../r/postgrespro~pg_probackup.md) | Backup and recovery manager for PostgreSQL | 799 | +0 |
| [pgbackup-sidecar](https://github.com/Musab520/pgbackup-sidecar) | `pgbackup-sidecar` is a lightweight Docker sidecar container designed to automate regular backups of a PostgreSQL databa | 5 | +0 |
| [pgbackweb](../r/eduardolat~pgbackweb.md) | 🐘 Effortless PostgreSQL backups with a user-friendly web interface! 🌐💾 | 2,645 | +0 |
| [pghoard](../r/aiven~pghoard.md) | PostgreSQL® backup and restore service | 1,428 | +0 |
| [postgres-backup-oss](https://github.com/isaced/postgres-backup-oss) | A handy Docker container to periodically backup PostgreSQL to Alibaba Cloud Object Storage Service (OSS) | 1 | +0 |
| [wal-e](https://github.com/wal-e/wal-e) | Continuous Archiving for Postgres | 3,467 | +0 |

[Back to top](#awesome-postgres)

## CLI

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [atlas](../r/ariga~atlas.md) | Declarative schema migrations with schema-as-code workflows | 8,794 | +16 |
| [pg-schema-diff](../r/stripe~pg-schema-diff.md) | Go library for diffing Postgres schemas and generating SQL migrations | 894 | +3 |
| [pgcli](../r/dbcli~pgcli.md) | Postgres CLI with autocompletion and syntax highlighting | 13,422 | +3 |
| [squix](../r/eduardofuncao~squix.md) | A CLI tool for managing and executing SQL queries across multiple databases. Written in Go, made beautiful with BubbleTe | 275 | +2 |
| [schemaspy](../r/schemaspy~schemaspy.md) | Database documentation built easy | 3,733 | +1 |
| [MigrationPilot](https://github.com/mickelsamuel/migrationpilot) | PostgreSQL migration linter. Blocks unsafe migrations before merge: 112 rules, the real Postgres parser, lock analysis,  | 9 | +0 |
| [pgplan](https://github.com/JacobArthurs/pgplan) | Compare and analyze PostgreSQL EXPLAIN plans from the CLI | 13 | +0 |
| [pgsh](https://github.com/sastraxi/pgsh) | Branch your PostgreSQL Database like Git | 652 | +0 |
| [pgxcli](https://github.com/Balaji01-4D/pgxcli) | Postgres CLI with autocompletion and syntax highlighting | 76 | +0 |
| [psql2csv](https://github.com/fphilipe/psql2csv) | Run a query in psql and output the result as CSV. | 186 | +0 |
| [sabiql](../r/riii111~sabiql.md) | Fast, safe-by-design, Vim-first TUI for PostgreSQL, MySQL, and SQLite, built in Rust. | 317 | +0 |

[Back to top](#awesome-postgres)

## Distributions

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Pigsty](../r/vonng~pigsty.md) | Enterprise-Grade OSS PostgreSQL Distribution with HA, PITR, IaC, Monitor, 12 kernel forks and 575 PG extensions. Best-of | 5,850 | +26 |

[Back to top](#awesome-postgres)

## Docker images

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [pglayers](../r/pglayers~pglayers.md) | PostgreSQL Docker images with the extensions you actually need -- pre-built, composable, no compilation. | 172 | +4 |

[Back to top](#awesome-postgres)

## Extensions

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [pg_search](../r/paradedb~paradedb.md) | One Postgres for your application data, full-text search, vector retrieval, and aggregations. Home of the pg_search exte | 9,437 | +33 |
| [AGE](../r/apache~age.md) | Graph database optimized for fast analysis and real-time data processing. It is provided as an extension to PostgreSQL. | 4,911 | +19 |
| [HypoPG](../r/hypopg~hypopg.md) | Hypothetical Indexes for PostgreSQL | 1,740 | +10 |
| [Citus](../r/citusdata~citus.md) | Distributed PostgreSQL as an extension | 12,824 | +6 |
| [pg_cron](../r/citusdata~pg_cron.md) | Run periodic jobs in PostgreSQL | 3,908 | +2 |
| [pg\_partman](../r/pgpartman~pg_partman.md) | Partition management extension for PostgreSQL | 2,841 | +2 |
| [pgRouting](../r/pgrouting~pgrouting.md) | Repository contains pgRouting library. Development branch is "develop", stable branch is "master" | 1,442 | +2 |
| [pg\_squeeze](../r/cybertec-postgresql~pg_squeeze.md) | A PostgreSQL extension for automatic bloat cleanup | 703 | +1 |
| [plpgsql\_check](../r/okbob~plpgsql_check.md) | plpgsql_check is a linter tool (does source code static analyze) for the PostgreSQL language plpgsql (the native languag | 784 | +1 |
| [psql_bm25s](../r/intelligent-internet~psql_bm25s.md) | The fastest PostgreSQL BM25 engine, now support Sparse Semantic Retrieval in the same index. | 200 | +1 |
| [pg\_barcode](https://github.com/btouchard/pg_barcode) | PostgreSQL SVG QRcode & Datamatrix generator | 1 | +0 |
| [pg\_paxos](https://github.com/citusdata/pg_paxos) | Basic implementation of Paxos and Paxos-based table replication for a cluster of PostgreSQL nodes | 310 | +0 |
| [pg\_shard](https://github.com/citusdata/pg_shard) | ATTENTION: pg_shard is superseded by Citus, its more powerful replacement | 1,060 | +0 |
| [pg\_stat\_monitor](../r/percona~pg_stat_monitor.md) | Query Performance Monitoring Tool for PostgreSQL | 593 | +0 |
| [PG\_Themis](https://github.com/cossacklabs/pg_themis) | Postgres Themis plugin | 33 | +0 |
| [pgcat](https://github.com/kingluo/pgcat) | Enhanced PostgreSQL logical replication | 387 | +0 |
| [pglogical](../r/2ndquadrant~pglogical.md) | Logical Replication extension for PostgreSQL 17, 16, 15, 14, 13, 12, 11, 10, 9.6, 9.5, 9.4 (Postgres), providing much fa | 1,242 | +0 |
| [pgMemento](../r/pgmemento~pgmemento.md) | Audit trail with schema versioning for PostgreSQL using transaction-based logging | 413 | +0 |
| [cstore\_fdw](https://github.com/citusdata/cstore_fdw) | Columnar storage extension for Postgres built as a foreign data wrapper. Check out https://github.com/citusdata/citus fo | 1,780 | -1 |
| [zomboDB](https://github.com/zombodb/zombodb) | Making Postgres and Elasticsearch work together like it's 2023 | 4,718 | -1 |

[Back to top](#awesome-postgres)

## GUI

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Teable](../r/teableio~teable.md) | ✨ AI Spreadsheet for Business | 21,920 | +25 |
| [Redash](../r/getredash~redash.md) | Make Your Company Data Driven. Connect to any data source, easily visualize, dashboard and share your data. | 28,850 | +15 |
| [pgweb](../r/sosedoff~pgweb.md) | Cross-platform client for PostgreSQL databases | 9,542 | +12 |
| [PgManage](../r/commandprompt~pgmanage.md) | Web tool for database management | 1,035 | +2 |
| [Dekart](../r/dekart-xyz~dekart.md) | Open-source backend for Kepler.gl. Self-hosted alternative to CARTO and Foursquare Studio. | 435 | +1 |
| [PgStudio](https://github.com/dev-asterix/PgStudio) | Intelligent PostgreSQL tooling for VS Code \| Build, explore, and query Postgres faster | 14 | +1 |
| [phpPgAdmin](https://github.com/phppgadmin/phppgadmin) | the premier web-based administration tool for postgresql | 847 | +1 |
| [Postbird](../r/paxa~postbird.md) | Open source PostgreSQL GUI client for macOS, Linux and Windows | 1,635 | +0 |
| [OrcaQ](../r/cin12211~orca-q.md) | The open source \| Next Generation database editor | 223 | -1 |
| [temBoard](../r/dalibo~temboard.md) | PostgreSQL Remote Control | 769 | -1 |

[Back to top](#awesome-postgres)

## High-Availability

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Patroni](../r/zalando~patroni.md) | A template for PostgreSQL High Availability with Etcd, Consul, ZooKeeper, or Kubernetes | 8,800 | +9 |
| [autobase](../r/vitabaks~autobase.md) | Automated database platform for PostgreSQL® - Your own DBaaS. | 4,427 | +7 |
| [Spock](../r/pgedge~spock.md) | Logical multi-master PostgreSQL replication | 758 | +2 |
| [pg_auto_failover](../r/citusdata~pg_auto_failover.md) | Postgres extension and service for automated failover and high-availability | 1,393 | +1 |
| [repmgr](../r/2ndquadrant~repmgr.md) | A lightweight replication manager for PostgreSQL (Postgres) | 1,719 | +1 |
| [BDR](https://github.com/2ndQuadrant/bdr) | Bi-Directional Multi-Master Replication (BDR) for PostgreSQL, deprecated, please visit 2ndQuadrant website for latest BD | 359 | +0 |
| [PAF](https://github.com/ClusterLabs/PAF) | PostgreSQL Automatic Failover: High-Availibility for Postgres, based on Pacemaker and Corosync. | 350 | +0 |
| [pg-status](https://github.com/krylosov-aa/pg-status) | A microservice (sidecar) that helps instantly determine the status of your PostgreSQL hosts including whether they are a | 83 | +0 |
| [pglookout](../r/aiven~pglookout.md) | PostgreSQL replication monitoring and failover daemon | 193 | +0 |
| [pgrwl](../r/hashmap-kz~pgrwl.md) | Cloud-native continuous backup for PostgreSQL - WAL/base-backup streaming, compression, encryption, retention, and monit | 182 | +0 |
| [SkyTools](https://github.com/pgq/skytools-legacy) | Obsolete, see https://github.com/pgq/ for maintained code. | 249 | +0 |
| [Stolon](https://github.com/sorintlab/stolon) | PostgreSQL cloud native High Availability and more. | 4,826 | +0 |

[Back to top](#awesome-postgres)

## Kubernetes

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [CloudNativePG operator](../r/cloudnative-pg~cloudnative-pg.md) | The most popular Kubernetes Operator for PostgreSQL. | 9,482 | +21 |
| [Crunchy Operator](../r/crunchydata~postgres-operator.md) | Production PostgreSQL for Kubernetes, from high availability Postgres clusters to full-scale database-as-a-service. | 4,456 | +4 |
| [StackGres Operator](../r/ongres~stackgres.md) | StackGres Operator, Full Stack PostgreSQL on Kubernetes // !! Mirror repository of https://gitlab.com/ongresinc/stackgre | 1,440 | +2 |
| [Zalando Operator](../r/zalando~postgres-operator.md) | Postgres operator creates and manages PostgreSQL clusters running in Kubernetes | 5,258 | +2 |
| [Kubegres Operator](https://github.com/reactive-tech/kubegres) | Kubegres is a Kubernetes operator allowing to deploy one or many clusters of PostgreSql instances and manage databases r | 1,350 | +0 |
| [Percona Everest Operator](https://github.com/percona/everest-operator) | OpenEverest Operator | 42 | +0 |
| [Percona PostgreSQL Operator](../r/percona~percona-postgresql-operator.md) | Percona Operator for PostgreSQL | 385 | +0 |

[Back to top](#awesome-postgres)

## Language bindings

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [rust-postgresql](../r/sfackler~rust-postgres.md) | Native PostgreSQL driver for the Rust programming language | 4,021 | +4 |
| [Npgsql](../r/npgsql~npgsql.md) | Npgsql is the .NET data provider for PostgreSQL. | 3,744 | +3 |
| [pq](../r/lib~pq.md) | Go PostgreSQL driver for database/sql | 9,967 | +3 |
| [node-postgres](../r/brianc~node-postgres.md) | PostgreSQL client for node.js. | 13,225 | +2 |
| [Postmodern](https://github.com/marijnh/Postmodern) | A Common Lisp PostgreSQL programming interface | 436 | +1 |
| [clj-postgresql](https://github.com/remodoy/clj-postgresql) | PostgreSQL helpers for Clojure projects | 162 | +0 |
| [luapgsql](../r/arcapos~luapgsql.md) | Lua binding for PostgreSQL | 119 | +0 |
| [pg](../r/ged~ruby-pg.md) | A PostgreSQL client library for Ruby | 870 | +0 |
| [postgrex](../r/elixir-ecto~postgrex.md) | PostgreSQL driver for Elixir | 1,211 | +0 |
| [RPostgres](../r/r-dbi~rpostgres.md) | A DBI-compliant interface to PostgreSQL | 344 | +0 |
| [zapatos](https://github.com/jawj/zapatos) | Zero-abstraction Postgres for TypeScript: a non-ORM database library | 1,401 | -2 |
| [pg.zig](../r/karlseguin~pg.zig.md) | Native PostgreSQL driver / client for Zig | 602 | -3 |

[Back to top](#awesome-postgres)

## Monitoring

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [coroot](../r/coroot~coroot.md) | Coroot is an open-source observability and APM tool with AI-powered Root Cause Analysis. It combines metrics, logs, trac | 7,982 | +8 |
| [pg_ash](../r/nikolays~pg_ash.md) | Active Session History for PostgreSQL — wait event sampling with zero bloat (pg_cron + PGQ-style partition rotation) | 253 | +7 |
| [PMM](../r/percona~pmm.md) | Percona Monitoring and Management: an open source database monitoring, observability and management tool | 1,116 | +5 |
| [postgres_exporter](../r/wrouesnel~postgres_exporter.md) | A PostgreSQL metric exporter for Prometheus | 3,641 | +4 |
| [Check\_postgres](https://github.com/bucardo/check_postgres) | Nagios check_postgres plugin for checking status of PostgreSQL databases | 604 | +2 |
| [pgwatch2](https://github.com/cybertec-postgresql/pgwatch2) | PostgreSQL metrics monitor/dashboard | 1,840 | +1 |
| [check\_pgactivity](../r/opmdg~check_pgactivity.md) | Nagios remote agent | 188 | +0 |
| [Instrumental](https://github.com/Instrumental/instrumentald) | Instrumental System and Service Daemon | 15 | +0 |
| [pg_exporter](../r/vonng~pg_exporter.md) | Advanced PostgreSQL & Pgbouncer Metrics Exporter for Prometheus | 365 | +0 |
| [pgvitals](https://github.com/pgvitals/pgvitals) | 40 copy-paste PostgreSQL diagnostic queries — one for every performance bottleneck. No extensions. No installation. Just | 7 | +0 |
| [pgwd](https://github.com/hrodrig/pgwd) | Go CLI that checks PostgreSQL connection counts and notifies via Slack and/or Loki when configured thresholds are exceed | 8 | +0 |
| [dexter](../r/ankane~dexter.md) | The automatic indexer for Postgres | 2,093 | -1 |
| [libzbxpgsql](https://github.com/cavaliercoder/libzbxpgsql) | Monitor PostgreSQL with Zabbix | 155 | -1 |
| [pg\_view](https://github.com/zalando/pg_view) | Get a detailed, real-time view of your PostgreSQL database and system metrics | 506 | -1 |
| [Pome](https://github.com/rach/pome) | A Postgres Metrics Dashboard | 1,071 | -1 |

[Back to top](#awesome-postgres)

## Optimization

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [pgtune](../r/le0pard~pgtune.md) | Pgtune - tuning PostgreSQL config by your hardware | 2,754 | +4 |
| [PEV2](../r/dalibo~pev2.md) | Postgres Explain Visualizer 2 | 3,609 | +2 |
| [TimescaleDB Tune](../r/timescale~timescaledb-tune.md) | A tool for tuning TimescaleDB for better performance by adjusting settings to match your system's CPU and memory resourc | 509 | +2 |
| [pgassistant](https://github.com/beh74/pgassistant-community) | A PostgreSQL assistant for developers Understand, optimize, and improve your PostgreSQL database with ease. | 57 | +1 |
| [PgHero](../r/ankane~pghero.md) | A performance dashboard for Postgres | 8,937 | +1 |
| [pgtune](https://github.com/gregs1104/pgtune) | PostgreSQL configuration wizard | 1,089 | +1 |
| [aqo](../r/postgrespro~aqo.md) | Adaptive query optimization for PostgreSQL | 501 | +0 |
| [pg_flame](https://github.com/mgartner/pg_flame) | A flamegraph generator for Postgres EXPLAIN ANALYZE output. | 1,620 | +0 |
| [pg_web_stats](https://github.com/kirs/pg_web_stats) | Web UI to view pg_stat_statements | 97 | +0 |
| [pgconfig.org](https://github.com/sebastianwebber/pgconfig) | Web Based PostgreSQL configuration tool | 88 | +0 |

[Back to top](#awesome-postgres)

## Platforms

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [neond](../r/matisiekpl~neond.md) | DX-focused control plane for Postgres dedicated to non-critical workloads. Your postgres:latest replacement 🐘  | 140 | +3 |
| [Atlas4D](https://github.com/crisbez/atlas4d-base) | Self-hosted 4D spatiotemporal AI platform built on PostgreSQL, PostGIS, TimescaleDB, H3 and pgvector, with anomaly & thr | 19 | +0 |

[Back to top](#awesome-postgres)

## Security

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Acra](../r/cossacklabs~acra.md) | Database security suite. Database proxy with field-level encryption, search through encrypted data, SQL injections preve | 1,494 | +2 |
| [pgrls](https://github.com/pgrls/pgrls) | Static analyzer for Postgres Row-Level Security — 67 lint rules covering tenant and per-user row-scoping bugs, performan | 29 | +0 |

[Back to top](#awesome-postgres)

## Server

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Apache Cloudberry](../r/apache~cloudberry.md) | One advanced and mature open-source MPP (Massively Parallel Processing) database. Open source alternative to Greenplum D | 1,435 | +4 |

[Back to top](#awesome-postgres)

## Tutorials

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [postgresDBSamples](https://github.com/morenoh149/postgresDBSamples) | Sample databases for postgres | 552 | +1 |
| [pagila](https://github.com/xzilla/pagila) | The PostgreSQL Sample Database | 80 | +0 |
| [pg-utils](../r/dataegret~pg-utils.md) | Useful PostgreSQL utilities | 1,219 | +0 |
| [SQL Syntax Cheat Sheet](https://github.com/mergisi/sql-syntax-cheat-sheet) | A comprehensive SQL syntax cheat sheet for quick reference, covering essential commands, functions, operators, and conce | 55 | +0 |

[Back to top](#awesome-postgres)

## Utilities

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Greenmask](../r/greenmaskio~greenmask.md) | Database anonymization and test data management | 1,794 | +8 |
| [PostgREST](../r/postgrest~postgrest.md) | REST API for any Postgres database | 27,727 | +6 |
| [pREST](../r/prest~prest.md) | Instant REST and MCP APIs for PostgreSQL and MySQL, on existing or new databases. CRUD, custom SQL routes, auth and ACL  | 4,629 | +5 |
| [pgroll](../r/xataio~pgroll.md) | PostgreSQL zero-downtime migrations made easy | 6,607 | +3 |
| [ldap2pg](../r/dalibo~ldap2pg.md) | 🐘 👥 Manage PostgreSQL roles and privileges from YAML or LDAP | 241 | +2 |
| [diesel-guard](../r/ayarotsky~diesel-guard.md) | Linter for dangerous Postgres migration patterns in Diesel and SQLx. Prevents   downtime caused by unsafe schema changes | 121 | +1 |
| [migra](https://github.com/djrobstep/migra) | DEPRECATED: Like diff but for PostgreSQL schemas | 3,048 | +1 |
| [pg-spot-operator](https://github.com/pg-spot-ops/pg-spot-operator) | Stateful Postgres on cheap Spot VMs | 61 | +1 |
| [pgbadger](../r/darold~pgbadger.md) | A fast PostgreSQL Log Analyzer | 4,072 | +1 |
| [pgFirstAid](../r/randoneering~pgfirstaid.md) | Easy to deploy, open source, postgresql function that provides a prioritized list of actions to take to improve stabilit | 538 | +1 |
| [pgMonitor](../r/crunchydata~pgmonitor.md) | PostgreSQL Monitoring, Metrics Collection and Alerting Resources from Crunchy Data | 715 | +1 |
| [pgspot](../r/timescale~pgspot.md) | Spot vulnerabilities in postgres SQL scripts | 150 | +1 |
| [sqitch](../r/sqitchers~sqitch.md) | Sensible database change management | 3,174 | +1 |
| [bemi](../r/bemihq~bemi.md) | Automatic data change tracking for PostgreSQL | 401 | +0 |
| [ERAlchemy](../r/alexis-benoist~eralchemy.md) | Entity Relation Diagrams generation tool | 1,431 | +0 |
| [GatewayD](../r/gatewayd-io~gatewayd.md) | database gateway for building data-driven applications | 289 | +0 |
| [mysql-postgresql-converter](https://github.com/lanyrd/mysql-postgresql-converter) | Lanyrd's MySQL to PostgreSQL conversion script | 1,313 | +0 |
| [NServiceBus.Transport.PostgreSql](https://github.com/Particular/NServiceBus.SqlServer) | SQL Server Transport for NServiceBus | 47 | +0 |
| [pg_docs_bot](https://github.com/mchristofides/pg_docs_bot) | A browser extension (Chrome and Firefox) for getting to the current Postgres docs by default. | 18 | +0 |
| [pg_insights](https://github.com/lob/pg_insights) | A collection of convenient SQL for monitoring Postgres database health. | 310 | +0 |
| [pg_migrate](https://github.com/jwdeitch/pg_migrate) | Manage postgres schema, triggers, procedures, and views | 32 | +0 |
| [pg_timetable](../r/cybertec-postgresql~pg_timetable.md) | pg_timetable: Advanced scheduling for PostgreSQL | 1,404 | +0 |
| [pg-differ](https://github.com/multum/pg-differ) | Node.js migration tool for PostgreSQL | 40 | +0 |
| [pg-formatter](https://github.com/gajus/pg-formatter) | A PostgreSQL SQL syntax beautifier. | 82 | +0 |
| [pg-safe-migrate](https://github.com/defnotwig/pg-safe-migrate) | Safety-first PostgreSQL migration engine for Node.js — advisory locks, drift detection, checksum verification, 10 lint r | 1 | +0 |
| [pgCenter](../r/lesovsky~pgcenter.md) | Command-line admin tool for observing and troubleshooting Postgres. | 1,632 | +0 |
| [pgclimb](https://github.com/lukasmartinelli/pgclimb) | Export data from PostgreSQL into different data formats | 393 | +0 |
| [pgcmp](https://github.com/cbbrowne/pgcmp) | Tool for comparing Postgres database schemas | 46 | +0 |
| [pglistend](https://github.com/kabirbaidhya/pglistend) | pglistend - A lightweight PostgreSQL LISTEN Daemon using Node.js/Systemd | 30 | +0 |
| [pgmigrate](../r/yandex~pgmigrate.md) | Simple tool to evolve PostgreSQL schema easily. | 671 | +0 |
| [pgsync](../r/ankane~pgsync.md) | Sync data from one Postgres database to another | 3,475 | +0 |
| [PGXN client](https://github.com/pgxn/pgxnclient) | A command line client for the PostgreSQL Extension Network | 161 | +0 |
| [planter](https://github.com/achiku/planter) | Generate PlantUML ER diagram textual description from PostgreSQL tables | 555 | +0 |
| [postgresql-metrics](https://github.com/spotify/postgresql-metrics) | Tool that extracts and provides metrics on your PostgreSQL database | 599 | +0 |
| [Qail](https://github.com/qail-io/qail) | AST-native PostgreSQL toolkit: typed queries to wire protocol, with built-in RLS tenant isolation. | 36 | +0 |
| [RegreSQL](../r/dimitri~regresql.md) | Regression Testing your SQL queries | 358 | +0 |
| [sqlcheck](https://github.com/jarulraj/sqlcheck) | Automatically identify anti-patterns in SQL queries | 2,523 | +0 |
| [yoke](https://github.com/nanopack/yoke) | Postgres high-availability cluster with auto-failover and automated cluster recovery. | 1,338 | +0 |
| [ZSON](https://github.com/postgrespro/zson) | ZSON is a PostgreSQL extension for transparent JSONB compression | 570 | +0 |
| [pg_chameleon](../r/the4thdoctor~pg_chameleon.md) | MySQL to PostgreSQL replica system | 442 | -1 |
| [pgfutter](https://github.com/lukasmartinelli/pgfutter) | Import CSV and JSON into PostgreSQL the easy way | 1,343 | -1 |
| [Pyrseas](../r/perseas~pyrseas.md) | Provides utilities for Postgres database schema versioning. This is being superseded by work done at https://codeberg.or | 405 | -1 |
| [pg\_activity](../r/dalibo~pg_activity.md) | pg_activity is a top like application for PostgreSQL server activity monitoring. | 3,051 | -2 |
| [pgloader](../r/dimitri~pgloader.md) | Migrate to PostgreSQL in a single command! | 6,548 | -2 |
| [PostGraphile](../r/graphile~postgraphile.md) | 🔮 Graphile's Crystal Monorepo; home to Grafast, PostGraphile, pg-introspection, pg-sql2 and much more! | 12,933 | -2 |
| [Hasura GraphQL Engine](../r/hasura~graphql-engine.md) | Blazing fast, instant realtime GraphQL APIs on all your data with fine grained access control, also trigger webhooks on  | 32,121 | -11 |

[Back to top](#awesome-postgres)

## Work Queues

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [pgBoss](../r/timgit~pg-boss.md) | Queueing jobs in Postgres from Node.js like a boss | 4,084 | +23 |
| [river](../r/riverqueue~river.md) | The polyglot queue: Fast and reliable background jobs in Go, Ruby, Rust, and JS/TS on Postgres or SQLite. | 5,808 | +20 |
| [pgmq](../r/pgmq~pgmq.md) | A lightweight message queue. Like AWS SQS and RSMQ but on Postgres. | 5,350 | +17 |
| [BeanQueue](https://github.com/LaunchPlatform/bq) | BeanQueue, a lightweight Python task queue framework based on SQLAlchemy, PostgreSQL SKIP LOCKED queries and NOTIFY / LI | 28 | +0 |

[Back to top](#awesome-postgres)

---
*Updated: 2026-10-24 | [View live site ↗](https://patrickclery.com/awesomer/l/postgres/)*
