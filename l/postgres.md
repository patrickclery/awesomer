# awesome-postgres

> A curated list of awesome PostgreSQL software, libraries, tools and resources, inspired by awesome-mysql

[Home](../README.md) | [Live site ↗](https://patrickclery.com/awesomer/l/postgres/) | [Source ↗](https://github.com/dhamaniasad/awesome-postgres)

## Top 10 Trending

| # | Repo | Stars | 7d | 30d | 90d |
|---|------|-------|----|-----|-----|
| 1 | [Apache Cloudberry](../r/apache~cloudberry.md) | 1,367 | +42 | +12 | +148 |
| 2 | [Teable](../r/teableio~teable.md) | 21,691 | +32 | +111 | +436 |
| 3 | [CloudNativePG operator](../r/cloudnative-pg~cloudnative-pg.md) | 9,169 | +30 | +196 | +503 |
| 4 | [atlas](../r/ariga~atlas.md) | 8,673 | +29 | +98 | +260 |
| 5 | [pq](../r/lib~pq.md) | 9,948 | +29 | +16 | +55 |
| 6 | [Pigsty](../r/vonng~pigsty.md) | 5,559 | +28 | +48 | +426 |
| 7 | [AGE](../r/apache~age.md) | 4,771 | +27 | +72 | +230 |
| 8 | [pgsh](../r/sastraxi~pgsh.md) | 647 | +23 | +1 | +46 |
| 9 | [Citus](../r/citusdata~citus.md) | 12,718 | +23 | +69 | +212 |
| 10 | [river](../r/riverqueue~river.md) | 5,593 | +23 | +123 | +452 |

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
| [pgbackweb](../r/eduardolat~pgbackweb.md) | 🐘 Effortless PostgreSQL backups with a user-friendly web interface! 🌐💾 | 2,621 | +4 |
| [pghoard](../r/aiven~pghoard.md) | PostgreSQL® backup and restore service | 1,419 | +2 |
| [OmniPITR](../r/omniti-labs~omnipitr.md) | Advanced WAL File Management Tools for PostgreSQL | 179 | +0 |
| [pg-backups-to-s3](../r/saicheg~pg-backups-to-s3.md) | Small tool to create your postgresql backups on regular bases and upload them to S3   | 19 | +0 |
| [pg\_back](../r/orgrim~pg_back.md) | Simple backup tool for PostgreSQL | 565 | +0 |
| [pg\_probackup](../r/postgrespro~pg_probackup.md) | Backup and recovery manager for PostgreSQL | 799 | +0 |
| [pgbackup-sidecar](../r/musab520~pgbackup-sidecar.md) | `pgbackup-sidecar` is a lightweight Docker sidecar container designed to automate regular backups of a PostgreSQL databa | 5 | +0 |
| [postgres-backup-oss](../r/isaced~postgres-backup-oss.md) | A handy Docker container to periodically backup PostgreSQL to Alibaba Cloud Object Storage Service (OSS) | 1 | +0 |
| [wal-g](../r/wal-g~wal-g.md) | Archival and Restoration for databases in the Cloud | 4,222 | -1 |
| [wal-e](../r/wal-e~wal-e.md) | Continuous Archiving for Postgres | 3,464 | -3 |

[Back to top](#awesome-postgres)

## CLI

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [atlas](../r/ariga~atlas.md) | Declarative schema migrations with schema-as-code workflows | 8,673 | +29 |
| [pgsh](../r/sastraxi~pgsh.md) | Branch your PostgreSQL Database like Git | 647 | +23 |
| [pgcli](../r/dbcli~pgcli.md) | Postgres CLI with autocompletion and syntax highlighting | 13,360 | +10 |
| [sabiql](../r/riii111~sabiql.md) | A fast PostgreSQL and SQLite TUI written in Rust. driver-less, vim-first, with ER diagrams. No database drivers, no setu | 254 | +4 |
| [pg-schema-diff](../r/stripe~pg-schema-diff.md) | Go library for diffing Postgres schemas and generating SQL migrations | 873 | +2 |
| [schemaspy](../r/schemaspy~schemaspy.md) | Database documentation built easy | 3,708 | +2 |
| [MigrationPilot](../r/mickelsamuel~migrationpilot.md) | PostgreSQL migration linter. Blocks unsafe migrations before merge: 112 rules, the real Postgres parser, lock analysis,  | 6 | +0 |
| [pgplan](../r/jacobarthurs~pgplan.md) | Compare and analyze PostgreSQL EXPLAIN plans from the CLI | 13 | +0 |
| [psql2csv](../r/fphilipe~psql2csv.md) | Run a query in psql and output the result as CSV. | 186 | +0 |
| [squix](../r/eduardofuncao~squix.md) | A CLI tool for managing and executing SQL queries across multiple databases. Written in Go, made beautiful with BubbleTe | 266 | -1 |

[Back to top](#awesome-postgres)

## Distributions

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Pigsty](../r/vonng~pigsty.md) | Enterprise-Grade OSS PostgreSQL Distribution with HA, PITR, IaC, Monitor, 12 kernel forks and 575 PG extensions. Best-of | 5,559 | +28 |

[Back to top](#awesome-postgres)

## Extensions

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [AGE](../r/apache~age.md) | Graph database optimized for fast analysis and real-time data processing. It is provided as an extension to PostgreSQL. | 4,771 | +27 |
| [Citus](../r/citusdata~citus.md) | Distributed PostgreSQL as an extension | 12,718 | +23 |
| [pg_search](../r/paradedb~paradedb.md) | One Postgres for your application data, full-text search, vector retrieval, and aggregations. Home of the pg_search exte | 9,179 | +19 |
| [pgRouting](../r/pgrouting~pgrouting.md) | Repository contains pgRouting library. Development branch is "develop", stable branch is "master" | 1,426 | +6 |
| [pg\_partman](../r/pgpartman~pg_partman.md) | Partition management extension for PostgreSQL | 2,796 | +4 |
| [HypoPG](../r/hypopg~hypopg.md) | Hypothetical Indexes for PostgreSQL | 1,695 | +3 |
| [pg_cron](../r/citusdata~pg_cron.md) | Run periodic jobs in PostgreSQL | 3,871 | +3 |
| [pg\_squeeze](../r/cybertec-postgresql~pg_squeeze.md) | A PostgreSQL extension for automatic bloat cleanup | 691 | +2 |
| [pglogical](../r/2ndquadrant~pglogical.md) | Logical Replication extension for PostgreSQL 17, 16, 15, 14, 13, 12, 11, 10, 9.6, 9.5, 9.4 (Postgres), providing much fa | 1,238 | +2 |
| [plpgsql\_check](../r/okbob~plpgsql_check.md) | plpgsql_check is a linter tool (does source code static analyze) for the PostgreSQL language plpgsql (the native languag | 777 | +2 |
| [cstore\_fdw](../r/citusdata~cstore_fdw.md) | Columnar storage extension for Postgres built as a foreign data wrapper. Check out https://github.com/citusdata/citus fo | 1,783 | +1 |
| [pgMemento](../r/pgmemento~pgmemento.md) | Audit trail with schema versioning for PostgreSQL using transaction-based logging | 412 | +1 |
| [pg\_barcode](../r/btouchard~pg_barcode.md) | PostgreSQL SVG QRcode & Datamatrix generator | 1 | +0 |
| [pg\_paxos](../r/citusdata~pg_paxos.md) | Basic implementation of Paxos and Paxos-based table replication for a cluster of PostgreSQL nodes | 309 | +0 |
| [pg\_shard](../r/citusdata~pg_shard.md) | ATTENTION: pg_shard is superseded by Citus, its more powerful replacement | 1,062 | +0 |
| [PG\_Themis](../r/cossacklabs~pg_themis.md) | Postgres Themis plugin | 33 | +0 |
| [pgcat](../r/kingluo~pgcat.md) | Enhanced PostgreSQL logical replication | 386 | +0 |
| [zomboDB](../r/zombodb~zombodb.md) | Making Postgres and Elasticsearch work together like it's 2023 | 4,719 | +0 |
| [pg\_stat\_monitor](../r/percona~pg_stat_monitor.md) | Query Performance Monitoring Tool for PostgreSQL | 585 | -1 |

[Back to top](#awesome-postgres)

## GUI

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Teable](../r/teableio~teable.md) | ✨ AI Spreadsheet for Business | 21,691 | +32 |
| [Redash](../r/getredash~redash.md) | Make Your Company Data Driven. Connect to any data source, easily visualize, dashboard and share your data. | 28,764 | +18 |
| [pgweb](../r/sosedoff~pgweb.md) | Cross-platform client for PostgreSQL databases | 9,482 | +4 |
| [PgManage](../r/commandprompt~pgmanage.md) | Web tool for database management | 1,030 | +1 |
| [Postbird](../r/paxa~postbird.md) | Open source PostgreSQL GUI client for macOS, Linux and Windows | 1,636 | +1 |
| [temBoard](../r/dalibo~temboard.md) | PostgreSQL Remote Control | 768 | +1 |
| [phpPgAdmin](../r/phppgadmin~phppgadmin.md) | the premier web-based administration tool for postgresql | 845 | +0 |

[Back to top](#awesome-postgres)

## High-Availability

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Patroni](../r/zalando~patroni.md) | A template for PostgreSQL High Availability with Etcd, Consul, ZooKeeper, or Kubernetes | 8,678 | +22 |
| [autobase](../r/vitabaks~autobase.md) | Automated database platform for PostgreSQL® - Your own DBaaS. | 4,341 | +7 |
| [pg_auto_failover](../r/citusdata~pg_auto_failover.md) | Postgres extension and service for automated failover and high-availability | 1,378 | +4 |
| [pg-status](../r/krylosov-aa~pg-status.md) | A microservice (sidecar) that helps instantly determine the status of your PostgreSQL hosts including whether they are a | 81 | +1 |
| [Stolon](../r/sorintlab~stolon.md) | PostgreSQL cloud native High Availability and more. | 4,826 | +1 |
| [BDR](../r/2ndquadrant~bdr.md) | Bi-Directional Multi-Master Replication (BDR) for PostgreSQL, deprecated, please visit 2ndQuadrant website for latest BD | 359 | +0 |
| [pglookout](../r/aiven~pglookout.md) | PostgreSQL replication monitoring and failover daemon | 191 | +0 |
| [pgrwl](../r/hashmap-kz~pgrwl.md) | Cloud-native continuous backup for PostgreSQL - WAL/base-backup streaming, compression, encryption, retention, and monit | 180 | +0 |
| [repmgr](../r/2ndquadrant~repmgr.md) | A lightweight replication manager for PostgreSQL (Postgres) | 1,707 | +0 |
| [SkyTools](../r/pgq~skytools-legacy.md) | Obsolete, see https://github.com/pgq/ for maintained code. | 249 | +0 |
| [Spock](../r/pgedge~spock.md) | Logical multi-master PostgreSQL replication | 744 | +0 |
| [PAF](../r/clusterlabs~paf.md) | PostgreSQL Automatic Failover: High-Availibility for Postgres, based on Pacemaker and Corosync. | 350 | -1 |

[Back to top](#awesome-postgres)

## Kubernetes

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [CloudNativePG operator](../r/cloudnative-pg~cloudnative-pg.md) | The most popular Kubernetes Operator for PostgreSQL. | 9,169 | +30 |
| [Crunchy Operator](../r/crunchydata~postgres-operator.md) | Production PostgreSQL for Kubernetes, from high availability Postgres clusters to full-scale database-as-a-service. | 4,442 | +5 |
| [StackGres Operator](../r/ongres~stackgres.md) | StackGres Operator, Full Stack PostgreSQL on Kubernetes // !! Mirror repository of https://gitlab.com/ongresinc/stackgre | 1,428 | +2 |
| [Zalando Operator](../r/zalando~postgres-operator.md) | Postgres operator creates and manages PostgreSQL clusters running in Kubernetes | 5,225 | +2 |
| [Kubegres Operator](../r/reactive-tech~kubegres.md) | Kubegres is a Kubernetes operator allowing to deploy one or many clusters of PostgreSql instances and manage databases r | 1,350 | +0 |
| [Percona Everest Operator](../r/percona~everest-operator.md) | OpenEverest Operator | 42 | +0 |
| [Percona PostgreSQL Operator](../r/percona~percona-postgresql-operator.md) | Percona Operator for PostgreSQL | 381 | +0 |

[Back to top](#awesome-postgres)

## Language bindings

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [pq](../r/lib~pq.md) | Go PostgreSQL driver for database/sql | 9,948 | +29 |
| [rust-postgresql](../r/sfackler~rust-postgres.md) | Native PostgreSQL driver for the Rust programming language | 3,989 | +5 |
| [node-postgres](../r/brianc~node-postgres.md) | PostgreSQL client for node.js. | 13,194 | +3 |
| [pg](../r/ged~ruby-pg.md) | A PostgreSQL client library for Ruby | 871 | +1 |
| [postgrex](../r/elixir-ecto~postgrex.md) | PostgreSQL driver for Elixir | 1,214 | +1 |
| [RPostgres](../r/r-dbi~rpostgres.md) | A DBI-compliant interface to PostgreSQL | 342 | +1 |
| [clj-postgresql](../r/remodoy~clj-postgresql.md) | PostgreSQL helpers for Clojure projects | 162 | +0 |
| [luapgsql](../r/arcapos~luapgsql.md) | Lua binding for PostgreSQL | 120 | +0 |
| [Postmodern](../r/marijnh~postmodern.md) | A Common Lisp PostgreSQL programming interface | 431 | +0 |
| [zapatos](../r/jawj~zapatos.md) | Zero-abstraction Postgres for TypeScript: a non-ORM database library | 1,402 | +0 |
| [Npgsql](../r/npgsql~npgsql.md) | Npgsql is the .NET data provider for PostgreSQL. | 3,720 | -1 |
| [pg.zig](../r/karlseguin~pg.zig.md) | Native PostgreSQL driver / client for Zig | 590 | -1 |

[Back to top](#awesome-postgres)

## Monitoring

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [coroot](../r/coroot~coroot.md) | Coroot is an open-source observability and APM tool with AI-powered Root Cause Analysis. It combines metrics, logs, trac | 7,884 | +12 |
| [pg_ash](../r/nikolays~pg_ash.md) | Active Session History for PostgreSQL — wait event sampling with zero bloat (pg_cron + PGQ-style partition rotation) | 243 | +7 |
| [postgres_exporter](../r/wrouesnel~postgres_exporter.md) | A PostgreSQL metric exporter for Prometheus | 3,597 | +4 |
| [PMM](../r/percona~pmm.md) | Percona Monitoring and Management: an open source database monitoring, observability and management tool | 1,088 | +3 |
| [check\_pgactivity](../r/opmdg~check_pgactivity.md) | Nagios remote agent | 185 | +1 |
| [pg_exporter](../r/vonng~pg_exporter.md) | Advanced PostgreSQL & Pgbouncer Metrics Exporter for Prometheus | 361 | +1 |
| [pg\_view](../r/zalando~pg_view.md) | Get a detailed, real-time view of your PostgreSQL database and system metrics | 507 | +1 |
| [Pome](../r/rach~pome.md) | A Postgres Metrics Dashboard | 1,072 | +1 |
| [Check\_postgres](../r/bucardo~check_postgres.md) | Nagios check_postgres plugin for checking status of PostgreSQL databases | 602 | +0 |
| [Instrumental](../r/instrumental~instrumentald.md) | Instrumental System and Service Daemon | 15 | +0 |
| [libzbxpgsql](../r/cavaliercoder~libzbxpgsql.md) | Monitor PostgreSQL with Zabbix | 156 | +0 |
| [pgwatch2](../r/cybertec-postgresql~pgwatch2.md) | PostgreSQL metrics monitor/dashboard | 1,836 | +0 |
| [dexter](../r/ankane~dexter.md) | The automatic indexer for Postgres | 2,091 | -1 |

[Back to top](#awesome-postgres)

## Optimization

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [PEV2](../r/dalibo~pev2.md) | Postgres Explain Visualizer 2 | 3,571 | +6 |
| [PgHero](../r/ankane~pghero.md) | A performance dashboard for Postgres | 8,913 | +3 |
| [pgtune](../r/gregs1104~pgtune.md) | PostgreSQL configuration wizard | 1,088 | +1 |
| [aqo](../r/postgrespro~aqo.md) | Adaptive query optimization for PostgreSQL | 499 | +0 |
| [pg_flame](../r/mgartner~pg_flame.md) | A flamegraph generator for Postgres EXPLAIN ANALYZE output. | 1,620 | +0 |
| [pg_web_stats](../r/kirs~pg_web_stats.md) | Web UI to view pg_stat_statements | 97 | +0 |
| [pgassistant](../r/beh74~pgassistant-community.md) | A PostgreSQL assistant for developers Understand, optimize, and improve your PostgreSQL database with ease. | 41 | +0 |
| [pgconfig.org](../r/sebastianwebber~pgconfig.md) | Web Based PostgreSQL configuration tool | 88 | +0 |
| [pgtune](../r/le0pard~pgtune.md) | Pgtune - tuning PostgreSQL config by your hardware | 2,736 | +0 |
| [TimescaleDB Tune](../r/timescale~timescaledb-tune.md) | A tool for tuning TimescaleDB for better performance by adjusting settings to match your system's CPU and memory resourc | 500 | -1 |

[Back to top](#awesome-postgres)

## Platforms

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Atlas4D](../r/crisbez~atlas4d-base.md) | Self-hosted 4D spatiotemporal AI platform built on PostgreSQL, PostGIS, TimescaleDB, H3 and pgvector, with anomaly & thr | 15 | +0 |

[Back to top](#awesome-postgres)

## Security

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Acra](../r/cossacklabs~acra.md) | Database security suite. Database proxy with field-level encryption, search through encrypted data, SQL injections preve | 1,492 | +1 |

[Back to top](#awesome-postgres)

## Server

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Apache Cloudberry](../r/apache~cloudberry.md) | One advanced and mature open-source MPP (Massively Parallel Processing) database. Open source alternative to Greenplum D | 1,367 | +42 |

[Back to top](#awesome-postgres)

## Tutorials

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [SQL Syntax Cheat Sheet](../r/mergisi~sql-syntax-cheat-sheet.md) | A comprehensive SQL syntax cheat sheet for quick reference, covering essential commands, functions, operators, and conce | 54 | +2 |
| [pagila](../r/xzilla~pagila.md) | The PostgreSQL Sample Database | 78 | +0 |
| [pg-utils](../r/dataegret~pg-utils.md) | Useful PostgreSQL utilities | 1,218 | +0 |
| [postgresDBSamples](../r/morenoh149~postgresdbsamples.md) | Sample databases for postgres | 552 | +0 |

[Back to top](#awesome-postgres)

## Utilities

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Hasura GraphQL Engine](../r/hasura~graphql-engine.md) | Blazing fast, instant realtime GraphQL APIs on all your data with fine grained access control, also trigger webhooks on  | 32,099 | +19 |
| [PostgREST](../r/postgrest~postgrest.md) | REST API for any Postgres database | 27,616 | +15 |
| [pgroll](../r/xataio~pgroll.md) | PostgreSQL zero-downtime migrations made easy | 6,556 | +6 |
| [Greenmask](../r/greenmaskio~greenmask.md) | Database anonymization and test data management | 1,750 | +5 |
| [sqitch](../r/sqitchers~sqitch.md) | Sensible database change management | 3,155 | +4 |
| [ERAlchemy](../r/alexis-benoist~eralchemy.md) | Entity Relation Diagrams generation tool | 1,427 | +3 |
| [pREST](../r/prest~prest.md) | PostgreSQL ➕ REST, low-code, simplify and accelerate development, ⚡ instant, realtime, high-performance on any Postgres  | 4,611 | +2 |
| [GatewayD](../r/gatewayd-io~gatewayd.md) | database gateway for building data-driven applications | 289 | +1 |
| [pg_chameleon](../r/the4thdoctor~pg_chameleon.md) | MySQL to PostgreSQL replica system | 440 | +1 |
| [pgbadger](../r/darold~pgbadger.md) | A fast PostgreSQL Log Analyzer | 4,052 | +1 |
| [pgMonitor](../r/crunchydata~pgmonitor.md) | PostgreSQL Monitoring, Metrics Collection and Alerting Resources from Crunchy Data | 714 | +1 |
| [sqlcheck](../r/jarulraj~sqlcheck.md) | Automatically identify anti-patterns in SQL queries | 2,521 | +1 |
| [bemi](../r/bemihq~bemi.md) | Automatic data change tracking for PostgreSQL | 401 | +0 |
| [diesel-guard](../r/ayarotsky~diesel-guard.md) | Linter for dangerous Postgres migration patterns in Diesel and SQLx. Prevents   downtime caused by unsafe schema changes | 120 | +0 |
| [ldap2pg](../r/dalibo~ldap2pg.md) | 🐘 👥 Manage PostgreSQL roles and privileges from YAML or LDAP | 235 | +0 |
| [mysql-postgresql-converter](../r/lanyrd~mysql-postgresql-converter.md) | Lanyrd's MySQL to PostgreSQL conversion script | 1,315 | +0 |
| [NServiceBus.Transport.PostgreSql](../r/particular~nservicebus.sqlserver.md) | SQL Server Transport for NServiceBus | 47 | +0 |
| [pg_docs_bot](../r/mchristofides~pg_docs_bot.md) | A browser extension (Chrome and Firefox) for getting to the current Postgres docs by default. | 18 | +0 |
| [pg_insights](../r/lob~pg_insights.md) | A collection of convenient SQL for monitoring Postgres database health. | 310 | +0 |
| [pg_migrate](../r/jwdeitch~pg_migrate.md) | Manage postgres schema, triggers, procedures, and views | 32 | +0 |
| [pg_timetable](../r/cybertec-postgresql~pg_timetable.md) | pg_timetable: Advanced scheduling for PostgreSQL | 1,395 | +0 |
| [pg-differ](../r/multum~pg-differ.md) | Node.js migration tool for PostgreSQL | 40 | +0 |
| [pg-formatter](../r/gajus~pg-formatter.md) | A PostgreSQL SQL syntax beautifier. | 83 | +0 |
| [pg-safe-migrate](../r/defnotwig~pg-safe-migrate.md) | Safety-first PostgreSQL migration engine for Node.js — advisory locks, drift detection, checksum verification, 10 lint r | 1 | +0 |
| [pg-spot-operator](../r/pg-spot-ops~pg-spot-operator.md) | Stateful Postgres on cheap Spot VMs | 59 | +0 |
| [pgCenter](../r/lesovsky~pgcenter.md) | Command-line admin tool for observing and troubleshooting Postgres. | 1,624 | +0 |
| [pgclimb](../r/lukasmartinelli~pgclimb.md) | Export data from PostgreSQL into different data formats | 393 | +0 |
| [pgcmp](../r/cbbrowne~pgcmp.md) | Tool for comparing Postgres database schemas | 46 | +0 |
| [pgfutter](../r/lukasmartinelli~pgfutter.md) | Import CSV and JSON into PostgreSQL the easy way | 1,345 | +0 |
| [pglistend](../r/kabirbaidhya~pglistend.md) | pglistend - A lightweight PostgreSQL LISTEN Daemon using Node.js/Systemd | 30 | +0 |
| [pgloader](../r/dimitri~pgloader.md) | Migrate to PostgreSQL in a single command! | 6,499 | +0 |
| [pgmigrate](../r/yandex~pgmigrate.md) | Simple tool to evolve PostgreSQL schema easily. | 668 | +0 |
| [pgspot](../r/timescale~pgspot.md) | Spot vulnerabilities in postgres SQL scripts | 147 | +0 |
| [pgsync](../r/ankane~pgsync.md) | Sync data from one Postgres database to another | 3,467 | +0 |
| [PGXN client](../r/pgxn~pgxnclient.md) | A command line client for the PostgreSQL Extension Network | 160 | +0 |
| [planter](../r/achiku~planter.md) | Generate PlantUML ER diagram textual description from PostgreSQL tables | 556 | +0 |
| [PostGraphile](../r/graphile~postgraphile.md) | 🔮 Graphile's Crystal Monorepo; home to Grafast, PostGraphile, pg-introspection, pg-sql2 and much more! | 12,930 | +0 |
| [postgresql-metrics](../r/spotify~postgresql-metrics.md) | Tool that extracts and provides metrics on your PostgreSQL database | 598 | +0 |
| [Pyrseas](../r/perseas~pyrseas.md) | Provides utilities for Postgres database schema versioning. | 406 | +0 |
| [Qail](../r/qail-io~qail.md) | AST-native PostgreSQL toolkit: typed queries to wire protocol, with built-in RLS tenant isolation. | 35 | +0 |
| [RegreSQL](../r/dimitri~regresql.md) | Regression Testing your SQL queries | 358 | +0 |
| [yoke](../r/nanopack~yoke.md) | Postgres high-availability cluster with auto-failover and automated cluster recovery. | 1,341 | +0 |
| [ZSON](../r/postgrespro~zson.md) | ZSON is a PostgreSQL extension for transparent JSONB compression | 568 | +0 |
| [migra](../r/djrobstep~migra.md) | DEPRECATED: Like diff but for PostgreSQL schemas | 3,050 | -1 |
| [pg\_activity](../r/dalibo~pg_activity.md) | pg_activity is a top like application for PostgreSQL server activity monitoring. | 3,033 | -1 |

[Back to top](#awesome-postgres)

## Work Queues

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [pgBoss](../r/timgit~pg-boss.md) | Queueing jobs in Postgres from Node.js like a boss | 3,880 | +23 |
| [river](../r/riverqueue~river.md) | Fast and reliable background jobs in Go | 5,593 | +23 |
| [pgmq](../r/pgmq~pgmq.md) | A lightweight message queue. Like AWS SQS and RSMQ but on Postgres. | 5,102 | +14 |
| [BeanQueue](../r/launchplatform~bq.md) | BeanQueue, a lightweight Python task queue framework based on SQLAlchemy, PostgreSQL SKIP LOCKED queries and NOTIFY / LI | 28 | +0 |

[Back to top](#awesome-postgres)

---
*Updated: 2026-08-22 | [View live site ↗](https://patrickclery.com/awesomer/l/postgres/)*
