# awesome-data-engineering

A curated list of data engineering tools for software developers

## Monitoring

- [HAProxy Exporter](https://github.com/prometheus/haproxy_exporter) - Simple server that scrapes HAProxy stats and exports them via HTTP for Prometheus consumption.
- [Prometheus.io](https://github.com/prometheus/prometheus) - An open-source service monitoring system and time series database.

## File System

- [JuiceFS](https://github.com/juicedata/juicefs) - JuiceFS is a high-performance Cloud-Native file system driven by object storage for large-scale data storage.
- [S3QL](https://github.com/s3ql/s3ql) - S3QL is a file system that stores all its data online using storage services like Google Storage, Amazon S3, or OpenStack.
- [SeaweedFS](https://github.com/chrislusf/seaweedfs) - Seaweed-FS is a simple and highly scalable distributed file system. There are two objectives: to store billions of files! to serve the files fast! Instead of supporting full POSIX file system semantics, Seaweed-FS choose to implement only a key~file mapping. Similar to the word "NoSQL", you can call it as "NoFS".
- [smart_open](https://github.com/RaRe-Technologies/smart_open) - Utils for streaming large files (S3, HDFS, gzip, bz2).
- [SnackFS](https://github.com/tuplejump/snackfs-release) - SnackFS is our bite-sized, lightweight HDFS compatible file system built over Cassandra.
- [Snakebite](https://github.com/spotify/snakebite) - A pure python HDFS client.

## Data Lake Management

- [Gravitino](https://github.com/apache/gravitino) - Gravitino is an open-source, unified metadata management for data lakes, data warehouses, and external catalogs.
- [lakeFS](https://github.com/treeverse/lakeFS) - lakeFS is an open source platform that delivers resilience and manageability to object-storage based data lakes.
- [Project Nessie](https://github.com/projectnessie/nessie) - Project Nessie is a Transactional Catalog for Data Lakes with Git-like semantics. Works with Apache Iceberg tables.

## Datasets

- [Eventsim](https://github.com/Interana/eventsim) - Event data simulator. Generates a stream of pseudo-random events from a set of users, designed to simulate web traffic.

## Stream Processing

- [CocoIndex](https://github.com/cocoindex-io/cocoindex) - An open source ETL framework to build fresh index for AI.
- [HStreamDB](https://github.com/hstreamdb/hstream) - The streaming database built for IoT data storage and real-time processing.
- [Kuiper](https://github.com/emqx/kuiper) - An edge lightweight IoT data analytics/streaming software implemented by Golang, and it can be run at all kinds of resource-constrained edge devices.
- [PipelineDB](https://github.com/pipelinedb/pipelinedb) - The Streaming SQL Database.
- [Robinhood's Faust](https://github.com/faust-streaming/faust) - Forever scalable event processing & in-memory durable K/V store as a library with asyncio & static typing.
- [SwimOS](https://github.com/swimos/swim-rust) - A framework for building real-time streaming data processing applications that supports a wide range of ingestion sources.
- [Zilla](https://github.com/aklivity/zilla) - - An API gateway built for event-driven architectures and streaming that supports standard protocols such as HTTP, SSE, gRPC, MQTT, and the native Kafka protocol.

## Workflow

- [Airflow](https://github.com/apache/airflow) - Airflow is a system to programmatically author, schedule, and monitor data pipelines.
- [CronQ](https://github.com/seatgeek/cronq) - An application cron-like system. [Used](https://chairnerd.seatgeek.com/building-out-the-seatgeek-data-pipeline/) w/Luige. Deprecated.
- [Dagster](https://github.com/dagster-io/dagster) - Dagster is an open-source Python library for building data applications.
- [Hamilton](https://github.com/dagworks-inc/hamilton) - Hamilton is a lightweight library to define data transformations as a directed-acyclic graph (DAG). If you like dbt for SQL transforms, you will like Hamilton for Python processing.
- [Kestra](https://github.com/kestra-io/kestra) - A versatile open source orchestrator and scheduler built on Java, designed to handle a broad range of workflows with a language-agnostic, API-first architecture.
- [Luigi](https://github.com/spotify/luigi) - Luigi is a Python module that helps you build complex pipelines of batch jobs.
- [Multiwoven](https://github.com/Multiwoven/multiwoven) - The open-source reverse ETL, data activation platform for modern data teams.
- [PACE](https://github.com/getstrm/pace) - An open source framework that allows you to enforce agreements on how data should be accessed, used, and transformed, regardless of the data platform (Snowflake, BigQuery, DataBricks, etc.)
- [Pinball](https://github.com/pinterest/pinball) - DAG based workflow manager. Job flows are defined programmatically in Python. Support output passing between jobs.
- [RudderStack](https://github.com/rudderlabs/rudder-server) - A warehouse-first Customer Data Platform that enables you to collect data from every application, website and SaaS platform, and then activate it in your warehouse and business tools.

## Testing

- [DQOps](https://github.com/dqops/dqo) - An open-source data quality platform for the whole data platform lifecycle from profiling new data sources to applying full automation of data quality monitoring.
- [Grai](https://github.com/grai-io/grai-core) - A data catalog tool that integrates into your CI system exposing downstream impact testing of data changes. These tests prevent data changes which might break data pipelines or BI dashboards from making it to production.

## Docker

- [cAdvisor](https://github.com/google/cadvisor) - Analyzes resource usage and performance characteristics of running containers.
- [Flocker](https://github.com/ClusterHQ/flocker) - Easily manage Docker containers & their data.
- [Gockerize](https://github.com/redbooth/gockerize) - Package golang service into minimal Docker containers.
- [Micro S3 persistence](https://github.com/figadore/micro-s3-persistence) - Docker microservice for saving/restoring volume data to S3.
- [Nomad](https://github.com/hashicorp/nomad) - Nomad is a cluster manager, designed for both long-lived services and short-lived batch processing workloads.
- [Rocker-compose](https://github.com/grammarly/rocker-compose) - Docker composition tool with idempotency features for deploying apps composed of multiple containers. Deprecated.
- [Weave](https://github.com/weaveworks/weave) - Weaving Docker containers into applications.
- [Zodiac](https://github.com/CenturyLinkLabs/zodiac) - A lightweight tool for easy deployment and rollback of dockerized applications.

## Batch Processing

- [Bistro](https://github.com/asavinov/bistro) - A light-weight engine for general-purpose data processing including both batch and stream analytics. It is based on a novel unique data model, which represents data via _functions_ and processes data via _columns operations_ as opposed to having only set operations in conventional approaches like MapReduce or SQL.
- [Deep Spark](https://github.com/Stratio/deep-spark) - Connecting Apache Spark with different data stores. Deprecated.
- [Delight](https://github.com/datamechanics/delight) - A free & cross platform monitoring tool (Spark UI / Spark History Server alternative).
- [Hivemall](https://github.com/apache/incubator-hivemall) - Scalable machine learning library for Hive/Hadoop.
- [PyHive](https://github.com/dropbox/PyHive) - Python interface to Hive and Presto.
- [Substation](https://github.com/brexhq/substation) - Substation is a cloud native data pipeline and transformation toolkit written in Go.

## Data Ingestion

- [AWS Data Wrangler](https://github.com/awslabs/aws-data-wrangler) - Utility belt to handle data on AWS.
- [BottledWater](https://github.com/confluentinc/bottledwater-pg) - Change data capture from PostgreSQL into Kafka. Deprecated.
- [Gobblin](https://github.com/apache/incubator-gobblin) - Universal data ingestion framework for Hadoop from LinkedIn.
- [Google Sheets ETL](https://github.com/fulldecent/google-sheets-etl) - Live import all your Google Sheets to your data warehouse.
- [Heka](https://github.com/mozilla-services/heka) - Data Acquisition and Processing Made Easy. Deprecated.
- [kafka-docker](https://github.com/wurstmeister/kafka-docker) - Kafka in Docker.
- [Kafka-logger](https://github.com/uber/kafka-logger) - Kafka-winston logger for Node.js from Uber.
- [kafka-manager](https://github.com/yahoo/kafka-manager) - A tool for managing Apache Kafka.
- [kafka-node](https://github.com/SOHU-Co/kafka-node) - Node.js client for Apache Kafka 0.8.
- [kafkacat](https://github.com/edenhill/kafkacat) - Generic command line non-JVM Apache Kafka producer and consumer.
- [kafkat](https://github.com/airbnb/kafkat) - Simplified command-line administration for Kafka brokers.
- [librdkafka](https://github.com/edenhill/librdkafka) - The Apache Kafka C/C++ library.
- [pg-kafka](https://github.com/xstevens/pg_kafka) - A PostgreSQL extension to produce messages to Apache Kafka.
- [Secor](https://github.com/pinterest/secor) - Pinterest's Kafka to S3 distributed consumer.

## Serialization format

- [Kryo](https://github.com/EsotericSoftware/kryo) - Kryo is a fast and efficient object graph serialization framework for Java.
- [ProtoBuf](https://github.com/protocolbuffers/protobuf) - Protocol Buffers - Google's data interchange format.
- [Snappy](https://github.com/google/snappy) - A fast compressor/decompressor. Used with Parquet.

## Profiling

- [Data Profiler](https://github.com/capitalone/dataprofiler) - The DataProfiler is a Python library designed to make data analysis, monitoring, and sensitive data detection easy.

## Databases

- [Akumuli](https://github.com/akumuli/Akumuli) - Akumuli is a numeric time-series database. It can be used to capture, store and process time-series data in real-time. The word "akumuli" can be translated from esperanto as "accumulate".
- [Blueflood](https://github.com/rackerlabs/blueflood) - A distributed system designed to ingest and process time series data.
- [cayley](https://github.com/cayleygraph/cayley) - An open-source graph database. Google.
- [CCM](https://github.com/pcmanus/ccm) - A script to easily create and destroy an Apache Cassandra cluster on localhost.
- [Dalmatiner DB](https://github.com/dalmatinerdb/dalmatinerdb) - Fast distributed metrics database.
- [Druid](https://github.com/apache/incubator-druid) - Column oriented distributed data store ideal for powering interactive applications.
- [FiloDB](https://github.com/filodb/FiloDB) - Distributed. Columnar. Versioned. Streaming. SQL.
- [FlockDB](https://github.com/twitter-archive/flockdb) - A distributed, fault-tolerant graph database by Twitter. Deprecated.
- [Gaffer](https://github.com/gchq/Gaffer) - A large-scale graph database.
- [GreenPlum](https://github.com/greenplum-db/gpdb) - The Greenplum Database (GPDB) - An advanced, fully featured, open source data warehouse. It provides powerful and rapid analytics on petabyte scale data volumes.
- [Heroic](https://github.com/spotify/heroic) - A scalable time series database based on Cassandra and Elasticsearch, by Spotify.
- [HyperDex](https://github.com/rescrv/HyperDex) - HyperDex is a scalable, searchable key-value store. Deprecated.
- [InfluxDB](https://github.com/influxdata/influxdb) - Scalable datastore for metrics, events, and real-time analytics.
- [IonDB](https://github.com/iondbproject/iondb) - A key-value store for microcontroller and IoT applications.
- [kairosdb](https://github.com/kairosdb/kairosdb) - Fast scalable time series database.
- [Kyoto Tycoon](https://github.com/alticelabs/kyoto) - Kyoto Tycoon is a lightweight network server on top of the Kyoto Cabinet key-value database, built for high-performance and concurrency.
- [MemDB](https://github.com/rain1017/memdb) - Distributed Transactional In-Memory Database (based on MongoDB).
- [mysql_utils](https://github.com/pinterest/mysql_utils) - Pinterest MySQL Management Tools.
- [OpenTSDB](https://github.com/OpenTSDB/opentsdb) - A scalable, distributed Time Series Database.
- [Rhombus](https://github.com/Pardot/Rhombus) - A time-series object store for Cassandra that handles all the complexity of building wide row indexes.
- [RQLite](https://github.com/rqlite/rqlite) - Replicated SQLite using the Raft consensus protocol.
- [ScyllaDB](https://github.com/scylladb/scylla) - NoSQL data store using the seastar framework, compatible with Apache Cassandra.
- [Snappydata](https://github.com/SnappyDataInc/snappydata) - SnappyData: OLTP + OLAP Database built on Apache Spark.
- [Tarantool](https://github.com/tarantool/tarantool) - Tarantool is an in-memory database and application server.
- [TiDB](https://github.com/pingcap/tidb) - TiDB is a distributed NewSQL database compatible with MySQL protocol.
- [Timely](https://github.com/NationalSecurityAgency/timely) - Timely is a time series database application that provides secure access to time series data based on Accumulo and Grafana.

## Charts and Dashboards

- [Apache Superset](https://github.com/apache/incubator-superset) - Apache Superset (incubating) - A modern, enterprise-ready business intelligence web application.
- [Metabase](https://github.com/metabase/metabase) - Metabase is the easy, open source way for everyone in your company to ask questions and learn from data.
- [Plotly](https://github.com/plotly/dash) - Flask, JS, and CSS boilerplate for interactive, web-based visualization apps in Python.
- [PyXley](https://github.com/stitchfix/pyxley) - Python helpers for building dashboards using Flask and React.
- [QueryGPT](https://github.com/MKY508/QueryGPT) - Natural language database query interface with automatic chart generation, supporting Chinese and English queries.

## ELK Elastic Logstash Kibana

- [docker-logstash](https://github.com/pblittle/docker-logstash) - A highly configurable Logstash (1.4.4) - Docker image running Elasticsearch (1.7.0) - and Kibana (3.1.2).
- [elasticsearch-jdbc](https://github.com/jprante/elasticsearch-jdbc) - JDBC importer for Elasticsearch.
- [ZomboDB](https://github.com/zombodb/zombodb) - Postgres Extension that allows creating an index backed by Elasticsearch.

## Data Comparison

- [datacompy](https://github.com/capitalone/datacompy) - DataComPy is a Python library that facilitates the comparison of two DataFrames in pandas, Polars, Spark and more. The library goes beyond basic equality checks by providing detailed insights into discrepancies at both row and column levels.
