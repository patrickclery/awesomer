# awesome-prometheus

A curated list of awesome Prometheus resources, projects and tools.

## Exporters

- [AWS CloudWatch exporter](https://github.com/prometheus/cloudwatch_exporter) - The exporter for Amazon AWS CloudWatch metrics.
- [Blackbox](https://github.com/prometheus/blackbox_exporter) - The Blackbox exporter allows blackbox probing of endpoints over HTTP, HTTPS, DNS, TCP and ICMP.
- [Collectd exporter](https://github.com/prometheus/collectd_exporter) - The exporter for Collectd metrics.
- [Consul exporter](https://github.com/prometheus/consul_exporter) - The exporter for Consul metrics.
- [Graphite exporter](https://github.com/prometheus/graphite_exporter) - The exporter for Graphite metrics.
- [HAProxy exporter](https://github.com/prometheus/haproxy_exporter) - The HAProxy exporter periodically scrapes HAProxy stats.
- [InfluxDB](https://github.com/prometheus/influxdb_exporter) - The exporter for InfluxDB metrics.
- [JMX exporter](https://github.com/prometheus/jmx_exporter) - The exporter for JMX metrics.
- [Memcached exporter](https://github.com/prometheus/memcached_exporter) - The Memcached exporter periodically scrapes Memcached stats.
- [MySQL server exporter](https://github.com/prometheus/mysqld_exporter) - The MySQL server exporter periodically scrapes MySQL stats.
- [Node/system metrics exporter](https://github.com/prometheus/node_exporter) - The Node exporter periodically scrapes system stats.
- [SNMP exporter](https://github.com/prometheus/snmp_exporter) - The exporter for SNMP metrics.
- [StatsD exporter](https://github.com/prometheus/statsd_exporter) - The exporter for StatsD metrics.

## Proxies

- [exporter_proxy](https://github.com/mrichar1/exporter_proxy) - A tiny, simple pure-python reverse-proxy for Prometheus exporters, with TLS support.
- [Multi-prometheus proxy](https://github.com/matt-deboer/mpp) - Forwards incoming requests to one of a set of multiple Prometheus instances deployed as HA duplicates of each other using a selector strategy.
- [PromQL Guard](https://github.com/kfdm/promql-guard) - Provides a thin proxy on top of Prometheus, that allows PromQL queries to be inspected and re-written, so that a tenant can only see allowed data, even when using a shared Prometheus server.
- [Promxy](https://github.com/jacksontj/promxy) - Deduplicates data from Prometheus HA pairs.
- [Trickster](https://github.com/tricksterproxy/trickster) - HTTP reverse proxy/cache for HTTP applications and a dashboard query accelerator for time series databases.

## Deployment tools

- [Ansible-prometheus](https://github.com/ernestas-poskus/ansible-prometheus) - Ansible playbook for installing Prometheus monitoring system, exporters such as: node, snmp, blackbox, thus alert manager and push gateway _by Ernestas Poskus_.
- [Ansitheus](https://github.com/ntk148v/ansitheus) - Ansible playbook to containerize, configure and deploy Prometheus ecosystem _by ntk148v_.
- [Prometheus Operator](https://github.com/coreos/prometheus-operator) - Prometheus Operator creates/configures/manages Prometheus clusters atop Kubernetes _by CoreOS_.

## Official resources

- [GitHub repository](https://github.com/prometheus/prometheus) - Prometheus' source code, issues discussion and collaboration.

## High Availability

- [Cortex](https://github.com/cortexproject/cortex) - Horizontally scalable, highly available, multi-tenant, long-term Prometheus.
- [M3DB](https://github.com/m3db/m3) - Scalable long-term remote storage for Prometheus.
- [Thanos](https://github.com/thanos-io/thanos) - Highly available Prometheus setup with long term storage capabilities.
- [VictoriaMetrics](https://github.com/VictoriaMetrics/VictoriaMetrics) - Cost-effective easy to operate remote storage for Prometheus.

## Alertmanager

- [Awesome Prometheus Alerting Rules](https://github.com/samber/awesome-prometheus-alerts) - Awesome List of Prometheus alerting rules.
- [Karma](https://github.com/prymitive/karma) - Alert dashboard for Prometheus Alertmanager.

## Tutorials

- [Instructions and example code for a Prometheus workshop](https://github.com/juliusv/prometheus_workshop) - Instructions and example code for a Prometheus workshop by Julius Volz.
- [Prometheus-Basics](https://github.com/yolossn/Prometheus-Basics) - Beginner friendly introduction to Prometheus by [yolossn](https://github.com/yolossn).
