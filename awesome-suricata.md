# awesome-suricata

A curated list of awesome things related to Suricata

## Operations, Monitoring and Troubleshooting

- [ansible-suricata](https://github.com/GitMirar/ansible-suricata) - Suricata Ansible role (slightly outdated).
- [docker-suricata](https://github.com/jasonish/docker-suricata) - Suricata Docker image.
- [MassDeploySuricata](https://github.com/pevma/MassDeploySuricata) - Mass deploy and update Suricata IDPS using Ansible IT automation platform.
- [Mauerspecht](https://github.com/DCSO/mauerspecht) - Simple Probing Tool for Corporate Walled Garden Networks.
- [slinkwatch](https://github.com/DCSO/slinkwatch) - Automatic enumeration and maintenance of Suricata monitoring interfaces.
- [suri-stats](https://github.com/regit/suri-stats) - A tool to work on suricata `stats.log` file.
- [Suricata-Monitoring](https://github.com/VVelox/Suricata-Monitoring) - LibreNMS JSON / Nagios monitor for Suricata stats.
- [suricata_exporter](https://github.com/corelight/suricata_exporter) - Simple Prometheus exporter written in Go exporting stats metrics scraped from Suricata socket.
- [Terraform Module for Suricata](https://github.com/onetwopunch/terraform-google-suricata) - Terraform module to setup Google Cloud packet mirroring and send packets to Suricata.

## Output Tools

- [FEVER](https://github.com/DCSO/fever) - Fast, extensible, versatile event router for Suricata's EVE-JSON format.
- [Lilith](https://github.com/VVelox/Lilith) - Reads EVE files into SQL as well as search stored data.
- [Meer](https://github.com/quadrantsec/meer) - Meer is a "spooler" for Suricata / Sagan.
- [suricata-kafka-output](https://github.com/Center-Sun/suricata-kafka-output) - Suricata Eve Kafka Output Plugin for Suricata 6.
- [Suricata-Logstash-Templates](https://github.com/pevma/Suricata-Logstash-Templates) - Templates for Kibana/Logstash to use with Suricata IDPS.
- [suricata-redis-output](https://github.com/jasonish/suricata-redis-output) - Suricata Eve Redis Output Plugin for Suricata 7.

## Simulation and Testing

- [Dalton](https://github.com/secureworks/dalton) - Suricata and Snort IDS rule and pcap testing system.
- [Leonidas](https://github.com/WithSecureLabs/leonidas) - Automated Attack Simulation in the Cloud, complete with detection use cases.
- [speeve](https://github.com/satta/speeve) - Fast, probabilistic EVE-JSON generator for testing and benchmarking of EVE-consuming applications.

## Systems Using Suricata

- [Amsterdam](https://github.com/StamusNetworks/Amsterdam) - Docker based Suricata, Elasticsearch, Logstash, Kibana, Scirius aka SELKS.
- [SELKS](https://github.com/StamusNetworks/SELKS) - A Suricata-based intrusion detection system/intrusion prevention system/network security monitoring distribution.

## Rule/Security Content Management and Handling

- [Aristotle](https://github.com/secureworks/aristotle) - Simple Python program that allows for the filtering and modifying of Suricata and Snort rulesets based on interpreted key-value pairs present in the metadata keyword within each rule.
- [IOCmite](https://github.com/sebdraven/IOCmite) - Tool to create dataset for suricata with indicators of MISP instances and add sightings in MISP if an indicator of dataset generates an alert.
- [luaevilbit](https://github.com/regit/luaevilbit) - An Evil bit implementation in luajit for Suricata.
- [OTX-Suricata](https://github.com/AlienVault-OTX/OTX-Suricata) - Create rules and configuration for Suricata to alert on indicators from an OTX account.
- [Scirius](https://github.com/StamusNetworks/scirius) - Web application for Suricata ruleset management and threat hunting.
- [suricata-prettifier](https://github.com/theY4Kman/suricata-prettifier) - Command-line tool to format and syntax highlight Suricata rules.
- [surify-cli](https://github.com/dgenzer/surify-cli) - Generate suricata-rules from collection of IOCs (JSON, CSV or flags) based on your suricata template.

## Development Tools

- [SublimeSuricata](https://github.com/ozuriexv/SublimeSuricata) - Basic Suricata syntax highlighter for Sublime Text.
- [Suricata Language Server](https://github.com/StamusNetworks/suricata-language-server) - Suricata Language Server is an implementation of the Language Server Protocol for Suricata signatures. It adds syntax check, hints and auto-completion to your preferred editor once it is configured.
- [suricata-highlight-vscode](https://github.com/dgenzer/suricata-highlight-vscode) - Suricata Rules Support for Visual Studio Code (syntax highlighting, etc).
- [suricata-ls-vscode](https://github.com/StamusNetworks/suricata-ls-vscode) - Suricata IntelliSense Extension using the Suricata Language Server.

## Programming Libraries and Toolkits

- [go-suricata](https://github.com/ks2211/go-suricata) - Go Client for Suricata (Interacting via Socket).
- [gonids](https://github.com/google/gonids) - Go library to parse intrusion detection rules for engines like Snort and Suricata.
- [py-idstools](https://github.com/jasonish/py-idstools) - Snort and Suricata Rule and Event Utilities in Python (Including a Rule Update Tool).
- [rust-suricatax-rule-parser](https://github.com/jasonish/rust-suricatax-rule-parser) - Experimental Suricata Rule Parser in Rust.
- [surevego](https://github.com/rhaist/surevego) - Suricata EVE-JSON parser in Go.
- [suricataparser](https://github.com/m-chrome/py-suricataparser) - Pure python parser for Snort/Suricata rules.

## Plugins and Extensions

- [suricata-zabbix](https://github.com/catenacyber/suricata-zabbix) - Zabbix application layer plugin for Suricata.

## Rule Sets

- [Antiphishing](https://github.com/julioliraup/Antiphishing) - Suricata rules and datasets to detect phishing attacks.
- [Cluster25/detection](https://github.com/Cluster25/detection) - Cluster25's detection rules.
- [Hunting rules](https://github.com/travisbgreen/hunting-rules) - Suricata IDS alert rules for network anomaly detection from Travis Green.
- [nids-rule-library](https://github.com/klingerko/nids-rule-library) - Collection of various open-source and commercial rulesets.
- [opnsense-suricata-nmaps](https://github.com/aleksibovellan/opnsense-suricata-nmaps) - OPNSense's Suricata IDS/IPS Detection Rules Against NMAP Scans.
- [QuadrantSec Suricata Rules](https://github.com/quadrantsec/suricata-rules) - QuadrantSec Suricata rules.

## Analysis Tools

- [Evebox](https://github.com/jasonish/evebox) - Web Based Event Viewer (GUI) for Suricata EVE Events in Elastic Search.
- [Malcolm](https://github.com/cisagov/Malcolm) - A powerful, easily deployable network traffic analysis tool suite for full packet capture artifacts (PCAP files), Zeek logs and Suricata alerts.
- [Suricata Analytics](https://github.com/StamusNetworks/suricata-analytics) - Various resources that are useful when interacting with Suricata data.

## Documentation and Guides

- [SEPTun](https://github.com/pevma/SEPTun) - Suricata Extreme Performance Tuning guide.
- [SEPTun-Mark-II](https://github.com/pevma/SEPTun-Mark-II) - Suricata Extreme Performance Tuning guide - Mark II.
- [Suricata Community Style Guide](https://github.com/sidallocation/suricata-style-guide) - A collaborative document to collect style guidelines from the community of rule writers.
- [suricata-4-analysts](https://github.com/StamusNetworks/suricata-4-analysts) - The Security Analyst's Guide to Suricata.

## Misc

- [bash_cata](https://github.com/isMTv/bash_cata) - A simple script that processes the generated Suricata eve-log in real time and, based on alerts, adds an ip-address to the MikroTik Address Lists for a specified time for subsequent blocking.
- [SuriGuard](https://github.com/SEc-123/SuriGuard1) - Web-based management system for Suricata IDS/IPS, featuring advanced analytics and visualization capabilities.
- [suriGUI](https://github.com/control-owl/suriGUI) - GUI for Suricata + Qubes OS.
- [Suriwire](https://github.com/regit/suriwire) - Wireshark plugin to display Suricata analysis info.

## Training

- [Experimental Suricata Training Environment](https://github.com/jasonish/experimental-suricata-training) - Experimental Suricata Training Environment.

## Input Tools

- [PacketStreamer](https://github.com/deepfence/PacketStreamer) - Distributed tcpdump for cloud native environments.

## Data Sets

- [suricata-sample-data](https://github.com/FrankHassanabad/suricata-sample-data) - Repository of creating different example suricata data sets.

## Dashboards and Templates

- [KTS](https://github.com/StamusNetworks/KTS) - Kibana 4 Templates for Suricata IDPS Threat Hunting.
- [KTS5](https://github.com/StamusNetworks/KTS5) - Kibana 5 Templates for Suricata IDPS Threat Hunting.
- [KTS6](https://github.com/StamusNetworks/KTS6) - Kibana 6 Templates for Suricata IDPS Threat Hunting.
- [KTS7](https://github.com/StamusNetworks/KTS7) - Kibana 7 Templates for Suricata IDPS Threat Hunting.
