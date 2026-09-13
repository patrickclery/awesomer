# awesome-docker

> 🐳 A curated list of Docker resources and projects

[Home](../README.md) | [Live site ↗](https://patrickclery.com/awesomer/l/docker/) | [Source ↗](https://github.com/veggiemonk/awesome-docker)

## Top 10 Trending

| # | Repo | Stars | 7d | 30d | 90d |
|---|------|-------|----|-----|-----|
| 1 | [Kubernetes](../r/kubernetes~kubernetes.md) | 127,379 | +597 | +2,897 | +4,377 |
| 2 | [Trivy](../r/aquasecurity~trivy.md) | 37,884 | +133 | +506 | +1,451 |
| 3 | [Dockerlings](../r/furkan~dockerlings.md) | 1,032 | +129 | +134 | +141 |
| 4 | [Drone](../r/drone~drone.md) | 38,333 | +114 | +527 | +1,588 |
| 5 | [Træfɪk](../r/containous~traefik.md) | 64,821 | +102 | +373 | +1,219 |
| 6 | [Komodo](../r/mbecker20~komodo.md) | 12,232 | +92 | +310 | +845 |
| 7 | [colima](../r/abiosoft~colima.md) | 30,776 | +92 | +429 | +1,498 |
| 8 | [Arcane](../r/getarcaneapp~arcane.md) | 7,351 | +85 | +386 | +1,618 |
| 9 | [lazydocker](../r/jesseduffield~lazydocker.md) | 52,805 | +79 | +349 | +1,455 |
| 10 | [podman](../r/containers~libpod.md) | 32,844 | +70 | +297 | +822 |

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
| [Awesome Sysadmin](../r/n1trux~awesome-sysadmin.md) | A curated list of amazingly awesome open-source sysadmin resources. | 35,130 | +63 |
| [Awesome Compose](../r/docker~awesome-compose.md) | Awesome Docker Compose samples | 46,300 | +53 |

[Back to top](#awesome-docker)

## Base Images

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Wolfi](../r/wolfi-dev~os.md) | Main package repository for production Wolfi images | 1,285 | +6 |
| [Chainguard Images](../r/chainguard-images~images.md) | Public Chainguard Images | 692 | +2 |
| [melange](../r/chainguard-dev~melange.md) | build APKs from source code | 627 | +1 |
| [pglayers](../r/pglayers~pglayers.md) | PostgreSQL Docker images with the extensions you actually need -- pre-built, composable, no compilation. | 159 | +1 |

[Back to top](#awesome-docker)

## Builder

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [ko](../r/ko-build~ko.md) | Build and deploy Go applications | 8,515 | +9 |
| [buildx](../r/docker~buildx.md) | Docker CLI plugin for extended build capabilities with BuildKit | 4,499 | +6 |
| [nix2container](../r/nlewo~nix2container.md) | An archive-less dockerTools.buildImage implementation  | 911 | +2 |
| [apko](../r/chainguard-dev~apko.md) | Build OCI images from APK packages directly without Dockerfile | 1,673 | +0 |
| [earthly](../r/earthly~earthly.md) | Super simple build framework with fast, repeatable builds and an instantly familiar syntax – like Dockerfile and Makefil | 12,046 | -2 |

[Back to top](#awesome-docker)

## CI/CD

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Self Hosted Runner](../r/youssefbrr~self-hosted-runner.md) | Dockerized solution for setting up a self-hosted GitHub Actions runner. Easily deploy and scale your runners using Docke | 135 | +3 |

[Back to top](#awesome-docker)

## Container Operations

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Kubernetes](../r/kubernetes~kubernetes.md) | Production-Grade Container Scheduling and Management | 127,379 | +597 |
| [Trivy](../r/aquasecurity~trivy.md) | Find vulnerabilities, misconfigurations, secrets, SBOM in containers, Kubernetes, code repositories, clouds and more | 37,884 | +133 |
| [Træfɪk](../r/containous~traefik.md) | The Cloud Native Application Proxy | 64,821 | +102 |
| [Komodo](../r/mbecker20~komodo.md) | 🦎 a tool to build and deploy software on many servers 🦎 | 12,232 | +92 |
| [lazydocker](../r/jesseduffield~lazydocker.md) | The lazier way to manage everything docker | 52,805 | +79 |
| [podman](../r/containers~libpod.md) | Podman: A tool for managing OCI containers and pods. | 32,844 | +70 |
| [Portainer](../r/portainer~portainer.md) | Making Docker and Kubernetes management easy. | 38,485 | +70 |
| [Nginx Proxy Manager](../r/jc21~nginx-proxy-manager.md) | Docker container for managing Nginx proxy hosts with a simple, powerful interface | 34,124 | +64 |
| [dockge](../r/louislam~dockge.md) | A fancy, easy-to-use and reactive self-hosted docker compose.yaml stack-oriented manager | 24,326 | +59 |
| [Syft](../r/anchore~syft.md) | CLI tool and library for generating a Software Bill of Materials from container images and filesystems | 9,554 | +34 |
| [Checkov](../r/bridgecrewio~checkov.md) | Prevent cloud misconfigurations and find vulnerabilities during build-time in infrastructure as code, container images a | 8,997 | +24 |
| [dive](../r/wagoodman~dive.md) | A tool for exploring each layer in a docker image | 54,559 | +23 |
| [Docker Volume Backup](../r/offen~docker-volume-backup.md) | Backup Docker volumes locally or to any S3, WebDAV, Azure Blob Storage, Dropbox, Google Drive or SSH compatible storage | 4,008 | +23 |
| [Nomad](../r/hashicorp~nomad.md) | Nomad is an easy-to-use, flexible, and performant workload orchestrator that can deploy a mix of microservice, batch, co | 16,889 | +22 |
| [Sysdig Falco](../r/falcosecurity~falco.md) | Cloud Native Runtime Security | 9,360 | +20 |
| [skopeo](../r/containers~skopeo.md) | Work with remote images registries - retrieving information, images, signing content | 11,228 | +19 |
| [Rancher](../r/rancher~rancher.md) | Complete container management platform | 25,903 | +15 |
| [podman-compose](../r/containers~podman-compose.md) | a script to run docker-compose.yml using podman | 6,213 | +14 |
| [cAdvisor](../r/google~cadvisor.md) | Analyzes resource usage and performance characteristics of running containers. | 19,419 | +13 |
| [oxker](../r/mrjackwills~oxker.md) | A simple tui to view & control docker containers  | 1,837 | +11 |
| [caprover](../r/caprover~caprover.md) | Scalable PaaS (automated Docker+nginx) - aka Heroku on Steroids | 15,159 | +8 |
| [Autoheal](../r/willfarrell~docker-autoheal.md) | Monitor and restart unhealthy docker containers. | 1,995 | +7 |
| [caddy-docker-proxy](../r/lucaslorentz~caddy-docker-proxy.md) | Caddy as a reverse proxy for Docker | 4,643 | +7 |
| [Deepfence Threat Mapper](../r/deepfence~threatmapper.md) | Open Source Cloud Native Application Protection Platform (CNAPP) | 5,322 | +6 |
| [docker rollout](../r/wowu~docker-rollout.md) | 🚀 Zero Downtime Deployment for Docker Compose | 3,334 | +6 |
| [KICS](../r/checkmarx~kics.md) | Find security vulnerabilities, compliance issues, and infrastructure misconfigurations early in the development cycle of | 2,698 | +6 |
| [netshoot](../r/nicolaka~netshoot.md) | a Docker + Kubernetes network trouble-shooting swiss-army container | 10,994 | +6 |
| [kompose](../r/kubernetes~kompose.md) | Convert Compose to Kubernetes | 10,623 | +5 |
| [lazyjournal](../r/lifailon~lazyjournal.md) | TUI for viewing logs from journald, auditd, file system, Docker and Podman containers, Compose stacks and Kubernetes pod | 1,402 | +5 |
| [oscap-docker](../r/openscap~openscap.md) | NIST Certified SCAP 1.2 toolkit | 1,815 | +5 |
| [Dokku](../r/dokku~dokku.md) | A docker-powered PaaS that helps you build and manage the lifecycle of applications | 32,130 | +4 |
| [lxc](../r/lxc~lxc.md) | LXC - Linux Containers | 5,259 | +4 |
| [cri-o](../r/cri-o~cri-o.md) | Open Container Initiative-based implementation of Kubernetes Container Runtime Interface | 5,658 | +3 |
| [d4s](../r/jr-k~d4s.md) | 🍊 A fast, keyboard-driven terminal UI to manage Docker containers, Compose stacks, and Swarm services with the ergonomi | 128 | +3 |
| [docker-bench-security](../r/docker~docker-bench-security.md) | The Docker Bench for Security is a script that checks for dozens of common best-practices around deploying Docker contai | 9,702 | +3 |
| [Clair](../r/quay~clair.md) | Vulnerability Static Analysis for Containers | 11,059 | +2 |
| [Docker Registry Browser](../r/klausmeyer~docker-registry-browser.md) | 🐳 Web Interface for the Docker Registry HTTP API V2 written in Ruby on Rails. | 700 | +2 |
| [dockprom](../r/stefanprodan~dockprom.md) | Docker hosts and containers monitoring with Prometheus, Grafana, cAdvisor, NodeExporter and AlertManager | 6,577 | +2 |
| [Flannel](../r/coreos~flannel.md) | flannel is a network fabric for containers, designed for Kubernetes | 9,536 | +2 |
| [Let's Encrypt Nginx-proxy Companion](../r/nginx-proxy~docker-letsencrypt-nginx-proxy-companion.md) | Automated ACME SSL certificate generation for nginx-proxy | 7,726 | +2 |
| [dcinja](../r/falldog~dcinja.md) | The smallest binary size of template engine, born for docker image | 15 | +1 |
| [decompose](../r/s0rg~decompose.md) | Reverse-engineering tool for docker environments | 141 | +1 |
| [dockly](../r/lirantal~dockly.md) | Immersive terminal interface for managing docker containers and services | 4,031 | +1 |
| [goManageDocker](../r/ajayd-san~gomanagedocker.md) | TUI tool to manage your docker images, containers and volumes 🚀 | 641 | +1 |
| [Grafeas](../r/grafeas~grafeas.md) | Artifact Metadata API | 1,570 | +1 |
| [OpenResty Manager](../r/safe3~openresty-manager.md) | Modern, secure, and elegant server control panel, alternative to OpenResty Edge and Nginx Proxy Manager. | 1,452 | +1 |
| [Simple Docker UI](../r/felixgborrego~simple-docker-ui.md) | Native Docker UI implemented using Scala.js and React - DEPRECATED | 604 | +1 |
| [Stevedore](../r/slonopotamus~stevedore.md) | 🚢 Docker distribution for Windows Containers that Just Works | 386 | +1 |
| [supdock](../r/segersniels~supdock.md) | What's Up, Doc(ker)? A convenient way to interact with the docker daemon using prompts. | 88 | +1 |
| [Swarm-cronjob](../r/crazy-max~swarm-cronjob.md) | Create jobs on a time-based schedule on Docker Swarm | 884 | +1 |
| [Swarmpit](../r/swarmpit~swarmpit.md) | Lightweight AI-friendly Docker Swarm management | 3,490 | +1 |
| [Tsuru](../r/tsuru~tsuru.md) | Open source and extensible Platform as a Service (PaaS). | 5,311 | +1 |
| [werf](../r/werf~werf.md) | A solution for implementing efficient and consistent software delivery to Kubernetes facilitating best practices. | 4,720 | +1 |
| [Anchor](../r/songstitch~anchor.md) | A tool for anchoring dependencies in dockerfiles | 24 | +0 |
| [caddy-docker-upstreams](../r/invzhi~caddy-docker-upstreams.md) | Docker dynamic upstreams for Caddy. | 39 | +0 |
| [CASA](../r/knrdl~casa.md) | Container as a Service admin | 87 | +0 |
| [CetusGuard](../r/hectorm~cetusguard.md) | CetusGuard is a tool that protects the Docker daemon socket by filtering calls to its API endpoints. | 90 | +0 |
| [CloudSlang](../r/cloudslang~cloud-slang.md) | CloudSlang Language, CLI and Builder | 242 | +0 |
| [Composerize](../r/magicmark~composerize.md) | 🏃→🎼  docker run asdlksjfksdf > docker-composerize up | 3,757 | +0 |
| [Container Web TTY](../r/wrfly~container-web-tty.md) | Connect your containers via a web-tty | 257 | +0 |
| [Convox Rack](../r/convox~rack.md) | Private PaaS built on native AWS services for maximum privacy and minimum upkeep | 1,890 | +0 |
| [ctk](../r/ctk-hq~ctk.md) | Visual composer for container based workloads | 301 | +0 |
| [dctl](../r/fabiend~docker-stack.md) | A curated collection of ready-to-use Docker Compose files for local web development, plus a powerful CLI (dctl) to manag | 24 | +0 |
| [DLIA](../r/zorak1103~dlia.md) | DLIA is an AI-powered Docker log monitoring agent that uses Large Language Models (LLMs) to intelligently analyze contai | 7 | +0 |
| [Docker DB Manager](../r/abians~docker-db-manager.md) | A desktop application for managing Docker database containers | 164 | +0 |
| [Docker Dnsmasq Updater](../r/moonbuggy~docker-dnsmasq-updater.md) | Automatically update a local or remote hosts file with Docker container hostnames | 34 | +0 |
| [docker pushrm](../r/christian-korneck~docker-pushrm.md) | "Docker Push Readme" - a Docker CLI plugin to update container repo docs | 152 | +0 |
| [docker-captain](../r/lucabello~docker-captain.md) | ⚓ A friendly CLI to manage multiple Docker Compose deployments with style — powered by Typer, Rich, questionary, and sh. | 3 | +0 |
| [docker-dns](../r/bytesharky~docker-dns.md) | Docker DNS Forwarder is a lightweight tool that enables the host machine to resolve Docker container names to their IPs  | 5 | +0 |
| [docker-flow-proxy](../r/docker-flow~docker-flow-proxy.md) | Docker Flow Proxy | 319 | +0 |
| [docker-to-iac](../r/deploystackio~docker-to-iac.md) | Translate docker run and docker compose file to Infrastructure as Code | 22 | +0 |
| [docker.el](../r/silex~docker.el.md) | Manage docker from Emacs. | 827 | +0 |
| [dockerfile-mode](../r/spotify~dockerfile-mode.md) | An emacs mode for handling Dockerfiles | 565 | +0 |
| [DockMate](../r/shubh-io~dockmate.md) | Dockmate: The open-source Docker TUI & Podman manager for terminal productivity. A fast, lightweight alternative to lazy | 338 | +0 |
| [Doku](../r/amerkurev~doku.md) | 💽 Doku - Docker disk usage dashboard | 446 | +0 |
| [dprs](../r/durableprogramming~dprs.md) | A developer-focused TUI for managing Docker containers with real-time log streaming and container management. Built with | 40 | +0 |
| [dry](../r/moncho~dry.md) | dry - A Docker manager for the terminal @ | 3,277 | +0 |
| [Exoframe](../r/exoframejs~exoframe.md) | Exoframe is a self-hosted tool that allows simple one-command deployments using Docker | 1,155 | +0 |
| [mesh-router](../r/yundera~mesh-router.md) | MeshRouter: Seamlessly route domain requests to containers across networks using ENS, or custom names, secured by Wiregu | 13 | +0 |
| [Mesos](../r/apache~mesos.md) | Apache Mesos | 5,367 | +0 |
| [Netshare](../r/containx~docker-volume-netshare.md) | Docker NFS, AWS EFS, Ceph & Samba/CIFS Volume Plugin | 1,141 | +0 |
| [Pipework](../r/jpetazzo~pipework.md) | Software-Defined Networking tools for LXC (LinuX Containers) | 4,252 | +0 |
| [plash](../r/ihucos~plash.md) | Build and run layered root filesystems. | 382 | +0 |
| [proco](../r/shiwaforce~poco.md) | Poco will help you to organise and manage Docker, Docker-Compose, Kubernetes, Openshift projects of any complexity using | 113 | +0 |
| [REX-Ray](../r/rexray~rexray.md) | REX-Ray is a container storage orchestration engine enabling persistence for cloud native workloads | 2,222 | +0 |
| [runtime-tools](../r/opencontainers~runtime-tools.md) | OCI Runtime Tools | 492 | +0 |
| [scuba](../r/jonathonreinhart~scuba.md) | Simple Container-Utilizing Build Apparatus | 99 | +0 |
| [Smalte](../r/roquie~smalte.md) | Dynamically configure applications that require static configuration in docker container. | 36 | +0 |
| [Swarm Router](../r/flavioaiello~swarm-router.md) | Scalable stateless «zero config» service-name ingress for docker swarm mode with a fresh more secure approach | 75 | +0 |
| [swarm-ansible](../r/lombardidaniel~swarm-ansible.md) | Build a Production-Ready Docker Swarm cluster using Ansible. The goal is rapidly bootstrap a Docker Swarm cluster with s | 58 | +0 |
| [SwarmManagement](../r/hansehe~swarmmanagement.md) | Swarm Management is a python application, installed with pip. The application makes it easy to manage a Docker Swarm by  | 22 | +0 |
| [docker-swarm-visualizer](../r/dockersamples~docker-swarm-visualizer.md) | A visualizer for Docker Swarm Mode using the Docker Remote API, Node.JS, and D3 | 3,338 | -1 |
| [registrator](../r/gliderlabs~registrator.md) | Service registry bridge for Docker with pluggable adapters | 4,675 | -1 |
| [DockSTARTer](../r/ghostwriters~dockstarter.md) | DockSTARTer helps you get started with running apps in Docker. | 2,570 | -2 |

[Back to top](#awesome-docker)

## Demos and Examples

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Local Docker DB](../r/alexmacarthur~local-docker-db.md) | A bunch o' Docker Compose files used to quickly spin up local databases.  | 299 | +1 |
| [Webstack-micro](../r/ferbs~webstack-micro.md) | Example/starter web app geared for small-ish teams interested in using a microservices architecture | 88 | +0 |

[Back to top](#awesome-docker)

## Deployment & Platforms

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [doco-cd](../r/kimdre~doco-cd.md) | Docker Compose Continuous Deployment | 1,659 | +17 |
| [OpenRun](../r/openrundev~openrun.md) | Deployment platform for teams to deploy internal tools. Deploy web apps declaratively, on a single-node or on Kubernetes | 974 | +7 |

[Back to top](#awesome-docker)

## Desktop

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Gantry (Desktop)](../r/getgantry~gantry.md) | Native macOS app for managing and monitoring Docker — local and over SSH. Agent-ready: built-in MCP server and App Inten | 62 | +1 |

[Back to top](#awesome-docker)

## Development Environment

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [HarborPilot](../r/potterwhite~harborpilot.md) | This is a One-Click docker images and containers setup base which is doing via a lot of bash scripts. My primary target  | 3 | +0 |
| [Laradock](../r/laradock~laradock.md) | Full PHP development environment for Docker. Run Laravel, Symfony, CodeIgniter, Phalcon, WordPress, Drupal, Magento, Moo | 12,673 |  |

[Back to top](#awesome-docker)

## Development with Docker

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Drone](../r/drone~drone.md) | Harness Open Source is an end-to-end developer platform with Source Control Management, CI/CD Pipelines, Hosted Develope | 38,333 | +114 |
| [coder](../r/coder~coder.md) | Secure environments for developers and their agents | 14,446 | +54 |
| [Pumba](../r/alexei-led~pumba.md) | Chaos testing, network emulation, and stress testing tool for containers | 3,148 | +30 |
| [Diun](../r/crazy-max~diun.md) | Receive notifications when an image is updated on a Docker registry | 4,915 | +25 |
| [OpenFaaS](../r/openfaas~faas.md) | OpenFaaS - Serverless Functions Made Simple | 26,236 | +7 |
| [dockcheck](../r/mag37~dockcheck.md) | CLI tool to automate docker image updates. Interactive or unattended with notifications, image backups, autoprune, no pr | 2,505 | +5 |
| [dockerode](../r/apocas~dockerode.md) | Docker + Node = Dockerode (Node.js module for Docker's Remote API) | 4,946 | +5 |
| [udocker](../r/indigo-dc~udocker.md) | A basic user tool to execute simple docker containers in batch or interactive systems without root privileges. | 1,787 | +5 |
| [Preevy](../r/livecycle~preevy.md) | Quickly deploy preview environments to the cloud! | 2,229 | +3 |
| [Apache OpenWhisk](../r/apache~openwhisk.md) | Apache OpenWhisk is an open source serverless cloud platform | 6,796 | +2 |
| [Zsh-in-Docker](../r/deluan~zsh-in-docker.md) | Install Zsh, Oh My Zsh and plugins inside a Docker container with one line! | 1,118 | +2 |
| [DIP](../r/bibendi~dip.md) | The dip is a CLI dev–tool that provides native-like interaction with a Dockerized application. | 1,347 | +1 |
| [Docker.DotNet](../r/microsoft~docker.dotnet.md) | 🐳 .NET (C#) Client Library for Docker API | 2,415 | +1 |
| [Docuum](../r/stepchowfun~docuum.md) | Docuum performs least recently used (LRU) eviction of Docker images. 🗑️ | 709 | +1 |
| [go-dockerclient](../r/fsouza~go-dockerclient.md) | Go client for the Docker Engine API. | 2,247 | +1 |
| [Kurtosis](../r/kurtosis-tech~kurtosis.md) | A platform for packaging and launching blockchain infra. Think docker compose for blockchain | 551 | +1 |
| [Lando](../r/lando~lando.md) | A development tool for all your projects that is fast, easy, powerful and liberating | 4,237 | +1 |
| [Captain](../r/harbur~captain.md) | Captain - Convert your Git workflow to Docker 🐳 containers | 777 | +0 |
| [contajners](../r/lispyclouds~contajners.md) | An idiomatic, data-driven, REPL friendly clojure client for OCI container engines | 150 | +0 |
| [dde](../r/whatwedo~dde.md) | Local development environment toolset based on Docker | 48 | +0 |
| [Defang](../r/defanglabs~defang.md) | Defang Deploy CLI. Develop Once, Deploy Anywhere. Take your app from Docker Compose to a secure and scalable deployment  | 165 | +0 |
| [Docker Client for JVM](../r/gesellix~docker-client.md) | A Docker client for Java written in Kotlin and Groovy | 123 | +0 |
| [Docker plugin for Jenkins](../r/jenkinsci~docker-plugin.md) | Jenkins cloud plugin that uses Docker | 498 | +0 |
| [docker-controller-bot](../r/dgongut~docker-controller-bot.md) | Bot de telegram para controlar los contenedores docker de tu servidor | 258 | +0 |
| [docker-custodian](../r/yelp~docker-custodian.md) | Keep docker hosts tidy | 373 | +0 |
| [docker-maven-plugin](../r/fabric8io~docker-maven-plugin.md) | Maven plugin for running and creating Docker images | 1,933 | +0 |
| [Docker.Registry.DotNet](../r/changemakerstudios~docker.registry.dotnet.md) | .NET (C#) Client Library for Docker Registry API V2 | 44 | +0 |
| [EnvCLI](../r/envcli~envcli.md) | Don't install Node, Go, ... locally - use containers you define within your project. If you have a new machine / other c | 115 | +0 |
| [Gantry](../r/shizunge~gantry.md) | Docker service for automatically updating Docker swarm services whenever their image is updated. | 90 | +0 |
| [Gebug](../r/moshebe~gebug.md) | Debug Dockerized Go applications better | 631 | +0 |
| [Gradle Docker plugin](../r/gesellix~gradle-docker-plugin.md) | Gradle Docker plugin | 82 | +0 |
| [Hokusai](../r/artsy~hokusai.md) | Artsy's Docker / Kubernetes CLI and Workflow | 98 | +0 |
| [Jaypore CI](../r/thesage21~jaypore_ci.md) | A small, very flexible, powerful CI system. Works offline and is configured in Python. | 38 | +0 |
| [Kraken CI](../r/kraken-ci~kraken.md) | Kraken CI is a continuous integration and testing system. | 160 | +0 |
| [Portainer stack utils](../r/greenled~portainer-stack-utils.md) | CLI client for Portainer | 75 | +0 |
| [Skipper](../r/stratoscale~skipper.md) | Easily dockerize your Git repository | 50 | +0 |
| [subuser](../r/subuser-security~subuser.md) | Run programs on linux with selectively restricted permissions. | 895 | +0 |
| [uniget](../r/uniget-org~cli.md) | MIRROR: The universal installer and updater for (container) tools | 24 | +0 |
| [Container Structure Test](../r/googlecontainertools~container-structure-test.md) | validate the structure of your container images | 2,496 | -1 |
| [sbt-docker](../r/marcuslonnberg~sbt-docker.md) | Create Docker images directly from sbt | 731 | -1 |

[Back to top](#awesome-docker)

## Docker Images

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Harbor](../r/goharbor~harbor.md) | An open source trusted cloud native registry project that stores, signs, and scans content. | 29,352 | +53 |
| [Hadolint](../r/hadolint~hadolint.md) | Dockerfile linter, validate inline bash, written in Haskell | 12,399 | +11 |
| [distroless](../r/googlecontainertools~distroless.md) | 🥑  Language focused docker images, minus the operating system.   | 23,069 | +10 |
| [BuildKit](../r/moby~buildkit.md) | concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit | 10,258 | +9 |
| [DockerSlim](../r/docker-slim~docker-slim.md) | Slim(toolkit): Don't change anything in your container image and minify it by up to 30x (and for compiled languages even | 23,408 | +8 |
| [supercronic](../r/aptible~supercronic.md) | Cron for containers | 2,631 | +8 |
| [buildah](../r/containers~buildah.md) | A tool that facilitates building OCI images. | 9,011 | +6 |
| [Dragonfly](../r/dragonflyoss~dragonfly2.md) | Delivers efficient, stable, and secure data distribution and acceleration powered by P2P technology, with an optional co | 3,326 | +6 |
| [Ofelia](../r/mcuadros~ofelia.md) | A docker job scheduler (aka. crontab for docker) | 3,987 | +5 |
| [HPC Container Maker](../r/nvidia~hpc-container-maker.md) | HPC Container Maker | 517 | +3 |
| [Kraken](../r/uber~kraken.md) | P2P Docker registry capable of distributing TBs of data in seconds | 6,744 | +3 |
| [dlayer](../r/orisano~dlayer.md) | dlayer is docker layer analyzer. | 447 | +1 |
| [docker-gen](../r/jwilder~docker-gen.md) | Generate files from docker container meta-data | 4,630 | +1 |
| [dockerfilegraph](../r/patrickhoefler~dockerfilegraph.md) | Visualize your multi-stage Dockerfiles | 275 | +1 |
| [GoSu](../r/tianon~gosu.md) | Simple Go-based setuid+setgid+setgroups+exec | 5,005 | +1 |
| [RAUDI](../r/cybersecsi~raudi.md) | A repo to automatically generate and keep updated a series of Docker images through GitHub Actions. | 560 | +1 |
| [Whaler](../r/p3gleg~whaler.md) | Program to reverse Docker images into Dockerfiles | 1,191 | +1 |
| [ansible-bender](../r/ansible-community~ansible-bender.md) | ansible-playbook + buildah = a sweet container image | 696 | +0 |
| [cekit](../r/cekit~cekit.md) | CEKit - Container Evolution Kit | 113 | +0 |
| [ckron](../r/nicomt~ckron.md) | 🐋 A cron-like job scheduler for docker | 57 | +0 |
| [Dockadvisor](../r/deckrun~dockadvisor.md) | Lightweight Dockerfile linter that helps you write better Dockerfiles. Get instant feedback with quality scores, securit | 213 | +0 |
| [docker-companion](../r/mudler~docker-companion.md) | squash and unpack Docker images, in Golang | 47 | +0 |
| [docker-image-size-limit](../r/wemake-services~docker-image-size-limit.md) | 🐳 Keep an eye on your docker image size and prevent it from growing too big | 133 | +0 |
| [docker-repack](../r/orf~docker-repack.md) | Repack docker images to optimize for pulling speed. | 167 | +0 |
| [Dockerfile Generator](../r/ozankasikci~dockerfile-generator.md) | dfg - Generates dockerfiles based on various input channels.  | 185 | +0 |
| [dockerize](../r/powerman~dockerize.md) | Utility to simplify running applications in docker containers | 194 | +0 |
| [Dockershelf](../r/dockershelf~dockershelf.md) | A repository containing useful, lightweight and reliable dockerfiles. | 98 | +0 |
| [essex](../r/utensils~essex.md) | A Docker project template generator written in Rust | 38 | +0 |
| [img](../r/genuinetools~img.md) | Standalone, daemon-less, unprivileged Dockerfile and OCI compatible container image builder. | 3,988 | +0 |
| [is-docker](../r/sindresorhus~is-docker.md) | Check if the process is running inside a Docker container | 234 | +0 |
| [microcheck](../r/tarampampam~microcheck.md) | 🧪 Lightweight health check utilities for Docker containers | 151 | +0 |
| [nscr](../r/jhstatewide~nscr.md) | New and Shiny Container Registry | 3 | +0 |
| [Registryo](../r/inmagik~registryo.md) | UI and token based authentication server for onpremise docker registry | 16 | +0 |
| [runlike](../r/lavie~runlike.md) | Given an existing docker container, prints the command line necessary to run a copy of it. | 2,943 | +0 |
| [su-exec](../r/ncopa~su-exec.md) | switch user and group id and exec | 1,025 | +0 |

[Back to top](#awesome-docker)

## Dockerfile

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Dofigen](../r/lenra-io~dofigen.md) | Dofigen is a Dockerfile generator using a simplified description in YAML or JSON format | 72 | +1 |

[Back to top](#awesome-docker)

## Engine & Runtime

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [colima](../r/abiosoft~colima.md) | Container runtimes on macOS (and Linux) with minimal setup | 30,776 | +92 |
| [gVisor](../r/google~gvisor.md) | Application Kernel for Containers | 19,279 | +48 |
| [containerd](../r/containerd~containerd.md) | An open and reliable container runtime | 21,288 | +26 |
| [youki](../r/youki-dev~youki.md) | A container runtime written in Rust | 7,597 | +14 |
| [runc](../r/opencontainers~runc.md) | CLI tool for spawning and running containers according to the OCI specification | 13,438 | +7 |

[Back to top](#awesome-docker)

## Image Scanning & SBOM

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [BomLens](../r/sktelecom~bomlens.md) | BomLens — a local-first SBOM generator & open-source risk assessor (CycloneDX). Produce an SBOM, an open-source notice,  | 19 | +0 |
| [Docker Scout](../r/docker~scout-cli.md) | Docker Scout CLI | 452 | +0 |

[Back to top](#awesome-docker)

## In-Container Tooling

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [cdebug](../r/iximiuz~cdebug.md) | cdebug - a swiss army knife of container debugging | 1,671 | +1 |

[Back to top](#awesome-docker)

## Monitoring

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Drydock](../r/codeswhat~drydock.md) | Open source container update monitoring — 23 registries, 20 notification triggers, audit log, OIDC auth, Prometheus metr | 252 | +27 |
| [Maintenant](../r/kolapsis~maintenant.md) | Self-hosted monitoring for Docker, Kubernetes and uptime. Single Go binary, no agent config, live alerts. Drop a contain | 502 | +7 |
| [ADRG](../r/jaldertech~adrg.md) | Aldertech Dynamic Resource Governor — A kernel-level resource manager for high-density Docker stacks on Raspberry Pi and | 12 | +0 |
| [Docker-Sentinel](../r/will-luck~docker-sentinel.md) | [maintenance mode] Docker-Sentinel: container update orchestration with manual approval queues | 22 | +0 |
| [DockProbe](../r/deep-on~dockprobe.md) | Lightweight Docker monitoring dashboard with anomaly detection & Telegram alerts. One-liner install, zero config. | 20 | +0 |
| [Wiremap](../r/codeofmario~wiremap.md) | A self-hosted visual Docker network topology explorer with real-time log streaming, live stats, embedded terminal, and c | 9 | +0 |

[Back to top](#awesome-docker)

## Monitoring Services

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [AppDynamics](../r/appdynamics~docker-monitoring-extension.md) | Docker Monitoring Extension | 5 | +0 |

[Back to top](#awesome-docker)

## Observability

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [InfraCanvas](../r/bytestrix~infracanvas.md) | Live Docker & Kubernetes infrastructure visualization - containers, pods, volumes, and networks in one visual map. No VP | 80 | +2 |
| [docker-exporter](../r/dlepaux~docker-exporter.md) | Lightweight Prometheus exporter for Docker container metrics — built for ARM64 and cgroup v2 | 3 | +0 |

[Back to top](#awesome-docker)

## Projects

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Moby](../r/moby~moby.md) | The Moby Project - a collaborative project for the container ecosystem to assemble container-based systems | 72,087 | +20 |
| [Docker Compose](../r/docker~compose.md) | Define and run multi-container applications with Docker | 38,137 | +12 |

[Back to top](#awesome-docker)

## Registry

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [NORA](../r/getnora-io~nora.md) | Lightweight multi-format artifact registry. 15 formats: Docker, Maven, npm, PyPI, Cargo, Go, Raw, RubyGems, Terraform, A | 296 | +7 |
| [kontain.me](../r/imjasonh~kontain.me.md) | Container image registry that serves images built fresh when you ask for them | 247 | +0 |

[Back to top](#awesome-docker)

## Registry CLI

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [oras](../r/oras-project~oras.md) | OCI registry client - managing content like artifacts, images, packages | 2,425 | +12 |
| [go-containerregistry](../r/google~go-containerregistry.md) | Go library and CLIs for working with container registries | 4,045 | +8 |
| [regctl](../r/regclient~regclient.md) | Docker and OCI Registry Client in Go and tooling using those libraries. | 1,929 | +3 |

[Back to top](#awesome-docker)

## Reverse Proxy

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [BunkerWeb](../r/bunkerity~bunkerweb.md) | 🛡️ Open-source and cloud-native Web Application Firewall (WAF) | 10,935 | +30 |

[Back to top](#awesome-docker)

## Runtime

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Mocker](../r/us~mocker.md) | Docker-compatible container CLI built on Apple's Containerization framework. Same commands, same flags, mocker run, ps,  | 342 | +6 |

[Back to top](#awesome-docker)

## Security

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Grype](../r/anchore~grype.md) | A vulnerability scanner for container images and filesystems | 12,875 | +29 |
| [docker-socket-proxy](../r/tecnativa~docker-socket-proxy.md) | Proxy over your Docker socket to restrict which requests it accepts | 2,759 | +21 |
| [compose-lint](../r/tmatens~compose-lint.md) | Security-focused linter for Docker Compose files. Catches dangerous misconfigurations before they reach production. Grou | 56 | +4 |
| [buildcage](../r/dash14~buildcage.md) | GitHub Action to build Docker images with outbound network access restricted to an allowlist | 11 | +1 |
| [Den](../r/us~den.md) | Secure sandbox runtime for AI   agents | 17 | +1 |
| [container-explorer](../r/google~container-explorer.md) | Forensic utility to explore Docker and containerd container details from mounted disk images. | 107 | +0 |
| [CVE Scanning Alpine images with Multi-stage builds in Docker 17.05](../r/tomwillfixit~alpine-cvecheck.md) | Code used to CVE check Alpine based images | 11 | +0 |
| [Docker Secure Deployment Guidelines](../r/aoncyberlabs~docker-secure-deployment-guidelines.md) | Deployment checklist for securely deploying Docker | 608 | +0 |
| [pindock](../r/deadnews~pindock.md) | Pin and update Docker image digests in Dockerfiles and compose files | 3 | +0 |
| [segspec](../r/dormstern~segspec.md) | Static analysis from configs → Kubernetes NetworkPolicies in seconds | 16 | +0 |

[Back to top](#awesome-docker)

## Storage & Data

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [resq](../r/mashb1t~resq.md) | restic backup via docker labels | 2 | +0 |

[Back to top](#awesome-docker)

## Supply Chain

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [cosign](../r/sigstore~cosign.md) | Code signing and transparency for containers and binaries | 6,296 | +18 |
| [in-toto](../r/in-toto~in-toto.md) | in-toto is a framework to protect supply chain integrity. | 1,036 | +2 |
| [policy-controller](../r/sigstore~policy-controller.md) | Sigstore Policy Controller -  an admission controller that can be used to enforce policy on a Kubernetes cluster based o | 179 | +0 |
| [witness](../r/in-toto~witness.md) | Witness is a pluggable framework for software supply chain risk management.  It automates, normalizes, and verifies soft | 544 | +0 |

[Back to top](#awesome-docker)

## Terminal

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [DockTUI](../r/strmax195-hue~docktui.md) | A lightweight, zero-dependency TUI dashboard for managing Docker containers and images dynamically in the terminal. | 35 | +1 |
| [dockup](../r/paulo-amaral~dockup.md) | dockup - interactive TUI to install, harden and maintain Docker Engine, Compose v2, NVIDIA Container Toolkit and Apple c | 4 | +1 |
| [bosun](../r/psychedelicdevx~bosun.md) | A fast terminal UI for Docker and Podman. Containers, images, volumes, networks, compose stacks, live logs and stats, lo | 4 |  |
| [layerx](../r/deveshctl~layerx.md) | LayerX Image Inspector - open-source terminal explorer for container images. Browse layers, spot wasted bytes, and gate  | 129 |  |

[Back to top](#awesome-docker)

## Useful Resources

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Cloud Native Landscape](../r/cncf~landscape.md) | 🌄 The Cloud Native Interactive Landscape filters and sorts hundreds of projects and products, and shows details includi | 9,991 | +11 |

[Back to top](#awesome-docker)

## User Interface

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Arcane](../r/getarcaneapp~arcane.md) | Modern Docker Management, Designed for Everyone | 7,351 | +85 |
| [easydocker](../r/joao-zanutto~easydocker.md) | EasyDocker is a TUI focused on investigating and troubleshooting Docker resources. Highly inspired by lazydocker and k9s | 126 | +1 |
| [tdocker](../r/pivovarit~tdocker.md) | minimalistic terminal UI for everyday Docker operations | 89 | +1 |
| [usulnet](../r/fr4nsys~usulnet.md) | Open-source Docker infrastructure platform. One web UI — containers, security, DNS, VPN, monitoring, backups, reverse pr | 131 | +1 |
| [swarmcli](../r/eldara-tech~swarmcli.md) | A terminal UI for Docker Swarm that makes cluster state easier to see, understand, and reason about. | 21 | +0 |
| [wharf](../r/idesyatov~wharf.md) | ⚓ Terminal UI (TUI) for Docker Compose — manage containers, view logs, exec, monitor CPU/RAM. | 10 | +0 |

[Back to top](#awesome-docker)

## Volume Management / Data

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Label Backup](../r/resulgg~label-backup.md) | Docker-aware backup agent using labels to automate backups for PostgreSQL, MySQL, MongoDB, and Redis to local or S3 comp | 24 | +0 |

[Back to top](#awesome-docker)

## Web

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Docker Commander](../r/koduj-dev~docker-commander.md) | Self-hosted Docker monitoring & control panel — a single Go binary with an embedded React UI. Multi-host, live logs & st | 3 |  |
| [DockScope](../r/manuelr-t~dockscope.md) | Visual Docker dashboard with a 3D dependency graph, live metrics, logs, terminal, and container actions | 108 |  |

[Back to top](#awesome-docker)

## Where to Start

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Dockerlings](../r/furkan~dockerlings.md) | learn docker in your terminal, with bite sized exercises | 1,032 | +129 |
| [Docker Curriculum](../r/prakhar1989~docker-curriculum.md) | 🐬 A comprehensive tutorial on getting started with Docker! | 6,091 | +5 |
| [wsargent](../r/wsargent~docker-cheat-sheet.md) | Docker Cheat Sheet | 22,543 | +3 |
| [eon01](../r/eon01~dockercheatsheet.md) | 🐋 Docker Cheat Sheet 🐋 | 3,948 | +1 |
| [dimonomid](../r/dimonomid~docker-quick-ref.md) | Docker: Printable Quick Reference | 201 | +0 |
| [Docker katas](../r/eficode-academy~docker-katas.md) | Exercises for Docker training | 290 | +0 |
| [JensPiegsa](../r/jenspiegsa~docker-cheat-sheet.md) | A collection of recipes for docker. | 23 | +0 |
| [Learn Docker](../r/dwyl~learn-docker.md) | 🚢    Learn how to use docker.io containers to consistently deploy your apps on any infrastructure. | 244 | +0 |
| [Practical Guide about Docker Commands in Spanish](../r/brunocascio~docker-espanol.md) | Un tutorial Docker en español. Basado en el libro Docker Cookbook de O'reilly | 264 | +0 |
| [Setting Python Development Environment with VScode and Docker](../r/ramikrispin~vscode-python.md) | A Tutorial for Setting Python Development Environment with VScode and Docker | 952 | +0 |

[Back to top](#awesome-docker)

---
*Updated: 2026-09-13 | [View live site ↗](https://patrickclery.com/awesomer/l/docker/)*
