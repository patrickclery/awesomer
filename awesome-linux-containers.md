# awesome-linux-containers

A curated list of awesome Linux Containers frameworks, libraries and software

**Source:** [Friz-zy/awesome-linux-containers](https://github.com/Friz-zy/awesome-linux-containers)

## Table of Contents

- [Top 10: Stars](#top-10-stars)
- [Containers](#containers)
- [Dashboard](#dashboard)
- [Filesystem](#filesystem)
- [Hypervisors](#hypervisors)
- [Operating Systems](#operating-systems)
- [Partial Access](#partial-access)
- [Sandboxes](#sandboxes)
- [Security](#security)
- [Specifications](#specifications)

## Top 10: Stars

| Name | Category | Stars | 7d | 30d | 90d | Last Commit |
|------|----------|-------|----|-----|-----|-------------|
| [Moby](https://github.com/moby/moby) | Partial Access | 71,483 | +38 |  |  | 2026-03-05 |
| [dive](https://github.com/wagoodman/dive) | Filesystem | 53,488 | +60 |  |  | 2025-12-15 |
| [portainer](https://github.com/portainer/portainer) | Dashboard | 36,761 | +80 |  |  | 2026-03-04 |
| [firecracker](https://github.com/firecracker-microvm/firecracker) | Containers | 32,844 | +154 |  |  | 2026-03-05 |
| [podman](https://github.com/containers/libpod) | Containers | 30,915 | +93 |  |  | 2026-03-05 |
| [gvisor](https://github.com/google/gvisor) | Security | 17,833 | +34 |  |  | 2026-03-06 |
| [kaniko](https://github.com/GoogleContainerTools/kaniko) | Filesystem | 15,754 | +1 |  |  | 2025-06-03 |
| [runc](https://github.com/opencontainers/runc) | Containers | 13,099 | +19 |  |  | 2026-03-06 |
| [Bocker](https://github.com/p8952/bocker) | Containers | 12,624 |  |  |  | 2017-12-09 |
| [skopeo](https://github.com/projectatomic/skopeo) | Filesystem | 10,536 | +41 |  |  | 2026-03-03 |

[Back to Top](#table-of-contents)

## Containers

| Name | Description | Stars | 7d | 30d | 90d | Last Commit |
|------|-------------|-------|----|-----|-----|-------------|
| [firecracker](https://github.com/firecracker-microvm/firecracker) | Secure and fast microVMs for serverless computing. | 32,844 | +154 |  |  | 2026-03-05 |
| [podman](https://github.com/containers/libpod) | Podman: A tool for managing OCI containers and pods. | 30,915 | +93 |  |  | 2026-03-05 |
| [runc](https://github.com/opencontainers/runc) | CLI tool for spawning and running containers according to the OCI specification | 13,099 | +19 |  |  | 2026-03-06 |
| [Bocker](https://github.com/p8952/bocker) | Docker implemented in around 100 lines of bash | 12,624 |  |  |  | 2017-12-09 |
| [Rocket](https://github.com/coreos/rkt) | [Project ended] rkt is a pod-native container engine for Linux. It is composable, secure, and built on standards. | 8,794 | +1 |  |  | 2020-02-24 |
| [youki](https://github.com/containers/youki) | A container runtime written in Rust | 7,264 | +17 |  |  | 2026-03-06 |
| [LXC](https://github.com/lxc/lxc) | LXC - Linux Containers | 5,123 | +9 |  |  | 2026-03-02 |
| [sysbox](https://github.com/nestybox/sysbox) | An open-source, next-generation "runc" that empowers rootless containers to run workloads such as Systemd, Docker, Kuber | 3,489 | +18 |  |  | 2026-03-04 |
| [Let Me Contain That For You](https://github.com/google/lmctfy) | lmctfy is the open source version of Google’s container stack, which provides Linux application containers. | 3,410 |  |  |  | 2015-06-29 |
| [Vagga](https://github.com/tailhook/vagga) | Vagga is a containerization tool without daemons | 1,896 | +1 |  |  | 2023-03-31 |
| [udocker](https://github.com/indigo-dc/udocker) | A basic user tool to execute simple docker containers in batch or interactive systems without root privileges. | 1,705 | +2 |  |  | 2025-08-13 |
| [footloose](https://github.com/weaveworks/footloose) | Container Machines - Containers that look like Virtual Machines | 1,587 | +-1 |  |  | 2023-08-29 |
| [railcar](https://github.com/oracle/railcar) | RailCar: Rust implementation of the Open Containers Initiative oci-runtime | 1,123 |  |  |  | 2019-10-15 |

[Back to Top](#table-of-contents)

## Dashboard

| Name | Description | Stars | 7d | 30d | 90d | Last Commit |
|------|-------------|-------|----|-----|-----|-------------|
| [portainer](https://github.com/portainer/portainer) | Making Docker and Kubernetes management easy. | 36,761 | +80 |  |  | 2026-03-04 |
| [swarmpit](https://github.com/swarmpit/swarmpit) | Lightweight mobile-friendly Docker Swarm management UI | 3,410 | +3 |  |  | 2026-03-04 |

[Back to Top](#table-of-contents)

## Filesystem

| Name | Description | Stars | 7d | 30d | 90d | Last Commit |
|------|-------------|-------|----|-----|-----|-------------|
| [dive](https://github.com/wagoodman/dive) | A tool for exploring each layer in a docker image | 53,488 | +60 |  |  | 2025-12-15 |
| [kaniko](https://github.com/GoogleContainerTools/kaniko) | Build Container Images In Kubernetes | 15,754 | +1 |  |  | 2025-06-03 |
| [skopeo](https://github.com/projectatomic/skopeo) | Work with remote images registries - retrieving information, images, signing content | 10,536 | +41 |  |  | 2026-03-03 |
| [buildah](https://github.com/projectatomic/buildah) | A tool that facilitates building OCI images. | 8,657 | +26 |  |  | 2026-03-05 |
| [img](https://github.com/jessfraz/img) | Standalone, daemon-less, unprivileged Dockerfile and OCI compatible container image builder. | 3,990 |  |  |  | 2024-05-19 |
| [container-diff](https://github.com/GoogleCloudPlatform/container-diff) | container-diff: Diff your Docker containers | 3,802 | +2 |  |  | 2024-03-27 |
| [go-containerregistry](https://github.com/google/go-containerregistry) | Go library and CLIs for working with container registries | 3,761 | +4 |  |  | 2026-03-04 |
| [Whaler](https://github.com/P3GLEG/Whaler) | Program to reverse Docker images into Dockerfiles | 1,185 | +1 |  |  | 2025-09-17 |

[Back to Top](#table-of-contents)

## Hypervisors

| Name | Description | Stars | 7d | 30d | 90d | Last Commit |
|------|-------------|-------|----|-----|-----|-------------|
| [LXD](https://github.com/lxc/lxd) | Powerful system container and virtual machine manager  | 4,975 | +42 |  |  | 2026-03-06 |

[Back to Top](#table-of-contents)

## Operating Systems

| Name | Description | Stars | 7d | 30d | 90d | Last Commit |
|------|-------------|-------|----|-----|-----|-------------|
| [Photon](https://github.com/vmware/photon) | Minimal Linux container host | 3,170 | +3 |  |  | 2026-03-06 |

[Back to Top](#table-of-contents)

## Partial Access

| Name | Description | Stars | 7d | 30d | 90d | Last Commit |
|------|-------------|-------|----|-----|-----|-------------|
| [Moby](https://github.com/moby/moby) | The Moby Project - a collaborative project for the container ecosystem to assemble container-based systems | 71,483 | +38 |  |  | 2026-03-05 |

[Back to Top](#table-of-contents)

## Sandboxes

| Name | Description | Stars | 7d | 30d | 90d | Last Commit |
|------|-------------|-------|----|-----|-----|-------------|
| [Bubblewrap](https://github.com/projectatomic/bubblewrap) | Low-level unprivileged sandboxing tool used by Flatpak and similar projects | 6,008 | +80 |  |  | 2026-02-04 |
| [NsJail](https://github.com/google/nsjail) | A lightweight process isolation tool that utilizes Linux namespaces, cgroups, rlimits and seccomp-bpf syscall filters, l | 3,751 | +15 |  |  | 2026-03-05 |
| [singularity](https://github.com/singularityware/singularity) | Singularity has been renamed to Apptainer as part of us moving the project to the Linux Foundation. This repo has been p | 2,606 | +1 |  |  | 2022-10-10 |

[Back to Top](#table-of-contents)

## Security

| Name | Description | Stars | 7d | 30d | 90d | Last Commit |
|------|-------------|-------|----|-----|-----|-------------|
| [gvisor](https://github.com/google/gvisor) | Application Kernel for Containers | 17,833 | +34 |  |  | 2026-03-06 |
| [Docker bench security](https://github.com/docker/docker-bench-security) | The Docker Bench for Security is a script that checks for dozens of common best-practices around deploying Docker contai | 9,599 |  |  |  | 2024-10-21 |
| [goss](https://github.com/aelsabbahy/goss) | Quick and Easy server testing/validation | 5,869 | +4 |  |  | 2025-05-01 |
| [bane](https://github.com/jfrazelle/bane) | Custom & better AppArmor profile generator for Docker containers. | 1,224 | +-1 |  |  | 2020-09-17 |

[Back to Top](#table-of-contents)

## Specifications

| Name | Description | Stars | 7d | 30d | 90d | Last Commit |
|------|-------------|-------|----|-----|-----|-------------|
| [Open Container Specifications](https://github.com/opencontainers/specs) | OCI Runtime Specification | 3,563 | +2 |  |  | 2026-02-25 |

[Back to Top](#table-of-contents)
