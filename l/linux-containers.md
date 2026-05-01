# awesome-linux-containers

> A curated list of awesome Linux Containers frameworks, libraries and software

[Home](../README.md) | [Live site ↗](https://patrickclery.com/awesomer/l/linux-containers/) | [Source ↗](https://github.com/Friz-zy/awesome-linux-containers)

## Top 10 Trending

| # | Repo | Stars | 7d | 30d | 90d |
|---|------|-------|----|-----|-----|
| 1 | [firecracker](../r/firecracker-microvm~firecracker.md) | 34,023 | +171 | +660 | +1,009 |
| 2 | [Bubblewrap](../r/projectatomic~bubblewrap.md) | 6,943 | +116 |  |  |
| 3 | [podman](../r/containers~libpod.md) | 31,550 | +91 | +379 |  |
| 4 | [portainer](../r/portainer~portainer.md) | 37,314 | +66 | +316 | +505 |
| 5 | [gvisor](../r/google~gvisor.md) | 18,198 | +52 | +189 | +302 |
| 6 | [dive](../r/wagoodman~dive.md) | 53,855 | +46 | +186 | +304 |
| 7 | [LXD](../r/lxc~lxd.md) | 5,272 | +45 |  |  |
| 8 | [skopeo](../r/projectatomic~skopeo.md) | 10,789 | +34 | +157 |  |
| 9 | [NsJail](../r/google~nsjail.md) | 3,867 | +18 |  |  |
| 10 | [buildah](../r/projectatomic~buildah.md) | 8,759 | +16 | +60 |  |

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
| [sysdig-container-ecosystem](../r/draios~sysdig-container-ecosystem.md) | The Container Ecosystem Project | 115 | +0 |

[Back to top](#awesome-linux-containers)

## Clouds

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Warden](../r/cloudfoundry~warden.md) | Cloud Foundry - the open platform as a service project | 284 | +0 |

[Back to top](#awesome-linux-containers)

## Containers

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [firecracker](../r/firecracker-microvm~firecracker.md) | Secure and fast microVMs for serverless computing. | 34,023 | +171 |
| [podman](../r/containers~libpod.md) | Podman: A tool for managing OCI containers and pods. | 31,550 | +91 |
| [sysbox](../r/nestybox~sysbox.md) | An open-source, next-generation "runc" that empowers rootless containers to run workloads such as Systemd, Docker, Kuber | 3,632 | +11 |
| [runc](../r/opencontainers~runc.md) | CLI tool for spawning and running containers according to the OCI specification | 13,196 | +10 |
| [youki](../r/containers~youki.md) | A container runtime written in Rust | 7,364 | +10 |
| [Bocker](../r/p8952~bocker.md) | Docker implemented in around 100 lines of bash | 12,647 | +7 |
| [LXC](../r/lxc~lxc.md) | LXC - Linux Containers | 5,170 | +6 |
| [udocker](../r/indigo-dc~udocker.md) | A basic user tool to execute simple docker containers in batch or interactive systems without root privileges. | 1,735 | +6 |
| [Vagga](../r/tailhook~vagga.md) | Vagga is a containerization tool without daemons | 1,897 | +1 |
| [cc-oci-runtime](../r/01org~cc-oci-runtime.md) | OCI (Open Containers Initiative) compatible runtime for Intel® Architecture | 417 | +0 |
| [footloose](../r/weaveworks~footloose.md) | Container Machines - Containers that look like Virtual Machines | 1,587 | +0 |
| [Let Me Contain That For You](../r/google~lmctfy.md) | lmctfy is the open source version of Google’s container stack, which provides Linux application containers. | 3,410 | +0 |
| [libct](../r/xemul~libct.md) | Linux containers control plane | 108 | +0 |
| [plash](../r/ihucos~plash.md) | Build and run layered root filesystems. | 384 | +0 |
| [porto](../r/yandex~porto.md) | Yet another Linux container management system | 403 | +0 |
| [railcar](../r/oracle~railcar.md) | RailCar: Rust implementation of the Open Containers Initiative oci-runtime | 1,121 | +0 |
| [runv](../r/hyperhq~runv.md) | Hypervisor-based Runtime for OCI | 829 | +0 |
| [Rocket](../r/coreos~rkt.md) | [Project ended] rkt is a pod-native container engine for Linux. It is composable, secure, and built on standards. | 8,782 | -1 |

[Back to top](#awesome-linux-containers)

## Dashboard

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [portainer](../r/portainer~portainer.md) | Making Docker and Kubernetes management easy. | 37,314 | +66 |
| [swarmpit](../r/swarmpit~swarmpit.md) | Lightweight AI-friendly Docker Swarm management | 3,430 | +8 |
| [Liman](../r/salihciftci~liman.md) |  |  |  |

[Back to top](#awesome-linux-containers)

## Filesystem

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [dive](../r/wagoodman~dive.md) | A tool for exploring each layer in a docker image | 53,855 | +46 |
| [skopeo](../r/projectatomic~skopeo.md) | Work with remote images registries - retrieving information, images, signing content | 10,789 | +34 |
| [buildah](../r/projectatomic~buildah.md) | A tool that facilitates building OCI images. | 8,759 | +16 |
| [go-containerregistry](../r/google~go-containerregistry.md) | Go library and CLIs for working with container registries | 3,846 | +15 |
| [container-diff](../r/googlecloudplatform~container-diff.md) | container-diff: Diff your Docker containers | 3,800 | +0 |
| [dgr](../r/blablacar~dgr.md) | Container build and runtime tool | 249 | +0 |
| [docker pushrm](../r/christian-korneck~docker-pushrm.md) | "Docker Push Readme" - a Docker CLI plugin to update container repo docs | 150 | +0 |
| [img](../r/jessfraz~img.md) | Standalone, daemon-less, unprivileged Dockerfile and OCI compatible container image builder. | 3,983 | +0 |
| [kaniko](../r/googlecontainertools~kaniko.md) | Build Container Images In Kubernetes | 15,768 | +0 |
| [Whaler](../r/p3gleg~whaler.md) | Program to reverse Docker images into Dockerfiles | 1,184 | +0 |

[Back to top](#awesome-linux-containers)

## Hypervisors

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [LXD](../r/lxc~lxd.md) | Powerful system container and virtual machine manager  | 5,272 | +45 |
| [Lithos](../r/tailhook~lithos.md) | Process supervisor that supports linux containers | 118 | +0 |
| [MultiDocker](../r/marty90~multidocker.md) | Creates a system where users are forced to login in dedicated independent docker containers. | 56 | +0 |

[Back to top](#awesome-linux-containers)

## Operating Systems

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Photon](../r/vmware~photon.md) | Minimal Linux container host | 3,175 | -2 |

[Back to top](#awesome-linux-containers)

## Partial Access

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Moby](../r/moby~moby.md) | The Moby Project - a collaborative project for the container ecosystem to assemble container-based systems | 71,512 | +6 |
| [pyspaces](../r/friz-zy~pyspaces.md) | Works with Linux namespaces througth glibc with pure python | 88 | +0 |
| [python-nsenter](../r/zalando~python-nsenter.md) | Enter kernel namespaces from Python | 142 | +0 |

[Back to top](#awesome-linux-containers)

## Sandboxes

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Bubblewrap](../r/projectatomic~bubblewrap.md) | Low-level unprivileged sandboxing tool used by Flatpak and similar projects | 6,943 | +116 |
| [NsJail](../r/google~nsjail.md) | A lightweight process isolation tool that utilizes Linux namespaces, cgroups, rlimits and seccomp-bpf syscall filters, l | 3,867 | +18 |
| [Lxroot](../r/parke~lxroot.md) | A lightweight, flexible, and safer alternative to chroot and/or Docker. | 118 | +0 |
| [Subuser](../r/subuser-security~subuser.md) | Run programs on linux with selectively restricted permissions. | 894 | +0 |
| [singularity](../r/singularityware~singularity.md) | Singularity has been renamed to Apptainer as part of us moving the project to the Linux Foundation. This repo has been p | 2,612 | -1 |

[Back to top](#awesome-linux-containers)

## Security

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [gvisor](../r/google~gvisor.md) | Application Kernel for Containers | 18,198 | +52 |
| [Docker bench security](../r/docker~docker-bench-security.md) | The Docker Bench for Security is a script that checks for dozens of common best-practices around deploying Docker contai | 9,627 | +6 |
| [goss](../r/aelsabbahy~goss.md) | Quick and Easy server testing/validation | 5,889 | +3 |
| [oci-seccomp-bpf-hook](../r/containers~oci-seccomp-bpf-hook.md) | OCI hook to trace syscalls and generate a seccomp profile | 342 | +2 |
| [bane](../r/jfrazelle~bane.md) | Custom & better AppArmor profile generator for Docker containers. | 1,226 | +0 |
| [docker-explorer](../r/google~docker-explorer.md) | A tool to help forensicate offline docker acquisitions | 555 | +0 |
| [drydock](../r/zubux~drydock.md) | drydock provides a flexible way of assessing the security of your Docker daemon configuration and containers using edita | 65 | +0 |
| [OpenSCAP](../r/openscap~container-compliance.md) | Assessing compliance of a container | 241 | +0 |
| [sockguard](../r/buildkite~sockguard.md) | A proxy for docker.sock that enforces access control and isolated privileges  | 144 | +0 |

[Back to top](#awesome-linux-containers)

## Specifications

| Repo | Description | Stars | 7d |
|------|-------------|-------|----|
| [Open Container Specifications](../r/opencontainers~specs.md) | OCI Runtime Specification | 3,607 | +4 |
| [Cloud Native Application Bundle Specification](../r/deislabs~cnab-spec.md) | Cloud Native Application Bundle Specification | 971 | +0 |

[Back to top](#awesome-linux-containers)

---
*Updated: 2026-04-29 | [View live site ↗](https://patrickclery.com/awesomer/l/linux-containers/)*
