# awesome-db-tools

Everything that makes working with databases easier

**Source:** [mgramin/awesome-db-tools](https://github.com/mgramin/awesome-db-tools)

## Table of Contents

- [Top 10](#top-10)
- [API](#api)
- [Application platforms](#application-platforms)
- [Backup](#backup)
- [CLI](#cli)
- [Cloning](#cloning)
- [Configuration Tuning](#configuration-tuning)
- [Data](#data)
- [Distributions](#distributions)
- [GUI](#gui)
- [HA/Failover/Sharding](#hafailoversharding)
- [IDE](#ide)
- [Kubernetes](#kubernetes)
- [Machine Learning](#machine-learning)
- [Monitoring/Statistics/Perfomance](#monitoringstatisticsperfomance)
- [Papers](#papers)
- [Reporting](#reporting)
- [SQL](#sql)
- [Schema](#schema)
- [Security](#security)
- [Testing](#testing)

## Top 10

| Name                                                                                   | Category              | Stars | 30d | Last Commit |
|----------------------------------------------------------------------------------------|-----------------------|-------|-----|-------------|
| [DBeaver](https://github.com/dbeaver/dbeaver)                                          | IDE                   | 48648 |     | 2026-02-11  |
| [Appsmith](https://github.com/appsmithorg/appsmith)                                    | Application platforms | 39083 |     | 2026-02-12  |
| [MindsDB](https://github.com/mindsdb/mindsdb)                                          | Machine Learning      | 38445 |     | 2026-02-12  |
| [Tooljet](https://github.com/ToolJet/ToolJet)                                          | Application platforms | 37422 |     | 2026-02-11  |
| [DrawDB](https://github.com/drawdb-io/drawdb)                                          | Schema                | 36565 |     | 2026-02-11  |
| [Another Redis Desktop Manager](https://github.com/qishibo/AnotherRedisDesktopManager) | GUI                   | 33912 |     | 2025-10-16  |
| [Hasura GraphQL Engine](https://github.com/hasura/graphql-engine)                      | API                   | 31899 |     | 2026-02-11  |
| [Budibase](https://github.com/Budibase/budibase)                                       | Application platforms | 27642 |     | 2026-02-11  |
| [PostgREST](https://github.com/PostgREST/postgrest)                                    | API                   | 26507 |     | 2026-02-08  |
| [osquery](https://github.com/osquery/osquery)                                          | SQL                   | 23100 |     | 2026-02-11  |

[Back to Top](#table-of-contents)

## API

| Name                                                                 | Description                                                                                                                                                                                                                      | Stars | 30d | Last Commit |
|----------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-----|-------------|
| [Hasura GraphQL Engine](https://github.com/hasura/graphql-engine)    | Blazing fast, instant realtime GraphQL APIs on all your data with fine grained access control, also trigger webhooks on database events.                                                                                         | 31899 |     | 2026-02-11  |
| [PostgREST](https://github.com/PostgREST/postgrest)                  | REST API for any Postgres database                                                                                                                                                                                               | 26507 |     | 2026-02-08  |
| [Datasette](https://github.com/simonw/datasette)                     | An open source multi-tool for exploring and publishing data                                                                                                                                                                      | 10747 |     | 2026-02-11  |
| [prest](https://github.com/prest/prest)                              | PostgreSQL ➕ REST, low-code, simplify and accelerate development, ⚡ instant, realtime, high-performance on any Postgres application, existing or new                                                                           | 4519  |     | 2026-02-11  |
| [Remult](https://github.com/remult/remult)                           | Full-stack CRUD, simplified, with SSOT TypeScript entities                                                                                                                                                                       | 3199  |     | 2026-02-03  |
| [sandman2](https://github.com/jeffknupp/sandman2)                    | Automatically generate a RESTful API service for your legacy database. No code required!                                                                                                                                         | 2044  |     | 2026-02-09  |
| [DreamFactory](https://github.com/dreamfactorysoftware/dreamfactory) | DreamFactory is a secure, self-hosted enterprise data access platform that provides governed API access to any data source, connecting enterprise applications and on-prem LLMs with role-based access and identity passthrough. | 1735  |     | 2026-02-11  |
| [soul](https://github.com/thevahidal/soul)                           | 🕉 Soul | Automatic SQLite RESTful  and realtime API server | Build CRUD APIs in minutes!                                                                                                                                         | 1676  |     | 2025-11-30  |
| [VulcanSQL](https://github.com/Canner/vulcan-sql)                    | Data API Framework for AI Agents and Data Apps                                                                                                                                                                                   | 785   |     | 2024-07-01  |
| [Graphweaver](https://github.com/exogee-technology/graphweaver)      | Turn multiple data sources into a single GraphQL API                                                                                                                                                                             | 546   |     | 2026-02-12  |
| [restSQL](https://github.com/restsql/restsql)                        | restSQL service and core framework                                                                                                                                                                                               | 146   |     | 2019-01-12  |
| [resquel](https://github.com/formio/resquel)                         | Easily convert your SQL database into a REST API using Express.js                                                                                                                                                                | 128   |     | 2024-09-06  |

[Back to Top](#table-of-contents)

## Application platforms

| Name                                                    | Description                                                                                                                                                                                                                                                                                                                     | Stars | 30d | Last Commit |
|---------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-----|-------------|
| [Appsmith](https://github.com/appsmithorg/appsmith)     | Platform to build admin panels, internal tools, and dashboards. Integrates with 25+ databases and any API.                                                                                                                                                                                                                      | 39083 |     | 2026-02-12  |
| [Tooljet](https://github.com/ToolJet/ToolJet)           | ToolJet is the open-source foundation of ToolJet AI - the AI-native platform for building internal tools, dashboard, business applications, workflows and AI agents 🚀                                                                                                                                                          | 37422 |     | 2026-02-11  |
| [Budibase](https://github.com/Budibase/budibase)        | Create business apps and automate workflows in minutes. Supports PostgreSQL, MySQL, MariaDB, MSSQL, MongoDB, Rest API, Docker, K8s, and more 🚀 No code / Low code platform..                                                                                                                                                   | 27642 |     | 2026-02-11  |
| [ILLA Cloud](https://github.com/illacloud/illa-builder) | Low-code platform allows you to build business apps, enables you to quickly create internal tools such as dashboard, crud app, admin panel, crm, cms, etc. Supports PostgreSQL, MySQL, Supabase, GraphQL, MongoDB, MSSQL, Rest API, Hugging Face, Redis, etc. Automate workflows with schedule or webhook. Open source Retool.  | 12369 |     | 2026-02-11  |
| [Nhost](https://github.com/nhost/nhost)                 | The Open Source Firebase Alternative with GraphQL.                                                                                                                                                                                                                                                                              | 9078  |     | 2026-02-12  |
| [SQLPage](https://github.com/sqlpage/SQLPage)           | Fast SQL-only data application builder. Automatically build a UI on top of SQL queries.                                                                                                                                                                                                                                         | 2437  |     | 2026-02-07  |
| [Saltcorn](https://github.com/saltcorn/saltcorn)        | Free and open source no-code application builder                                                                                                                                                                                                                                                                                | 1991  |     | 2026-02-11  |

[Back to Top](#table-of-contents)

## Backup

| Name                                                        | Description                                                                                                     | Stars | 30d | Last Commit |
|-------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------|-------|-----|-------------|
| [Databasus](https://github.com/databasus/databasus)         | Databases backup tool (PostgreSQL, MySQL, MongoDB)                                                              | 5495  |     | 2026-02-10  |
| [pgbackrest](https://github.com/pgbackrest/pgbackrest)      | Reliable PostgreSQL Backup & Restore                                                                            | 3594  |     | 2026-02-10  |
| [pgcopydb](https://github.com/dimitri/pgcopydb)             | Copy a Postgres database to a target Postgres server (pg_dump | pg_restore on steroids)                         | 1406  |     | 2025-04-28  |
| [pg_probackup](https://github.com/postgrespro/pg_probackup) | Backup and recovery manager for PostgreSQL                                                                      | 779   |     | 2025-12-09  |
| [Portabase](https://github.com/Portabase/portabase)         | Portabase - Database backup & restore tool for PostgreSQL, MySQL/MariaDB, MongoDB (more engines coming soon 🚀) | 322   |     | 2026-02-11  |

[Back to Top](#table-of-contents)

## CLI

| Name                                                          | Description                                                                                                                                                                                                                                                                                     | Stars | 30d | Last Commit |
|---------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-----|-------------|
| [pgcli](https://github.com/dbcli/pgcli)                       | Postgres CLI with autocompletion and syntax highlighting                                                                                                                                                                                                                                        | 13019 |     | 2026-01-17  |
| [mycli](https://github.com/dbcli/mycli)                       | A Terminal Client for MySQL with AutoCompletion and Syntax Highlighting.                                                                                                                                                                                                                        | 11869 |     | 2026-02-11  |
| [usql](https://github.com/xo/usql)                            | Universal command-line interface for SQL databases                                                                                                                                                                                                                                              | 9807  |     | 2026-01-11  |
| [litecli](https://github.com/dbcli/litecli)                   | CLI for SQLite Databases with auto-completion and syntax highlighting                                                                                                                                                                                                                           | 3184  |     | 2026-01-31  |
| [iredis](https://github.com/laixintao/iredis)                 | Interactive Redis: A Terminal Client for Redis with AutoCompletion and Syntax Highlighting.                                                                                                                                                                                                     | 2723  |     | 2026-02-05  |
| [pspg](https://github.com/okbob/pspg)                         | Unix pager (with very rich functionality) designed for work with tables. Designed for PostgreSQL, but MySQL is supported too. Works well with pgcli too. Can be used as CSV or TSV viewer too. It supports searching, selecting rows, columns, or block and export selected area to clipboard.  | 2687  |     | 2026-01-23  |
| [sqlite-utils](https://github.com/simonw/sqlite-utils)        | Python CLI utility and library for manipulating SQLite databases                                                                                                                                                                                                                                | 2003  |     | 2026-01-21  |
| [ipython-sql](https://github.com/catherinedevlin/ipython-sql) | %%sql magic for IPython, hopefully evolving into full SQL client                                                                                                                                                                                                                                | 1802  |     | 2024-07-12  |
| [pgcenter](https://github.com/lesovsky/pgcenter)              | Command-line admin tool for observing and troubleshooting Postgres.                                                                                                                                                                                                                             | 1590  |     | 2026-01-06  |
| [mssql-cli](https://github.com/dbcli/mssql-cli)               | A command-line client for SQL Server with auto-completion and syntax highlighting                                                                                                                                                                                                               | 1410  |     | 2024-02-26  |
| [SQLLine](https://github.com/julianhyde/sqlline)              | Shell for issuing SQL to relational databases via JDBC                                                                                                                                                                                                                                          | 648   |     | 2023-07-07  |
| [athenacli](https://github.com/dbcli/athenacli)               | AthenaCLI is a CLI tool for AWS Athena service that can do auto-completion and syntax highlighting.                                                                                                                                                                                             | 226   |     | 2025-12-12  |
| [pg_top](https://github.com/markwkm/pg_top)                   | Mirror of https://gitlab.com/pg_top/pg_top                                                                                                                                                                                                                                                      | 119   |     | 2024-06-06  |
| [vcli](https://github.com/dbcli/vcli)                         | Vertica CLI with auto-completion and syntax highlighting                                                                                                                                                                                                                                        | 80    |     | 2017-03-15  |

[Back to Top](#table-of-contents)

## Cloning

| Name                                                           | Description                                                                                                                                                                                                                                     | Stars | 30d | Last Commit |
|----------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-----|-------------|
| [clone_schema](https://github.com/denishpatel/pg-clone-schema) | Postgres clone schema utility without need of going outside of database. Makes developers life easy by running single function to clone schema with all objects. It is very handy on Postgres RDS. Utility is sponsored by http://elephas.io/   | 200   |     | 2025-12-17  |

[Back to Top](#table-of-contents)

## Configuration Tuning

| Name                                                           | Description                                                                                                                                                 | Stars | 30d | Last Commit |
|----------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-----|-------------|
| [MySQLTuner-perl](https://github.com/major/MySQLTuner-perl)    | MySQLTuner is a script written in Perl that will assist you with your MySQL configuration and make recommendations for increased performance and stability. | 9432  |     | 2026-01-18  |
| [postgresqltuner.pl](https://github.com/jfcoz/postgresqltuner) | Simple script to analyse your PostgreSQL database configuration, and give tuning advice                                                                     | 2684  |     | 2024-01-08  |
| [pgtune](https://github.com/gregs1104/pgtune)                  | PostgreSQL configuration wizard                                                                                                                             | 1081  |     | 2021-08-17  |

[Back to Top](#table-of-contents)

## Data

| Name                                                                   | Description                                                                                                                                                                                                                                                                          | Stars | 30d | Last Commit |
|------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-----|-------------|
| [Faker](https://github.com/faker-js/faker)                             | Generate massive amounts of fake data in the browser and node.js                                                                                                                                                                                                                     | 14863 |     | 2026-02-11  |
| [YData Profiling](https://github.com/ydataai/ydata-profiling)          | 1 Line of code data quality profiling & exploratory data analysis for Pandas and Spark DataFrames.                                                                                                                                                                                   | 13376 |     | 2026-02-02  |
| [Litestream](https://github.com/benbjohnson/litestream)                | Streaming replication for SQLite.                                                                                                                                                                                                                                                    | 13184 |     | 2026-02-12  |
| [dbt](https://github.com/dbt-labs/dbt-core)                            | dbt enables data analysts and engineers to transform their data using the same practices that software engineers use to build applications.                                                                                                                                          | 12235 |     | 2026-02-12  |
| [DataHub](https://github.com/datahub-project/datahub)                  | The Metadata Platform for your Data and AI Stack                                                                                                                                                                                                                                     | 11570 |     | 2026-02-12  |
| [Amundsen](https://github.com/amundsen-io/amundsen)                    | Amundsen is a metadata driven application for improving the productivity of data analysts, data scientists and engineers when interacting with data.                                                                                                                                 | 4737  |     | 2026-02-09  |
| [pgsync](https://github.com/ankane/pgsync)                             | Sync data from one Postgres database to another                                                                                                                                                                                                                                      | 3428  |     | 2025-12-26  |
| [data-diff](https://github.com/datafold/data-diff)                     | Compare tables within or across databases                                                                                                                                                                                                                                            | 2990  |     | 2024-05-17  |
| [Marquez](https://github.com/MarquezProject/marquez)                   | Collect, aggregate, and visualize a data ecosystem's metadata                                                                                                                                                                                                                        | 2119  |     | 2026-02-11  |
| [Data Profiler](https://github.com/capitalone/dataprofiler)            | What's in your data? Extract schema, statistics and entities from datasets                                                                                                                                                                                                           | 1542  |     | 2025-09-26  |
| [Noisia](https://github.com/lesovsky/noisia)                           | Harmful workload generator for PostgreSQL                                                                                                                                                                                                                                            | 699   |     | 2023-11-06  |
| [dtle](https://github.com/actiontech/dtle)                             | Distributed Data Transfer Service for MySQL                                                                                                                                                                                                                                          | 560   |     | 2023-12-12  |
| [Desbordante](https://github.com/desbordante/desbordante-core)         | Desbordante is a high-performance data profiler that is capable of discovering many different patterns in data using various algorithms. It also allows to run data cleaning scenarios using these algorithms. Desbordante has a console version and an easy-to-use web application. | 466   |     | 2026-02-07  |
| [pg_chameleon](https://github.com/the4thdoctor/pg_chameleon)           | MySQL to PostgreSQL replica system                                                                                                                                                                                                                                                   | 428   |     | 2025-01-21  |
| [PGDeltaStream](https://github.com/hasura/pgdeltastream)               | Streaming Postgres logical replication changes atleast-once over websockets                                                                                                                                                                                                          | 259   |     | 2018-06-13  |
| [Benerator](https://github.com/rapiddweller/rapiddweller-benerator-ce) | BENERATOR is a leading software solution to generate, obfuscate, pseudonymize and migrate data for development, testing, and training purposes with a model-driven approach.                                                                                                         | 157   |     | 2026-01-17  |
| [quick-seed](https://github.com/miit-daga/quick-seed)                  | A powerful, database-agnostic seeding tool for generating realistic development data.                                                                                                                                                                                                | 25    |     | 2026-02-02  |

[Back to Top](#table-of-contents)

## Distributions

| Name                                                       | Description                                                      | Stars | 30d | Last Commit |
|------------------------------------------------------------|------------------------------------------------------------------|-------|-----|-------------|
| [Postgres.app](https://github.com/PostgresApp/PostgresApp) | The easiest way to get started with PostgreSQL on the Mac        | 7691  |     | 2026-02-11  |
| [DBdeployer](https://github.com/datacharmer/dbdeployer)    | DBdeployer is a tool that deploys MySQL database servers easily. | 716   |     | 2023-10-29  |
| [Elephant Shed](https://github.com/credativ/elephant-shed) | PostgreSQL Management Appliance                                  | 228   |     | 2026-01-26  |

[Back to Top](#table-of-contents)

## GUI

| Name                                                                                   | Description                                                                                                                                                                                                                                                                                                                                                | Stars | 30d | Last Commit |
|----------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-----|-------------|
| [Another Redis Desktop Manager](https://github.com/qishibo/AnotherRedisDesktopManager) | 🚀🚀🚀A faster, better and more stable Redis desktop manager [GUI client], compatible with Linux, Windows, Mac.                                                                                                                                                                                                                                            | 33912 |     | 2025-10-16  |
| [Beekeeper Studio](https://github.com/beekeeper-studio/beekeeper-studio)               | Modern and easy to use SQL client for MySQL, Postgres, SQLite, SQL Server, and more. Linux, MacOS, and Windows.                                                                                                                                                                                                                                            | 21985 |     | 2026-02-11  |
| [Robo 3T](https://github.com/Studio3T/robomongo)                                       | Native cross-platform MongoDB management tool                                                                                                                                                                                                                                                                                                              | 9370  |     | 2022-09-22  |
| [Pgweb](https://github.com/sosedoff/pgweb)                                             | Cross-platform client for PostgreSQL databases                                                                                                                                                                                                                                                                                                             | 9252  |     | 2026-02-01  |
| [Sequel Pro](https://github.com/sequelpro/sequelpro)                                   | MySQL/MariaDB database management for macOS                                                                                                                                                                                                                                                                                                                | 9201  |     | 2023-02-25  |
| [phpMyAdmin](https://github.com/phpmyadmin/phpmyadmin)                                 | A web interface for MySQL and MariaDB                                                                                                                                                                                                                                                                                                                      | 7792  |     | 2026-02-11  |
| [Azure Data Studio](https://github.com/microsoft/azuredatastudio)                      | Azure Data Studio is a data management and development tool with connectivity to popular cloud and on-premises databases. Azure Data Studio supports Windows, macOS, and Linux, with immediate capability to connect to Azure SQL and SQL Server. Browse the extension library for more database support options including MySQL, PostgreSQL, and MongoDB. | 7716  |     | 2026-02-11  |
| [Sequel Ace](https://github.com/Sequel-Ace/Sequel-Ace)                                 | MySQL/MariaDB database management for macOS                                                                                                                                                                                                                                                                                                                | 7294  |     | 2026-02-09  |
| [Adminer](https://github.com/vrana/adminer)                                            | Database management in a single PHP file                                                                                                                                                                                                                                                                                                                   | 7260  |     | 2026-02-08  |
| [DbGate](https://github.com/dbgate/dbgate)                                             | Database manager for MySQL, PostgreSQL, SQL Server, MongoDB, SQLite and others. Runs under Windows, Linux, Mac or as web application                                                                                                                                                                                                                       | 6755  |     | 2026-02-10  |
| [Clidey WhoDB](https://github.com/clidey/whodb)                                        | A lightweight next-gen data explorer - Postgres, MySQL, SQLite, MongoDB, Redis, MariaDB, Elastic Search, and Clickhouse with Chat interface                                                                                                                                                                                                                | 4556  |     | 2026-02-11  |
| [TablePlus](https://github.com/TablePlus/TablePlus)                                    |  TablePlus macOS issue tracker                                                                                                                                                                                                                                                                                                                             | 3720  |     | 2024-03-15  |
| [OmniDB](https://github.com/OmniDB/OmniDB)                                             | Web tool for database management                                                                                                                                                                                                                                                                                                                           | 3276  |     | 2023-02-01  |
| [Jailer](https://github.com/Wisser/Jailer)                                             | Database Subsetting and Relational Data Browsing Tool.                                                                                                                                                                                                                                                                                                     | 3127  |     | 2026-02-08  |
| [Antares SQL](https://github.com/antares-sql/antares)                                  | A modern, fast and productivity driven SQL client with a focus in UX                                                                                                                                                                                                                                                                                       | 2548  |     | 2025-10-14  |
| [Tabix](https://github.com/tabixio/tabix)                                              | Tabix.io UI                                                                                                                                                                                                                                                                                                                                                | 2282  |     | 2023-01-15  |
| [SQLTools](https://github.com/mtxr/vscode-sqltools)                                    | Database management for VSCode                                                                                                                                                                                                                                                                                                                             | 1719  |     | 2026-02-09  |
| [DB Lens](https://github.com/dblens/app)                                               | Database explorer for Mac, Windows & Linux                                                                                                                                                                                                                                                                                                                 | 274   |     | 2025-08-07  |
| [Malewicz](https://github.com/mgramin/malewicz)                                        | Suprematistic hackable GUI SQL-manager written in SQL itself                                                                                                                                                                                                                                                                                               | 66    |     | 2025-01-04  |
| [ocelotgui](https://github.com/ocelot-inc/ocelotgui)                                   | GUI client for MySQL or MariaDB, including debugger                                                                                                                                                                                                                                                                                                        | 63    |     | 2025-11-06  |

[Back to Top](#table-of-contents)

## HA/Failover/Sharding

| Name                                                                        | Description                                                                                                     | Stars | 30d | Last Commit |
|-----------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------|-------|-----|-------------|
| [Vitess](https://github.com/vitessio/vitess)                                | Vitess is a database clustering system for horizontal scaling of MySQL.                                         | 20689 |     | 2026-02-12  |
| [ShardingSphere](https://github.com/apache/shardingsphere)                  | Empowering Data Intelligence with Distributed SQL for Sharding, Scalability, and Security Across All Databases. | 20674 |     | 2026-02-11  |
| [Citus](https://github.com/citusdata/citus)                                 | Distributed PostgreSQL as an extension                                                                          | 12282 |     | 2026-02-11  |
| [stolon](https://github.com/sorintlab/stolon)                               | PostgreSQL cloud native High Availability and more.                                                             | 4807  |     | 2024-07-08  |
| [autobase](https://github.com/vitabaks/autobase)                            | Automated database platform for PostgreSQL® - Your own DBaaS.                                                   | 3916  |     | 2026-02-09  |
| [pgslice](https://github.com/ankane/pgslice)                                | Postgres partitioning as easy as pie                                                                            | 1234  |     | 2026-01-06  |
| [Percona XtraDB Cluster](https://github.com/percona/percona-xtradb-cluster) | A High Scalability Solution for MySQL Clustering and High Availability                                          | 376   |     | 2026-02-03  |
| [PostgreSQL Automatic Failover](https://github.com/ClusterLabs/PAF)         | PostgreSQL Automatic Failover: High-Availibility for Postgres, based on Pacemaker and Corosync.                 | 346   |     | 2024-06-13  |

[Back to Top](#table-of-contents)

## IDE

| Name                                                         | Description                                                                                                                                                                                                                                                                                      | Stars | 30d | Last Commit |
|--------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-----|-------------|
| [DBeaver](https://github.com/dbeaver/dbeaver)                | Free universal database tool and SQL client                                                                                                                                                                                                                                                      | 48648 |     | 2026-02-11  |
| [HeidiSQL](https://github.com/HeidiSQL/HeidiSQL)             | A lightweight client for managing MariaDB, MySQL, SQL Server, PostgreSQL, SQLite, Interbase and Firebird, written in Delphi and Lazarus/FreePascal                                                                                                                                               | 5796  |     | 2026-02-11  |
| [DataStation](https://github.com/multiprocessio/datastation) | App to easily query, script, and visualize data from every database, file, and API.                                                                                                                                                                                                              | 2959  |     | 2023-11-10  |
| [Querybook](https://github.com/pinterest/querybook)          | Querybook is a Big Data Querying UI, combining collocated table metadata and a simple notebook interface.                                                                                                                                                                                        | 2230  |     | 2026-02-10  |
| [dbKoda](https://github.com/SouthbankSoftware/dbkoda)        | State of the art MongoDB IDE                                                                                                                                                                                                                                                                     | 855   |     | 2022-12-20  |
| [Kangaroo](https://github.com/dbkangaroo/kangaroo)           | Kangaroo is an AI-powered SQL client and admin tool for popular databases (MariaDB / MySQL / Oracle / PostgreSQL / Redis / SQLite / SQL Server / ...) on Windows / MacOS / Linux, support table design, query, model, sync, export/import etc, focus on comfortable, fun and developer friendly. | 463   |     | 2026-02-09  |
| [TOra](https://github.com/tora-tool/tora)                    | TOra is an open source SQL IDE for Oracle, MySQL and PostgreSQL dbs                                                                                                                                                                                                                              | 294   |     | 2024-03-03  |

[Back to Top](#table-of-contents)

## Kubernetes

| Name                                                                | Description                                                                     | Stars | 30d | Last Commit |
|---------------------------------------------------------------------|---------------------------------------------------------------------------------|-------|-----|-------------|
| [PostgreSQL operator](https://github.com/zalando/postgres-operator) | Postgres operator creates and manages PostgreSQL clusters running in Kubernetes | 5080  |     | 2026-02-06  |
| [Spilo](https://github.com/zalando/spilo)                           | Highly available elephant herd: HA PostgreSQL cluster using Docker              | 1786  |     | 2026-02-06  |

[Back to Top](#table-of-contents)

## Machine Learning

| Name                                                       | Description                                                          | Stars | 30d | Last Commit |
|------------------------------------------------------------|----------------------------------------------------------------------|-------|-----|-------------|
| [MindsDB](https://github.com/mindsdb/mindsdb)              | Federated Query Engine for AI - The only MCP Server you'll ever need | 38445 |     | 2026-02-12  |
| [SQLFlow](https://github.com/sql-machine-learning/sqlflow) | Brings SQL and AI together.                                          | 5190  |     | 2024-04-18  |

[Back to Top](#table-of-contents)

## Monitoring/Statistics/Perfomance

| Name                                                                | Description                                                                                                                                              | Stars | 30d | Last Commit |
|---------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-----|-------------|
| [PgHero](https://github.com/ankane/pghero)                          | A performance dashboard for Postgres                                                                                                                     | 8785  |     | 2025-12-26  |
| [pgwatch2](https://github.com/cybertec-postgresql/pgwatch2)         | PostgreSQL metrics monitor/dashboard                                                                                                                     | 1845  |     | 2024-12-17  |
| [Promscale](https://github.com/timescale/promscale)                 | [DEPRECATED] Promscale is a unified metric and trace observability backend for Prometheus, Jaeger and OpenTelemetry built on PostgreSQL and TimescaleDB. | 1318  |     | 2024-03-28  |
| [pgmetrics](https://github.com/rapidloop/pgmetrics)                 | Collect and display information and stats from a running PostgreSQL server                                                                               | 1072  |     | 2026-01-18  |
| [Percona Monitoring and Management](https://github.com/percona/pmm) | Percona Monitoring and Management: an open source database monitoring, observability and management tool                                                 | 965   |     | 2026-02-11  |
| [pgMonitor](https://github.com/CrunchyData/pgmonitor)               | PostgreSQL Monitoring, Metrics Collection and Alerting Resources from Crunchy Data                                                                       | 695   |     | 2026-02-05  |
| [PostgreSQL Metrics](https://github.com/spotify/postgresql-metrics) | Tool that extracts and provides metrics on your PostgreSQL database                                                                                      | 598   |     | 2023-05-29  |
| [pganalyze collector](https://github.com/pganalyze/collector)       | pganalyze statistics collector for gathering PostgreSQL metrics and log data                                                                             | 386   |     | 2026-02-09  |
| [ASH Viewer](https://github.com/akardapolov/ASH-Viewer)             | ASH Viewer provides a graphical view of active session history data within the Oracle and PostgreSQL DB                                                  | 199   |     | 2023-12-04  |
| [Mamonsu](https://github.com/postgrespro/mamonsu)                   | Monitoring agent for PostgreSQL.                                                                                                                         | 187   |     | 2025-11-20  |
| [pg_monz](https://github.com/pg-monz/pg_monz)                       | This is the Zabbix monitoring template for PostgreSQL Database.                                                                                          | 162   |     | 2021-10-31  |
| [pgstats](https://github.com/gleu/pgstats)                          | Collects PostgreSQL statistics, and either saves them in CSV files or print them on the stdout                                                           | 126   |     | 2026-01-22  |
| [mssql-monitoring](https://github.com/microsoft/mssql-monitoring)   | Monitor your SQL Server on Linux performance using collectd, InfluxDB and Grafana                                                                        | 93    |     | 2023-06-12  |
| [pgbadger](https://github.com/dalibo/pgbadger)                      | pgbadger.github.io                                                                                                                                       | 25    |     | 2018-09-13  |

[Back to Top](#table-of-contents)

## Papers

| Name                                                                            | Description                 | Stars | 30d | Last Commit |
|---------------------------------------------------------------------------------|-----------------------------|-------|-----|-------------|
| [The "Database as Code" Manifesto](https://github.com/mgramin/database-as-code) | Treat your database as Code | 113   |     | 2025-01-15  |

[Back to Top](#table-of-contents)

## Reporting

| Name                                  | Description                                                                                                  | Stars | 30d | Last Commit |
|---------------------------------------|--------------------------------------------------------------------------------------------------------------|-------|-----|-------------|
| [Poli](https://github.com/shzlw/poli) | An easy-to-use BI server built for SQL lovers. Power data analysis in SQL and gain faster business insights. | 1975  |     | 2023-01-06  |

[Back to Top](#table-of-contents)

## SQL

| Name                                                                         | Description                                                                                                                                                                                         | Stars | 30d | Last Commit |
|------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-----|-------------|
| [osquery](https://github.com/osquery/osquery)                                | SQL powered operating system instrumentation, monitoring, and analytics.                                                                                                                            | 23100 |     | 2026-02-11  |
| [Trino](https://github.com/trinodb/trino)                                    | Official repository of Trino, the distributed SQL query engine for big data, formerly known as PrestoSQL (https://trino.io)                                                                         | 12539 |     | 2026-02-12  |
| [SQLFluff](https://github.com/sqlfluff/sqlfluff)                             | A modular SQL linter and auto-formatter with support for multiple dialects and templated code.                                                                                                      | 9492  |     | 2026-02-11  |
| [TextQL](https://github.com/dinedal/textql)                                  | Execute SQL against structured text like CSV or TSV                                                                                                                                                 | 9118  |     | 2023-10-22  |
| [SQLGlot](https://github.com/tobymao/sqlglot)                                | Python SQL Parser and Transpiler                                                                                                                                                                    | 8903  |     | 2026-02-11  |
| [Steampipe](https://github.com/turbot/steampipe)                             | Zero-ETL, infinite possibilities. Live query APIs, code & more with SQL. No DB required.                                                                                                            | 7690  |     | 2026-02-10  |
| [jOOQ](https://github.com/jOOQ/jOOQ)                                         | jOOQ is the best way to write SQL in Java                                                                                                                                                           | 6656  |     | 2026-02-11  |
| [CloudQuery](https://github.com/cloudquery/cloudquery)                       | Data pipelines for cloud config and security data. Build cloud asset inventory, CSPM, FinOps, and vulnerability management solutions. Extract from AWS, Azure, GCP, and 70+ cloud and SaaS sources. | 6321  |     | 2026-02-09  |
| [JSqlParser](https://github.com/JSQLParser/JSqlParser)                       | JSqlParser parses an SQL statement and translate it into a hierarchy of Java classes. The generated hierarchy can be navigated using the Visitor Pattern                                            | 5913  |     | 2026-01-26  |
| [OctoSQL](https://github.com/cube2222/octosql)                               | OctoSQL is a query tool that allows you to join, analyse and transform data from multiple databases and file formats using SQL.                                                                     | 5211  |     | 2024-05-26  |
| [sqlparse](https://github.com/andialbrecht/sqlparse)                         | A non-validating SQL parser module for Python                                                                                                                                                       | 3992  |     | 2025-12-19  |
| [dsq](https://github.com/multiprocessio/dsq)                                 | Commandline tool for running SQL queries against JSON, CSV, Excel, Parquet, and more.                                                                                                               | 3864  |     | 2023-09-30  |
| [pev2](https://github.com/dalibo/pev2)                                       | Postgres Explain Visualizer 2                                                                                                                                                                       | 3347  |     | 2026-02-02  |
| [SQLCheck](https://github.com/jarulraj/sqlcheck)                             | Automatically identify anti-patterns in SQL queries                                                                                                                                                 | 2521  |     | 2024-02-21  |
| [trdsql](https://github.com/noborus/trdsql)                                  | CLI tool that can execute SQL queries on CSV, LTSV, JSON, YAML and TBLN. Can output to various formats.                                                                                             | 2146  |     | 2026-01-15  |
| [SQL Murder Mystery](https://github.com/NUKnightLab/sql-mysteries)           | Inspired by @veltman's command-line mystery, use SQL to research clues and find out whodunit!                                                                                                       | 2022  |     | 2025-04-14  |
| [pgFormatter](https://github.com/darold/pgFormatter)                         | A PostgreSQL SQL syntax beautifier that can work as a console program or as a CGI. On-line demo site at http://sqlformat.darold.net/                                                                | 1899  |     | 2026-02-05  |
| [SQLLineage](https://github.com/reata/sqllineage)                            | SQL Lineage Analysis Tool powered by Python                                                                                                                                                         | 1617  |     | 2026-01-22  |
| [pg_flame](https://github.com/mgartner/pg_flame)                             | A flamegraph generator for Postgres EXPLAIN ANALYZE output.                                                                                                                                         | 1614  |     | 2020-01-13  |
| [csvq](https://github.com/mithrandie/csvq)                                   | SQL-like query language for csv                                                                                                                                                                     | 1608  |     | 2024-07-25  |
| [pgx_scripts](https://github.com/pgexperts/pgx_scripts)                      | A collection of useful little scripts for database analysis and administration, created by our team at PostgreSQL Experts.                                                                          | 1459  |     | 2023-08-10  |
| [libpg_query](https://github.com/pganalyze/libpg_query)                      | C library for accessing the PostgreSQL parser outside of the server environment                                                                                                                     | 1427  |     | 2026-02-07  |
| [postgres_dba](https://github.com/NikolayS/postgres_dba)                     | The missing set of useful tools for Postgres DBAs and all engineers                                                                                                                                 | 1217  |     | 2026-02-10  |
| [pg-utils](https://github.com/dataegret/pg-utils)                            | Useful PostgreSQL utilities                                                                                                                                                                         | 1186  |     | 2025-12-05  |
| [Advanced SQL Puzzles](https://github.com/smpetersgithub/AdvancedSQLPuzzles) | Welcome to my GitHub repository.  I hope you enjoy solving these puzzles as much as I have enjoyed creating them.                                                                                   | 847   |     | 2026-01-23  |
| [SQLLanguageServer](https://github.com/joe-re/sql-language-server)           | SQL Language Server                                                                                                                                                                                 | 765   |     | 2024-12-05  |
| [TPT](https://github.com/tanelpoder/tpt-oracle)                              | Tanel Poder's Performance & Troubleshooting Tools for Oracle Databases                                                                                                                              | 711   |     | 2026-01-14  |
| [pgsql-bloat-estimation](https://github.com/ioguix/pgsql-bloat-estimation)   | Queries to mesure statistical bloat in indexes and tables for PostgreSQL                                                                                                                            | 565   |     | 2022-08-23  |
| [CodeBuff](https://github.com/antlr/codebuff)                                | Language-agnostic pretty-printing through machine learning (uh, like, is this possible? YES, apparently).                                                                                           | 476   |     | 2025-07-12  |
| [More SQL Parsing!](https://github.com/klahnakoski/mo-sql-parsing)           | Let's make a SQL parser so we can provide a familiar interface to non-sql datastores!                                                                                                               | 292   |     | 2025-10-28  |
| [TSQLLint](https://github.com/tsqllint/tsqllint)                             | Configurable linting for TSQL                                                                                                                                                                       | 233   |     | 2024-09-18  |
| [MAT Calcite plugin](https://github.com/vlsi/mat-calcite-plugin)             | Heap query plugin for Eclipse Memory Analyzer                                                                                                                                                       | 175   |     | 2025-12-22  |
| [DBA MultiTool](https://github.com/LowlyDBA/dba-multitool)                   | :hammer_and_wrench:  T-SQL scripts for the long haul: optimizing storage, on-the-fly documentation, and general administrative needs.                                                               | 102   |     | 2026-01-26  |
| [JSQLFormatter](https://github.com/manticore-projects/jsqlformatter)         | Java SQL Formatter, Beautifier and Pretty Printer                                                                                                                                                   | 40    |     | 2026-02-02  |

[Back to Top](#table-of-contents)

## Schema

| Name                                                                 | Description                                                                                                                                              | Stars | 30d | Last Commit |
|----------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-----|-------------|
| [DrawDB](https://github.com/drawdb-io/drawdb)                        | Free, simple, and intuitive online database diagram editor and SQL generator.                                                                            | 36565 |     | 2026-02-11  |
| [ChartDB](https://github.com/chartdb/chartdb)                        | Database diagrams editor that allows you to visualize and design your DB with a single query.                                                            | 21135 |     | 2026-02-11  |
| [Bytebase](https://github.com/bytebase/bytebase)                     | World's most advanced database DevSecOps solution for Developer, Security, DBA and Platform Engineering teams. The GitHub/GitLab for database DevSecOps. | 13718 |     | 2026-02-12  |
| [gh-ost](https://github.com/github/gh-ost)                           | GitHub's Online Schema-migration Tool for MySQL                                                                                                          | 13207 |     | 2026-02-10  |
| [flyway](https://github.com/flyway/flyway)                           | Flyway by Redgate • Database Migrations Made Easy.                                                                                                       | 9526  |     | 2026-01-28  |
| [Atlas](https://github.com/ariga/atlas)                              | Declarative schema migrations with schema-as-code workflows                                                                                              | 8076  |     | 2026-02-07  |
| [liquibase](https://github.com/liquibase/liquibase)                  | Main Liquibase Source                                                                                                                                    | 5417  |     | 2026-02-10  |
| [Liam ERD](https://github.com/liam-hq/liam)                          | Automatically generates beautiful and easy-to-read ER diagrams from your database.                                                                       | 4696  |     | 2026-02-11  |
| [tbls](https://github.com/k1LoW/tbls)                                | tbls is a CI-Friendly tool to document a database, written in Go.                                                                                        | 4143  |     | 2026-01-16  |
| [Schema Spy](https://github.com/schemaspy/schemaspy)                 | Database documentation built easy                                                                                                                        | 3538  |     | 2026-01-26  |
| [DBML](https://github.com/holistics/dbml)                            | Database Markup Language (DBML), designed to define and document database structures                                                                     | 3513  |     | 2026-02-11  |
| [Sqitch](https://github.com/sqitchers/sqitch)                        | Sensible database change management                                                                                                                      | 3100  |     | 2026-01-25  |
| [migra](https://github.com/djrobstep/migra)                          | DEPRECATED: Like diff but for PostgreSQL schemas                                                                                                         | 3052  |     | 2025-08-25  |
| [WWW SQL Designer](https://github.com/ondras/wwwsqldesigner)         | WWW SQL Designer, your online SQL diagramming tool                                                                                                       | 2918  |     | 2025-08-25  |
| [Azimutt](https://github.com/azimuttapp/azimutt)                     | Explore, document and optimize any database                                                                                                              | 2045  |     | 2025-07-07  |
| [Reshape](https://github.com/fabianlindfors/reshape)                 | An easy-to-use, zero-downtime schema migration tool for Postgres                                                                                         | 1824  |     | 2026-02-10  |
| [SchemaCrawler](https://github.com/schemacrawler/SchemaCrawler)      | Free database schema discovery and comprehension tool                                                                                                    | 1783  |     | 2026-02-11  |
| [node-pg-migrate](https://github.com/salsita/node-pg-migrate)        | Node.js database migration management for PostgreSQL                                                                                                     | 1441  |     | 2026-02-12  |
| [Skeema](https://github.com/skeema/skeema)                           | Declarative pure-SQL schema management for MySQL and MariaDB                                                                                             | 1357  |     | 2026-02-04  |
| [SchemaHero](https://github.com/schemahero/schemahero)               | A Kubernetes operator for declarative database schema management (gitops for database schemas)                                                           | 1105  |     | 2026-02-11  |
| [Prisma Migrate](https://github.com/prisma/migrate)                  | Issues for Prisma Migrate are now tracked at prisma/prisma. This repo was used to track issues for Prisma Migrate Experimental and is now deprecated.    | 764   |     | 2020-12-18  |
| [pg-osc](https://github.com/shayonj/pg-osc)                          | Easy CLI tool for making zero downtime schema changes and backfills  in PostgreSQL                                                                       | 609   |     | 2026-02-03  |
| [Database Design](https://github.com/alextanhongpin/database-design) | Ideas on better database design                                                                                                                          | 496   |     | 2025-08-26  |
| [yuniql](https://github.com/rdagumampan/yuniql)                      | Free and open source schema versioning and database migration made natively with .NET/6. NEW THIS MAY 2022! v1.3.15 released!                            | 428   |     | 2024-07-25  |
| [Pyrseas](https://github.com/perseas/Pyrseas)                        | Provides utilities for Postgres database schema versioning.                                                                                              | 406   |     | 2024-07-10  |
| [ddl-generator](https://github.com/catherinedevlin/ddl-generator)    | Guesses table DDL based on data                                                                                                                          | 276   |     | 2022-09-09  |
| [scheme2ddl](https://github.com/qwazer/scheme2ddl)                   |  Command line util for export oracle schema to set of ddl scripts                                                                                        | 83    |     | 2024-11-28  |
| [2bass](https://github.com/CourseOrchestra/2bass)                    | DB schema as code tool                                                                                                                                   | 44    |     | 2024-11-12  |

[Back to Top](#table-of-contents)

## Security

| Name                                                       | Description                                                                                                                                                                                                                                | Stars | 30d | Last Commit |
|------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-----|-------------|
| [Acra](https://github.com/cossacklabs/acra)                | Database security suite. Database proxy with field-level encryption, search through encrypted data, SQL injections prevention, intrusion detection, honeypots. Supports client-side and proxy-side ("transparent") encryption. SQL, NoSQL. | 1453  |     | 2025-12-05  |
| [Databunker](https://github.com/securitybunker/databunker) | Secure Vault for Customer PII/PHI/PCI/KYC Records                                                                                                                                                                                          | 1383  |     | 2025-11-06  |

[Back to Top](#table-of-contents)

## Testing

| Name                                             | Description                                                                                             | Stars | 30d | Last Commit |
|--------------------------------------------------|---------------------------------------------------------------------------------------------------------|-------|-----|-------------|
| [SQLancer](https://github.com/sqlancer/sqlancer) | Automated testing to find logic and performance bugs in database systems                                | 1695  |     | 2025-11-23  |
| [pgTAP](https://github.com/theory/pgtap)         | PostgreSQL Unit Testing Suite                                                                           | 1115  |     | 2025-12-18  |
| [RegreSQL](https://github.com/dimitri/regresql)  | Regression Testing your SQL queries                                                                     | 347   |     | 2024-09-04  |
| [DbFit](https://github.com/dbfit/dbfit)          | DbFit is a database testing framework that supports easy test-driven development of your database code. | 242   |     | 2022-07-23  |

[Back to Top](#table-of-contents)
