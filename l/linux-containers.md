# awesome-linux-containers

> A curated list of awesome Linux Containers frameworks, libraries and software

[Home](../README.md) | [Live site ↗](https://patrickclery.com/awesomer/l/linux-containers/) | [Source ↗](https://github.com/Friz-zy/awesome-linux-containers)

## Top 10 Trending

| # | Repo | Stars | 7d | 30d | 90d |
|---|------|-------|----|-----|-----|
| 1 | [firecracker](../r/firecracker-microvm~firecracker.md) | 38,147 | +133 | +596 | +1,932 |
| 2 | [Bubblewrap](../r/projectatomic~bubblewrap.md) | 9,576 | +91 | +415 | +1,120 |
| 3 | [podman](../r/containers~libpod.md) | 33,347 | +73 | +251 | +679 |
| 4 | [gvisor](../r/google~gvisor.md) | 20,070 | +70 | +326 | +931 |
| 5 | [portainer](../r/portainer~portainer.md) | 38,876 | +47 | +171 | +564 |
| 6 | [LXD](../r/lxc~lxd.md) | 6,686 | +46 | +233 | +680 |
| 7 | [Moby](../r/moby~moby.md) | 72,304 | +46 | +107 | +313 |
| 8 | [youki](../r/containers~youki.md) | 7,708 | +28 | +64 | +147 |
| 9 | [dive](../r/wagoodman~dive.md) | 54,751 | +27 | +89 | +266 |
| 10 | [skopeo](../r/projectatomic~skopeo.md) | 11,425 | +24 | +84 | +241 |

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
| [sysdig-container-ecosystem](https://github.com/draios/sysdig-container-ecosystem) | The Container Ecosystem Project | 115 | +0 |

[Back to top](#awesome-linux-containers)

## Clouds

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Warden](https://github.com/cloudfoundry/warden) | Cloud Foundry - the open platform as a service project | 284 | +0 |

[Back to top](#awesome-linux-containers)

## Containers

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [firecracker](../r/firecracker-microvm~firecracker.md) | Secure and fast microVMs for serverless computing. | 38,147 | +133 |
| [podman](../r/containers~libpod.md) | Podman: A tool for managing OCI containers and pods. | 33,347 | +73 |
| [youki](../r/containers~youki.md) | A container runtime written in Rust | 7,708 | +28 |
| [runc](../r/opencontainers~runc.md) | CLI tool for spawning and running containers according to the OCI specification | 13,569 | +14 |
| [Bocker](https://github.com/p8952/bocker) | Docker implemented in around 100 lines of bash | 12,722 | +12 |
| [sysbox](../r/nestybox~sysbox.md) | An open-source, next-generation "runc" that empowers rootless containers to run workloads such as Systemd, Docker, Kuber | 3,981 | +12 |
| [LXC](../r/lxc~lxc.md) | LXC - Linux Containers | 5,299 | +2 |
| [udocker](https://github.com/indigo-dc/udocker) | A basic user tool to execute simple docker containers in batch or interactive systems without root privileges. | 1,810 | +2 |
| [cc-oci-runtime](https://github.com/01org/cc-oci-runtime) | OCI (Open Containers Initiative) compatible runtime for Intel® Architecture | 417 | +0 |
| [libct](https://github.com/xemul/libct) | Linux containers control plane | 108 | +0 |
| [plash](https://github.com/ihucos/plash) | Build and run layered root filesystems. | 381 | +0 |
| [porto](https://github.com/yandex/porto) | Yet another Linux container management system | 403 | +0 |
| [runv](https://github.com/hyperhq/runv) | Hypervisor-based Runtime for OCI | 828 | +0 |
| [Let Me Contain That For You](https://github.com/google/lmctfy) | lmctfy is the open source version of Google’s container stack, which provides Linux application containers. | 3,397 | -1 |
| [Rocket](https://github.com/coreos/rkt) | [Project ended] rkt is a pod-native container engine for Linux. It is composable, secure, and built on standards. | 8,757 | -1 |
| [Vagga](https://github.com/tailhook/vagga) | Vagga is a containerization tool without daemons | 1,892 | -1 |
| [footloose](https://github.com/weaveworks/footloose) | Container Machines - Containers that look like Virtual Machines | 1,580 | -2 |
| [railcar](https://github.com/oracle/railcar) | RailCar: Rust implementation of the Open Containers Initiative oci-runtime | 1,119 | -2 |

[Back to top](#awesome-linux-containers)

## Dashboard

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [portainer](../r/portainer~portainer.md) | Making Docker and Kubernetes management easy. | 38,876 | +47 |
| [swarmpit](../r/swarmpit~swarmpit.md) | Lightweight AI-friendly Docker Swarm management | 3,509 | +1 |
| [Liman](https://github.com/salihciftci/liman) |  |  |  |

[Back to top](#awesome-linux-containers)

## Filesystem

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [dive](../r/wagoodman~dive.md) | A tool for exploring each layer in a docker image | 54,751 | +27 |
| [skopeo](../r/projectatomic~skopeo.md) | Work with remote images registries - retrieving information, images, signing content | 11,425 | +24 |
| [buildah](../r/projectatomic~buildah.md) | A tool that facilitates building OCI images. | 9,193 | +9 |
| [go-containerregistry](../r/google~go-containerregistry.md) | Go library and CLIs for working with container registries | 4,139 | +6 |
| [img](https://github.com/jessfraz/img) | Standalone, daemon-less, unprivileged Dockerfile and OCI compatible container image builder. | 3,989 | +1 |
| [kaniko](https://github.com/GoogleContainerTools/kaniko) | Build Container Images In Kubernetes | 15,745 | +1 |
| [dgr](https://github.com/blablacar/dgr) | Container build and runtime tool | 247 | +0 |
| [docker pushrm](https://github.com/christian-korneck/docker-pushrm) | "Docker Push Readme" - a Docker CLI plugin to update container repo docs | 153 | +0 |
| [container-diff](https://github.com/GoogleCloudPlatform/container-diff) | container-diff: Diff your Docker containers | 3,792 | -1 |
| [Whaler](../r/p3gleg~whaler.md) | Program to reverse Docker images into Dockerfiles | 1,196 | -1 |

[Back to top](#awesome-linux-containers)

## Hypervisors

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [LXD](../r/lxc~lxd.md) | Powerful system container and virtual machine manager  | 6,686 | +46 |
| [Lithos](https://github.com/tailhook/lithos) | Process supervisor that supports linux containers | 118 | +0 |
| [MultiDocker](https://github.com/marty90/multidocker) | Creates a system where users are forced to login in dedicated independent docker containers. | 55 | +0 |

[Back to top](#awesome-linux-containers)

## Operating Systems

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Photon](../r/vmware~photon.md) | Minimal Linux container host | 3,183 | +2 |

[Back to top](#awesome-linux-containers)

## Partial Access

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Moby](../r/moby~moby.md) | The Moby Project - a collaborative project for the container ecosystem to assemble container-based systems | 72,304 | +46 |
| [pyspaces](https://github.com/Friz-zy/pyspaces) | Works with Linux namespaces througth glibc with pure python | 88 | +0 |
| [python-nsenter](https://github.com/zalando/python-nsenter) | Enter kernel namespaces from Python | 140 | +0 |

[Back to top](#awesome-linux-containers)

## Sandboxes

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Bubblewrap](../r/projectatomic~bubblewrap.md) | Low-level unprivileged sandboxing tool used by Flatpak and similar projects | 9,576 | +91 |
| [NsJail](../r/google~nsjail.md) | A lightweight process isolation tool that utilizes Linux namespaces, cgroups, rlimits and seccomp-bpf syscall filters, l | 4,200 | +10 |
| [singularity](https://github.com/singularityware/singularity) | Singularity has been renamed to Apptainer as part of us moving the project to the Linux Foundation. This repo has been p | 2,629 | +2 |
| [Lxroot](https://github.com/parke/lxroot) | A lightweight, flexible, and safer alternative to chroot and/or Docker. | 121 | +0 |
| [Subuser](https://github.com/subuser-security/subuser) | Run programs on linux with selectively restricted permissions. | 893 | -1 |

[Back to top](#awesome-linux-containers)

## Security

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [gvisor](../r/google~gvisor.md) | Application Kernel for Containers | 20,070 | +70 |
| [goss](../r/aelsabbahy~goss.md) | Quick and Easy server testing/validation | 6,010 | +3 |
| [Docker bench security](../r/docker~docker-bench-security.md) | The Docker Bench for Security is a script that checks for dozens of common best-practices around deploying Docker contai | 9,713 | +0 |
| [docker-explorer](https://github.com/google/docker-explorer) | A tool to help forensicate offline docker acquisitions | 553 | +0 |
| [drydock](https://github.com/zuBux/drydock) | drydock provides a flexible way of assessing the security of your Docker daemon configuration and containers using edita | 66 | +0 |
| [oci-seccomp-bpf-hook](../r/containers~oci-seccomp-bpf-hook.md) | OCI hook to trace syscalls and generate a seccomp profile | 353 | +0 |
| [OpenSCAP](https://github.com/OpenSCAP/container-compliance) | Assessing compliance of a container | 241 | +0 |
| [sockguard](https://github.com/buildkite/sockguard) | A proxy for docker.sock that enforces access control and isolated privileges  | 143 | +0 |
| [bane](https://github.com/jfrazelle/bane) | Custom & better AppArmor profile generator for Docker containers. | 1,228 | -1 |

[Back to top](#awesome-linux-containers)

## Specifications

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Open Container Specifications](../r/opencontainers~specs.md) | OCI Runtime Specification | 3,708 | +4 |
| [Cloud Native Application Bundle Specification](https://github.com/deislabs/cnab-spec) | Cloud Native Application Bundle Specification | 972 | +0 |

[Back to top](#awesome-linux-containers)

---
*Updated: 2026-11-21 | [View live site ↗](https://patrickclery.com/awesomer/l/linux-containers/)*
