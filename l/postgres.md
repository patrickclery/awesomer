# awesome-postgres

> A curated list of awesome PostgreSQL software, libraries, tools and resources, inspired by awesome-mysql

[Home](../README.md) | [Live site ↗](https://patrickclery.com/awesomer/l/postgres/) | [Source ↗](https://github.com/dhamaniasad/awesome-postgres)

## Top 10 Trending

| # | Repo | Stars | 7d | 30d | 90d |
|---|------|-------|----|-----|-----|
| 1 | [CloudNativePG operator](../r/cloudnative-pg~cloudnative-pg.md) | 8,837 | +48 | +196 | +523 |
| 2 | [river](../r/riverqueue~river.md) | 5,257 | +48 | +123 | +380 |
| 3 | [Teable](../r/teableio~teable.md) | 21,360 | +35 | +111 | +304 |
| 4 | [pgweb](../r/sosedoff~pgweb.md) | 9,402 | +28 | +44 | +121 |
| 5 | [atlas](../r/ariga~atlas.md) | 8,502 | +27 | +98 | +292 |
| 6 | [pgBoss](../r/timgit~pg-boss.md) | 3,653 | +23 | +112 | +342 |
| 7 | [pgmq](../r/pgmq~pgmq.md) | 4,965 | +21 | +94 | +314 |
| 8 | [Hasura GraphQL Engine](../r/hasura~graphql-engine.md) | 32,071 | +20 | +103 | +147 |
| 9 | [coroot](../r/coroot~coroot.md) | 7,761 | +19 | +112 | +233 |
| 10 | [PostgREST](../r/postgrest~postgrest.md) | 27,241 | +19 | +101 | +546 |

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
| [wal-g](../r/wal-g~wal-g.md) | Archival and Restoration for databases in the Cloud | 4,122 | +9 |
| [pg\_probackup](../r/postgrespro~pg_probackup.md) | Backup and recovery manager for PostgreSQL | 791 | +3 |
| [OmniPITR](../r/omniti-labs~omnipitr.md) | Advanced WAL File Management Tools for PostgreSQL | 179 | +0 |
| [pg-backups-to-s3](../r/saicheg~pg-backups-to-s3.md) | Small tool to create your postgresql backups on regular bases and upload them to S3   | 19 | +0 |
| [pg\_back](../r/orgrim~pg_back.md) | Simple backup tool for PostgreSQL | 563 | +0 |
| [pgbackup-sidecar](../r/musab520~pgbackup-sidecar.md) | `pgbackup-sidecar` is a lightweight Docker sidecar container designed to automate regular backups of a PostgreSQL databa | 5 | +0 |
| [pghoard](../r/aiven~pghoard.md) | PostgreSQL® backup and restore service | 1,413 | +0 |
| [postgres-backup-oss](../r/isaced~postgres-backup-oss.md) | A handy Docker container to periodically backup PostgreSQL to Alibaba Cloud Object Storage Service (OSS) | 1 | +0 |
| [pgbackweb](../r/eduardolat~pgbackweb.md) | 🐘 Effortless PostgreSQL backups with a user-friendly web interface! 🌐💾 | 2,586 | -1 |
| [wal-e](../r/wal-e~wal-e.md) | Continuous Archiving for Postgres | 3,467 | -1 |

[Back to top](#awesome-postgres)

## CLI

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [atlas](../r/ariga~atlas.md) | Declarative schema migrations with schema-as-code workflows | 8,502 | +27 |
| [pgcli](../r/dbcli~pgcli.md) | Postgres CLI with autocompletion and syntax highlighting | 13,223 | +7 |
| [schemaspy](../r/schemaspy~schemaspy.md) | Database documentation built easy | 3,660 | +4 |
| [pg-schema-diff](../r/stripe~pg-schema-diff.md) | Go library for diffing Postgres schemas and generating SQL migrations | 860 | +3 |
| [sabiql](../r/riii111~sabiql.md) | A fast PostgreSQL TUI written in Rust. driver-less, vim-first, with ER diagrams. No database drivers, no setup, just psq | 200 | +2 |
| [pgsh](../r/sastraxi~pgsh.md) | Branch your PostgreSQL Database like Git | 602 | +1 |
| [MigrationPilot](../r/mickelsamuel~migrationpilot.md) | Know exactly what your PostgreSQL migration will do to production — before you merge. | 5 | +0 |
| [pgplan](../r/jacobarthurs~pgplan.md) | Compare and analyze PostgreSQL EXPLAIN plans from the CLI | 12 | +0 |
| [psql2csv](../r/fphilipe~psql2csv.md) | Run a query in psql and output the result as CSV. | 186 | +0 |
| [squix](../r/eduardofuncao~squix.md) | A minimal CLI tool for managing and executing SQL queries across multiple databases. Written in Go, made beautiful with  | 240 | +0 |

[Back to top](#awesome-postgres)

## Distributions

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Pigsty](../r/vonng~pigsty.md) | Enterprise-Grade OSS PostgreSQL Distribution with HA, PITR, IaC, Monitor, 12 kernel forks and 500+ PG extensions. Best-o | 5,176 | +11 |

[Back to top](#awesome-postgres)

## Extensions

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [pg_search](../r/paradedb~paradedb.md) | Simple, Elastic-quality search for Postgres | 8,940 | +16 |
| [Citus](../r/citusdata~citus.md) | Distributed PostgreSQL as an extension | 12,570 | +12 |
| [pg\_partman](../r/pgpartman~pg_partman.md) | Partition management extension for PostgreSQL | 2,738 | +11 |
| [AGE](../r/apache~age.md) | Graph database optimized for fast analysis and real-time data processing. It is provided as an extension to PostgreSQL. | 4,605 | +10 |
| [HypoPG](../r/hypopg~hypopg.md) | Hypothetical Indexes for PostgreSQL | 1,663 | +4 |
| [pg_cron](../r/citusdata~pg_cron.md) | Run periodic jobs in PostgreSQL | 3,812 | +4 |
| [pg\_squeeze](../r/cybertec-postgresql~pg_squeeze.md) | A PostgreSQL extension for automatic bloat cleanup | 676 | +4 |
| [pg\_stat\_monitor](../r/percona~pg_stat_monitor.md) | Query Performance Monitoring Tool for PostgreSQL | 583 | +3 |
| [pglogical](../r/2ndquadrant~pglogical.md) | Logical Replication extension for PostgreSQL 17, 16, 15, 14, 13, 12, 11, 10, 9.6, 9.5, 9.4 (Postgres), providing much fa | 1,225 | +3 |
| [pgRouting](../r/pgrouting~pgrouting.md) | Repository contains pgRouting library. Development branch is "develop", stable branch is "master" | 1,409 | +3 |
| [plpgsql\_check](../r/okbob~plpgsql_check.md) | plpgsql_check is a linter tool (does source code static analyze) for the PostgreSQL language plpgsql (the native languag | 765 | +1 |
| [pg\_barcode](../r/btouchard~pg_barcode.md) | PostgreSQL SVG QRcode & Datamatrix generator | 1 | +0 |
| [pg\_paxos](../r/citusdata~pg_paxos.md) | Basic implementation of Paxos and Paxos-based table replication for a cluster of PostgreSQL nodes | 308 | +0 |
| [pg\_shard](../r/citusdata~pg_shard.md) | ATTENTION: pg_shard is superseded by Citus, its more powerful replacement | 1,062 | +0 |
| [PG\_Themis](../r/cossacklabs~pg_themis.md) | Postgres Themis plugin | 33 | +0 |
| [pgcat](../r/kingluo~pgcat.md) | Enhanced PostgreSQL logical replication | 386 | +0 |
| [pgMemento](../r/pgmemento~pgmemento.md) | Audit trail with schema versioning for PostgreSQL using transaction-based logging | 409 | +0 |
| [cstore\_fdw](../r/citusdata~cstore_fdw.md) | Columnar storage extension for Postgres built as a foreign data wrapper. Check out https://github.com/citusdata/citus fo | 1,783 | -1 |
| [zomboDB](../r/zombodb~zombodb.md) | Making Postgres and Elasticsearch work together like it's 2023 | 4,730 | -1 |

[Back to top](#awesome-postgres)

## GUI

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Teable](../r/teableio~teable.md) | ✨ The Next Gen Airtable Alternative: No-Code Postgres | 21,360 | +35 |
| [pgweb](../r/sosedoff~pgweb.md) | Cross-platform client for PostgreSQL databases | 9,402 | +28 |
| [Redash](../r/getredash~redash.md) | Make Your Company Data Driven. Connect to any data source, easily visualize, dashboard and share your data. | 28,646 | +12 |
| [Postbird](../r/paxa~postbird.md) | Open source PostgreSQL GUI client for macOS, Linux and Windows | 1,626 | +1 |
| [PgManage](../r/commandprompt~pgmanage.md) | Web tool for database management | 1,012 | +0 |
| [phpPgAdmin](../r/phppgadmin~phppgadmin.md) | the premier web-based administration tool for postgresql | 843 | +0 |
| [temBoard](../r/dalibo~temboard.md) | PostgreSQL Remote Control | 761 | +0 |

[Back to top](#awesome-postgres)

## High-Availability

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Patroni](../r/zalando~patroni.md) | A template for PostgreSQL High Availability with Etcd, Consul, ZooKeeper, or Kubernetes | 8,537 | +17 |
| [autobase](../r/vitabaks~autobase.md) | Automated database platform for PostgreSQL® - Your own DBaaS. | 4,269 | +6 |
| [pg-status](../r/krylosov-aa~pg-status.md) | A microservice (sidecar) that helps instantly determine the status of your PostgreSQL hosts including whether they are a | 79 | +6 |
| [Spock](../r/pgedge~spock.md) | Logical multi-master PostgreSQL replication | 733 | +3 |
| [pg_auto_failover](../r/citusdata~pg_auto_failover.md) | Postgres extension and service for automated failover and high-availability | 1,351 | +2 |
| [pgrwl](../r/hashmap-kz~pgrwl.md) | Cloud-native continuous backup for PostgreSQL - WAL/base-backup streaming, compression, encryption, retention, and monit | 177 | +2 |
| [PAF](../r/clusterlabs~paf.md) | PostgreSQL Automatic Failover: High-Availibility for Postgres, based on Pacemaker and Corosync. | 350 | +1 |
| [repmgr](../r/2ndquadrant~repmgr.md) | A lightweight replication manager for PostgreSQL (Postgres) | 1,702 | +1 |
| [BDR](../r/2ndquadrant~bdr.md) | Bi-Directional Multi-Master Replication (BDR) for PostgreSQL, deprecated, please visit 2ndQuadrant website for latest BD | 359 | +0 |
| [pglookout](../r/aiven~pglookout.md) | PostgreSQL replication monitoring and failover daemon | 190 | +0 |
| [SkyTools](../r/pgq~skytools-legacy.md) | Obsolete, see https://github.com/pgq/ for maintained code. | 249 | +0 |
| [Stolon](../r/sorintlab~stolon.md) | PostgreSQL cloud native High Availability and more. | 4,816 | -1 |

[Back to top](#awesome-postgres)

## Kubernetes

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [CloudNativePG operator](../r/cloudnative-pg~cloudnative-pg.md) | CloudNativePG is a comprehensive platform designed to seamlessly manage PostgreSQL databases within Kubernetes environme | 8,837 | +48 |
| [Crunchy Operator](../r/crunchydata~postgres-operator.md) | Production PostgreSQL for Kubernetes, from high availability Postgres clusters to full-scale database-as-a-service. | 4,423 | +2 |
| [StackGres Operator](../r/ongres~stackgres.md) | StackGres Operator, Full Stack PostgreSQL on Kubernetes // !! Mirror repository of https://gitlab.com/ongresinc/stackgre | 1,408 | +2 |
| [Percona Everest Operator](../r/percona~everest-operator.md) | OpenEverest Operator | 42 | +1 |
| [Percona PostgreSQL Operator](../r/percona~percona-postgresql-operator.md) | Percona Operator for PostgreSQL | 375 | +1 |
| [Zalando Operator](../r/zalando~postgres-operator.md) | Postgres operator creates and manages PostgreSQL clusters running in Kubernetes | 5,182 | +1 |
| [Kubegres Operator](../r/reactive-tech~kubegres.md) | Kubegres is a Kubernetes operator allowing to deploy one or many clusters of PostgreSql instances and manage databases r | 1,349 | -2 |

[Back to top](#awesome-postgres)

## Language bindings

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [node-postgres](../r/brianc~node-postgres.md) | PostgreSQL client for node.js. | 13,160 | +8 |
| [rust-postgresql](../r/sfackler~rust-postgres.md) | Native PostgreSQL driver for the Rust programming language | 3,947 | +6 |
| [pq](../r/lib~pq.md) | Go PostgreSQL driver for database/sql | 9,906 | +5 |
| [Npgsql](../r/npgsql~npgsql.md) | Npgsql is the .NET data provider for PostgreSQL. | 3,704 | +3 |
| [pg.zig](../r/karlseguin~pg.zig.md) | Native PostgreSQL driver / client for Zig | 568 | +3 |
| [postgrex](../r/elixir-ecto~postgrex.md) | PostgreSQL driver for Elixir | 1,212 | +1 |
| [RPostgres](../r/r-dbi~rpostgres.md) | A DBI-compliant interface to PostgreSQL | 339 | +1 |
| [clj-postgresql](../r/remodoy~clj-postgresql.md) | PostgreSQL helpers for Clojure projects | 162 | +0 |
| [luapgsql](../r/arcapos~luapgsql.md) | Lua binding for PostgreSQL | 120 | +0 |
| [pg](../r/ged~ruby-pg.md) | A PostgreSQL client library for Ruby | 870 | +0 |
| [Postmodern](../r/marijnh~postmodern.md) | A Common Lisp PostgreSQL programming interface | 430 | +0 |
| [zapatos](../r/jawj~zapatos.md) | Zero-abstraction Postgres for TypeScript: a non-ORM database library | 1,398 | -3 |

[Back to top](#awesome-postgres)

## Monitoring

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [coroot](../r/coroot~coroot.md) | Coroot is an open-source observability and APM tool with AI-powered Root Cause Analysis. It combines metrics, logs, trac | 7,761 | +19 |
| [PMM](../r/percona~pmm.md) | Percona Monitoring and Management: an open source database monitoring, observability and management tool | 1,048 | +5 |
| [dexter](../r/ankane~dexter.md) | The automatic indexer for Postgres | 2,083 | +4 |
| [postgres_exporter](../r/wrouesnel~postgres_exporter.md) | A PostgreSQL metric exporter for Prometheus | 3,547 | +4 |
| [pg\_view](../r/zalando~pg_view.md) | Get a detailed, real-time view of your PostgreSQL database and system metrics | 504 | +1 |
| [check\_pgactivity](../r/opmdg~check_pgactivity.md) | Nagios remote agent | 183 | +0 |
| [Check\_postgres](../r/bucardo~check_postgres.md) | Nagios check_postgres plugin for checking status of PostgreSQL databases | 598 | +0 |
| [Instrumental](../r/instrumental~instrumentald.md) | Instrumental System and Service Daemon | 15 | +0 |
| [libzbxpgsql](../r/cavaliercoder~libzbxpgsql.md) | Monitor PostgreSQL with Zabbix | 155 | +0 |
| [pg_ash](../r/nikolays~pg_ash.md) | Active Session History for PostgreSQL — wait event sampling with zero bloat (pg_cron + PGQ-style partition rotation) | 231 | +0 |
| [pg_exporter](../r/vonng~pg_exporter.md) | Advanced PostgreSQL & Pgbouncer Metrics Exporter for Prometheus | 349 | +0 |
| [pgwatch2](../r/cybertec-postgresql~pgwatch2.md) | PostgreSQL metrics monitor/dashboard | 1,840 | -1 |
| [Pome](../r/rach~pome.md) | A Postgres Metrics Dashboard | 1,073 | -1 |

[Back to top](#awesome-postgres)

## Optimization

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [PEV2](../r/dalibo~pev2.md) | Postgres Explain Visualizer 2 | 3,493 | +7 |
| [PgHero](../r/ankane~pghero.md) | A performance dashboard for Postgres | 8,880 | +3 |
| [pgtune](../r/le0pard~pgtune.md) | Pgtune - tuning PostgreSQL config by your hardware | 2,721 | +3 |
| [pgassistant](../r/beh74~pgassistant-community.md) | A PostgreSQL assistant for developers Understand, optimize, and improve your PostgreSQL database with ease. | 35 | +2 |
| [pg_flame](../r/mgartner~pg_flame.md) | A flamegraph generator for Postgres EXPLAIN ANALYZE output. | 1,619 | +1 |
| [aqo](../r/postgrespro~aqo.md) | Adaptive query optimization for PostgreSQL | 495 | +0 |
| [pg_web_stats](../r/kirs~pg_web_stats.md) | Web UI to view pg_stat_statements | 97 | +0 |
| [pgconfig.org](../r/sebastianwebber~pgconfig.md) | Web Based PostgreSQL configuration tool | 88 | +0 |
| [pgtune](../r/gregs1104~pgtune.md) | PostgreSQL configuration wizard | 1,086 | +0 |
| [TimescaleDB Tune](../r/timescale~timescaledb-tune.md) | A tool for tuning TimescaleDB for better performance by adjusting settings to match your system's CPU and memory resourc | 501 | +0 |

[Back to top](#awesome-postgres)

## Platforms

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Atlas4D](../r/crisbez~atlas4d-base.md) | Self-hosted 4D spatiotemporal AI platform built on PostgreSQL, PostGIS, TimescaleDB, H3 and pgvector, with anomaly & thr | 14 | +0 |

[Back to top](#awesome-postgres)

## Security

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Acra](../r/cossacklabs~acra.md) | Database security suite. Database proxy with field-level encryption, search through encrypted data, SQL injections preve | 1,482 | +0 |

[Back to top](#awesome-postgres)

## Server

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Apache Cloudberry](../r/apache~cloudberry.md) | One advanced and mature open-source MPP (Massively Parallel Processing) database. Open source alternative to Greenplum D | 1,230 | +1 |

[Back to top](#awesome-postgres)

## Tutorials

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [pg-utils](../r/dataegret~pg-utils.md) | Useful PostgreSQL utilities | 1,210 | +2 |
| [SQL Syntax Cheat Sheet](../r/mergisi~sql-syntax-cheat-sheet.md) | A comprehensive SQL syntax cheat sheet for quick reference, covering essential commands, functions, operators, and conce | 44 | +2 |
| [pagila](../r/xzilla~pagila.md) | The PostgreSQL Sample Database | 75 | +0 |
| [postgresDBSamples](../r/morenoh149~postgresdbsamples.md) | Sample databases for postgres | 553 | +0 |

[Back to top](#awesome-postgres)

## Utilities

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Hasura GraphQL Engine](../r/hasura~graphql-engine.md) | Blazing fast, instant realtime GraphQL APIs on all your data with fine grained access control, also trigger webhooks on  | 32,071 | +20 |
| [PostgREST](../r/postgrest~postgrest.md) | REST API for any Postgres database | 27,241 | +19 |
| [Greenmask](../r/greenmaskio~greenmask.md) | Database anonymization and test data management | 1,697 | +5 |
| [pgroll](../r/xataio~pgroll.md) | PostgreSQL zero-downtime migrations made easy | 6,503 | +4 |
| [pg_timetable](../r/cybertec-postgresql~pg_timetable.md) | pg_timetable: Advanced scheduling for PostgreSQL | 1,370 | +3 |
| [pgbadger](../r/darold~pgbadger.md) | A fast PostgreSQL Log Analyzer | 4,030 | +3 |
| [pgloader](../r/dimitri~pgloader.md) | Migrate to PostgreSQL in a single command! | 6,439 | +3 |
| [PostGraphile](../r/graphile~postgraphile.md) | 🔮 Graphile's Crystal Monorepo; home to Grafast, PostGraphile, pg-introspection, pg-sql2 and much more! | 12,931 | +3 |
| [pgsync](../r/ankane~pgsync.md) | Sync data from one Postgres database to another | 3,454 | +2 |
| [diesel-guard](../r/ayarotsky~diesel-guard.md) | Linter for dangerous Postgres migration patterns in Diesel and SQLx. Prevents   downtime caused by unsafe schema changes | 115 | +1 |
| [migra](../r/djrobstep~migra.md) | DEPRECATED: Like diff but for PostgreSQL schemas | 3,049 | +1 |
| [pg\_activity](../r/dalibo~pg_activity.md) | pg_activity is a top like application for PostgreSQL server activity monitoring. | 3,021 | +1 |
| [pgMonitor](../r/crunchydata~pgmonitor.md) | PostgreSQL Monitoring, Metrics Collection and Alerting Resources from Crunchy Data | 707 | +1 |
| [pgspot](../r/timescale~pgspot.md) | Spot vulnerabilities in postgres SQL scripts | 144 | +1 |
| [bemi](../r/bemihq~bemi.md) | Automatic data change tracking for PostgreSQL | 399 | +0 |
| [ERAlchemy](../r/alexis-benoist~eralchemy.md) | Entity Relation Diagrams generation tool | 1,416 | +0 |
| [ldap2pg](../r/dalibo~ldap2pg.md) | 🐘 👥 Manage PostgreSQL roles and privileges from YAML or LDAP | 232 | +0 |
| [mysql-postgresql-converter](../r/lanyrd~mysql-postgresql-converter.md) | Lanyrd's MySQL to PostgreSQL conversion script | 1,312 | +0 |
| [NServiceBus.Transport.PostgreSql](../r/particular~nservicebus.sqlserver.md) | SQL Server Transport for NServiceBus | 47 | +0 |
| [pg_chameleon](../r/the4thdoctor~pg_chameleon.md) | MySQL to PostgreSQL replica system | 438 | +0 |
| [pg_docs_bot](../r/mchristofides~pg_docs_bot.md) | A browser extension (Chrome and Firefox) for getting to the current Postgres docs by default. | 18 | +0 |
| [pg_insights](../r/lob~pg_insights.md) | A collection of convenient SQL for monitoring Postgres database health. | 310 | +0 |
| [pg_migrate](../r/jwdeitch~pg_migrate.md) | Manage postgres schema, triggers, procedures, and views | 32 | +0 |
| [pg-differ](../r/multum~pg-differ.md) | Node.js migration tool for PostgreSQL | 40 | +0 |
| [pg-formatter](../r/gajus~pg-formatter.md) | A PostgreSQL SQL syntax beautifier. | 83 | +0 |
| [pg-safe-migrate](../r/defnotwig~pg-safe-migrate.md) | Safety-first PostgreSQL migration engine for Node.js — advisory locks, drift detection, checksum verification, 10 lint r | 1 | +0 |
| [pg-spot-operator](../r/pg-spot-ops~pg-spot-operator.md) | Stateful Postgres on cheap Spot VMs | 59 | +0 |
| [pgCenter](../r/lesovsky~pgcenter.md) | Command-line admin tool for observing and troubleshooting Postgres. | 1,612 | +0 |
| [pgclimb](../r/lukasmartinelli~pgclimb.md) | Export data from PostgreSQL into different data formats | 393 | +0 |
| [pgcmp](../r/cbbrowne~pgcmp.md) | Tool for comparing Postgres database schemas | 46 | +0 |
| [pgfutter](../r/lukasmartinelli~pgfutter.md) | Import CSV and JSON into PostgreSQL the easy way | 1,346 | +0 |
| [pglistend](../r/kabirbaidhya~pglistend.md) | pglistend - A lightweight PostgreSQL LISTEN Daemon using Node.js/Systemd | 30 | +0 |
| [PGXN client](../r/pgxn~pgxnclient.md) | A command line client for the PostgreSQL Extension Network | 158 | +0 |
| [planter](../r/achiku~planter.md) | Generate PlantUML ER diagram textual description from PostgreSQL tables | 557 | +0 |
| [postgresql-metrics](../r/spotify~postgresql-metrics.md) | Tool that extracts and provides metrics on your PostgreSQL database | 598 | +0 |
| [pREST](../r/prest~prest.md) | PostgreSQL ➕ REST, low-code, simplify and accelerate development, ⚡ instant, realtime, high-performance on any Postgres  | 4,550 | +0 |
| [Pyrseas](../r/perseas~pyrseas.md) | Provides utilities for Postgres database schema versioning. | 407 | +0 |
| [Qail](../r/qail-io~qail.md) | AST-native PostgreSQL toolkit: typed queries to wire protocol, with built-in RLS tenant isolation. | 26 | +0 |
| [RegreSQL](../r/dimitri~regresql.md) | Regression Testing your SQL queries | 353 | +0 |
| [sqitch](../r/sqitchers~sqitch.md) | Sensible database change management | 3,132 | +0 |
| [sqlcheck](../r/jarulraj~sqlcheck.md) | Automatically identify anti-patterns in SQL queries | 2,520 | +0 |
| [yoke](../r/nanopack~yoke.md) | Postgres high-availability cluster with auto-failover and automated cluster recovery. | 1,342 | +0 |
| [ZSON](../r/postgrespro~zson.md) | ZSON is a PostgreSQL extension for transparent JSONB compression | 569 | +0 |
| [GatewayD](../r/gatewayd-io~gatewayd.md) | database gateway for building data-driven applications | 284 | -1 |
| [pgmigrate](../r/yandex~pgmigrate.md) | Simple tool to evolve PostgreSQL schema easily. | 666 | -1 |

[Back to top](#awesome-postgres)

## Work Queues

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [river](../r/riverqueue~river.md) | Fast and reliable background jobs in Go | 5,257 | +48 |
| [pgBoss](../r/timgit~pg-boss.md) | Queueing jobs in Postgres from Node.js like a boss | 3,653 | +23 |
| [pgmq](../r/pgmq~pgmq.md) | A lightweight message queue. Like AWS SQS and RSMQ but on Postgres. | 4,965 | +21 |
| [BeanQueue](../r/launchplatform~bq.md) | BeanQueue, a lightweight Python task queue framework based on SQLAlchemy, PostgreSQL SKIP LOCKED queries and NOTIFY / LI | 28 | +1 |

[Back to top](#awesome-postgres)

---
*Updated: 2026-06-19 | [View live site ↗](https://patrickclery.com/awesomer/l/postgres/)*
