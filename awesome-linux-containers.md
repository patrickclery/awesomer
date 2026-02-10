# awesome-linux-containers

A curated list of awesome Linux Containers frameworks, libraries and software

**Source:** [Friz-zy/awesome-linux-containers](https://github.com/Friz-zy/awesome-linux-containers)

## Table of Contents

- [Containers](#containers)
- [Dashboard](#dashboard)
- [Filesystem](#filesystem)
- [Hypervisors](#hypervisors)
- [Operating Systems](#operating-systems)
- [Partial Access](#partial-access)
- [Sandboxes](#sandboxes)
- [Security](#security)

## Containers

| Name                                                              | Description                                                                                                                                                                                                                                                               | Stars | Last Commit |
|-------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [firecracker](https://github.com/firecracker-microvm/firecracker) | Firecracker runs workloads in lightweight virtual machines, called microVMs, which combine the security and isolation properties provided by hardware virtualization technology with the speed and flexibility of containers.                                             | 30232 | 2025-09-04  |
| [runc](https://github.com/opencontainers/runc)                    | runc is a CLI tool for spawning and running containers according to the OCS specification.                                                                                                                                                                                | 12630 | 2025-09-05  |
| [Bocker](https://github.com/p8952/bocker)                         | Docker implemented in around 100 lines of bash.                                                                                                                                                                                                                           | 12439 | 2017-12-09  |
| [LXC](https://github.com/lxc/lxc)                                 | LXC is the well known set of tools, templates, library and language bindings. It's pretty low level, very flexible and covers just about every containment feature supported by the upstream kernel.                                                                      | 4974  | 2025-08-27  |
| [Let Me Contain That For You](https://github.com/google/lmctfy)   | LMCTFY is the open source version of Google’s container stack, which provides Linux application containers.                                                                                                                                                               | 3410  | 2015-06-29  |
| [sysbox](https://github.com/nestybox/sysbox)                      | Sysbox is a "runc" that creates secure (rootless) containers / pods that run not just microservices, but most workloads that run in VMs (e.g., systemd, Docker, and Kubernetes), seamlessly.                                                                              | 3201  | 2025-08-30  |
| [Vagga](https://github.com/tailhook/vagga)                        | Vagga is a fully-userspace container engine inspired by Vagrant and Docker, specialized for development environments.                                                                                                                                                     | 1887  | 2023-03-31  |
| [footloose](https://github.com/weaveworks/footloose)              | Containers that look like Virtual Machines.                                                                                                                                                                                                                               | 1590  | 2023-08-29  |
| [udocker](https://github.com/indigo-dc/udocker)                   | A basic user tool to execute simple containers in batch or interactive systems without root privileges.                                                                                                                                                                   | 1536  | 2025-08-13  |
| [railcar](https://github.com/oracle/railcar)                      | Railcar is a rust implementation of the opencontainers initiative's runtime spec. It is similar to the reference implementation runc, but it is implemented completely in rust for memory safety without needing the overhead of a garbage collector or multiple threads. | 1122  | 2019-10-15  |
| [runv](https://github.com/hyperhq/runv)                           | Hypervisor-based (KVM, Xen, QEMU) Runtime for OCI. Security by isolation.                                                                                                                                                                                                 | 825   | 2021-02-08  |

[Back to Top](#table-of-contents)

## Dashboard

| Name                                                | Description                                             | Stars | Last Commit |
|-----------------------------------------------------|---------------------------------------------------------|-------|-------------|
| [portainer](https://github.com/portainer/portainer) | Lightweight Docker management UI.                       | 34360 | 2025-09-05  |
| [swarmpit](https://github.com/swarmpit/swarmpit)    | Lightweight mobile-friendly Docker Swarm management UI. | 3309  | 2025-02-06  |

[Back to Top](#table-of-contents)

## Filesystem

| Name                                                                   | Description                                                                                             | Stars | Last Commit |
|------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------|-------|-------------|
| [dive](https://github.com/wagoodman/dive)                              | A tool for exploring each layer in a docker image.                                                      | 51935 | 2025-08-21  |
| [kaniko](https://github.com/GoogleContainerTools/kaniko)               | Kaniko is a tool to build container images from a Dockerfile, inside a container or Kubernetes cluster. | 15677 | 2025-06-03  |
| [go-containerregistry](https://github.com/google/go-containerregistry) | Go library and CLIs for working with container registries.                                              | 3494  | 2025-09-08  |
| [Whaler](https://github.com/P3GLEG/Whaler)                             | Whaler is designed to reverse engineer a Docker Image into the Dockerfile that created it.              | 1140  | 2025-05-25  |

[Back to Top](#table-of-contents)

## Hypervisors

| Name                                                   | Description                                                                                        | Stars | Last Commit |
|--------------------------------------------------------|----------------------------------------------------------------------------------------------------|-------|-------------|
| [Docker](https://github.com/veggiemonk/awesome-docker) | An open platform for distributed applications for developers and sysadmins. **Standard de facto**. | 33607 | 2025-08-26  |

[Back to Top](#table-of-contents)

## Operating Systems

| Name                                       | Description                                                                                                                                                                                                                                 | Stars | Last Commit |
|--------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Photon](https://github.com/vmware/photon) | Photon OS is a minimal Linux container host designed to have a small footprint and tuned for VMware platforms. Photon is intended to invite collaboration around running containerized and Linux applications in a virtualized environment. | 3132  | 2025-09-05  |

[Back to Top](#table-of-contents)

## Partial Access

| Name                                 | Description                                                                   | Stars | Last Commit |
|--------------------------------------|-------------------------------------------------------------------------------|-------|-------------|
| [Moby](https://github.com/moby/moby) | A "Lego set" of toolkit components for containers software created by Docker. | 70633 | 2025-09-06  |

[Back to Top](#table-of-contents)

## Sandboxes

| Name                                                   | Description                                                                                                                                                     | Stars | Last Commit |
|--------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [NsJail](https://github.com/google/nsjail)             | NsJail is a process isolation tool for Linux. It makes use of the namespacing, resource control, and seccomp-bpf syscall filter subsystems of the Linux kernel. | 3473  | 2025-05-09  |
| [Subuser](https://github.com/subuser-security/subuser) | Securing the Linux desktop with Docker.                                                                                                                         | 891   | 2025-02-23  |

[Back to Top](#table-of-contents)

## Security

| Name                                                                     | Description                                                                                                                                                                                                                                                                                                                                                                  | Stars | Last Commit |
|--------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [gvisor](https://github.com/google/gvisor)                               | gVisor is a user-space kernel, written in Go, that implements a substantial portion of the Linux system surface. It includes an Open Container Initiative (OCI) runtime called runsc that provides an isolation boundary between the application and the host kernel. The runsc runtime integrates with Docker and Kubernetes, making it simple to run sandboxed containers. | 16935 | 2025-09-06  |
| [Docker bench security](https://github.com/docker/docker-bench-security) | The Docker Bench for Security is a script that checks for dozens of common best-practices around deploying Docker containers in production.                                                                                                                                                                                                                                  | 9477  | 2024-10-21  |
| [docker-explorer](https://github.com/google/docker-explorer)             | A tool to help forensicate offline docker acquisitions.                                                                                                                                                                                                                                                                                                                      | 548   | 2024-10-04  |

[Back to Top](#table-of-contents)
