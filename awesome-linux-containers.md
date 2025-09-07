# awesome-linux-containers

A curated list of awesome Linux Containers frameworks, libraries and software

## Clouds

- [Warden](https://github.com/cloudfoundry/warden) - Manages isolated, ephemeral, and resource controlled environments. Part of Cloud Foundry - the open platform as a service project.

## Containers

- [Bocker](https://github.com/p8952/bocker) - Docker implemented in around 100 lines of bash.
- [cc-oci-runtime](https://github.com/01org/cc-oci-runtime) - Intel Clear Linux OCI (Open Containers Initiative) compatible runtime.
- [firecracker](https://github.com/firecracker-microvm/firecracker) - Firecracker runs workloads in lightweight virtual machines, called microVMs, which combine the security and isolation properties provided by hardware virtualization technology with the speed and flexibility of containers.
- [footloose](https://github.com/weaveworks/footloose) - Containers that look like Virtual Machines.
- [Let Me Contain That For You](https://github.com/google/lmctfy) - LMCTFY is the open source version of Google’s container stack, which provides Linux application containers.
- [libct](https://github.com/xemul/libct) - Libct is a containers management library which provides convenient API for frontend programs to rule a container during its whole lifetime.
- [LXC](https://github.com/lxc/lxc) - LXC is the well known set of tools, templates, library and language bindings. It's pretty low level, very flexible and covers just about every containment feature supported by the upstream kernel.
- [plash](https://github.com/ihucos/plash) - Lightweight, rootless containers.
- [podman](https://github.com/containers/libpod) - Full management of container lifecycle.
- [porto](https://github.com/yandex/porto) - The main goal of Porto is to create a convenient, reliable interface over several Linux kernel mechanism such as cgroups, namespaces, mounts, networking etc.
- [railcar](https://github.com/oracle/railcar) - Railcar is a rust implementation of the opencontainers initiative's runtime spec. It is similar to the reference implementation runc, but it is implemented completely in rust for memory safety without needing the overhead of a garbage collector or multiple threads.
- [Rocket](https://github.com/coreos/rkt) - rkt (pronounced "rock-it") is a CLI for running app containers on Linux. rkt is designed to be composable, secure, and fast. Based on AppC specification.
- [runc](https://github.com/opencontainers/runc) - runc is a CLI tool for spawning and running containers according to the OCS specification.
- [runv](https://github.com/hyperhq/runv) - Hypervisor-based (KVM, Xen, QEMU) Runtime for OCI. Security by isolation.
- [sysbox](https://github.com/nestybox/sysbox) - Sysbox is a "runc" that creates secure (rootless) containers / pods that run not just microservices, but most workloads that run in VMs (e.g., systemd, Docker, and Kubernetes), seamlessly.
- [udocker](https://github.com/indigo-dc/udocker) - A basic user tool to execute simple containers in batch or interactive systems without root privileges.
- [Vagga](https://github.com/tailhook/vagga) - Vagga is a fully-userspace container engine inspired by Vagrant and Docker, specialized for development environments.
- [youki](https://github.com/containers/youki) - A container runtime written in Rust.

## Operating Systems

- [Photon](https://github.com/vmware/photon) - Photon OS is a minimal Linux container host designed to have a small footprint and tuned for VMware platforms. Photon is intended to invite collaboration around running containerized and Linux applications in a virtualized environment.

## Sandboxes

- [Bubblewrap](https://github.com/projectatomic/bubblewrap) - Run applications in a sandbox using Linux namespaces without root privileges, with user namespacing provided via setuid binary.
- [Lxroot](https://github.com/parke/lxroot) - Lxroot is a flexible, lightweight, and safer alternative to chroot and/or Docker for non-root users on Linux.
- [NsJail](https://github.com/google/nsjail) - NsJail is a process isolation tool for Linux. It makes use of the namespacing, resource control, and seccomp-bpf syscall filter subsystems of the Linux kernel.
- [singularity](https://github.com/singularityware/singularity) - Universal application containers for Linux.
- [Subuser](https://github.com/subuser-security/subuser) - Securing the Linux desktop with Docker.

## Another Information Sources

- [sysdig-container-ecosystem](https://github.com/draios/sysdig-container-ecosystem) - The ecosystem of awesome new technologies emerging around containers and microservices can be a little overwhelming, to say the least. We thought we might be able to help: welcome to the Container Ecosystem Project.

## Security

- [bane](https://github.com/jfrazelle/bane) - Custom AppArmor profile generator for docker containers.
- [Docker bench security](https://github.com/docker/docker-bench-security) - The Docker Bench for Security is a script that checks for dozens of common best-practices around deploying Docker containers in production.
- [docker-explorer](https://github.com/google/docker-explorer) - A tool to help forensicate offline docker acquisitions.
- [drydock](https://github.com/zuBux/drydock) - Drydock provides a flexible way of assessing the security of your Docker daemon configuration and containers using editable audit templates.
- [goss](https://github.com/aelsabbahy/goss) - Quick and Easy server testing/validation.
- [gvisor](https://github.com/google/gvisor) - gVisor is a user-space kernel, written in Go, that implements a substantial portion of the Linux system surface. It includes an Open Container Initiative (OCI) runtime called runsc that provides an isolation boundary between the application and the host kernel. The runsc runtime integrates with Docker and Kubernetes, making it simple to run sandboxed containers.
- [oci-seccomp-bpf-hook](https://github.com/containers/oci-seccomp-bpf-hook) - OCI hook to trace syscalls and generate a seccomp profile.
- [OpenSCAP](https://github.com/OpenSCAP/container-compliance) - The OpenSCAP ecosystem provides multiple tools to assist administrators and auditors with assessment, measurement and enforcement of security baselines.
- [sockguard](https://github.com/buildkite/sockguard) - A proxy for docker.sock that enforces access control and isolated privileges.

## Partial Access

- [Moby](https://github.com/moby/moby) - A "Lego set" of toolkit components for containers software created by Docker.
- [pyspaces](https://github.com/Friz-zy/pyspaces) - Works with Linux namespaces through glibc with pure python.
- [python-nsenter](https://github.com/zalando/python-nsenter) - This Python package allows entering Linux kernel namespaces (mount, IPC, net, PID, user and UTS) by doing the "setns" syscall.

## Dashboard

- [Liman](https://github.com/salihciftci/liman) - Basic docker monitoring web application.
- [portainer](https://github.com/portainer/portainer) - Lightweight Docker management UI.
- [swarmpit](https://github.com/swarmpit/swarmpit) - Lightweight mobile-friendly Docker Swarm management UI.

## Hypervisors

- [Docker](https://github.com/veggiemonk/awesome-docker) - An open platform for distributed applications for developers and sysadmins. **Standard de facto**.
- [Lithos](https://github.com/tailhook/lithos) - Lithos is a process supervisor and containerizer for running services. It is not intended to be system init, but rather tries to be a base tool to build container orchestration.
- [LXD](https://github.com/lxc/lxd) - Daemon based on liblxc offering a REST API to manage LXC containers.
- [MultiDocker](https://github.com/marty90/multidocker) - Create a secure multi-user Docker machine, where each user is segregated into an indepentent container.

## Specifications

- [Cloud Native Application Bundle Specification](https://github.com/deislabs/cnab-spec) - A package format specification that describes a technology for bundling, installing, and managing distributed applications, that are by design, cloud agnostic.
- [Open Container Specifications](https://github.com/opencontainers/specs) - This project is where the Open Container Initiative Specifications are written. This is a work in progress.

## Filesystem

- [buildah](https://github.com/projectatomic/buildah) - A tool which facilitates building OCI container images.
- [container-diff](https://github.com/GoogleCloudPlatform/container-diff) - A tool for analyzing and comparing container images.
- [dgr](https://github.com/blablacar/dgr) - Command line utility designed to build and to configure at runtime App Containers Images (ACI) and App Container Pods (POD) based on convention over configuration.
- [dive](https://github.com/wagoodman/dive) - A tool for exploring each layer in a docker image.
- [docker pushrm](https://github.com/christian-korneck/docker-pushrm) - A Docker CLI plugin that that lets you push the README.md file from the current directory to a container registry. Supports Docker Hub, Quay and Harbor.
- [go-containerregistry](https://github.com/google/go-containerregistry) - Go library and CLIs for working with container registries.
- [img](https://github.com/jessfraz/img) - Standalone, daemon-less, unprivileged Dockerfile and OCI compatible container image builder.
- [kaniko](https://github.com/GoogleContainerTools/kaniko) - Kaniko is a tool to build container images from a Dockerfile, inside a container or Kubernetes cluster.
- [skopeo](https://github.com/projectatomic/skopeo) - Work with remote images registries - retrieving information, images, signing content.
- [Whaler](https://github.com/P3GLEG/Whaler) - Whaler is designed to reverse engineer a Docker Image into the Dockerfile that created it.
