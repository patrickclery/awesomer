# awesome-docker

> 🐳 A curated list of Docker resources and projects

[Home](../README.md) | [Live site ↗](https://patrickclery.com/awesomer/l/docker/) | [Source ↗](https://github.com/veggiemonk/awesome-docker)

## Top 10 Trending

| # | Repo | Stars | 7d | 30d | 90d |
|---|------|-------|----|-----|-----|
| 1 | [Kubernetes](../r/kubernetes~kubernetes.md) | 128,172 | +159 | +2,845 | +4,693 |
| 2 | [Trivy](../r/aquasecurity~trivy.md) | 38,207 | +126 | +479 | +1,484 |
| 3 | [coder](../r/coder~coder.md) | 16,821 | +116 | +2,461 | +1,887 |
| 4 | [colima](../r/abiosoft~colima.md) | 31,083 | +83 | +495 | +1,517 |
| 5 | [Arcane](../r/getarcaneapp~arcane.md) | 7,694 | +82 | +495 | +1,642 |
| 6 | [Træfɪk](../r/containous~traefik.md) | 65,052 | +81 | +394 | +1,214 |
| 7 | [Komodo](../r/mbecker20~komodo.md) | 12,594 | +80 | +448 | +932 |
| 8 | [dockge](../r/louislam~dockge.md) | 24,527 | +78 | +299 | +848 |
| 9 | [lazydocker](../r/jesseduffield~lazydocker.md) | 53,021 | +68 | +353 | +1,462 |
| 10 | [Nginx Proxy Manager](../r/jc21~nginx-proxy-manager.md) | 34,308 | +67 | +281 | +853 |

## Table of Contents

- [Awesome Lists](#awesome-lists)
- [Base Images](#base-images)
- [Builder](#builder)
- [CI/CD](#cicd)
- [Container Operations](#container-operations)
- [Demos and Examples](#demos-and-examples)
- [Deployment & Platforms](#deployment-platforms)
- [Desktop](#desktop)
- [Development Environment](#development-environment)
- [Development with Docker](#development-with-docker)
- [Docker Images](#docker-images)
- [Dockerfile](#dockerfile)
- [Engine & Runtime](#engine-runtime)
- [Image Scanning & SBOM](#image-scanning-sbom)
- [In-Container Tooling](#in-container-tooling)
- [Monitoring](#monitoring)
- [Monitoring Services](#monitoring-services)
- [Observability](#observability)
- [Projects](#projects)
- [Registry](#registry)
- [Registry CLI](#registry-cli)
- [Reverse Proxy](#reverse-proxy)
- [Runtime](#runtime)
- [Security](#security)
- [Storage & Data](#storage-data)
- [Supply Chain](#supply-chain)
- [Terminal](#terminal)
- [Useful Resources](#useful-resources)
- [User Interface](#user-interface)
- [Volume Management / Data](#volume-management-data)
- [Web](#web)
- [Where to Start](#where-to-start)

## Awesome Lists

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Awesome Sysadmin](../r/n1trux~awesome-sysadmin.md) | A curated list of amazingly awesome open-source sysadmin resources. | 35,321 | +63 |
| [Awesome Compose](../r/docker~awesome-compose.md) | Awesome Docker Compose samples | 46,458 | +45 |

[Back to top](#awesome-docker)

## Base Images

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [pglayers](../r/pglayers~pglayers.md) | PostgreSQL Docker images with the extensions you actually need -- pre-built, composable, no compilation. | 163 | +2 |
| [Chainguard Images](../r/chainguard-images~images.md) | Public Chainguard Images | 696 | +1 |
| [Wolfi](../r/wolfi-dev~os.md) | Main package repository for production Wolfi images | 1,292 | +1 |
| [melange](../r/chainguard-dev~melange.md) | build APKs from source code | 629 | +0 |

[Back to top](#awesome-docker)

## Builder

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [ko](../r/ko-build~ko.md) | Build and deploy Go applications | 8,559 | +8 |
| [nix2container](../r/nlewo~nix2container.md) | An archive-less dockerTools.buildImage implementation  | 923 | +6 |
| [buildx](../r/docker~buildx.md) | Docker CLI plugin for extended build capabilities with BuildKit | 4,518 | +5 |
| [earthly](../r/earthly~earthly.md) | Super simple build framework with fast, repeatable builds and an instantly familiar syntax – like Dockerfile and Makefil | 12,054 | +4 |
| [apko](../r/chainguard-dev~apko.md) | Build OCI images from APK packages directly without Dockerfile | 1,685 | +3 |

[Back to top](#awesome-docker)

## CI/CD

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Self Hosted Runner](../r/youssefbrr~self-hosted-runner.md) | Dockerized solution for setting up a self-hosted GitHub Actions runner. Easily deploy and scale your runners using Docke | 140 | -1 |

[Back to top](#awesome-docker)

## Container Operations

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Kubernetes](../r/kubernetes~kubernetes.md) | Production-Grade Container Scheduling and Management | 128,172 | +159 |
| [Trivy](../r/aquasecurity~trivy.md) | Find vulnerabilities, misconfigurations, secrets, SBOM in containers, Kubernetes, code repositories, clouds and more | 38,207 | +126 |
| [Træfɪk](../r/containous~traefik.md) | The Cloud Native Application Proxy | 65,052 | +81 |
| [Komodo](../r/mbecker20~komodo.md) | 🦎 a tool to build and deploy software on many servers 🦎 | 12,594 | +80 |
| [dockge](../r/louislam~dockge.md) | A fancy, easy-to-use and reactive self-hosted docker compose.yaml stack-oriented manager | 24,527 | +78 |
| [lazydocker](../r/jesseduffield~lazydocker.md) | The lazier way to manage everything docker | 53,021 | +68 |
| [Nginx Proxy Manager](../r/jc21~nginx-proxy-manager.md) | Docker container for managing Nginx proxy hosts with a simple, powerful interface | 34,308 | +67 |
| [podman](../r/containers~libpod.md) | Podman: A tool for managing OCI containers and pods. | 32,989 | +49 |
| [Portainer](../r/portainer~portainer.md) | Making Docker and Kubernetes management easy. | 38,617 | +40 |
| [Checkov](../r/bridgecrewio~checkov.md) | Prevent cloud misconfigurations and find vulnerabilities during build-time in infrastructure as code, container images a | 9,053 | +24 |
| [Syft](../r/anchore~syft.md) | CLI tool and library for generating a Software Bill of Materials from container images and filesystems | 9,633 | +21 |
| [dive](../r/wagoodman~dive.md) | A tool for exploring each layer in a docker image | 54,628 | +20 |
| [skopeo](../r/containers~skopeo.md) | Work with remote images registries - retrieving information, images, signing content | 11,281 | +19 |
| [Sysdig Falco](../r/falcosecurity~falco.md) | Cloud Native Runtime Security | 9,436 | +19 |
| [cAdvisor](../r/google~cadvisor.md) | Analyzes resource usage and performance characteristics of running containers. | 19,463 | +15 |
| [Rancher](../r/rancher~rancher.md) | Complete container management platform | 25,952 | +15 |
| [Nomad](../r/hashicorp~nomad.md) | Nomad is an easy-to-use, flexible, and performant workload orchestrator that can deploy a mix of microservice, batch, co | 16,988 | +14 |
| [Docker Volume Backup](../r/offen~docker-volume-backup.md) | Backup Docker volumes locally or to any S3, WebDAV, Azure Blob Storage, Dropbox, Google Drive or SSH compatible storage | 4,028 | +9 |
| [caddy-docker-proxy](../r/lucaslorentz~caddy-docker-proxy.md) | Caddy as a reverse proxy for Docker | 4,717 | +7 |
| [oxker](../r/mrjackwills~oxker.md) | A simple tui to view & control docker containers  | 1,871 | +7 |
| [docker rollout](../r/wowu~docker-rollout.md) | 🚀 Zero Downtime Deployment for Docker Compose | 3,346 | +6 |
| [caprover](../r/caprover~caprover.md) | Scalable PaaS (automated Docker+nginx) - aka Heroku on Steroids | 15,177 | +5 |
| [cri-o](../r/cri-o~cri-o.md) | Open Container Initiative-based implementation of Kubernetes Container Runtime Interface | 5,667 | +5 |
| [KICS](../r/checkmarx~kics.md) | Find security vulnerabilities, compliance issues, and infrastructure misconfigurations early in the development cycle of | 2,713 | +5 |
| [netshoot](../r/nicolaka~netshoot.md) | a Docker + Kubernetes network trouble-shooting swiss-army container | 11,021 | +5 |
| [podman-compose](../r/containers~podman-compose.md) | a script to run docker-compose.yml using podman | 6,229 | +5 |
| [Autoheal](https://github.com/willfarrell/docker-autoheal) | Monitor and restart unhealthy docker containers. | 2,010 | +4 |
| [Clair](../r/quay~clair.md) | Vulnerability Static Analysis for Containers | 11,069 | +4 |
| [docker-bench-security](../r/docker~docker-bench-security.md) | The Docker Bench for Security is a script that checks for dozens of common best-practices around deploying Docker contai | 9,701 | +4 |
| [werf](../r/werf~werf.md) | A solution for implementing efficient and consistent software delivery to Kubernetes facilitating best practices. | 4,727 | +3 |
| [docker-swarm-visualizer](https://github.com/dockersamples/docker-swarm-visualizer) | A visualizer for Docker Swarm Mode using the Docker Remote API, Node.JS, and D3 | 3,341 | +2 |
| [dry](../r/moncho~dry.md) | dry - A Docker manager for the terminal @ | 3,282 | +2 |
| [kompose](../r/kubernetes~kompose.md) | Convert Compose to Kubernetes | 10,631 | +2 |
| [Swarmpit](../r/swarmpit~swarmpit.md) | Lightweight AI-friendly Docker Swarm management | 3,497 | +2 |
| [d4s](../r/jr-k~d4s.md) | 🍊 A fast, keyboard-driven terminal UI to manage Docker containers, Compose stacks, and Swarm services with the ergonomi | 133 | +1 |
| [Deepfence Threat Mapper](../r/deepfence~threatmapper.md) | Open Source Cloud Native Application Protection Platform (CNAPP) | 5,322 | +1 |
| [Docker Registry Browser](../r/klausmeyer~docker-registry-browser.md) | 🐳 Web Interface for the Docker Registry HTTP API V2 written in Ruby on Rails. | 702 | +1 |
| [docker.el](../r/silex~docker.el.md) | Manage docker from Emacs. | 828 | +1 |
| [DockMate](../r/shubh-io~dockmate.md) | Dockmate: The open-source Docker TUI & Podman manager for terminal productivity. A fast, lightweight alternative to lazy | 341 | +1 |
| [dockprom](../r/stefanprodan~dockprom.md) | Docker hosts and containers monitoring with Prometheus, Grafana, cAdvisor, NodeExporter and AlertManager | 6,578 | +1 |
| [Dokku](../r/dokku~dokku.md) | A docker-powered PaaS that helps you build and manage the lifecycle of applications | 32,161 | +1 |
| [lazyjournal](../r/lifailon~lazyjournal.md) | TUI for viewing logs from journald, auditd, file system, Docker and Podman containers, Compose stacks and Kubernetes pod | 1,415 | +1 |
| [lxc](../r/lxc~lxc.md) | LXC - Linux Containers | 5,266 | +1 |
| [Anchor](https://github.com/SongStitch/anchor) | A tool for anchoring dependencies in dockerfiles | 23 | +0 |
| [caddy-docker-upstreams](https://github.com/invzhi/caddy-docker-upstreams) | Docker dynamic upstreams for Caddy. | 39 | +0 |
| [CetusGuard](https://github.com/hectorm/cetusguard) | CetusGuard is a tool that protects the Docker daemon socket by filtering calls to its API endpoints. | 91 | +0 |
| [CloudSlang](../r/cloudslang~cloud-slang.md) | CloudSlang Language, CLI and Builder | 242 | +0 |
| [Composerize](../r/magicmark~composerize.md) | 🏃→🎼  docker run asdlksjfksdf > docker-composerize up | 3,769 | +0 |
| [Container Web TTY](../r/wrfly~container-web-tty.md) | Connect your containers via a web-tty | 257 | +0 |
| [Convox Rack](../r/convox~rack.md) | Private PaaS built on native AWS services for maximum privacy and minimum upkeep | 1,890 | +0 |
| [ctk](../r/ctk-hq~ctk.md) | Visual composer for container based workloads | 300 | +0 |
| [dcinja](https://github.com/Falldog/dcinja) | The smallest binary size of template engine, born for docker image | 15 | +0 |
| [dctl](https://github.com/FabienD/docker-stack) | A curated collection of ready-to-use Docker Compose files for local web development, plus a powerful CLI (dctl) to manag | 24 | +0 |
| [decompose](../r/s0rg~decompose.md) | Reverse-engineering tool for docker environments | 142 | +0 |
| [DLIA](https://github.com/zorak1103/dlia) | DLIA is an AI-powered Docker log monitoring agent that uses Large Language Models (LLMs) to intelligently analyze contai | 7 | +0 |
| [Docker DB Manager](../r/abians~docker-db-manager.md) | A desktop application for managing Docker database containers | 164 | +0 |
| [Docker Dnsmasq Updater](https://github.com/moonbuggy/docker-dnsmasq-updater) | Automatically update a local or remote hosts file with Docker container hostnames | 34 | +0 |
| [docker pushrm](https://github.com/christian-korneck/docker-pushrm) | "Docker Push Readme" - a Docker CLI plugin to update container repo docs | 153 | +0 |
| [docker-captain](https://github.com/lucabello/docker-captain) | ⚓ A friendly CLI to manage multiple Docker Compose deployments with style — powered by Typer, Rich, questionary, and sh. | 3 | +0 |
| [docker-dns](https://github.com/bytesharky/docker-dns) | Docker DNS Forwarder is a lightweight tool that enables the host machine to resolve Docker container names to their IPs  | 5 | +0 |
| [docker-flow-proxy](../r/docker-flow~docker-flow-proxy.md) | Docker Flow Proxy | 319 | +0 |
| [docker-to-iac](https://github.com/deploystackio/docker-to-iac) | Translate docker run and docker compose file to Infrastructure as Code | 22 | +0 |
| [dockly](../r/lirantal~dockly.md) | Immersive terminal interface for managing docker containers and services | 4,033 | +0 |
| [DockSTARTer](../r/ghostwriters~dockstarter.md) | DockSTARTer helps you get started with running apps in Docker. | 2,571 | +0 |
| [Doku](../r/amerkurev~doku.md) | 💽 Doku - Docker disk usage dashboard | 449 | +0 |
| [dprs](https://github.com/durableprogramming/dprs) | A developer-focused TUI for managing Docker containers with real-time log streaming and container management. Built with | 42 | +0 |
| [Exoframe](../r/exoframejs~exoframe.md) | Exoframe is a self-hosted tool that allows simple one-command deployments using Docker | 1,155 | +0 |
| [Flannel](../r/coreos~flannel.md) | flannel is a network fabric for containers, designed for Kubernetes | 9,548 | +0 |
| [goManageDocker](https://github.com/ajayd-san/gomanagedocker) | TUI tool to manage your docker images, containers and volumes 🚀 | 641 | +0 |
| [Grafeas](../r/grafeas~grafeas.md) | Artifact Metadata API | 1,569 | +0 |
| [mesh-router](https://github.com/Yundera/mesh-router) | MeshRouter: Seamlessly route domain requests to containers across networks using ENS, or custom names, secured by Wiregu | 13 | +0 |
| [Netshare](https://github.com/ContainX/docker-volume-netshare) | Docker NFS, AWS EFS, Ceph & Samba/CIFS Volume Plugin | 1,141 | +0 |
| [OpenResty Manager](../r/safe3~openresty-manager.md) | Modern, secure, and elegant server control panel, alternative to OpenResty Edge and Nginx Proxy Manager. | 1,463 | +0 |
| [oscap-docker](../r/openscap~openscap.md) | NIST Certified SCAP 1.2 toolkit | 1,824 | +0 |
| [Pipework](https://github.com/jpetazzo/pipework) | Software-Defined Networking tools for LXC (LinuX Containers) | 4,251 | +0 |
| [proco](../r/shiwaforce~poco.md) | Poco will help you to organise and manage Docker, Docker-Compose, Kubernetes, Openshift projects of any complexity using | 113 | +0 |
| [registrator](https://github.com/gliderlabs/registrator) | Service registry bridge for Docker with pluggable adapters | 4,675 | +0 |
| [REX-Ray](https://github.com/rexray/rexray) | REX-Ray is a container storage orchestration engine enabling persistence for cloud native workloads | 2,221 | +0 |
| [runtime-tools](../r/opencontainers~runtime-tools.md) | OCI Runtime Tools | 492 | +0 |
| [scuba](https://github.com/JonathonReinhart/scuba) | Simple Container-Utilizing Build Apparatus | 99 | +0 |
| [Simple Docker UI](https://github.com/felixgborrego/simple-docker-ui) | Native Docker UI implemented using Scala.js and React - DEPRECATED | 604 | +0 |
| [Smalte](https://github.com/roquie/smalte) | Dynamically configure applications that require static configuration in docker container. | 36 | +0 |
| [supdock](https://github.com/segersniels/supdock) | What's Up, Doc(ker)? A convenient way to interact with the docker daemon using prompts. | 88 | +0 |
| [Swarm Router](https://github.com/flavioaiello/swarm-router) | Scalable stateless «zero config» service-name ingress for docker swarm mode with a fresh more secure approach | 75 | +0 |
| [swarm-ansible](https://github.com/LombardiDaniel/swarm-ansible) | Build a Production-Ready Docker Swarm cluster using Ansible. The goal is rapidly bootstrap a Docker Swarm cluster with s | 59 | +0 |
| [Swarm-cronjob](../r/crazy-max~swarm-cronjob.md) | Create jobs on a time-based schedule on Docker Swarm | 885 | +0 |
| [SwarmManagement](https://github.com/hansehe/SwarmManagement) | Swarm Management is a python application, installed with pip. The application makes it easy to manage a Docker Swarm by  | 22 | +0 |
| [Tsuru](../r/tsuru~tsuru.md) | Open source and extensible Platform as a Service (PaaS). | 5,312 | +0 |
| [CASA](https://github.com/knrdl/casa) | Container as a Service admin | 86 | -1 |
| [dockerfile-mode](../r/spotify~dockerfile-mode.md) | An emacs mode for handling Dockerfiles | 564 | -1 |
| [Mesos](../r/apache~mesos.md) | Apache Mesos | 5,365 | -1 |
| [plash](https://github.com/ihucos/plash) | Build and run layered root filesystems. | 381 | -1 |
| [Stevedore](../r/slonopotamus~stevedore.md) | 🚢 Docker distribution for Windows Containers that Just Works | 385 | -1 |
| [Let's Encrypt Nginx-proxy Companion](../r/nginx-proxy~docker-letsencrypt-nginx-proxy-companion.md) | Automated ACME SSL certificate generation for nginx-proxy | 7,725 | -3 |

[Back to top](#awesome-docker)

## Demos and Examples

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Local Docker DB](https://github.com/alexmacarthur/local-docker-db) | A bunch o' Docker Compose files used to quickly spin up local databases.  | 299 | +0 |
| [Webstack-micro](https://github.com/ferbs/webstack-micro) | Example/starter web app geared for small-ish teams interested in using a microservices architecture | 88 | +0 |

[Back to top](#awesome-docker)

## Deployment & Platforms

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [doco-cd](../r/kimdre~doco-cd.md) | Docker Compose Continuous Deployment | 1,689 | +7 |
| [OpenRun](../r/openrundev~openrun.md) | Deployment platform for teams to deploy internal tools. Deploy web apps declaratively, on a single-node or on Kubernetes | 979 | +2 |

[Back to top](#awesome-docker)

## Desktop

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Gantry (Desktop)](https://github.com/getgantry/gantry) | Native macOS app for managing and monitoring Docker — local and over SSH. Agent-ready: built-in MCP server and App Inten | 68 | +1 |

[Back to top](#awesome-docker)

## Development Environment

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Laradock](../r/laradock~laradock.md) | Full PHP development environment for Docker. Run Laravel, Symfony, CodeIgniter, Phalcon, WordPress, Drupal, Magento, Moo | 12,678 | +4 |
| [HarborPilot](https://github.com/potterwhite/HarborPilot) | This is a One-Click docker images and containers setup base which is doing via a lot of bash scripts. My primary target  | 3 | +0 |

[Back to top](#awesome-docker)

## Development with Docker

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [coder](../r/coder~coder.md) | Secure environments for developers and their agents | 16,821 | +116 |
| [Drone](../r/drone~drone.md) | Harness Open Source is an end-to-end developer platform with Source Control Management, CI/CD Pipelines, Hosted Develope | 38,479 | +39 |
| [Diun](../r/crazy-max~diun.md) | Receive notifications when an image is updated on a Docker registry | 4,952 | +13 |
| [dockcheck](../r/mag37~dockcheck.md) | CLI tool to automate docker image updates. Interactive or unattended with notifications, image backups, autoprune, no pr | 2,517 | +3 |
| [Pumba](../r/alexei-led~pumba.md) | Chaos testing, network emulation, and stress testing tool for containers | 3,176 | +3 |
| [Zsh-in-Docker](https://github.com/deluan/zsh-in-docker) | Install Zsh, Oh My Zsh and plugins inside a Docker container with one line! | 1,121 | +3 |
| [Apache OpenWhisk](../r/apache~openwhisk.md) | Apache OpenWhisk is an open source serverless cloud platform | 6,800 | +2 |
| [udocker](https://github.com/indigo-dc/udocker) | A basic user tool to execute simple docker containers in batch or interactive systems without root privileges. | 1,791 | +2 |
| [dockerode](../r/apocas~dockerode.md) | Docker + Node = Dockerode (Node.js module for Docker's Remote API) | 4,947 | +1 |
| [Docuum](../r/stepchowfun~docuum.md) | Least recently used (LRU) eviction of Docker images. 🗑️ | 712 | +1 |
| [Kurtosis](../r/kurtosis-tech~kurtosis.md) | A platform for packaging and launching blockchain infra. Think docker compose for blockchain | 554 | +1 |
| [OpenFaaS](../r/openfaas~faas.md) | OpenFaaS - Serverless Functions Made Simple | 26,250 | +1 |
| [Container Structure Test](../r/googlecontainertools~container-structure-test.md) | validate the structure of your container images | 2,497 | +0 |
| [contajners](../r/lispyclouds~contajners.md) | An idiomatic, data-driven, REPL friendly clojure client for OCI container engines | 150 | +0 |
| [dde](https://github.com/whatwedo/dde) | Local development environment toolset based on Docker | 48 | +0 |
| [Defang](../r/defanglabs~defang.md) | Defang Deploy CLI. Develop Once, Deploy Anywhere. Take your app from Docker Compose to a secure and scalable deployment  | 167 | +0 |
| [Docker Client for JVM](../r/gesellix~docker-client.md) | A Docker client for Java written in Kotlin and Groovy | 123 | +0 |
| [Docker plugin for Jenkins](../r/jenkinsci~docker-plugin.md) | Jenkins cloud plugin that uses Docker | 498 | +0 |
| [docker-controller-bot](../r/dgongut~docker-controller-bot.md) | Bot de telegram para controlar los contenedores docker de tu servidor | 259 | +0 |
| [Docker.Registry.DotNet](https://github.com/ChangemakerStudios/Docker.Registry.DotNet) | .NET (C#) Client Library for Docker Registry API V2 | 44 | +0 |
| [EnvCLI](https://github.com/EnvCLI/EnvCLI) | Don't install Node, Go, ... locally - use containers you define within your project. If you have a new machine / other c | 115 | +0 |
| [Gantry](https://github.com/shizunge/gantry) | Docker service for automatically updating Docker swarm services whenever their image is updated. | 90 | +0 |
| [Gebug](../r/moshebe~gebug.md) | Debug Dockerized Go applications better | 631 | +0 |
| [go-dockerclient](../r/fsouza~go-dockerclient.md) | Go client for the Docker Engine API. | 2,248 | +0 |
| [Gradle Docker plugin](https://github.com/gesellix/gradle-docker-plugin) | Gradle Docker plugin | 82 | +0 |
| [Hokusai](https://github.com/artsy/hokusai) | Artsy's Docker / Kubernetes CLI and Workflow | 98 | +0 |
| [Jaypore CI](https://github.com/theSage21/jaypore_ci) | A small, very flexible, powerful CI system. Works offline and is configured in Python. | 39 | +0 |
| [Kraken CI](../r/kraken-ci~kraken.md) | Kraken CI is a continuous integration and testing system. | 160 | +0 |
| [Portainer stack utils](https://github.com/greenled/portainer-stack-utils) | CLI client for Portainer | 75 | +0 |
| [Preevy](../r/livecycle~preevy.md) | Quickly deploy preview environments to the cloud! | 2,230 | +0 |
| [sbt-docker](https://github.com/marcuslonnberg/sbt-docker) | Create Docker images directly from sbt | 731 | +0 |
| [Skipper](https://github.com/Stratoscale/skipper) | Easily dockerize your Git repository | 50 | +0 |
| [subuser](https://github.com/subuser-security/subuser) | Run programs on linux with selectively restricted permissions. | 895 | +0 |
| [uniget](https://github.com/uniget-org/cli) | MIRROR: The universal installer and updater for (container) tools | 24 | +0 |
| [Captain](../r/harbur~captain.md) | Captain - Convert your Git workflow to Docker 🐳 containers | 776 | -1 |
| [DIP](../r/bibendi~dip.md) | The dip is a CLI dev–tool that provides native-like interaction with a Dockerized application. | 1,350 | -1 |
| [docker-custodian](../r/yelp~docker-custodian.md) | Keep docker hosts tidy | 373 | -1 |
| [Docker.DotNet](https://github.com/Microsoft/Docker.DotNet) | 🐳 .NET (C#) Client Library for Docker API | 2,414 | -1 |
| [Lando](../r/lando~lando.md) | A development tool for all your projects that is fast, easy, powerful and liberating | 4,242 | -1 |
| [docker-maven-plugin](../r/fabric8io~docker-maven-plugin.md) | Maven plugin for running and creating Docker images | 1,931 | -2 |

[Back to top](#awesome-docker)

## Docker Images

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Harbor](../r/goharbor~harbor.md) | An open source trusted cloud native registry project that stores, signs, and scans content. | 29,482 | +25 |
| [distroless](../r/googlecontainertools~distroless.md) | 🥑  Language focused docker images, minus the operating system.   | 23,117 | +22 |
| [Hadolint](../r/hadolint~hadolint.md) | Dockerfile linter, validate inline bash, written in Haskell | 12,450 | +19 |
| [buildah](../r/containers~buildah.md) | A tool that facilitates building OCI images. | 9,050 | +14 |
| [BuildKit](../r/moby~buildkit.md) | concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit | 10,301 | +9 |
| [Dragonfly](../r/dragonflyoss~dragonfly2.md) | Delivers efficient, stable, and secure data distribution and acceleration powered by P2P technology, with an optional co | 3,342 | +7 |
| [DockerSlim](../r/docker-slim~docker-slim.md) | Slim(toolkit): Don't change anything in your container image and minify it by up to 30x (and for compiled languages even | 23,422 | +6 |
| [runlike](../r/lavie~runlike.md) | Given an existing docker container, prints the command line necessary to run a copy of it. | 2,953 | +4 |
| [Kraken](../r/uber~kraken.md) | P2P Docker registry capable of distributing TBs of data in seconds | 6,753 | +3 |
| [img](https://github.com/genuinetools/img) | Standalone, daemon-less, unprivileged Dockerfile and OCI compatible container image builder. | 3,990 | +2 |
| [Ofelia](../r/mcuadros~ofelia.md) | A docker job scheduler (aka. crontab for docker) | 3,999 | +2 |
| [ansible-bender](../r/ansible-community~ansible-bender.md) | ansible-playbook + buildah = a sweet container image | 698 | +1 |
| [dlayer](../r/orisano~dlayer.md) | dlayer is docker layer analyzer. | 448 | +1 |
| [docker-gen](../r/jwilder~docker-gen.md) | Generate files from docker container meta-data | 4,632 | +1 |
| [HPC Container Maker](../r/nvidia~hpc-container-maker.md) | HPC Container Maker | 519 | +1 |
| [Whaler](../r/p3gleg~whaler.md) | Program to reverse Docker images into Dockerfiles | 1,193 | +1 |
| [cekit](../r/cekit~cekit.md) | CEKit - Container Evolution Kit | 113 | +0 |
| [ckron](https://github.com/nicomt/ckron) | 🐋 A cron-like job scheduler for docker | 57 | +0 |
| [Dockadvisor](../r/deckrun~dockadvisor.md) | Lightweight Dockerfile linter that helps you write better Dockerfiles. Get instant feedback with quality scores, securit | 214 | +0 |
| [docker-companion](https://github.com/mudler/docker-companion) | squash and unpack Docker images, in Golang | 47 | +0 |
| [docker-image-size-limit](../r/wemake-services~docker-image-size-limit.md) | 🐳 Keep an eye on your docker image size and prevent it from growing too big | 133 | +0 |
| [docker-repack](https://github.com/orf/docker-repack) | Repack docker images to optimize for pulling speed. | 167 | +0 |
| [Dockerfile Generator](https://github.com/ozankasikci/dockerfile-generator) | dfg - Generates dockerfiles based on various input channels.  | 186 | +0 |
| [dockerfilegraph](../r/patrickhoefler~dockerfilegraph.md) | Visualize your multi-stage Dockerfiles | 275 | +0 |
| [dockerize](../r/powerman~dockerize.md) | Utility to simplify running applications in docker containers | 194 | +0 |
| [Dockershelf](https://github.com/Dockershelf/dockershelf) | A repository containing useful, lightweight and reliable dockerfiles. | 98 | +0 |
| [essex](https://github.com/utensils/essex) | A Docker project template generator written in Rust | 38 | +0 |
| [GoSu](../r/tianon~gosu.md) | Simple Go-based setuid+setgid+setgroups+exec | 5,011 | +0 |
| [is-docker](../r/sindresorhus~is-docker.md) | Check if the process is running inside a Docker container | 234 | +0 |
| [microcheck](../r/tarampampam~microcheck.md) | 🧪 Lightweight health check utilities for Docker containers | 152 | +0 |
| [nscr](https://github.com/jhstatewide/nscr) | New and Shiny Container Registry | 3 | +0 |
| [RAUDI](../r/cybersecsi~raudi.md) | A repo to automatically generate and keep updated a series of Docker images through GitHub Actions. | 561 | +0 |
| [Registryo](https://github.com/inmagik/registryo) | UI and token based authentication server for onpremise docker registry | 16 | +0 |
| [supercronic](../r/aptible~supercronic.md) | Cron for containers | 2,653 | +0 |
| [su-exec](../r/ncopa~su-exec.md) | switch user and group id and exec | 1,025 | -1 |

[Back to top](#awesome-docker)

## Dockerfile

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Dofigen](https://github.com/lenra-io/dofigen) | Dofigen is a Dockerfile generator using a simplified description in YAML or JSON format | 84 | +12 |

[Back to top](#awesome-docker)

## Engine & Runtime

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [colima](../r/abiosoft~colima.md) | Container runtimes on macOS (and Linux) with minimal setup | 31,083 | +83 |
| [gVisor](../r/google~gvisor.md) | Application Kernel for Containers | 19,484 | +62 |
| [containerd](../r/containerd~containerd.md) | An open and reliable container runtime | 21,377 | +41 |
| [runc](../r/opencontainers~runc.md) | CLI tool for spawning and running containers according to the OCI specification | 13,470 | +10 |
| [youki](../r/youki-dev~youki.md) | A container runtime written in Rust | 7,616 | +5 |

[Back to top](#awesome-docker)

## Image Scanning & SBOM

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [BomLens](https://github.com/sktelecom/bomlens) | BomLens — a local-first SBOM generator & open-source risk assessor (CycloneDX). Produce an SBOM, an open-source notice,  | 21 | +0 |
| [Docker Scout](../r/docker~scout-cli.md) | Docker Scout CLI | 454 | -1 |

[Back to top](#awesome-docker)

## In-Container Tooling

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [cdebug](../r/iximiuz~cdebug.md) | cdebug - a swiss army knife of container debugging | 1,677 | +3 |

[Back to top](#awesome-docker)

## Monitoring

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Maintenant](../r/kolapsis~maintenant.md) | Self-hosted monitoring for Docker, Kubernetes and uptime. Single Go binary, no agent config, live alerts. Drop a contain | 522 | +9 |
| [Drydock](../r/codeswhat~drydock.md) | Open source container update monitoring — 23 registries, 20 notification triggers, audit log, OIDC auth, Prometheus metr | 258 | +1 |
| [ADRG](https://github.com/jaldertech/adrg) | Aldertech Dynamic Resource Governor — A kernel-level resource manager for high-density Docker stacks on Raspberry Pi and | 12 | +0 |
| [Docker-Sentinel](https://github.com/Will-Luck/Docker-Sentinel) | [maintenance mode] Docker-Sentinel: container update orchestration with manual approval queues | 22 | +0 |
| [DockProbe](https://github.com/deep-on/dockprobe) | Lightweight Docker monitoring dashboard with anomaly detection & Telegram alerts. One-liner install, zero config. | 20 | +0 |
| [Wiremap](https://github.com/codeofmario/wiremap) | A self-hosted visual Docker network topology explorer with real-time log streaming, live stats, embedded terminal, and c | 9 | +0 |

[Back to top](#awesome-docker)

## Monitoring Services

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [AppDynamics](https://github.com/Appdynamics/docker-monitoring-extension) | Docker Monitoring Extension | 5 | +0 |

[Back to top](#awesome-docker)

## Observability

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [docker-exporter](https://github.com/dlepaux/docker-exporter) | Lightweight Prometheus exporter for Docker container metrics — built for ARM64 and cgroup v2 | 4 | +0 |
| [InfraCanvas](https://github.com/bytestrix/InfraCanvas) | Live Docker & Kubernetes infrastructure visualization - containers, pods, volumes, and networks in one visual map. No VP | 81 | +0 |

[Back to top](#awesome-docker)

## Projects

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Docker Compose](../r/docker~compose.md) | Define and run multi-container applications with Docker | 38,280 | +49 |
| [Moby](../r/moby~moby.md) | The Moby Project - a collaborative project for the container ecosystem to assemble container-based systems | 72,142 | +9 |

[Back to top](#awesome-docker)

## Registry

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [NORA](../r/getnora-io~nora.md) | Lightweight multi-format artifact registry. 15 formats: Docker, Maven, npm, PyPI, Cargo, Go, Raw, RubyGems, Terraform, A | 318 | +10 |
| [kontain.me](../r/imjasonh~kontain.me.md) | Container image registry that serves images built fresh when you ask for them | 246 | +0 |

[Back to top](#awesome-docker)

## Registry CLI

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [go-containerregistry](../r/google~go-containerregistry.md) | Go library and CLIs for working with container registries | 4,068 | +8 |
| [oras](../r/oras-project~oras.md) | OCI registry client - managing content like artifacts, images, packages | 2,456 | +8 |
| [regctl](../r/regclient~regclient.md) | Docker and OCI Registry Client in Go and tooling using those libraries. | 1,939 | +3 |

[Back to top](#awesome-docker)

## Reverse Proxy

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [BunkerWeb](../r/bunkerity~bunkerweb.md) | 🛡️ Open-source and cloud-native Web Application Firewall (WAF) | 11,037 | +32 |

[Back to top](#awesome-docker)

## Runtime

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Mocker](../r/us~mocker.md) | Docker-compatible container CLI built on Apple's Containerization framework. Same commands, same flags, mocker run, ps,  | 357 | +5 |

[Back to top](#awesome-docker)

## Security

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Grype](../r/anchore~grype.md) | A vulnerability scanner for container images and filesystems | 12,967 | +37 |
| [docker-socket-proxy](../r/tecnativa~docker-socket-proxy.md) | Proxy over your Docker socket to restrict which requests it accepts | 2,810 | +14 |
| [container-explorer](../r/google~container-explorer.md) | Forensic utility to explore Docker and containerd container details from mounted disk images. | 108 | +1 |
| [Den](https://github.com/us/den) | Secure sandbox runtime for AI   agents | 17 | +1 |
| [buildcage](https://github.com/dash14/buildcage) | GitHub Action to build Docker images with outbound network access restricted to an allowlist | 11 | +0 |
| [compose-lint](https://github.com/tmatens/compose-lint) | Security-focused linter for Docker Compose files. Catches dangerous misconfigurations before they reach production. Grou | 59 | +0 |
| [CVE Scanning Alpine images with Multi-stage builds in Docker 17.05](https://github.com/tomwillfixit/alpine-cvecheck) | Code used to CVE check Alpine based images | 11 | +0 |
| [Docker Secure Deployment Guidelines](https://github.com/AonCyberLabs/Docker-Secure-Deployment-Guidelines) | Deployment checklist for securely deploying Docker | 608 | +0 |
| [pindock](https://github.com/deadnews/pindock) | Pin and update Docker image digests in Dockerfiles and compose files | 3 | +0 |
| [segspec](https://github.com/dormstern/segspec) | Static analysis from configs → Kubernetes NetworkPolicies in seconds | 16 | +0 |

[Back to top](#awesome-docker)

## Storage & Data

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [resq](https://github.com/mashb1t/resq) | restic backup via docker labels | 2 | +0 |

[Back to top](#awesome-docker)

## Supply Chain

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [cosign](../r/sigstore~cosign.md) | Code signing and transparency for containers and binaries | 6,344 | +16 |
| [in-toto](../r/in-toto~in-toto.md) | in-toto is a framework to protect supply chain integrity. | 1,049 | +7 |
| [policy-controller](../r/sigstore~policy-controller.md) | Sigstore Policy Controller -  an admission controller that can be used to enforce policy on a Kubernetes cluster based o | 182 | +1 |
| [witness](../r/in-toto~witness.md) | Witness is a pluggable framework for software supply chain risk management.  It automates, normalizes, and verifies soft | 547 | +1 |

[Back to top](#awesome-docker)

## Terminal

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [layerx](../r/deveshctl~layerx.md) | LayerX Image Inspector - open-source terminal explorer for container images. Browse layers, spot wasted bytes, and gate  | 133 | +1 |
| [bosun](https://github.com/psychedelicdevx/bosun) | A fast terminal UI for Docker and Podman. Containers, images, volumes, networks, compose stacks, live logs and stats, lo | 4 | +0 |
| [dockup](https://github.com/paulo-amaral/dockup) | dockup - interactive TUI to install, harden and maintain Docker Engine, Compose v2, NVIDIA Container Toolkit and Apple c | 5 | +0 |
| [DockTUI](https://github.com/strmax195-hue/docktui) | A lightweight, zero-dependency TUI dashboard for managing Docker containers and images dynamically in the terminal. | 36 | -1 |

[Back to top](#awesome-docker)

## Useful Resources

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Cloud Native Landscape](../r/cncf~landscape.md) | 🌄 The Cloud Native Interactive Landscape filters and sorts hundreds of projects and products, and shows details includi | 10,003 | +8 |

[Back to top](#awesome-docker)

## User Interface

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Arcane](../r/getarcaneapp~arcane.md) | Modern Docker Management, Designed for Everyone | 7,694 | +82 |
| [easydocker](../r/joao-zanutto~easydocker.md) | EasyDocker is a TUI focused on investigating and troubleshooting Docker resources. Highly inspired by lazydocker and k9s | 127 | +0 |
| [swarmcli](https://github.com/Eldara-Tech/swarmcli) | A terminal UI for Docker Swarm that makes cluster state easier to see, understand, and reason about. | 23 | +0 |
| [tdocker](https://github.com/pivovarit/tdocker) | minimalistic terminal UI for everyday Docker operations | 89 | +0 |
| [usulnet](../r/fr4nsys~usulnet.md) | Open-source Docker infrastructure platform. One web UI — containers, security, DNS, VPN, monitoring, backups, reverse pr | 131 | +0 |
| [wharf](https://github.com/idesyatov/wharf) | ⚓ Terminal UI (TUI) for Docker Compose — manage containers, view logs, exec, monitor CPU/RAM. | 10 | +0 |

[Back to top](#awesome-docker)

## Volume Management / Data

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Label Backup](https://github.com/resulgg/label-backup) | Docker-aware backup agent using labels to automate backups for PostgreSQL, MySQL, MongoDB, and Redis to local or S3 comp | 25 | +0 |

[Back to top](#awesome-docker)

## Web

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Docker Commander](https://github.com/koduj-dev/docker-commander) | Self-hosted Docker monitoring & control panel — a single Go binary with an embedded React UI. Multi-host, live logs & st | 5 | +1 |
| [DockScope](../r/manuelr-t~dockscope.md) | Visual Docker dashboard with a 3D dependency graph, live metrics, logs, terminal, and container actions | 109 | +0 |

[Back to top](#awesome-docker)

## Where to Start

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [wsargent](https://github.com/wsargent/docker-cheat-sheet) | Docker Cheat Sheet | 22,552 | +3 |
| [Docker Curriculum](../r/prakhar1989~docker-curriculum.md) | 🐬 A comprehensive tutorial on getting started with Docker! | 6,100 | +1 |
| [dimonomid](https://github.com/dimonomid/docker-quick-ref) | Docker: Printable Quick Reference | 201 | +0 |
| [Docker katas](../r/eficode-academy~docker-katas.md) | Exercises for Docker training | 291 | +0 |
| [Dockerlings](../r/furkan~dockerlings.md) | learn docker in your terminal, with bite sized exercises | 1,033 | +0 |
| [JensPiegsa](https://github.com/JensPiegsa/docker-cheat-sheet) | A collection of recipes for docker. | 23 | +0 |
| [Learn Docker](https://github.com/dwyl/learn-docker) | 🚢    Learn how to use docker.io containers to consistently deploy your apps on any infrastructure. | 245 | +0 |
| [Practical Guide about Docker Commands in Spanish](https://github.com/brunocascio/docker-espanol) | Un tutorial Docker en español. Basado en el libro Docker Cookbook de O'reilly | 266 | +0 |
| [Setting Python Development Environment with VScode and Docker](https://github.com/RamiKrispin/vscode-python) | A Tutorial for Setting Python Development Environment with VScode and Docker | 951 | +0 |
| [eon01](../r/eon01~dockercheatsheet.md) | 🐋 Docker Cheat Sheet 🐋 | 3,950 | -1 |

[Back to top](#awesome-docker)

---
*Updated: 2026-10-03 | [View live site ↗](https://patrickclery.com/awesomer/l/docker/)*
