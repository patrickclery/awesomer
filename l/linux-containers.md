# awesome-linux-containers

> A curated list of awesome Linux Containers frameworks, libraries and software

[Home](../README.md) | [Live site ↗](https://patrickclery.com/awesomer/l/linux-containers/) | [Source ↗](https://github.com/Friz-zy/awesome-linux-containers)

## Top 10 Trending

| # | Repo | Stars | 7d | 30d | 90d |
|---|------|-------|----|-----|-----|
| 1 | [firecracker](../r/firecracker-microvm~firecracker.md) | 37,882 | +143 | +653 | +1,928 |
| 2 | [Moby](../r/moby~moby.md) | 72,355 | +128 | +192 | +332 |
| 3 | [Bubblewrap](../r/projectatomic~bubblewrap.md) | 9,402 | +99 | +440 | +1,106 |
| 4 | [gvisor](../r/google~gvisor.md) | 19,903 | +62 | +305 | +871 |
| 5 | [LXD](../r/lxc~lxd.md) | 6,602 | +61 | +246 | +724 |
| 6 | [podman](../r/containers~libpod.md) | 33,195 | +44 | +184 | +691 |
| 7 | [portainer](../r/portainer~portainer.md) | 38,786 | +30 | +172 | +593 |
| 8 | [dive](../r/wagoodman~dive.md) | 54,706 | +24 | +80 | +277 |
| 9 | [runc](../r/opencontainers~runc.md) | 13,537 | +19 | +59 | +146 |
| 10 | [sysbox](../r/nestybox~sysbox.md) | 3,952 | +14 | +55 | +133 |

## Table of Contents

- [Another Information Sources](#another-information-sources)
- [Clouds](#clouds)
- [Containers](#containers)
- [Dashboard](#dashboard)
- [Filesystem](#filesystem)
- [Hypervisors](#hypervisors)
- [Operating Systems](#operating-systems)
- [Partial Access](#partial-access)
- [Sandboxes](#sandboxes)
- [Security](#security)
- [Specifications](#specifications)

## Another Information Sources

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [sysdig-container-ecosystem](https://github.com/draios/sysdig-container-ecosystem) | The Container Ecosystem Project | 115 | -1 |

[Back to top](#awesome-linux-containers)

## Clouds

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Warden](https://github.com/cloudfoundry/warden) | Cloud Foundry - the open platform as a service project | 284 | +0 |

[Back to top](#awesome-linux-containers)

## Containers

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [firecracker](../r/firecracker-microvm~firecracker.md) | Secure and fast microVMs for serverless computing. | 37,882 | +143 |
| [podman](../r/containers~libpod.md) | Podman: A tool for managing OCI containers and pods. | 33,195 | +44 |
| [runc](../r/opencontainers~runc.md) | CLI tool for spawning and running containers according to the OCI specification | 13,537 | +19 |
| [sysbox](../r/nestybox~sysbox.md) | An open-source, next-generation "runc" that empowers rootless containers to run workloads such as Systemd, Docker, Kuber | 3,952 | +14 |
| [udocker](https://github.com/indigo-dc/udocker) | A basic user tool to execute simple docker containers in batch or interactive systems without root privileges. | 1,806 | +5 |
| [youki](../r/containers~youki.md) | A container runtime written in Rust | 7,668 | +5 |
| [LXC](../r/lxc~lxc.md) | LXC - Linux Containers | 5,291 | +1 |
| [cc-oci-runtime](https://github.com/01org/cc-oci-runtime) | OCI (Open Containers Initiative) compatible runtime for Intel® Architecture | 417 | +0 |
| [footloose](https://github.com/weaveworks/footloose) | Container Machines - Containers that look like Virtual Machines | 1,581 | +0 |
| [libct](https://github.com/xemul/libct) | Linux containers control plane | 108 | +0 |
| [plash](https://github.com/ihucos/plash) | Build and run layered root filesystems. | 381 | +0 |
| [porto](https://github.com/yandex/porto) | Yet another Linux container management system | 403 | +0 |
| [railcar](https://github.com/oracle/railcar) | RailCar: Rust implementation of the Open Containers Initiative oci-runtime | 1,120 | +0 |
| [Rocket](https://github.com/coreos/rkt) | [Project ended] rkt is a pod-native container engine for Linux. It is composable, secure, and built on standards. | 8,757 | +0 |
| [runv](https://github.com/hyperhq/runv) | Hypervisor-based Runtime for OCI | 828 | +0 |
| [Vagga](https://github.com/tailhook/vagga) | Vagga is a containerization tool without daemons | 1,892 | +0 |
| [Bocker](https://github.com/p8952/bocker) | Docker implemented in around 100 lines of bash | 12,709 | -1 |
| [Let Me Contain That For You](https://github.com/google/lmctfy) | lmctfy is the open source version of Google’s container stack, which provides Linux application containers. | 3,398 | -1 |

[Back to top](#awesome-linux-containers)

## Dashboard

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [portainer](../r/portainer~portainer.md) | Making Docker and Kubernetes management easy. | 38,786 | +30 |
| [Liman](https://github.com/salihciftci/liman) |  |  |  |
| [swarmpit](../r/swarmpit~swarmpit.md) | Lightweight AI-friendly Docker Swarm management | 3,503 | +0 |

[Back to top](#awesome-linux-containers)

## Filesystem

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [dive](../r/wagoodman~dive.md) | A tool for exploring each layer in a docker image | 54,706 | +24 |
| [buildah](../r/projectatomic~buildah.md) | A tool that facilitates building OCI images. | 9,174 | +14 |
| [go-containerregistry](../r/google~go-containerregistry.md) | Go library and CLIs for working with container registries | 4,119 | +14 |
| [skopeo](../r/projectatomic~skopeo.md) | Work with remote images registries - retrieving information, images, signing content | 11,379 | +12 |
| [Whaler](../r/p3gleg~whaler.md) | Program to reverse Docker images into Dockerfiles | 1,197 | +2 |
| [container-diff](https://github.com/GoogleCloudPlatform/container-diff) | container-diff: Diff your Docker containers | 3,796 | +0 |
| [dgr](https://github.com/blablacar/dgr) | Container build and runtime tool | 247 | +0 |
| [docker pushrm](https://github.com/christian-korneck/docker-pushrm) | "Docker Push Readme" - a Docker CLI plugin to update container repo docs | 153 | +0 |
| [kaniko](https://github.com/GoogleContainerTools/kaniko) | Build Container Images In Kubernetes | 15,749 | +0 |
| [img](https://github.com/jessfraz/img) | Standalone, daemon-less, unprivileged Dockerfile and OCI compatible container image builder. | 3,988 | -1 |

[Back to top](#awesome-linux-containers)

## Hypervisors

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [LXD](../r/lxc~lxd.md) | Powerful system container and virtual machine manager  | 6,602 | +61 |
| [Lithos](https://github.com/tailhook/lithos) | Process supervisor that supports linux containers | 118 | +0 |
| [MultiDocker](https://github.com/marty90/multidocker) | Creates a system where users are forced to login in dedicated independent docker containers. | 55 | +0 |

[Back to top](#awesome-linux-containers)

## Operating Systems

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Photon](../r/vmware~photon.md) | Minimal Linux container host | 3,180 | +1 |

[Back to top](#awesome-linux-containers)

## Partial Access

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Moby](../r/moby~moby.md) | The Moby Project - a collaborative project for the container ecosystem to assemble container-based systems | 72,355 | +128 |
| [pyspaces](https://github.com/Friz-zy/pyspaces) | Works with Linux namespaces througth glibc with pure python | 88 | +0 |
| [python-nsenter](https://github.com/zalando/python-nsenter) | Enter kernel namespaces from Python | 140 | +0 |

[Back to top](#awesome-linux-containers)

## Sandboxes

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Bubblewrap](../r/projectatomic~bubblewrap.md) | Low-level unprivileged sandboxing tool used by Flatpak and similar projects | 9,402 | +99 |
| [NsJail](../r/google~nsjail.md) | A lightweight process isolation tool that utilizes Linux namespaces, cgroups, rlimits and seccomp-bpf syscall filters, l | 4,185 | +6 |
| [Lxroot](https://github.com/parke/lxroot) | A lightweight, flexible, and safer alternative to chroot and/or Docker. | 120 | +0 |
| [singularity](https://github.com/singularityware/singularity) | Singularity has been renamed to Apptainer as part of us moving the project to the Linux Foundation. This repo has been p | 2,625 | +0 |
| [Subuser](https://github.com/subuser-security/subuser) | Run programs on linux with selectively restricted permissions. | 893 | +0 |

[Back to top](#awesome-linux-containers)

## Security

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [gvisor](../r/google~gvisor.md) | Application Kernel for Containers | 19,903 | +62 |
| [goss](../r/aelsabbahy~goss.md) | Quick and Easy server testing/validation | 6,002 | +3 |
| [oci-seccomp-bpf-hook](../r/containers~oci-seccomp-bpf-hook.md) | OCI hook to trace syscalls and generate a seccomp profile | 352 | +1 |
| [bane](https://github.com/jfrazelle/bane) | Custom & better AppArmor profile generator for Docker containers. | 1,229 | +0 |
| [OpenSCAP](https://github.com/OpenSCAP/container-compliance) | Assessing compliance of a container | 241 | +0 |
| [sockguard](https://github.com/buildkite/sockguard) | A proxy for docker.sock that enforces access control and isolated privileges  | 143 | +0 |
| [docker-explorer](https://github.com/google/docker-explorer) | A tool to help forensicate offline docker acquisitions | 554 | -1 |
| [drydock](https://github.com/zuBux/drydock) | drydock provides a flexible way of assessing the security of your Docker daemon configuration and containers using edita | 66 | -1 |
| [Docker bench security](../r/docker~docker-bench-security.md) | The Docker Bench for Security is a script that checks for dozens of common best-practices around deploying Docker contai | 9,705 | -2 |

[Back to top](#awesome-linux-containers)

## Specifications

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Open Container Specifications](../r/opencontainers~specs.md) | OCI Runtime Specification | 3,700 | +3 |
| [Cloud Native Application Bundle Specification](https://github.com/deislabs/cnab-spec) | Cloud Native Application Bundle Specification | 972 | +0 |

[Back to top](#awesome-linux-containers)

---
*Updated: 2026-11-07 | [View live site ↗](https://patrickclery.com/awesomer/l/linux-containers/)*
