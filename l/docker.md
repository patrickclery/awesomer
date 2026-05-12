# awesome-docker

> 🐳 A curated list of Docker resources and projects

[Home](../README.md) | [Live site ↗](https://patrickclery.com/awesomer/l/docker/) | [Source ↗](https://github.com/veggiemonk/awesome-docker)

## Top 10 Trending

| # | Repo | Stars | 7d | 30d | 90d |
|---|------|-------|----|-----|-----|
| 1 | [Drone](../r/drone~drone.md) | 35,700 | +209 | +1,182 | +2,352 |
| 2 | [Træfɪk](../r/containous~traefik.md) | 63,116 | +142 | +468 | +1,797 |
| 3 | [Kubernetes](../r/kubernetes~kubernetes.md) | 122,196 | +131 | +538 | +1,124 |
| 4 | [Trivy](../r/aquasecurity~trivy.md) | 34,938 | +100 | +483 | +1,356 |
| 5 | [lazydocker](../r/jesseduffield~lazydocker.md) | 50,990 | +96 | +385 | +749 |
| 6 | [coder](../r/coder~coder.md) | 13,157 | +93 | +300 | +574 |
| 7 | [Awesome Compose](../r/docker~awesome-compose.md) | 45,206 | +89 | +407 | +1,525 |
| 8 | [MyIP](../r/jason5ng32~myip.md) | 10,338 | +87 | +266 | +401 |
| 9 | [dockge](../r/louislam~dockge.md) | 23,156 | +85 | +343 | +715 |
| 10 | [podman](../r/containers~libpod.md) | 31,661 | +81 | +306 | +1,132 |

## Table of Contents

- [Awesome Lists](#awesome-lists)
- [Container Operations](#container-operations)
- [Demos and Examples](#demos-and-examples)
- [Development Environment](#development-environment)
- [Development with Docker](#development-with-docker)
- [Docker Images](#docker-images)
- [Good Tips](#good-tips)
- [Monitoring](#monitoring)
- [Monitoring Services](#monitoring-services)
- [Projects](#projects)
- [Registry](#registry)
- [Reverse Proxy](#reverse-proxy)
- [Runtime](#runtime)
- [Security](#security)
- [Useful Resources](#useful-resources)
- [User Interface](#user-interface)
- [Volume Management / Data](#volume-management-data)
- [Where to start](#where-to-start)

## Awesome Lists

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Awesome Compose](../r/docker~awesome-compose.md) | Awesome Docker Compose samples | 45,206 | +89 |
| [Awesome Sysadmin](../r/n1trux~awesome-sysadmin.md) | A curated list of amazingly awesome open-source sysadmin resources. | 33,861 | +66 |

[Back to top](#awesome-docker)

## Container Operations

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Træfɪk](../r/containous~traefik.md) | The Cloud Native Application Proxy | 63,116 | +142 |
| [Kubernetes](../r/kubernetes~kubernetes.md) | Production-Grade Container Scheduling and Management | 122,196 | +131 |
| [Trivy](../r/aquasecurity~trivy.md) | Find vulnerabilities, misconfigurations, secrets, SBOM in containers, Kubernetes, code repositories, clouds and more | 34,938 | +100 |
| [lazydocker](../r/jesseduffield~lazydocker.md) | The lazier way to manage everything docker | 50,990 | +96 |
| [MyIP](../r/jason5ng32~myip.md) | The best IP Toolbox. Easy to check what's your IPs, IP geolocation, check for DNS leaks, examine WebRTC connections, spe | 10,338 | +87 |
| [dockge](../r/louislam~dockge.md) | A fancy, easy-to-use and reactive self-hosted docker compose.yaml stack-oriented manager | 23,156 | +85 |
| [podman](../r/containers~libpod.md) | Podman: A tool for managing OCI containers and pods. | 31,661 | +81 |
| [Nginx Proxy Manager](../r/jc21~nginx-proxy-manager.md) | Docker container for managing Nginx proxy hosts with a simple, powerful interface | 32,784 | +78 |
| [netdata](../r/netdata~netdata.md) | The fastest path to AI-powered full stack observability, even for lean teams. | 78,768 | +72 |
| [Portainer](../r/portainer~portainer.md) | Making Docker and Kubernetes management easy. | 37,399 | +58 |
| [Komodo](../r/mbecker20~komodo.md) | 🦎 a tool to build and deploy software on many servers 🦎 | 11,135 | +55 |
| [Syft](../r/anchore~syft.md) | CLI tool and library for generating a Software Bill of Materials from container images and filesystems | 8,919 | +44 |
| [Glances](../r/nicolargo~glances.md) | Glances an Eye on your system. A top/htop alternative for GNU/Linux, BSD, Mac OS and Windows operating systems. | 32,501 | +43 |
| [skopeo](../r/containers~skopeo.md) | Work with remote images registries - retrieving information, images, signing content | 10,845 | +37 |
| [Autoheal](../r/willfarrell~docker-autoheal.md) | Monitor and restart unhealthy docker containers. | 1,894 | +36 |
| [istio](../r/istio~istio.md) | Connect, secure, control, and observe services. | 38,195 | +33 |
| [Checkmate](../r/bluewave-labs~checkmate.md) | Checkmate is an open-source, self-hosted tool designed to track and monitor server hardware, uptime, response times, and | 9,758 | +32 |
| [Mafl](../r/hywax~mafl.md) | Minimalistic flexible homepage | 724 | +29 |
| [dive](../r/wagoodman~dive.md) | A tool for exploring each layer in a docker image | 53,900 | +28 |
| [Rancher](../r/rancher~rancher.md) | Complete container management platform | 25,567 | +26 |
| [netshoot](../r/nicolaka~netshoot.md) | a Docker + Kubernetes network trouble-shooting swiss-army container | 10,666 | +25 |
| [Docker Volume Backup](../r/offen~docker-volume-backup.md) | Backup Docker volumes locally or to any S3, WebDAV, Azure Blob Storage, Dropbox, Google Drive or SSH compatible storage | 3,559 | +23 |
| [HertzBeat](../r/dromara~hertzbeat.md) | An AI-powered next-generation open source real-time observability system. | 7,223 | +22 |
| [caddy-docker-proxy](../r/lucaslorentz~caddy-docker-proxy.md) | Caddy as a reverse proxy for Docker | 4,466 | +21 |
| [LLM Harbor](../r/av~harbor.md) | Stop configuring your AI stack. Start using it. One command brings a complete pre-wired LLM stack with hundreds of servi | 2,924 | +21 |
| [cAdvisor](../r/google~cadvisor.md) | Analyzes resource usage and performance characteristics of running containers. | 19,126 | +18 |
| [Nomad](../r/hashicorp~nomad.md) | Nomad is an easy-to-use, flexible, and performant workload orchestrator that can deploy a mix of microservice, batch, co | 16,490 | +17 |
| [Sysdig Falco](../r/falcosecurity~falco.md) | Cloud Native Runtime Security | 8,932 | +14 |
| [Checkov](../r/bridgecrewio~checkov.md) | Prevent cloud misconfigurations and find vulnerabilities during build-time in infrastructure as code, container images a | 8,700 | +13 |
| [oxker](../r/mrjackwills~oxker.md) | A simple tui to view & control docker containers  | 1,650 | +12 |
| [docker rollout](../r/wowu~docker-rollout.md) | 🚀 Zero Downtime Deployment for Docker Compose | 3,207 | +11 |
| [Theia](../r/eclipse-theia~theia.md) | Eclipse Theia is a cloud & desktop IDE framework implemented in TypeScript. | 21,499 | +11 |
| [caprover](../r/caprover~caprover.md) | Scalable PaaS (automated Docker+nginx) - aka Heroku on Steroids | 15,014 | +10 |
| [lazyjournal](../r/lifailon~lazyjournal.md) | TUI for viewing logs from journald, auditd, file system, Docker and Podman containers, Compose stacks and Kubernetes pod | 1,264 | +9 |
| [cri-o](../r/cri-o~cri-o.md) | Open Container Initiative-based implementation of Kubernetes Container Runtime Interface | 5,612 | +8 |
| [OpenResty Manager](../r/safe3~openresty-manager.md) | Modern, secure, and elegant server control panel, alternative to OpenResty Edge and Nginx Proxy Manager. | 1,371 | +7 |
| [podman-compose](../r/containers~podman-compose.md) | a script to run docker-compose.yml using podman | 6,069 | +7 |
| [kompose](../r/kubernetes~kompose.md) | Convert Compose to Kubernetes | 10,524 | +6 |
| [oscap-docker](../r/openscap~openscap.md) | NIST Certified SCAP 1.2 toolkit | 1,718 | +6 |
| [d4s](../r/jr-k~d4s.md) | 🍊 A fast, keyboard-driven terminal UI to manage Docker containers, Compose stacks, and Swarm services with the ergonomi | 80 | +5 |
| [Deepfence Threat Mapper](../r/deepfence~threatmapper.md) | Open Source Cloud Native Application Protection Platform (CNAPP) | 5,266 | +4 |
| [dry](../r/moncho~dry.md) | dry - A Docker manager for the terminal @ | 3,248 | +4 |
| [Swarmpit](../r/swarmpit~swarmpit.md) | Lightweight AI-friendly Docker Swarm management | 3,437 | +4 |
| [DockMate](../r/shubh-io~dockmate.md) | Dockmate: The open-source Docker TUI & Podman manager for terminal productivity. A fast, lightweight alternative to lazy | 306 | +3 |
| [DockSTARTer](../r/ghostwriters~dockstarter.md) | DockSTARTer helps you get started with running apps in Docker. | 2,559 | +3 |
| [etcd](../r/etcd-io~etcd.md) | Distributed reliable key-value store for the most critical data of a distributed system | 51,687 | +3 |
| [KICS](../r/checkmarx~kics.md) | Find security vulnerabilities, compliance issues, and infrastructure misconfigurations early in the development cycle of | 2,632 | +3 |
| [OctoLinker](../r/octolinker~octolinker.md) | OctoLinker — Links together, what belongs together | 5,357 | +3 |
| [Clair](../r/quay~clair.md) | Vulnerability Static Analysis for Containers | 10,977 | +2 |
| [Composerize](../r/magicmark~composerize.md) | 🏃→🎼  docker run asdlksjfksdf > docker-composerize up | 3,735 | +2 |
| [Dagda](../r/eliasgranderubio~dagda.md) | a tool to perform static analysis of known vulnerabilities, trojans, viruses, malware & other malicious threats in docke | 1,232 | +2 |
| [docker-bench-security](../r/docker~docker-bench-security.md) | The Docker Bench for Security is a script that checks for dozens of common best-practices around deploying Docker contai | 9,631 | +2 |
| [Flannel](../r/coreos~flannel.md) | flannel is a network fabric for containers, designed for Kubernetes | 9,450 | +2 |
| [Swarm Router](../r/flavioaiello~swarm-router.md) | Scalable stateless «zero config» service-name ingress for docker swarm mode with a fresh more secure approach | 75 | +2 |
| [dockemon](../r/productiveops~dokemon.md) | Docker Container Management GUI | 767 | +1 |
| [Docker Registry Browser](../r/klausmeyer~docker-registry-browser.md) | 🐳 Web Interface for the Docker Registry HTTP API V2 written in Ruby on Rails. | 687 | +1 |
| [dockerfile-mode](../r/spotify~dockerfile-mode.md) | An emacs mode for handling Dockerfiles | 564 | +1 |
| [fabio](../r/fabiolb~fabio.md) | Consul Load-Balancing made simple | 7,334 | +1 |
| [Freeflow](../r/microsoft~freeflow.md) | High performance container overlay networks on Linux. Enabling RDMA (on both InfiniBand and RoCE) and accelerating TCP t | 637 | +1 |
| [gitkube](../r/hasura~gitkube.md) | Build and deploy docker images to Kubernetes using git push | 3,850 | +1 |
| [Kubevious](../r/kubevious~kubevious.md) | Kubevious - Kubernetes without disasters | 1,696 | +1 |
| [ManageIQ](../r/manageiq~manageiq.md) | ManageIQ Open-Source Management Platform | 1,398 | +1 |
| [runtime-tools](../r/opencontainers~runtime-tools.md) | OCI Runtime Tools | 482 | +1 |
| [Stevedore](../r/slonopotamus~stevedore.md) | 🚢 Docker distribution for Windows Containers that Just Works | 372 | +1 |
| [Swarm-cronjob](../r/crazy-max~swarm-cronjob.md) | Create jobs on a time-based schedule on Docker Swarm | 872 | +1 |
| [Anchor](../r/songstitch~anchor.md) | A tool for anchoring dependencies in dockerfiles | 24 | +0 |
| [Ansible Linux Docker](../r/peco602~ansible-linux-docker.md) | This Docker image allows to run Ansible from a Linux container. It supports Linux, Windows and MacOS target hosts. | 39 | +0 |
| [athena](../r/athena-oss~athena.md) | An automation platform with a plugin architecture that allows you to easily create and share services. | 96 | +0 |
| [awesome-stacks](../r/ethibox~awesome-stacks.md) | Deploy 150+ open-source web apps with one Docker command | 1,279 | +0 |
| [bane](../r/genuinetools~bane.md) | Custom & better AppArmor profile generator for Docker containers. | 1,226 | +0 |
| [Blockbridge](../r/blockbridge~blockbridge-docker-volume.md) | Blockbridge volume plugin for Docker | 94 | +0 |
| [caddy-docker-upstreams](../r/invzhi~caddy-docker-upstreams.md) | Docker dynamic upstreams for Caddy. | 35 | +0 |
| [Capitan](../r/byrnedo~capitan.md) | Capitan is a tool for managing multiple Docker containers | 31 | +0 |
| [captain](../r/jenssegers~captain.md) | ⚓️ Easily start and stop docker compose projects | 245 | +0 |
| [CetusGuard](../r/hectorm~cetusguard.md) | CetusGuard is a tool that protects the Docker daemon socket by filtering calls to its API endpoints. | 83 | +0 |
| [CIS Docker Benchmark](../r/dev-sec~cis-docker-benchmark.md) | CIS Docker Benchmark - InSpec Profile | 523 | +0 |
| [Clocker](../r/brooklyncentral~clocker.md) | Apache Brooklyn cloud native infrastructure blueprints | 429 | +0 |
| [CloudSlang](../r/cloudslang~cloud-slang.md) | CloudSlang Language, CLI and Builder | 241 | +0 |
| [clusterdock](../r/clusterdock~clusterdock.md) | clusterdock is a framework for creating Docker-based container clusters | 30 | +0 |
| [Conduit](../r/ehazlett~conduit.md) | Deployment system for Docker | 108 | +0 |
| [Container Web TTY](../r/wrfly~container-web-tty.md) | Connect your containers via a web-tty | 258 | +0 |
| [Convox Rack](../r/convox~rack.md) | Private PaaS built on native AWS services for maximum privacy and minimum upkeep | 1,893 | +0 |
| [Crane](../r/dataman-cloud~crane.md) | Yet another control plane based on docker built-in swarmkit | 749 | +0 |
| [crowdr](../r/polonskiy~crowdr.md) | Crowdr is a tool for managing multiple Docker containers | 98 | +0 |
| [ctk](../r/ctk-hq~ctk.md) | Visual composer for container based workloads | 300 | +0 |
| [dcinja](../r/falldog~dcinja.md) | The smallest binary size of template engine, born for docker image | 14 | +0 |
| [dcp](../r/exdx~dcp.md) | docker cp made easy | 115 | +0 |
| [Dcw](../r/pbertera~dcw.md) | Docker Compose Wrapper (a poor man's PAAS management tool) | 17 | +0 |
| [decompose](../r/s0rg~decompose.md) | Reverse-engineering tool for docker environments | 132 | +0 |
| [depcon](../r/containx~depcon.md) | Docker blue-green/deployment/management supporting Mesos/Marathon and Compose. | 93 | +0 |
| [dext-docker-registry-plugin](../r/vutran~dext-docker-registry-plugin.md) | 🐳 Dext plugin to search the Docker Registry for Docker images. | 4 | +0 |
| [DLIA](../r/zorak1103~dlia.md) | DLIA is an AI-powered Docker log monitoring agent that uses Large Language Models (LLMs) to intelligently analyze contai | 3 | +0 |
| [dockdash](../r/byrnedo~dockdash.md) | Docker dashboard using Termui | 125 | +0 |
| [Docker DB Manager](../r/abians~docker-db-manager.md) | A desktop application for managing Docker database containers | 160 | +0 |
| [Docker Dnsmasq Updater](../r/moonbuggy~docker-dnsmasq-updater.md) | Automatically update a local or remote hosts file with Docker container hostnames | 34 | +0 |
| [Docker Flow Swarm Listener](../r/docker-flow~docker-flow-swarm-listener.md) | Docker Flow Swarm Listener | 68 | +0 |
| [docker pushrm](../r/christian-korneck~docker-pushrm.md) | "Docker Push Readme" - a Docker CLI plugin to update container repo docs | 150 | +0 |
| [Docker-Alertd](../r/deltaskelta~docker-alertd.md) | Monitor docker stats and send alerts | 108 | +0 |
| [docker-captain](../r/lucabello~docker-captain.md) | ⚓ A friendly CLI to manage multiple Docker Compose deployments with style — powered by Typer, Rich, questionary, and sh. | 2 | +0 |
| [docker-config-update](../r/sudo-bmitch~docker-config-update.md) | Utility to handle updates to docker configs and secrets | 53 | +0 |
| [docker-consul](../r/gliderlabs~docker-consul.md) | Dockerized Consul | 1,062 | +0 |
| [docker-dns](../r/bytesharky~docker-dns.md) | Docker DNS Forwarder is a lightweight tool that enables the host machine to resolve Docker container names to their IPs  | 4 | +0 |
| [Docker-Flow-Monitor](../r/docker-flow~docker-flow-monitor.md) | Reconfigures Prometheus when a new service is updated or deployed automatically by [@docker-flow][docker-flow] | 87 | +0 |
| [docker-registry-web](../r/mkuchin~docker-registry-web.md) | Web UI for private docker registry v2 | 547 | +0 |
| [docker-ssh](../r/jeroenpeeters~docker-ssh.md) | SSH Server for Docker containers  ~ Because every container should be accessible | 659 | +0 |
| [docker-swarm-visualizer](../r/dockersamples~docker-swarm-visualizer.md) | A visualizer for Docker Swarm Mode using the Docker Remote API, Node.JS, and D3 | 3,349 | +0 |
| [docker-to-iac](../r/deploystackio~docker-to-iac.md) | Translate docker run and docker compose file to Infrastructure as Code | 21 | +0 |
| [docker.el](../r/silex~docker.el.md) | Manage docker from Emacs. | 819 | +0 |
| [dockprom](../r/stefanprodan~dockprom.md) | Docker hosts and containers monitoring with Prometheus, Grafana, cAdvisor, NodeExporter and AlertManager | 6,507 | +0 |
| [Doku](../r/amerkurev~doku.md) | 💽 Doku - Docker disk usage dashboard | 413 | +0 |
| [dprs](../r/durableprogramming~dprs.md) | A developer-focused TUI for managing Docker containers with real-time log streaming and container management. Built with | 38 | +0 |
| [DVM](../r/howtowhale~dvm.md) | Docker Version Manager | 526 | +0 |
| [dvwassl](../r/peco602~dvwassl.md) | SSL-enabled Damn Vulnerable Web App (DVWA) | 6 | +0 |
| [elsy](../r/cisco~elsy.md) | An opinionated, multi-language, build tool based on Docker and Docker Compose | 80 | +0 |
| [Empire](../r/remind101~empire.md) | A PaaS built on top of Amazon EC2 Container Service (ECS) | 2,680 | +0 |
| [Exoframe](../r/exoframejs~exoframe.md) | Exoframe is a self-hosted tool that allows simple one-command deployments using Docker | 1,150 | +0 |
| [goinside](../r/iamsoorena~goinside.md) | 🐠 Command line tool that helps going inside docker containers 🐠 | 31 | +0 |
| [goManageDocker](../r/ajayd-san~gomanagedocker.md) | TUI tool to manage your docker images, containers and volumes 🚀 | 637 | +0 |
| [Grafeas](../r/grafeas~grafeas.md) | Artifact Metadata API | 1,563 | +0 |
| [Haven](../r/codeabovelab~haven-platform.md) | Haven is an open source Docker container management system. It integrates container, application, cluster, image, and re | 298 | +0 |
| [Hephy Workflow](../r/teamhephy~workflow.md) | Hephy Workflow - An open source fork of Deis Workflow - The open source PaaS for Kubernetes. | 419 | +0 |
| [InfluxDB, cAdvisor, Grafana](../r/vegasbrianc~docker-monitoring.md) | Docker-Monitoring based on Cadvisor, InfluxDB, and Grafana | 473 | +0 |
| [Krane](../r/krane~krane.md) |  Open-source, self-hosted, container management solution | 85 | +0 |
| [Logspout](../r/gliderlabs~logspout.md) | Log routing for Docker container logs | 4,698 | +0 |
| [lxc](../r/lxc~lxc.md) | LXC - Linux Containers | 5,176 | +0 |
| [mesh-router](../r/yundera~mesh-router.md) | MeshRouter: Seamlessly route domain requests to containers across networks using ENS, or custom names, secured by Wiregu | 12 | +0 |
| [Mesos](../r/apache~mesos.md) | Apache Mesos | 5,368 | +0 |
| [monit-docker](../r/decryptus~monit-docker.md) | Monitor docker containers resources usage and execute docker commands or inside containers  | 34 | +0 |
| [MultiDocker](../r/marty90~multidocker.md) | Creates a system where users are forced to login in dedicated independent docker containers. | 56 | +0 |
| [Nanobox](../r/nanobox-io~nanobox.md) | The ideal platform for developers | 1,628 | +0 |
| [Netshare](../r/containx~docker-volume-netshare.md) | Docker NFS, AWS EFS, Ceph & Samba/CIFS Volume Plugin | 1,142 | +0 |
| [Out-of-the-box Host/Container Monitoring/Logging/Alerting Stack](../r/uschtwill~docker_monitoring_logging_alerting.md) | Docker host and container monitoring, logging and alerting out of the box using cAdvisor, Prometheus, Grafana for monito | 540 | +0 |
| [Pdocker](../r/g31s~pdocker.md) | Pdocker is a simple terminal UI to maintain and manage personal projects in Docker. | 7 | +0 |
| [Pipework](../r/jpetazzo~pipework.md) | Software-Defined Networking tools for LXC (LinuX Containers) | 4,252 | +0 |
| [plash](../r/ihucos~plash.md) | Build and run layered root filesystems. | 384 | +0 |
| [Powerline-Docker](../r/adrianmo~powerline-docker.md) | A Powerline segment for showing the status of your Docker containers | 62 | +0 |
| [proco](../r/shiwaforce~poco.md) | Poco will help you to organise and manage Docker, Docker-Compose, Kubernetes, Openshift projects of any complexity using | 113 | +0 |
| [Rapid Dashboard](../r/ozlerhakan~rapid.md) | 🐳 A lightweight Docker Developer Interface for Docker Remote API | 147 | +0 |
| [RedHerd Framework](../r/redherd-project~redherd-framework.md) | RedHerd is a collaborative and serverless framework for orchestrating a geographically distributed group of assets. | 75 | +0 |
| [registrator](../r/gliderlabs~registrator.md) | Service registry bridge for Docker with pluggable adapters | 4,676 | +0 |
| [REX-Ray](../r/rexray~rexray.md) | REX-Ray is a container storage orchestration engine enabling persistence for cloud native workloads | 2,222 | +0 |
| [rlxc](../r/brauner~rlxc.md) | LXC binary written in Rust | 19 | +0 |
| [Seagull](../r/tobegit3hub~seagull.md) | Friendly Web UI to manage and monitor docker | 1,936 | +0 |
| [Smalte](../r/roquie~smalte.md) | Dynamically configure applications that require static configuration in docker container. | 36 | +0 |
| [Stitchocker](../r/alexaandrov~stitchocker.md) | 🌈 Stitchoker its a lightweight and fast command line utility utility for conveniently grouping your docker-compose mult | 30 | +0 |
| [Storidge](../r/storidge~quick-start.md) | START HERE:  Setup a Swarm cluster with persistent storage in 10 minutes | 1 | +0 |
| [swarm-ansible](../r/lombardidaniel~swarm-ansible.md) | Build a Production-Ready Docker Swarm cluster using Ansible. The goal is rapidly bootstrap a Docker Swarm cluster with s | 57 | +0 |
| [SwarmAlert](../r/gpulido~swarmalert.md) | Monitor docker Swarm services and sends a pushover notification if anyone is down | 21 | +0 |
| [SwarmManagement](../r/hansehe~swarmmanagement.md) | Swarm Management is a python application, installed with pip. The application makes it easy to manage a Docker Swarm by  | 21 | +0 |
| [Swirl](../r/cuigh~swirl.md) | A web UI for Docker, focused on swarm cluster. | 668 | +0 |
| [tsaotun](../r/qazbnm456~tsaotun.md) | Tsaotun - Python based Assistance for Docker | 56 | +0 |
| [Tsuru](../r/tsuru~tsuru.md) | Open source and extensible Platform as a Service (PaaS). | 5,277 | +0 |
| [werf](../r/werf~werf.md) | A solution for implementing efficient and consistent software delivery to Kubernetes facilitating best practices. | 4,684 | +0 |
| [Zabbix Docker](../r/gomex~docker-zabbix.md) | Add and monitor running docker containers in Zabbix Server | 52 | +0 |
| [CASA](../r/knrdl~casa.md) | Container as a Service admin | 85 | -1 |
| [dctl](../r/fabiend~docker-stack.md) | A curated collection of ready-to-use Docker Compose files for local web development, plus a powerful CLI (dctl) to manag | 23 | -1 |
| [docker-explorer](../r/google~docker-explorer.md) | A tool to help forensicate offline docker acquisitions | 553 | -1 |
| [docker-flow-proxy](../r/docker-flow~docker-flow-proxy.md) | Docker Flow Proxy | 318 | -1 |
| [dockly](../r/lirantal~dockly.md) | Immersive terminal interface for managing docker containers and services | 4,014 | -1 |
| [habitus](../r/cloud66-oss~habitus.md) | A build flow tool for Docker. | 1,396 | -1 |
| [Let's Encrypt Nginx-proxy Companion](../r/nginx-proxy~docker-letsencrypt-nginx-proxy-companion.md) | Automated ACME SSL certificate generation for nginx-proxy | 7,703 | -1 |
| [NexClipper](../r/nexclipper~nexclipper.md) | Metrics Pipeline for interoperability and Enterprise Prometheus | 563 | -1 |
| [scuba](../r/jonathonreinhart~scuba.md) | Simple Container-Utilizing Build Apparatus | 97 | -1 |
| [Sidekick](../r/runsidekick~sidekick.md) | Sidekick is no longer in service | 1,607 | -1 |
| [Simple Docker UI](../r/felixgborrego~simple-docker-ui.md) | Native Docker UI implemented using Scala.js and React - DEPRECATED | 604 | -1 |
| [supdock](../r/segersniels~supdock.md) | What's Up, Doc(ker)? A convenient way to interact with the docker daemon using prompts. | 85 | -1 |
| [Zabbix Docker module](../r/monitoringartist~zabbix-docker-monitoring.md) | 🐳 Docker/Kubernetes/Mesos/Marathon/Chronos/LXC/LXD/Swarm container monitoring - Docker image, Zabbix template and C mod | 1,191 | -1 |
| [Dokku](../r/dokku~dokku.md) | A docker-powered PaaS that helps you build and manage the lifecycle of applications | 31,867 | -7 |

[Back to top](#awesome-docker)

## Demos and Examples

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Local Docker DB](../r/alexmacarthur~local-docker-db.md) | A bunch o' Docker Compose files used to quickly spin up local databases.  | 298 | +0 |
| [Webstack-micro](../r/ferbs~webstack-micro.md) | Example/starter web app geared for small-ish teams interested in using a microservices architecture | 89 | +0 |

[Back to top](#awesome-docker)

## Development Environment

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Bytebase](../r/bytebase~bytebase.md) | World's most advanced database DevSecOps solution for Developer, Security, DBA and Platform Engineering teams. The GitHu | 13,987 | +31 |
| [HarborPilot](../r/potterwhite~harborpilot.md) | This is a One-Click docker images and containers setup base which is doing via a lot of bash scripts. My primary target  | 2 | +0 |

[Back to top](#awesome-docker)

## Development with Docker

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Drone](../r/drone~drone.md) | Harness Open Source is an end-to-end developer platform with Source Control Management, CI/CD Pipelines, Hosted Develope | 35,700 | +209 |
| [coder](../r/coder~coder.md) | Secure environments for developers and their agents | 13,157 | +93 |
| [Diun](../r/crazy-max~diun.md) | Receive notifications when an image is updated on a Docker registry | 4,650 | +22 |
| [Apache OpenWhisk](../r/apache~openwhisk.md) | Apache OpenWhisk is an open source serverless cloud platform | 6,776 | +8 |
| [dockcheck](../r/mag37~dockcheck.md) | CLI tool to automate docker image updates. Interactive or unattended with notifications, image backups, autoprune, no pr | 2,314 | +7 |
| [OpenFaaS](../r/openfaas~faas.md) | OpenFaaS - Serverless Functions Made Simple | 26,156 | +6 |
| [dockerode](../r/apocas~dockerode.md) | Docker + Node = Dockerode (Node.js module for Docker's Remote API) | 4,886 | +5 |
| [udocker](../r/indigo-dc~udocker.md) | A basic user tool to execute simple docker containers in batch or interactive systems without root privileges. | 1,741 | +4 |
| [Container Structure Test](../r/googlecontainertools~container-structure-test.md) | validate the structure of your container images | 2,476 | +2 |
| [DIP](../r/bibendi~dip.md) | The dip is a CLI dev–tool that provides native-like interaction with a Dockerized application. | 1,331 | +2 |
| [ESP32 Linux - Docker builder](../r/hpsaturn~esp32s3-linux.md) | ESP32 S3 Linux - Docker builder  | 84 | +2 |
| [Lando](../r/lando~lando.md) | A development tool for all your projects that is fast, easy, powerful and liberating | 4,232 | +2 |
| [contajners](../r/lispyclouds~contajners.md) | An idiomatic, data-driven, REPL friendly clojure client for OCI container engines | 149 | +1 |
| [Docker Client for JVM](../r/gesellix~docker-client.md) | A Docker client for Java written in Kotlin and Groovy | 121 | +1 |
| [docker-controller-bot](../r/dgongut~docker-controller-bot.md) | Bot de telegram para controlar los contenedores docker de tu servidor | 246 | +1 |
| [docker-custodian](../r/yelp~docker-custodian.md) | Keep docker hosts tidy | 375 | +1 |
| [Docuum](../r/stepchowfun~docuum.md) | Docuum performs least recently used (LRU) eviction of Docker images. 🗑️ | 693 | +1 |
| [go-dockerclient](../r/fsouza~go-dockerclient.md) | Go client for the Docker Engine API. | 2,235 | +1 |
| [Preevy](../r/livecycle~preevy.md) | Quickly deploy preview environments to the cloud! | 2,206 | +1 |
| [Pumba](../r/alexei-led~pumba.md) | Chaos testing, network emulation, and stress testing tool for containers | 3,019 | +1 |
| [ahab](../r/instacart~ahab.md) | Docker event handling with Python | 139 | +0 |
| [Binci](../r/binci~binci.md) | 🐳 Containerize your development workflow. | 673 | +0 |
| [caduc](../r/tjamet~caduc.md) | Event based Continuous Docker Cleaner | 21 | +0 |
| [Captain](../r/harbur~captain.md) | Captain - Convert your Git workflow to Docker 🐳 containers | 777 | +0 |
| [construi](../r/lstephen~construi.md) | Use Docker to define your build environment. | 25 | +0 |
| [Cyclone](../r/caicloud~cyclone.md) | Powerful workflow engine and end-to-end pipeline solutions implemented with native Kubernetes resources. https://cyclone | 1,070 | +0 |
| [Defang](../r/defanglabs~defang.md) | Defang CLI. Develop Once, Deploy Anywhere. Take your app from Docker Compose to a secure and scalable deployment on your | 152 | +0 |
| [dexec](../r/docker-exec~dexec.md) | 🐳 Command line interface for running code in many languages via Docker. | 332 | +0 |
| [dobi](../r/dnephin~dobi.md) | A build automation tool for Docker applications | 315 | +0 |
| [Docker Missing Tools](../r/nandoquintana~docker-missing-tools.md) | Docker missing tools | 30 | +0 |
| [Docker plugin for Jenkins](../r/jenkinsci~docker-plugin.md) | Jenkins cloud plugin that uses Docker | 498 | +0 |
| [Docker-Arch](../r/ph3nol~docker-arch.md) | Generate Web/CLI projects Dockerized development environments, from 1 simple YAML file. | 31 | +0 |
| [docker-it-scala](../r/whisklabs~docker-it-scala.md) | Docker integration testing kit with Scala | 433 | +0 |
| [docker-java-api](../r/amihaiemil~docker-java-api.md) | Lightweight Java Docker client | 276 | +0 |
| [docker-maven-plugin](../r/fabric8io~docker-maven-plugin.md) | Maven plugin for running and creating Docker images | 1,930 | +0 |
| [docker-vm](../r/shyiko~docker-vm.md) | A simple and transparent alternative to boot2docker (backed by Vagrant) | 43 | +0 |
| [Docker.DotNet](../r/microsoft~docker.dotnet.md) | 🐳 .NET (C#) Client Library for Docker API | 2,410 | +0 |
| [Docker.Registry.DotNet](../r/changemakerstudios~docker.registry.dotnet.md) | .NET (C#) Client Library for Docker Registry API V2 | 42 | +0 |
| [DockerSpec](../r/zuazo~dockerspec.md) | A small Ruby Gem to run RSpec and Serverspec, Infrataster and Capybara tests against Dockerfiles or Docker images easily | 182 | +0 |
| [DoMonit](../r/eon01~domonit.md) | A Deadly Simple Docker Monitoring Wrapper For Docker API | 76 | +0 |
| [Dray](../r/centurylinklabs~dray.md) | An engine for managing the execution of container-based workflows. | 385 | +0 |
| [EnvCLI](../r/envcli~envcli.md) | Don't install Node, Go, ... locally - use containers you define within your project. If you have a new machine / other c | 116 | +0 |
| [Funker](../r/bfirsh~funker-example-voting-app.md) | An example app using Funker | 26 | +0 |
| [Gantry](../r/shizunge~gantry.md) | Docker service for automatically updating Docker swarm services whenever their image is updated. | 88 | +0 |
| [Kitt](../r/senges~kitt.md) | The container based portable Shell environment | 20 | +0 |
| [Microservices Continuous Deployment](../r/francescou~docker-continuous-deployment.md) | continuous deployment of a microservices application with Docker | 146 | +0 |
| [mu](../r/stelligent~mu.md) | A full-stack DevOps on AWS framework | 966 | +0 |
| [Popper](../r/systemslab~popper.md) | Container-native task automation engine. | 308 | +0 |
| [Portainer stack utils](../r/greenled~portainer-stack-utils.md) | CLI client for Portainer | 74 | +0 |
| [Pull Dog](../r/apps~pull-dog.md) | A GitHub app that automatically creates Docker-based test environments for your pull requests, from your docker-compose  | 0 |  |
| [Rust Universal Compiler](../r/peco602~rust-universal-compiler.md) | Container solution to compile Rust projects for Linux, macOS and Windows | 33 | +0 |
| [sbt-docker](../r/marcuslonnberg~sbt-docker.md) | Create Docker images directly from sbt | 733 | +0 |
| [SCAR](../r/grycap~scar.md) | Serverless Container-aware ARchitectures (e.g. Docker in AWS Lambda) | 600 | +0 |
| [subuser](../r/subuser-security~subuser.md) | Run programs on linux with selectively restricted permissions. | 894 | +0 |
| [SwarmCI](../r/ghostsquad~swarmci.md) | Swarm CI - Docker Swarm-based CI system or enhancement to existing systems. | 58 | +0 |
| [Terraform cloud-init config](../r/christippett~terraform-cloudinit-container-server.md) | A batteries included cloud-init config to quickly and easily deploy a single Docker image or Docker Compose file to any  | 119 | +0 |
| [Turbo](../r/ramitsurana~turbo.md) | Simple and Powerfull Utility for Docker | 27 | +0 |
| [Vagga](../r/tailhook~vagga.md) | Vagga is a containerization tool without daemons | 1,896 | +0 |
| [Zsh-in-Docker](../r/deluan~zsh-in-docker.md) | Install Zsh, Oh My Zsh and plugins inside a Docker container with one line! | 1,105 | +0 |
| [dde](../r/whatwedo~dde.md) | Local development environment toolset based on Docker | 45 | -1 |
| [Docker Clean](../r/zzrotdesign~docker-clean.md) | A script that cleans docker containers, images, volumes, and networks.  | 1,299 | -1 |
| [docker_gc](../r/pdacity~docker_gc.md) | Garbage collector for Docker Swarm / Автоматическая сборка мусора для Docker и Docker Swarm | 129 | -1 |
| [DockerDL](../r/matifali~dockerdl.md) | Deep Learning Docker Image | 85 | -1 |
| [dockerized](../r/benzaita~dockerized-cli.md) | Containerized development environments using Docker | 62 | -1 |
| [EZDC](../r/lynchborg~ezdc.md) | Easy Testing With Docker Compose in Go. | 11 | -1 |
| [Gebug](../r/moshebe~gebug.md) | Debug Dockerized Go applications better | 633 | -1 |
| [Gradle Docker plugin](../r/gesellix~gradle-docker-plugin.md) | Gradle Docker plugin | 81 | -1 |
| [Hokusai](../r/artsy~hokusai.md) | Artsy's Docker / Kubernetes CLI and Workflow | 97 | -1 |
| [IronFunctions](../r/iron-io~functions.md) | IronFunctions - the serverless microservices platform by | 3,216 | -1 |
| [Jaypore CI](../r/thesage21~jaypore_ci.md) | A small, very flexible, powerful CI system. Works offline and is configured in Python. | 37 | -1 |
| [Kraken CI](../r/kraken-ci~kraken.md) | Kraken CI is a continuous integration and testing system. | 160 | -1 |
| [Kurtosis](../r/kurtosis-tech~kurtosis.md) | A platform for packaging and launching blockchain infra. Think docker compose for blockchain | 538 | -1 |
| [Skipper](../r/stratoscale~skipper.md) | Easily dockerize your Git repository | 49 | -1 |
| [uniget](../r/uniget-org~cli.md) | MIRROR: The universal installer and updater for (container) tools | 19 | -1 |
| [Docker-sync](../r/eugenmayer~docker-sync.md) | Run your application at full speed while syncing your code for development, finally empowering you to utilize docker for | 3,562 | -2 |
| [Eclipse Che](../r/eclipse~che.md) | Kubernetes based Cloud Development Environments for Enterprise Teams | 7,165 | -2 |
| [Shutit](../r/ianmiell~shutit.md) | Automation framework for programmers | 2,140 | -2 |

[Back to top](#awesome-docker)

## Docker Images

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [DockerSlim](../r/docker-slim~docker-slim.md) | Slim(toolkit): Don't change anything in your container image and minify it by up to 30x (and for compiled languages even | 23,228 | +53 |
| [Harbor](../r/goharbor~harbor.md) | An open source trusted cloud native registry project that stores, signs, and scans content. | 28,462 | +43 |
| [distroless](../r/googlecontainertools~distroless.md) | 🥑  Language focused docker images, minus the operating system.   | 22,617 | +36 |
| [Hadolint](../r/hadolint~hadolint.md) | Dockerfile linter, validate inline bash, written in Haskell | 12,130 | +24 |
| [BuildKit](../r/moby~buildkit.md) | concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit | 9,960 | +13 |
| [Ofelia](../r/mcuadros~ofelia.md) | A docker job scheduler (aka. crontab for docker) | 3,840 | +11 |
| [buildah](../r/containers~buildah.md) | A tool that facilitates building OCI images. | 8,775 | +10 |
| [supercronic](../r/aptible~supercronic.md) | Cron for containers | 2,486 | +9 |
| [Dragonfly](../r/dragonflyoss~dragonfly2.md) | Delivers efficient, stable, and secure data distribution and acceleration powered by P2P technology, with an optional co | 3,161 | +7 |
| [Kraken](../r/uber~kraken.md) | P2P Docker registry capable of distributing TBs of data in seconds | 6,690 | +5 |
| [GoSu](../r/tianon~gosu.md) | Simple Go-based setuid+setgid+setgroups+exec | 4,966 | +2 |
| [img](../r/genuinetools~img.md) | Standalone, daemon-less, unprivileged Dockerfile and OCI compatible container image builder. | 3,986 | +2 |
| [microcheck](../r/tarampampam~microcheck.md) | 🧪 Lightweight health check utilities for Docker containers | 141 | +2 |
| [@vimagick](../r/vimagick~dockerfiles.md) | 🐳 A curated list of delicious docker recipes 🇺🇦🇮🇱 (Let's Fight Against Dictatorship) | 3,203 | +1 |
| [Chaperone](../r/garywiz~chaperone.md) | Lightweight process-tree manager for Docker-like containers | 179 | +1 |
| [Derrick](../r/alibaba~derrick.md) | 🐳A tool to help you containerize application in seconds | 694 | +1 |
| [Dockadvisor](../r/deckrun~dockadvisor.md) | Lightweight Dockerfile linter that helps you write better Dockerfiles. Get instant feedback with quality scores, securit | 203 | +1 |
| [docker-alpine](../r/gliderlabs~docker-alpine.md) | Alpine Linux Docker image. Win at minimalism! | 5,707 | +1 |
| [docker-repack](../r/orf~docker-repack.md) | Repack docker images to optimize for pulling speed. | 154 | +1 |
| [dockerfilegraph](../r/patrickhoefler~dockerfilegraph.md) | Visualize your multi-stage Dockerfiles | 264 | +1 |
| [Docket](../r/netvarun~docket.md) | Docket - Custom docker registry that allows for lightning fast deploys through bittorrent | 710 | +1 |
| [HPC Container Maker](../r/nvidia~hpc-container-maker.md) | HPC Container Maker | 513 | +1 |
| [lstags](../r/ivanilves~lstags.md) | Explore Docker registries and manipulate Docker images! | 344 | +1 |
| [su-exec](../r/ncopa~su-exec.md) | switch user and group id and exec | 1,018 | +1 |
| [Whales](../r/gueils~whales.md) | 🐳 Tool to automatically dockerize your application.  | 394 | +1 |
| [@arun-gupta](../r/arun-gupta~docker-images.md) | Docker Images | 251 | +0 |
| [@awesome-startup](../r/awesome-startup~docker-compose.md) | Docker Compose Sample | 65 | +0 |
| [@crosbymichael](../r/crosbymichael~dockerfiles.md) | Collection of Dockerfiles  | 300 | +0 |
| [@komljen](../r/komljen~dockerfile-examples.md) | Dockerfile examples | 586 | +0 |
| [@kstaken](../r/kstaken~dockerfile-examples.md) | Some example dockerfiles for use with Docker | 827 | +0 |
| [@ondrejmo](../r/ondrejmo~dockerfiles.md) | These are Dockerfiles I've created for programs without official docker image. | 23 | +0 |
| [amicontained](../r/genuinetools~amicontained.md) | Container introspection tool. Find out what container runtime is being used as well as features available. | 1,078 | +0 |
| [CargoOS](../r/redcoolbeans~cargos-buildroot.md) | A bare essential OS for running the Docker Engine on bare metal or Cloud. By [@RedCoolBeans](https://github.com/RedCoolB | 12 | +0 |
| [cekit](../r/cekit~cekit.md) | CEKit - Container Evolution Kit | 113 | +0 |
| [chaperone-docker](../r/garywiz~chaperone-docker.md) | Docker base images which use the chaperone lightweight process manager. | 66 | +0 |
| [cleanreg](../r/hcguersoy~cleanreg.md) | A small tool to clean up Docker Registries (v2). | 59 | +0 |
| [container-factory](../r/mutable~container-factory.md) | container-factory produces Docker images from tarballs of application source code | 64 | +0 |
| [copy-docker-image](../r/mdlavin~copy-docker-image.md) | Copy a Docker image between registries without a full Docker installation | 38 | +0 |
| [dlayer](../r/orisano~dlayer.md) | dlayer is docker layer analyzer. | 446 | +0 |
| [docker-companion](../r/mudler~docker-companion.md) | squash and unpack Docker images, in Golang | 47 | +0 |
| [docker-gen](../r/jwilder~docker-gen.md) | Generate files from docker container meta-data | 4,626 | +0 |
| [docker-image-size-limit](../r/wemake-services~docker-image-size-limit.md) | 🐳 Keep an eye on your docker image size and prevent it from growing too big | 131 | +0 |
| [docker-make](../r/ctripcloud~docker-make.md) | build,tag,and push a bunch of related docker images via a single command | 99 | +0 |
| [docker-replay](../r/bcicen~docker-replay.md) | Generate docker commands to rerun existing containers | 202 | +0 |
| [Dockerfile Generator](../r/ozankasikci~dockerfile-generator.md) | dfg - Generates dockerfiles based on various input channels.  | 186 | +0 |
| [Dockerfile Linter action](../r/buddy-works~dockerfile-linter.md) | The linter lets you verify Dockerfile syntax to make sure it follows the best practices for building efficient Docker im | 46 | +0 |
| [dockerize](../r/powerman~dockerize.md) | Utility to simplify running applications in docker containers | 195 | +0 |
| [Dockly](../r/swipely~dockly.md) | DSL and Gem for building ready-to-launch Docker images | 228 | +0 |
| [essex](../r/utensils~essex.md) | A Docker project template generator written in Rust | 38 | +0 |
| [FROM:latest](../r/replicatedhq~dockerfilelint.md) | An opinionated Dockerfile linter. | 1,031 | +0 |
| [is-docker](../r/sindresorhus~is-docker.md) | Check if the process is running inside a Docker container | 233 | +0 |
| [nscr](../r/jhstatewide~nscr.md) | New and Shiny Container Registry | 1 | +0 |
| [portainer](../r/duedil-ltd~portainer.md) | Apache Mesos framework for building Docker images on a cluster of machines | 134 | +0 |
| [Registryo](../r/inmagik~registryo.md) | UI and token based authentication server for onpremise docker registry | 15 | +0 |
| [Rescoyl](../r/noteed~rescoyl.md) | Private Docker registry | 18 | +0 |
| [SparkView](../r/beyondssl~sparkview-container.md) | Current repository of SparkView for Docker, globally distributed by beyond SSL GmbH. | 20 | +0 |
| [sue](../r/theakito~sue.md) | As small and swift as su-exec, but as featureful and robust as gosu! | 13 | +0 |
| [TrivialRC](../r/vorakl~trivialrc.md) | A trivial process manager for containers and applications | 32 | +0 |
| [userdef](../r/theakito~userdef.md) | A more advanced adduser for your Alpine based Docker images. | 11 | +0 |
| [Whaler](../r/p3gleg~whaler.md) | Program to reverse Docker images into Dockerfiles | 1,184 | +0 |
| [ansible-bender](../r/ansible-community~ansible-bender.md) | ansible-playbook + buildah = a sweet container image | 695 | -1 |
| [ckron](../r/nicomt~ckron.md) | 🐋 A cron-like job scheduler for docker | 56 | -1 |
| [Dockershelf](../r/dockershelf~dockershelf.md) | A repository containing useful, lightweight and reliable dockerfiles. | 95 | -1 |
| [RAUDI](../r/cybersecsi~raudi.md) | A repo to automatically generate and keep updated a series of Docker images through GitHub Actions. | 560 | -1 |
| [runlike](../r/lavie~runlike.md) | Given an existing docker container, prints the command line necessary to run a copy of it. | 2,926 | -1 |
| [@jessfraz](../r/jessfraz~dockerfiles.md) | Various Dockerfiles I use on the desktop and on servers. | 13,933 | -5 |

[Back to top](#awesome-docker)

## Good Tips

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Dockerfile best practices](../r/hexops~dockerfile.md) | Dockerfile best-practices for writing production-worthy Docker images. | 4,089 | -2 |

[Back to top](#awesome-docker)

## Monitoring

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Maintenant](../r/kolapsis~maintenant.md) | Drop a container. Your stack is monitored. | 260 | +28 |
| [ADRG](../r/jaldertech~adrg.md) | Aldertech Dynamic Resource Governor — A kernel-level resource manager for high-density Docker stacks on Raspberry Pi and | 6 | +1 |
| [Docker-Sentinel](../r/will-luck~docker-sentinel.md) | [maintenance mode] Docker-Sentinel: container update orchestration with manual approval queues | 18 | +1 |
| [DockProbe](../r/deep-on~dockprobe.md) | Lightweight Docker monitoring dashboard with anomaly detection & Telegram alerts. One-liner install, zero config. | 13 | +0 |
| [Drydock](../r/codeswhat~drydock.md) | Open source container update monitoring — 23 registries, 20 notification triggers, audit log, OIDC auth, Prometheus metr | 197 | +0 |
| [Wiremap](../r/codeofmario~wiremap.md) | A self-hosted visual Docker network topology explorer with real-time log streaming, live stats, embedded terminal, and c | 3 | +0 |

[Back to top](#awesome-docker)

## Monitoring Services

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [AppDynamics](../r/appdynamics~docker-monitoring-extension.md) | Docker Monitoring Extension | 5 | +0 |
| [SPM for Docker](../r/sematext~sematext-agent-docker.md) | Sematext Docker Agent - host + container metrics, logs & event collector | 208 | +0 |

[Back to top](#awesome-docker)

## Projects

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Docker Compose](../r/docker~compose.md) | Define and run multi-container applications with Docker | 37,371 | +33 |
| [Moby](../r/moby~moby.md) | The Moby Project - a collaborative project for the container ecosystem to assemble container-based systems | 71,541 | +4 |

[Back to top](#awesome-docker)

## Registry

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [NORA](../r/getnora-io~nora.md) | Lightweight multi-format artifact registry. 13 formats: Docker, Maven, npm, PyPI, Cargo, Go, RubyGems, Terraform, NuGet, | 157 | +15 |

[Back to top](#awesome-docker)

## Reverse Proxy

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [BunkerWeb](../r/bunkerity~bunkerweb.md) | 🛡️ Open-source and cloud-native Web Application Firewall (WAF) | 10,466 | +51 |
| [idle-less](../r/tvup~idle-less.md) | Docker reverse proxy with automatic Wake-on-LAN — wakes sleeping servers when traffic arrives. Save €300/year per server | 19 | +2 |

[Back to top](#awesome-docker)

## Runtime

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Mocker](../r/us~mocker.md) | Docker-compatible container CLI built on Apple's Containerization framework. Same commands, same flags — mocker run, ps, | 177 | +25 |

[Back to top](#awesome-docker)

## Security

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Grype](../r/anchore~grype.md) | A vulnerability scanner for container images and filesystems | 12,186 | +46 |
| [crowdsec-blocklist-import](../r/wolffcatskyy~crowdsec-blocklist-import.md) | 10-20x more blocks for your CrowdSec bouncers — 120k+ IPs from 36 free threat feeds | 208 | +5 |
| [Docker Secure Deployment Guidelines](../r/aoncyberlabs~docker-secure-deployment-guidelines.md) | Deployment checklist for securely deploying Docker | 606 | +1 |
| [buildcage](../r/dash14~buildcage.md) | Secure your Docker builds against supply chain attacks — restrict outbound network access to only the domains you allow | 4 | +0 |
| [CVE Scanning Alpine images with Multi-stage builds in Docker 17.05](../r/tomwillfixit~alpine-cvecheck.md) | Code used to CVE check Alpine based images | 11 | +0 |
| [Den](../r/us~den.md) | Secure sandbox runtime for AI   agents | 6 | +0 |
| [pindock](../r/deadnews~pindock.md) | Pin and update Docker image digests in Dockerfiles and compose files | 2 | +0 |
| [segspec](../r/dormstern~segspec.md) | Static analysis from configs → Kubernetes NetworkPolicies in seconds | 15 | +0 |

[Back to top](#awesome-docker)

## Useful Resources

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Cloud Native Landscape](../r/cncf~landscape.md) | 🌄 The Cloud Native Interactive Landscape filters and sorts hundreds of projects and products, and shows details includi | 9,887 | +7 |

[Back to top](#awesome-docker)

## User Interface

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Arcane](../r/getarcaneapp~arcane.md) | Modern Docker Management, Designed for Everyone | 5,491 | +64 |
| [usulnet](../r/fr4nsys~usulnet.md) | Open-source Docker infrastructure platform. One web UI — containers, security, DNS, VPN, monitoring, backups, reverse pr | 96 | +3 |
| [easydocker](../r/joao-zanutto~easydocker.md) | EasyDocker is a TUI focused on investigating and troubleshooting Docker resources. Highly inspired by lazydocker and k9s | 110 | +2 |
| [swarmcli](../r/eldara-tech~swarmcli.md) | A terminal UI for Docker Swarm that makes cluster state easier to see, understand, and reason about. | 15 | +1 |
| [wharf](../r/idesyatov~wharf.md) | ⚓ Terminal UI (TUI) for Docker Compose — manage containers, view logs, exec, monitor CPU/RAM. | 3 | +1 |
| [tdocker](../r/pivovarit~tdocker.md) | minimalistic terminal UI for everyday Docker operations | 84 | +0 |

[Back to top](#awesome-docker)

## Volume Management / Data

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [duplicacy-cli-cron](../r/geiserx~duplicacy-cli-cron.md) | Docker-based encrypted dual-storage backup automation using Duplicacy CLI with cross-site redundancy | 2 | +0 |
| [Label Backup](../r/resulgg~label-backup.md) | Docker-aware backup agent using labels to automate backups for PostgreSQL, MySQL, MongoDB, and Redis to local or S3 comp | 21 | +0 |

[Back to top](#awesome-docker)

## Where to start

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [wsargent](../r/wsargent~docker-cheat-sheet.md) | Docker Cheat Sheet | 22,517 | +5 |
| [eon01](../r/eon01~dockercheatsheet.md) | 🐋 Docker Cheat Sheet 🐋 | 3,937 | +2 |
| [Dockerlings](../r/furkan~dockerlings.md) | learn docker in your terminal, with bite sized exercises | 887 | +1 |
| [Practical Guide about Docker Commands in Spanish](../r/brunocascio~docker-espanol.md) | Un tutorial Docker en español. Basado en el libro Docker Cookbook de O'reilly | 256 | +1 |
| [dimonomid](../r/dimonomid~docker-quick-ref.md) | Docker: Printable Quick Reference | 198 | +0 |
| [Docker katas](../r/eficode-academy~docker-katas.md) | Exercises for Docker training | 289 | +0 |
| [JensPiegsa](../r/jenspiegsa~docker-cheat-sheet.md) | A collection of recipes for docker. | 22 | +0 |
| [Learn Docker](../r/dwyl~learn-docker.md) | 🚢    Learn how to use docker.io containers to consistently deploy your apps on any infrastructure. | 243 | +0 |
| [Setting Python Development Environment with VScode and Docker](../r/ramikrispin~vscode-python.md) | A Tutorial for Setting Python Development Environment with VScode and Docker | 951 | +0 |
| [Docker Curriculum](../r/prakhar1989~docker-curriculum.md) | 🐬 A comprehensive tutorial on getting started with Docker! | 6,041 | -1 |

[Back to top](#awesome-docker)

---
*Updated: 2026-05-11 | [View live site ↗](https://patrickclery.com/awesomer/l/docker/)*
