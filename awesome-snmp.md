# awesome-snmp

A curated list of awesome SNMP libraries, tools, and other resources.

## Tools

- [snmpsim](https://github.com/etingof/snmpsim) - This is a pure-Python, open source and free implementation of SNMP agents simulator distributed under 2-clause BSD license.
- [snmpfwd](https://github.com/etingof/snmpfwd) - The SNMP Proxy Forwarder tool works as an application-level proxy with a built-in SNMP message router. Typical use case for an SNMP proxy is to work as an application-level firewall or a protocol translator that enables SNMPv3 access to a SNMPv1/SNMPv2c entity or vice versa.
- [snmpclitools](https://github.com/etingof/snmpclitools) - This is a collection of command-line SNMP tools written in pure-Python. The tools mimic their famous Net-SNMP counterparts. It includes snmpget.py, snmpset.py, snmpwalk.py, snmpbulkwalk.py, snmptrap.py, and snmptranslate.py, see [here](https://snmplabs.thola.io/snmpclitools/) for more details.
- [snmpwn](https://github.com/hatlord/snmpwn) - SNMPwn is an SNMPv3 user enumerator and attack tool.
- [trapperkeeper](https://github.com/dropbox/trapperkeeper) - A suite of tools for ingesting and displaying SNMP traps. This is designed as a replacement for snmptrapd and to supplement existing stateful monitoring solutions.
- [prometheus/snmp_exporter](https://github.com/prometheus/snmp_exporter) - This exporter is the recommended way to expose SNMP data in a format which Prometheus can ingest.
- [trailofbits/onesixtyone](https://github.com/trailofbits/onesixtyone) - Fast SNMP Scanner.
- [SECFORCE/SNMP-Brute](https://github.com/SECFORCE/SNMP-Brute) - Fast SNMP brute force, enumeration, CISCO config downloader and password cracking script.
- [hatlord/snmpwn](https://github.com/hatlord/snmpwn) - An SNMPv3 User Enumerator and Attack tool.
- [zabbix-tools/mib2zabbix](https://github.com/zabbix-tools/mib2zabbix) - This Perl script will generate a Zabbix v3 Template in XML format from an OID tree in a SNMP MIB file.
- [OIDrage](https://github.com/patrickscottbest/OIDrage) - A lightweight standalone SNMPd mimic server based on any snmpwalk output. Easily scales to mock thousands of servers.
- [Visual SNMP](https://github.com/sisraell/VisualSNMP) - Visual SNMP is a simple tool for testing access to SNMP agents. Currently SNMPGET and SNMPWALK are supported with some limited funcionality.
- [toni-moreno/snmpcollector](https://github.com/toni-moreno/snmpcollector) - SnmpCollector is a full featured Generic SNMP data collector with Web Administration Interface Open Source tool which has as main goal simplify the configuration for getting data from any device which snmp protocol support and send resulting data to an influxdb backend.

## MIB repositories

- [hsnodgrass/snmp_mib_archive](https://github.com/hsnodgrass/snmp_mib_archive) - An archive of over 3000 unique SNMP MIBs.
- [kcsinclair/mibs](https://github.com/kcsinclair/mibs) - Another collection of MIBS used for SNMP. Make sure to clone the repository to see the full list of MIBs.

## Libraries

- [C# SNMP Library](https://github.com/lextudio/sharpsnmplib) - MIT licensed SNMP library for .NET with extensive SNMP standard support, latest .NET platform targets, as well as rich manager/agent samples.
- [SnmpSharpNet](https://github.com/rqx110/SnmpSharpNet) - Simple Network Management Protocol (SNMP) .Net library written in C# (csharp). Implements protocol version 1, 2 and 3.
- [gosnmp/gosnmp](https://github.com/gosnmp/gosnmp) - An SNMP library written in Go. It provides Get, GetNext, GetBulk, Walk, BulkWalk, Set and Traps. It supports IPv4/IPv6, using SNMP v1/v2c/v3.
- [sleepinggenius2/gosmi](https://github.com/sleepinggenius2/gosmi) - MIB parser in Go language.
- [posteo/go-agentx](https://github.com/posteo/go-agentx) - A library with a pure Go implementation of the AgentX-Protocol.
- [mibble](https://github.com/cederberg/mibble) - Mibble is an open-source SNMP MIB (or SMI) parser library for Java.
- [node-net-snmp](https://github.com/markabrahams/node-net-snmp) - JavaScript implementation of the Simple Network Management Protocol (SNMP), implements versions 1, 2c and 3.
- [node-snmp-native](https://github.com/calmh/node-snmp-native) - Native JavaScript SNMP library for Node.js.
- [node-snmpjs](https://github.com/joyent/node-snmpjs) - This package provides a toolkit for SNMP agents and management applications in Node.js.
- [snmp-node](https://github.com/neias/snmp-node) - Native JavaScript SNMP library for Node.js.
- [luasnmp](https://github.com/hleuwer/luasnmp) - Lua binding to net-snmp library.
- [FreeDSx/SNMP](https://github.com/FreeDSx/SNMP) - A Pure PHP SNMP Library.
- [opensolutions/OSS_SNMP](https://github.com/opensolutions/OSS_SNMP) - A PHP SNMP library for people who hate SNMP, MIBs and OIDs!
- [pysnmp](https://github.com/lextudio/pysnmp) - This is a pure-Python, open source and free implementation of v1/v2c/v3 SNMP engine distributed under 2-clause BSD license.
- [pysmi](https://github.com/lextudio/pysmi) - PySMI is a pure-Python implementation of SNMP SMI MIB parser.
- [gufo_snmp](https://github.com/gufolabs/gufo_snmp) - The accelerated Python SNMP client library supporting both async and synchronous mode. It consists of a clean Python API for high-efficient BER parser and socket IO, implemented in the Rust language with PyO3 wrapper. Seems to be a bit early in the project's lifecycle, but it is easy to use and ___extremely___ fast, especially when querying many devices. ![GitHub last commit](https://img.shields.io/github/last-commit/gufolabs/gufo_snmp)
- [easysnmp](https://github.com/easysnmp/easysnmp) - A fork of [net-snmp Python bindings](http://www.net-snmp.org/wiki/index.php/Python_Bindings) that attempts to bring a more Pythonic interface to the library. ![GitHub last commit](https://img.shields.io/github/last-commit/easysnmp/easysnmp)
- [puresnmp](https://github.com/exhuma/puresnmp) - Pure Python3 SNMPv2 library without any dependencies. ![GitHub last commit](https://img.shields.io/github/last-commit/exhuma/puresnmp)
- [snimpy](https://github.com/vincentbernat/snimpy) - Snimpy is a Python-based tool providing a simple interface to build SNMP query. ![GitHub last commit](https://img.shields.io/github/last-commit/vincentbernat/snimpy)
- [python-netsnmpagent](https://github.com/pief/python-netsnmpagent) - This package allows to write net-snmp subagents in Python. ![GitHub last commit](https://img.shields.io/github/last-commit/pief/python-netsnmpagent)
- [hnmp](https://github.com/trehn/hnmp) - HNMP is a high-level Python library to ease the pain of retrieving and processing data from SNMP-capable devices such as network switches, routers, and printers. ![GitHub last commit](https://img.shields.io/github/last-commit/trehn/hnmp)
- [aiosnmp](https://github.com/hh-h/aiosnmp) - Python package aiosnmp is an asynchronous SNMP client for use with asyncio. Only SNMP v2c is supported. ![GitHub last commit](https://img.shields.io/github/last-commit/hh-h/aiosnmp)
- [robotframework-snmplibrary](https://github.com/kontron/robotframework-snmplibrary) - SNMPLibrary is a Robot Framework test library for testing SNMP. ![GitHub last commit](https://img.shields.io/github/last-commit/kontron/robotframework-snmplibrary)
- [Scapy](https://github.com/secdev/scapy) - Packet manipulation program & library. Scapy has a [module](https://github.com/secdev/scapy/blob/master/scapy/layers/snmp.py) to build/dissect SNMP packets. ![GitHub last commit](https://img.shields.io/github/last-commit/secdev/scapy)
- [ruby-netsnmp](https://github.com/swisscom/ruby-netsnmp) - SNMP library in ruby (v1, v2c, v3).
- [snmp-parser](https://github.com/rusticata/snmp-parser) - SNMP parser written in rust with nom parser combinator framework.
- [davedufresne/modern_snmp](https://github.com/davedufresne/modern_snmp) - Modern SNMP is a pure-Rust library for SNMPv3. This repository includes snmp_mp (SNMPv3 Message Processing) and snmp_usm (Implementation of the User-based Security Model (USM) for SNMPv3) crates.
- [Svedrin/sunt](https://github.com/Svedrin/sunt) - This repository implements an SNMP Agent written in Rust. __[⬆ back to top](#contents)__
