## High-Availability

| Name                                                              | Description                                                                                                                            | Stars | Last Commit |
|-------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Patroni](https://github.com/zalando/patroni)                     | Template for PostgreSQL HA with ZooKeeper or etcd.                                                                                     | 7382  | 2025-05-30  |
| [Stolon](https://github.com/sorintlab/stolon)                     | PostgreSQL HA based on Consul or etcd, with Kubernetes integration.                                                                    | 4734  | 2024-07-08  |
| [autobase](https://github.com/vitabaks/autobase)                  | Autobase for PostgreSQL® is an open-source DBaaS that automates the deployment and management of highly available PostgreSQL clusters. | 2658  | 2025-06-02  |
| [repmgr](https://github.com/2ndQuadrant/repmgr)                   | Open-source tool suite to manage replication and failover in a cluster of PostgreSQL servers.                                          | 1631  | 2025-04-17  |
| [pg_auto_failover](https://github.com/citusdata/pg_auto_failover) | Postgres extension and service for automated failover and high-availability.                                                           | 1209  | 2025-04-11  |
| [BDR](https://github.com/2ndQuadrant/bdr)                         | BiDirectional Replication - a multimaster replication system for PostgreSQL                                                            | 358   | 2020-02-20  |
| [PAF](https://github.com/ClusterLabs/PAF)                         | PostgreSQL Automatic Failover: High-Availibility for Postgres, based on Pacemaker and Corosync.                                        | 348   | 2024-06-13  |
| [SkyTools](https://github.com/pgq/skytools-legacy)                | Replication tools, including PgQ, a queuing system, and Londiste, a replication system a bit simpler to manage than Slony.             | 246   | 2017-06-28  |
| [pglookout](https://github.com/aiven/pglookout)                   | Replication monitoring and failover daemon.                                                                                            | 183   | 2025-01-17  |
| [pgrwl](https://github.com/hashmap-kz/pgrwl)                      | Stream write-ahead logs (WAL) from a PostgreSQL server in real time. A drop-in, container-friendly alternative to pg_receivewal.       | 11    | 2025-06-06  |

## Backups

| Name                                                             | Description                                                                                                                                                                                                                                                                                                                                                                                                       | Stars | Last Commit |
|------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [wal-g](https://github.com/wal-g/wal-g)                          | The successor of WAL-E rewritten in Go. Currently supports cloud object storage services by AWS (S3), Google Cloud (GCS), Azure, as well as OpenStack Swift, MinIO, and file system storages. Supports block-level incremental backups, offloading backup tasks to a standby server, provides parallelization and throttling options. In addition to Postgres, WAL-G can be used for MySQL and MongoDB databases. | 3582  | 2025-05-22  |
| [wal-e](https://github.com/wal-e/wal-e)                          |                                                                                                                                                                                                                                                                                                                                                                                                                   | 3470  | 2023-12-20  |
| [pgbackweb](https://github.com/eduardolat/pgbackweb)             | A Complete Docker-based Postgres backup and maintenance tool with Web UI.                                                                                                                                                                                                                                                                                                                                         | 1620  | 2025-03-14  |
| [pghoard](https://github.com/aiven/pghoard)                      | Backup and restore tool for cloud object stores (AWS S3, Azure, Google Cloud, OpenStack Swift).                                                                                                                                                                                                                                                                                                                   | 1347  | 2025-04-15  |
| [pg\_probackup](https://github.com/postgrespro/pg_probackup)     |                                                                                                                                                                                                                                                                                                                                                                                                                   | 739   | 2024-10-10  |
| [pg\_back](https://github.com/orgrim/pg_back)                    | pg\_back is a simple backup script                                                                                                                                                                                                                                                                                                                                                                                | 552   | 2025-05-10  |
| [OmniPITR](https://github.com/omniti-labs/omnipitr)              | Advanced WAL File Management Tools for PostgreSQL.                                                                                                                                                                                                                                                                                                                                                                | 180   | 2019-06-25  |
| [pg-backups-to-s3](https://github.com/Saicheg/pg-backups-to-s3)  | Docker-first solution on top of pg_dump with support for environment-based configuration for scheduled PostgreSQL backups with optional compression, GPG encryption, webhooks, automatic upload to Amazon S3.                                                                                                                                                                                                     | 6     | 2025-05-30  |
| [pgbackup-sidecar](https://github.com/Musab520/pgbackup-sidecar) | `pgbackup-sidecar` is a lightweight Docker sidecar container designed to automate regular backups of a PostgreSQL database using `pg_dump`, `cron`, and bash scripts while also sending output to a webhook.                                                                                                                                                                                                      | 4     | 2024-11-08  |

## GUI

| Name                                                   | Description                                                                  | Stars | Last Commit |
|--------------------------------------------------------|------------------------------------------------------------------------------|-------|-------------|
| [Redash](https://github.com/getredash/redash)          | Connect to any data source, easily visualize and share your data.            | 27360 | 2025-05-20  |
| [Teable](https://github.com/teableio/teable)           | A Super fast, Real-time, Professional, Developer friendly, No code database. | 18511 | 2025-05-30  |
| [pgweb](https://github.com/sosedoff/pgweb)             | Web-based PostgreSQL database browser written in Go.                         | 8900  | 2025-05-08  |
| [Postbird](https://github.com/Paxa/postbird)           | PostgreSQL Client for macOS.                                                 | 1579  | 2023-05-08  |
| [phpPgAdmin](https://github.com/phppgadmin/phppgadmin) | The Premier Web Based Administration Tool for PostgreSQL.                    | 824   | 2024-07-30  |
| [temBoard](https://github.com/dalibo/temboard)         | Web-based PostgreSQL GUI and monitoring.                                     | 484   | 2025-05-28  |

## Distributions

| Name                                      | Description                                                                                                                         | Stars | Last Commit |
|-------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Pigsty](https://github.com/Vonng/pigsty) | Battery-Included Open-Source Distribution for PostgreSQL with ultimate observability &amp; Database-as-Code toolbox for developers. | 3963  | 2025-05-28  |

## CLI

| Name                                                       | Description                                                                                                                        | Stars | Last Commit |
|------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [pgcli](https://github.com/dbcli/pgcli)                    | Postgres CLI with autocompletion and syntax highlighting                                                                           | 12481 | 2025-05-04  |
| [atlas](https://github.com/ariga/atlas)                    | Atlas is a tool for managing and migrating database schemas using modern DevOps principles.                                        | 6889  | 2025-05-29  |
| [schemaspy](https://github.com/schemaspy/schemaspy)        | SchemaSpy is a JAVA JDBC-compliant tool for generating your database to HTML documentation, including Entity Relationship diagrams | 3369  | 2025-03-15  |
| [pgsh](https://github.com/sastraxi/pgsh)                   | Branch your PostgreSQL Database like Git                                                                                           | 588   | 2023-01-11  |
| [pg-schema-diff](https://github.com/stripe/pg-schema-diff) | CLI (and Golang library) for diffing Postgres schemas and generating SQL migrations with minimal locking.                          | 503   | 2025-04-14  |
| [psql2csv](https://github.com/fphilipe/psql2csv)           | Run a query in psql and output the result as CSV                                                                                   | 184   | 2022-02-23  |

## Server

| Name                                                      | Description                                                             | Stars | Last Commit |
|-----------------------------------------------------------|-------------------------------------------------------------------------|-------|-------------|
| [Apache Cloudberry](https://github.com/apache/cloudberry) | And MPP PostgreSQL fork. Open source alternative to Greenplum Database. | 971   | 2025-05-31  |

## Security

| Name                                        | Description                                                                                                                                                                 | Stars | Last Commit |
|---------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Acra](https://github.com/cossacklabs/acra) | SQL database security suite: proxy for data protection with transparent "on the fly" data encryption, SQL firewall (SQL injections prevention), intrusion detection system. | 1400  | 2025-04-17  |

## Monitoring

| Name                                                                | Description                                                                                                                                            | Stars | Last Commit |
|---------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [coroot](https://github.com/coroot/coroot)                          | Coroot is an open-source APM &amp; Observability tool, a DataDog and NewRelic alternative. Powered by eBPF for rapid insights into system performance. | 6496  | 2025-05-29  |
| [postgres_exporter](https://github.com/wrouesnel/postgres_exporter) | Prometheus exporter for PostgreSQL server metrics.                                                                                                     | 3071  | 2025-06-01  |
| [dexter](https://github.com/ankane/dexter)                          | The automatic indexer for Postgres. Detects slow queries and creates indexes if configured to do so.                                                   | 1987  | 2025-06-02  |
| [pgwatch2](https://github.com/cybertec-postgresql/pgwatch2)         | Flexible and easy to get started PostgreSQL metrics monitor focusing on Grafana dashboards.                                                            | 1838  | 2024-12-17  |
| [Pome](https://github.com/rach/pome)                                | Pome stands for PostgreSQL Metrics. Pome is a PostgreSQL Metrics Dashboard to keep track of the health of your database.                               | 1087  | 2020-09-04  |
| [PMM](https://github.com/percona/pmm)                               | Percona Monitoring and Management (PMM) is a Free and Open Source platform for monitoring and managing PostgreSQL, MySQL, and MongoDB.                 | 771   | 2025-06-02  |
| [Check\_postgres](https://github.com/bucardo/check_postgres)        | Nagios check\_postgres plugin for checking status of PostgreSQL databases.                                                                             | 578   | 2025-01-02  |
| [pg\_view](https://github.com/zalando/pg_view)                      | Open-source command-line tool that shows global system stats, per-partition information, memory stats and other information.                           | 499   | 2023-03-25  |
| [pg_exporter](https://github.com/Vonng/pg_exporter)                 | Fully customizable Prometheus exporter for PostgreSQL &amp; Pgbouncer with fine-grained execution control.                                             | 231   | 2025-05-07  |
| [check\_pgactivity](https://github.com/OPMDG/check_pgactivity)      | check\_pgactivity is designed to monitor PostgreSQL clusters from Nagios. It offers many options to measure and monitor useful performance metrics.    | 177   | 2025-04-08  |
| [libzbxpgsql](https://github.com/cavaliercoder/libzbxpgsql)         | Comprehensive PostgreSQL monitoring module for Zabbix.                                                                                                 | 156   | 2023-11-14  |
| [Instrumental](https://github.com/Instrumental/instrumentald)       | Real-time performance monitoring, including for ease of setup (Commercial Software)                                                                    | 15    | 2018-09-17  |

## Extensions

| Name                                                             | Description                                                                                                                                                             | Stars | Last Commit |
|------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Citus](https://github.com/citusdata/citus)                      | Scalable PostgreSQL cluster for real-time workloads.                                                                                                                    | 11423 | 2025-06-01  |
| [ParadeDB](https://github.com/paradedb/paradedb)                 | Postgres for Search and Analytics                                                                                                                                       | 7137  | 2025-06-02  |
| [pg_lakehouse](https://github.com/paradedb/paradedb)             | pg_lakehouse is an extension that transforms Postgres into an analytical query engine over object stores like AWS S3/GCS and table formats like Delta Lake/Iceberg.     | 7137  | 2025-06-02  |
| [pg_search](https://github.com/paradedb/paradedb)                | pg_search is a PostgreSQL extension that enables full-text search over SQL tables using the BM25 algorithm, the state-of-the-art ranking function for full-text search. | 7137  | 2025-06-02  |
| [zomboDB](https://github.com/zombodb/zombodb)                    | Extension that enables efficient full-text searching via the use of indexes backed by Elasticsearch.                                                                    | 4737  | 2025-03-01  |
| [AGE](https://github.com/apache/age)                             | Adds fully-functional graph database support including Cypher queries.                                                                                                  | 3583  | 2025-05-18  |
| [pg_cron](https://github.com/citusdata/pg_cron)                  | Run periodic jobs in PostgreSQL.                                                                                                                                        | 3318  | 2025-05-07  |
| [pg\_partman](https://github.com/pgpartman/pg_partman)           | Partition management extension for PostgreSQL.                                                                                                                          | 2324  | 2025-03-14  |
| [cstore\_fdw](https://github.com/citusdata/cstore_fdw)           | Columnar store for analytics with PostgreSQL.                                                                                                                           | 1775  | 2021-03-08  |
| [HypoPG](https://github.com/HypoPG/hypopg)                       | HypoPG provides hypothetical/virtual indexes feature.                                                                                                                   | 1491  | 2025-06-01  |
| [pgRouting](https://github.com/pgRouting/pgrouting)              | pgRouting extends the PostGIS/PostgreSQL geospatial database to provide geospatial routing and other network analysis functionality.                                    | 1280  | 2025-05-31  |
| [pglogical](https://github.com/2ndQuadrant/pglogical)            | Extension that provides logical streaming replication.                                                                                                                  | 1115  | 2025-05-21  |
| [pg\_shard](https://github.com/citusdata/pg_shard)               | Extension to scale out real-time reads and writes.                                                                                                                      | 1061  | 2016-08-03  |
| [plpgsql\_check](https://github.com/okbob/plpgsql_check)         | Extension that allows to check plpgsql source code.                                                                                                                     | 687   | 2025-05-18  |
| [pg\_squeeze](https://github.com/cybertec-postgresql/pg_squeeze) | An extension for automatic bloat cleanup with minimal locking.                                                                                                          | 551   | 2025-04-22  |
| [pg_analytics](https://github.com/paradedb/pg_analytics)         | pg_analytics is an extension that accelerates analytical query processing inside Postgres to a performance level comparable to dedicated OLAP databases.                | 523   | 2025-03-19  |
| [pg\_stat\_monitor](https://github.com/percona/pg_stat_monitor)  | Query Performance Monitoring tool for PostgreSQL.                                                                                                                       | 508   | 2025-05-21  |
| [pgMemento](https://github.com/pgMemento/pgMemento)              | Provides an audit trail for your data inside a PostgreSQL database using triggers and server-side functions written in PL/pgSQL.                                        | 389   | 2025-03-11  |
| [pgcat](https://github.com/kingluo/pgcat)                        | Enhanced PostgreSQL logical replication                                                                                                                                 | 383   | 2024-09-26  |
| [pg\_paxos](https://github.com/citusdata/pg_paxos)               | Basic implementation of Paxos and Paxos-based table replication for a cluster of PostgreSQL nodes.                                                                      | 306   | 2022-09-16  |
| [PG\_Themis](https://github.com/cossacklabs/pg_themis)           | Postgres binding as extension for crypto library Themis, providing various security services on PgSQL's side.                                                           | 33    | 2016-12-12  |
| [pg\_barcode](https://github.com/btouchard/pg_barcode)           | PostgreSQL SVG QRcode &amp; Datamatrix generator.                                                                                                                       | 1     | 2025-01-09  |

## Work Queues

| Name                                              | Description                                                           | Stars | Last Commit |
|---------------------------------------------------|-----------------------------------------------------------------------|-------|-------------|
| [river](https://github.com/riverqueue/river)      | A high-performance job processing system for Go and Postgres.         | 4137  | 2025-05-30  |
| [pgmq](https://github.com/pgmq/pgmq)              | A lightweight message queue. Like AWS SQS and RSMQ but on Postgres.   | 3254  | 2025-05-25  |
| [BeanQueue](https://github.com/LaunchPlatform/bq) | A Python work queue framework based on SKIP LOCKED, LISTEN and NOTIFY | 18    | 2025-04-19  |

## Optimization

| Name                                                              | Description                                                                                                                      | Stars | Last Commit |
|-------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [PgHero](https://github.com/ankane/pghero)                        | PostgreSQL insights made easy.                                                                                                   | 8466  | 2025-06-02  |
| [PEV2](https://github.com/dalibo/pev2)                            | Online Postgres Explain Visualizer.                                                                                              | 2947  | 2025-05-27  |
| [pgtune](https://github.com/le0pard/pgtune)                       | Online version of PostgreSQL configuration wizard.                                                                               | 2410  | 2025-05-05  |
| [pg_flame](https://github.com/mgartner/pg_flame)                  | A flamegraph generator for query plans.                                                                                          | 1596  | 2020-01-13  |
| [pgtune](https://github.com/gregs1104/pgtune)                     | PostgreSQL configuration wizard.                                                                                                 | 1066  | 2021-08-17  |
| [TimescaleDB Tune](https://github.com/timescale/timescaledb-tune) | a program for tuning a TimescaleDB database to perform its best based on the host's resources such as memory and number of CPUs. | 469   | 2025-05-02  |
| [aqo](https://github.com/postgrespro/aqo)                         | Adaptive query optimization for PostgreSQL.                                                                                      | 463   | 2025-03-18  |
| [pg_web_stats](https://github.com/kirs/pg_web_stats)              | Web UI to view pg_stat_statements.                                                                                               | 94    | 2018-10-14  |
| [pgconfig.org](https://github.com/sebastianwebber/pgconfig)       | PostgreSQL Online Configuration Tool (also based on pgtune).                                                                     | 88    | 2020-08-20  |

## Utilities

| Name                                                                                    | Description                                                                                                                                                 | Stars | Last Commit |
|-----------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Hasura GraphQL Engine](https://github.com/hasura/graphql-engine)                       | Blazing fast, instant realtime GraphQL APIs on Postgres with fine grained access control, also trigger webhooks on database events.                         | 31546 | 2025-05-28  |
| [PostgREST](https://github.com/PostgREST/postgrest)                                     | Serves a fully RESTful API from any existing PostgreSQL database.                                                                                           | 25346 | 2025-06-01  |
| [PostGraphile](https://github.com/graphile/postgraphile)                                | Instant GraphQL API or GraphQL schema for your PostgreSQL database                                                                                          | 12735 | 2025-06-01  |
| [pgloader](https://github.com/dimitri/pgloader)                                         | Loads data into PostgreSQL using the COPY streaming protocol, and does so with separate threads for reading and writing data.                               | 5809  | 2025-05-24  |
| [pgroll](https://github.com/xataio/pgroll)                                              | Zero-downtime, reversible, schema migrations for Postgres                                                                                                   | 5023  | 2025-05-31  |
| [pREST](https://github.com/prest/prest)                                                 | Serve a RESTful API from any PostgreSQL database (Golang)                                                                                                   | 4356  | 2025-04-29  |
| [pgbadger](https://github.com/darold/pgbadger)                                          | Fast PostgreSQL Log Analyzer.                                                                                                                               | 3736  | 2025-03-29  |
| [pgsync](https://github.com/ankane/pgsync)                                              | Tool to sync PostgreSQL data to your local machine.                                                                                                         | 3316  | 2025-04-20  |
| [migra](https://github.com/djrobstep/migra)                                             | Like diff but for Postgres schemas.                                                                                                                         | 3006  | 2024-05-31  |
| [sqitch](https://github.com/sqitchers/sqitch)                                           | Tool for managing versioned schema deployment                                                                                                               | 2987  | 2025-05-19  |
| [pg\_activity](https://github.com/dalibo/pg_activity)                                   | top like application for PostgreSQL server activity monitoring.                                                                                             | 2596  | 2025-04-15  |
| [sqlcheck](https://github.com/jarulraj/sqlcheck)                                        | Automatically detects common SQL anti-patterns. Such anti-patterns often slow down queries. Addressing them will, therefore, help accelerate queries.       | 2477  | 2024-02-21  |
| [pgCenter](https://github.com/lesovsky/pgcenter)                                        | Provides convenient interface to various statistics, management task, reloading services, viewing log files and canceling or terminating database backends. | 1573  | 2024-12-11  |
| [yoke](https://github.com/nanopack/yoke)                                                | PostgreSQL high-availability cluster with auto-failover and automated cluster recovery.                                                                     | 1345  | 2016-01-07  |
| [pgfutter](https://github.com/lukasmartinelli/pgfutter)                                 | Import CSV and JSON into PostgreSQL the easy way.                                                                                                           | 1337  | 2020-09-02  |
| [mysql-postgresql-converter](https://github.com/lanyrd/mysql-postgresql-converter)      | Lanyrd's MySQL to PostgreSQL conversion script.                                                                                                             | 1296  | 2022-09-16  |
| [ERAlchemy](https://github.com/Alexis-benoist/eralchemy)                                | ERAlchemy generates Entity Relation (ER) diagram from databases.                                                                                            | 1236  | 2025-04-30  |
| [pg_timetable](https://github.com/cybertec-postgresql/pg_timetable)                     | Advanced job scheduler for PostgreSQL.                                                                                                                      | 1183  | 2025-05-05  |
| [pgMonitor](https://github.com/CrunchyData/pgmonitor)                                   | Postgres metrics collection and visualization that can be deployed to bare metal, virtual machines, or Kubernetes.                                          | 650   | 2025-05-28  |
| [pgmigrate](https://github.com/yandex/pgmigrate)                                        | CLI tool to evolve schema migrations, developed by Yandex.                                                                                                  | 648   | 2025-01-02  |
| [postgresql-metrics](https://github.com/spotify/postgresql-metrics)                     | Tool that extracts and provides metrics for your PostgreSQL database.                                                                                       | 595   | 2023-05-29  |
| [planter](https://github.com/achiku/planter)                                            | Generate PlantUML ER diagram textual description from PostgreSQL tables                                                                                     | 553   | 2024-03-30  |
| [ZSON](https://github.com/postgrespro/zson)                                             | PostgreSQL extension for transparent JSONB compression                                                                                                      | 552   | 2023-04-14  |
| [Pyrseas](https://github.com/perseas/Pyrseas)                                           | Postgres database schema versioning.                                                                                                                        | 403   | 2024-07-10  |
| [pg_chameleon](https://github.com/the4thdoctor/pg_chameleon)                            | Real time replica from MySQL to PostgreSQL with optional type override migration and migration capabilities.                                                | 401   | 2025-01-21  |
| [pgclimb](https://github.com/lukasmartinelli/pgclimb)                                   | Export data from PostgreSQL into different data formats.                                                                                                    | 391   | 2020-06-18  |
| [bemi](https://github.com/BemiHQ/bemi)                                                  | Automatic data change tracking for PostgreSQL                                                                                                               | 351   | 2025-05-26  |
| [pg_insights](https://github.com/lob/pg_insights)                                       | Convenient SQL for monitoring Postgres database health.                                                                                                     | 303   | 2019-12-11  |
| [RegreSQL](https://github.com/dimitri/regresql)                                         | Tool to build, maintain and execute a regression testing suite for SQL queries.                                                                             | 284   | 2024-09-04  |
| [GatewayD](https://github.com/gatewayd-io/gatewayd)                                     | Cloud-native database gateway and framework for building data-driven applications. Like API gateways, for databases.                                        | 259   | 2025-05-26  |
| [ldap2pg](https://github.com/dalibo/ldap2pg)                                            | Synchronize roles and privileges from YML and LDAP.                                                                                                         | 217   | 2025-05-30  |
| [PGXN client](https://github.com/pgxn/pgxnclient)                                       | Command line tool to interact with the PostgreSQL Extension Network                                                                                         | 149   | 2024-06-14  |
| [pgspot](https://github.com/timescale/pgspot)                                           | Spot vulnerabilities in PostgreSQL extension scripts.                                                                                                       | 107   | 2025-06-01  |
| [pg-formatter](https://github.com/gajus/pg-formatter)                                   | A PostgreSQL SQL syntax beautifier (Node.js).                                                                                                               | 81    | 2025-03-28  |
| [pg-spot-operator](https://github.com/pg-spot-ops/pg-spot-operator)                     | A daemon to run stateful Postgres on cheap AWS Spot VMs                                                                                                     | 56    | 2025-05-16  |
| [pgcmp](https://github.com/cbbrowne/pgcmp)                                              | Tool to compare database schemas, with capability to accept some persistent differences                                                                     | 45    | 2024-05-15  |
| [NServiceBus.Transport.PostgreSql](https://github.com/Particular/NServiceBus.SqlServer) | The NServiceBus.Transport.PostgreSql library allows .NET developers to . (Commerical Software)                                                              | 43    | 2025-05-21  |
| [pg-differ](https://github.com/multum/pg-differ)                                        | Tool for easy initialization / updating of the structure of PostgreSQL tables, migration alternative (Node.js).                                             | 38    | 2021-04-29  |
| [pg_migrate](https://github.com/jwdeitch/pg_migrate)                                    | Manage PostgreSQL codebases and make VCS simple.                                                                                                            | 32    | 2017-10-11  |
| [pglistend](https://github.com/kabirbaidhya/pglistend)                                  | A lightweight PostgresSQL `LISTEN`/`NOTIFY` daemon built on top of `node-postgres`.                                                                         | 29    | 2017-03-29  |
| [pg_docs_bot](https://github.com/mchristofides/pg_docs_bot)                             | Browser extension to redirect PostgreSQL docs links to the current version.                                                                                 | 18    | 2025-04-04  |

## Kubernetes

| Name                                                                       | Description                                                                                                                                              | Stars | Last Commit |
|----------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [CloudNativePG operator](https://github.com/cloudnative-pg/cloudnative-pg) | A comprehensive platform designed to seamlessly manage PostgreSQL databases within Kubernetes environments.                                              | 6066  | 2025-06-02  |
| [Zalando Operator](https://github.com/zalando/postgres-operator)           | Creates and manages PostgreSQL clusters running in Kubernetes.                                                                                           | 4710  | 2025-05-20  |
| [Crunchy Operator](https://github.com/CrunchyData/postgres-operator)       | Production PostgreSQL for Kubernetes, from high availability Postgres clusters to full-scale database-as-a-service.                                      | 4128  | 2025-05-29  |
| [Kubegres Operator](https://github.com/reactive-tech/kubegres)             | Kubegres is a Kubernetes operator allowing to deploy one or many clusters of PostgreSql instances and manage databases replication, failover and backup. | 1332  | 2025-01-04  |
| [StackGres Operator](https://github.com/ongres/stackgres)                  | Full Stack PostgreSQL on Kubernetes.                                                                                                                     | 1206  | 2025-05-29  |

## Tutorials

| Name                                                                 | Description                             | Stars | Last Commit |
|----------------------------------------------------------------------|-----------------------------------------|-------|-------------|
| [pg-utils](https://github.com/dataegret/pg-utils)                    | Useful DBA tools by Data Egret          | 1129  | 2025-01-09  |
| [postgresDBSamples](https://github.com/morenoh149/postgresDBSamples) | A collection of sample postgres schemas | 527   | 2023-09-20  |
| [pagila](https://github.com/xzilla/pagila)                           | Pagila, Postgres Sample Database        | 62    | 2025-06-01  |

## Blogs

| Name                                                                                       | Description | Stars | Last Commit |
|--------------------------------------------------------------------------------------------|-------------|-------|-------------|
| [Digoal's PostgreSQL and Technical blog(Chinese Language)](https://github.com/digoal/blog) |             | 8249  | 2025-06-09  |
