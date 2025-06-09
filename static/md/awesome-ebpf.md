## Other

| Name                                                                      | Description                                 | Stars | Last Commit |
|---------------------------------------------------------------------------|---------------------------------------------|-------|-------------|
| [List of BPF features per kernel version](https://github.com/iovisor/bcc) |                                             | 21456 | 2025-06-08  |
| [IO Visor's Unofficial eBPF spec](https://github.com/iovisor/bpf-docs)    | Summary of eBPF syntax and operation codes. | 987   | 2022-09-20  |

## Generic eBPF Presentations and Articles

| Name                                                                  | Description                                                                                                                                 | Stars | Last Commit |
|-----------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [A BPF reference guide](https://github.com/iovisor/bcc)               | About BPF C and bcc Python helpers, from bcc repository.                                                                                    | 21456 | 2025-06-08  |
| [Beginner's guide to eBPF](https://github.com/lizrice/ebpf-beginners) | A set of live-coding talks and the accompanying code examples, introducing eBPF programming using a variety of libraries and program types. | 1669  | 2023-05-08  |

## XDP

| Name                                                           | Description                       | Stars | Last Commit |
|----------------------------------------------------------------|-----------------------------------|-------|-------------|
| [eXpress Data Path (XDP)](https://github.com/iovisor/bpf-docs) | The first presentation about XDP. | 987   | 2022-09-20  |

## Hardware Offload

| Name                                                                 | Description                                                                                                                                                          | Stars | Last Commit |
|----------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [hBPF - eBPF in hardware](https://github.com/rprinz08/hBPF)          | An eBPF CPU written for FPGAs.                                                                                                                                       | 414   | 2023-01-27  |
| [OpenCSD eBPF SSD offloading](https://github.com/Dantali0n/qemu-csd) | Computational Storage simulation (QEMU) platform with FUSE LFS filesystem for Zoned Namespaces NVMe SSDs using uBPF for compute kernel offloading, all in userspace. | 60    | 2023-11-01  |

## Tutorials

| Name                                                                                    | Description                                                                                    | Stars | Last Commit |
|-----------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------|-------|-------------|
| [bcc Python Developer Tutorial](https://github.com/iovisor/bcc)                         | Comes with bcc, but targets the Python bits across seventeen "lessons".                        | 21456 | 2025-06-08  |
| [bcc Reference Guide](https://github.com/iovisor/bcc)                                   | Many incremental steps to start using bcc and eBPF, mostly centered on tracing and monitoring. | 21456 | 2025-06-08  |
| [XDP Hands-On Tutorial](https://github.com/xdp-project/xdp-tutorial)                    | A progressive (three levels of difficulty) tutorial to learn how to process packets with XDP.  | 2675  | 2025-03-13  |
| [Linux Tracing Workshops Materials](https://github.com/goldshtn/linux-tracing-workshop) | Involves the use of several BPF tools for tracing.                                             | 1306  | 2020-06-19  |

## Examples

| Name                                                                                    | Description                                                                                                                                                             | Stars | Last Commit |
|-----------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [bcc/examples](https://github.com/iovisor/bcc)                                          | Examples coming along with the bcc tools, mostly about tracing.                                                                                                         | 21456 | 2025-06-08  |
| [bcc/tools](https://github.com/iovisor/bcc)                                             | These tools themselves can be seen as example use cases for BPF programs, mostly for tracing and monitoring. bcc tools have been packaged for some Linux distributions. | 21456 | 2025-06-08  |
| [redbpf examples](https://github.com/foniod/redbpf)                                     | Example programs for using RedBPF to write eBPF programs in Rust.                                                                                                       | 1718  | 2023-06-30  |
| [prototype-kernel/kernel/samples/bpf](https://github.com/netoptimizer/prototype-kernel) | Jesper Dangaard Brouer's prototype-kernel repository contains some additional examples that can be compiled outside of kernel infrastructure.                           | 312   | 2025-01-16  |
| [Netronome sample network applications](https://github.com/Netronome/bpf-samples)       | Provides basic but complete examples of eBPF applications also compatible with hardware offload.                                                                        | 103   | 2020-04-06  |
| [ebpf-samples](https://github.com/vbpf/ebpf-samples)                                    | A collection of compiled (as ELF object files) samples gathered from several projects, primarily intended to serve as test cases for user space verifiers.              | 93    | 2024-12-18  |
| [XDP/TC-eBPF example](https://github.com/netfoundry/zfw)                                | Program that uses XDP/TC-eBPF to provide statefull firewalling and socket redirection.                                                                                  | 59    | 2025-06-02  |
| [MPLSinIP sample](https://github.com/fzakaria/eBPF-mpls-encap-decap)                    | A heavily commented sample demonstrating how to encapsulate &amp; decapsulate MPLS within IP. The code is commented for those new to BPF development.                   | 55    | 2019-10-18  |
| [ebpf-kill-example](https://github.com/niclashedam/ebpf-kill-example)                   | A fully documented and tested example of an eBPF probe that logs all force-kills and prints them out in user-space.                                                     | 22    | 2023-05-26  |

## bcc

| Name                                                    | Description                                                                                                                                                                               | Stars | Last Commit |
|---------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [bcc](https://github.com/iovisor/bcc)                   | Framework and set of tools - One way to handle BPF programs, in particular for tracing and monitoring. Also includes some utilities that may help inspect maps or programs on the system. | 21456 | 2025-06-08  |
| [Lua front-end for BCC](https://github.com/iovisor/bcc) | Another alternative to C, and even to most of the Python code used in bcc.                                                                                                                | 21456 | 2025-06-08  |

## libbpf

| Name                                                           | Description                                                            | Stars | Last Commit |
|----------------------------------------------------------------|------------------------------------------------------------------------|-------|-------------|
| [libbpf-bootstrap](https://github.com/libbpf/libbpf-bootstrap) | Scaffolding for BPF application development with libbpf and BPF CO-RE. | 1272  | 2025-06-02  |

## Go libraries

| Name                                                 | Description                                                                                                  | Stars | Last Commit |
|------------------------------------------------------|--------------------------------------------------------------------------------------------------------------|-------|-------------|
| [cilium/ebpf](https://github.com/cilium/ebpf)        | Pure-Go library to read, modify and load eBPF programs and attach them to various hooks in the Linux kernel. | 6900  | 2025-06-03  |
| [gobpf](https://github.com/iovisor/gobpf)            | Go bindings for BCC for creating eBPF programs.                                                              | 2181  | 2023-08-31  |
| [libbpfgo](https://github.com/aquasecurity/libbpfgo) | eBPF library for Go, powered by libbpf.                                                                      | 791   | 2025-06-02  |

## Aya

| Name                                                   | Description                                                                                                                                                                                                                                                                         | Stars | Last Commit |
|--------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [aya](https://github.com/aya-rs/aya)                   | A pure Rust library for writing, loading, and managing eBPF objects, with a focus on developer experience and operability. It supports writing eBPF programs in Rust and distributing library code over crates.io to share it between eBPF programs. Aya does not depend on libbpf. | 3665  | 2025-06-04  |
| [Ebpfguard](https://github.com/deepfence/ebpfguard)    | Rust library for writing Linux security policies using eBPF.                                                                                                                                                                                                                        | 299   | 2024-01-22  |
| [aya-template](https://github.com/aya-rs/aya-template) | Templates for writing BPF applications in Aya that can be used with .                                                                                                                                                                                                               | 99    | 2025-06-08  |

## zbpf

| Name                                      | Description                                                                                         | Stars | Last Commit |
|-------------------------------------------|-----------------------------------------------------------------------------------------------------|-------|-------------|
| [zbpf](https://github.com/tw4452852/zbpf) | A pure Zig framework for writing cross platform eBPF programs, powered by libbpf and Zig toolchain. | 168   | 2025-06-04  |

## eunomia-bpf

| Name                                                      | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | Stars | Last Commit |
|-----------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [eunomia-bpf](https://github.com/eunomia-bpf/eunomia-bpf) | A compilation framework and runtime library to build, distribute, dynamically load, and run CO-RE eBPF applications in multiple languages and WebAssembly. It supports writing eBPF kernel code only (to build simple CO-RE libbpf eBPF applications), writing the kernel part in both BCC and libbpf styles, and writing userspace in multiple languages in a WASM module and distributing it with simple JSON data or WASM OCI images. The runtime is based on libbpf only and provides CO-RE to BCC-style eBPF programs without depending on the LLVM library. | 750   | 2024-09-05  |

## oxidebpf

| Name                                                | Description                                                                                                                                                                                                                                         | Stars | Last Commit |
|-----------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [oxidebpf](https://github.com/redcanaryco/oxidebpf) | A pure Rust library for managing eBPF programs, designed for security use cases. The featureset is more limited than other libraries but emphasizes stability across a wide range of kernels and backwards-compatible compile-once-run-most-places. | 120   | 2024-02-26  |

## User Space eBPF

| Name                                                                       | Description                                                                                                                 | Stars | Last Commit |
|----------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [rbpf](https://github.com/qmonnet/rbpf)                                    | Written in Rust. Interpreter for Linux, macOS and Windows, and JIT-compiler for x86_64 under Linux.                         | 1002  | 2025-06-04  |
| [uBPF](https://github.com/iovisor/ubpf)                                    | Written in C. Contains an interpreter, a JIT compiler for x86_64 architecture, an assembler and a disassembler.             | 891   | 2025-06-08  |
| [PREVAIL](https://github.com/vbpf/ebpf-verifier)                           | A user space verifier for eBPF , with support for loops.                                                                    | 420   | 2025-06-07  |
| [oster](https://github.com/grantseltzer/oster)                             | Written in Go. A tool for tracing execution of Go programs by attaching eBPF to uprobes.                                    | 304   | 2025-03-13  |
| [A generic implementation](https://github.com/YutaroHayakawa/generic-ebpf) | With support for FreeBSD kernel, FreeBSD user space, Linux kernel, Linux user space and macOS user space. Used for the 's . | 151   | 2021-05-28  |

## eBPF on Other Platforms

| Name                                                              | Description                                                                                                                                          | Stars | Last Commit |
|-------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [eBPF for Windows](https://github.com/microsoft/ebpf-for-windows) | This project is a work-in-progress that allows using existing eBPF toolchains and APIs familiar in the Linux ecosystem to be used on top of Windows. | 3211  | 2025-06-07  |

## Testing in Virtual Environments

| Name                                                            | Description | Stars | Last Commit |
|-----------------------------------------------------------------|-------------|-------|-------------|
| [bcc in a Docker container](https://github.com/zlim/bcc-docker) |             | 44    | 2020-07-23  |

## Networking

| Name                                                                       | Description                                                                                                                                                                                                                                                 | Stars | Last Commit |
|----------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Old documentation for P4 usage with eBPF](https://github.com/iovisor/bcc) | From bcc repository; deprecated by the P4_16 backend linked below.                                                                                                                                                                                          | 21456 | 2025-06-08  |
| [ApFree WiFiDog](https://github.com/liudf0716/apfree-wifidog)              | A high performance and lightweight captive portal solution for wireless networks. It leverages eBPF for traffic control and deep packet inspection capabilities, with plans to gradually replace nftables firewall functionality with eBPF-based solutions. | 876   | 2025-06-02  |
| [merbridge](https://github.com/merbridge/merbridge)                        | Use eBPF to speed up your Service Mesh. Merbridge replaces iptables rules with eBPF to intercept traffic. It also combines msg_redirect to reduce latency with a shortened datapath between sidecars and services.                                          | 782   | 2025-05-19  |
| [P4_16 backend for eBPF](https://github.com/p4lang/p4c)                    |                                                                                                                                                                                                                                                             | 765   | 2025-06-09  |
| [SEPTun-Mark-II](https://github.com/pevma/SEPTun-Mark-II)                  | Extreme Performance Tuning guide - Mark II.                                                                                                                                                                                                                 | 117   | 2018-04-17  |

## Observability

| Name                                                                                               | Description                                                                                                                                                                                                                                                                                                 | Stars | Last Commit |
|----------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Coroot](https://github.com/coroot/coroot)                                                         | Coroot is an open-source APM &amp; Observability tool, a DataDog and NewRelic alternative.                                                                                                                                                                                                                  | 6496  | 2025-05-29  |
| [pixie](https://github.com/pixie-io/pixie)                                                         | Observability for Kubernetes using eBPF. Features include protocol tracing, application profiling, and support for distributed bpftrace deployments.                                                                                                                                                        | 6045  | 2025-06-06  |
| [Hubble](https://github.com/cilium/hubble)                                                         | Network, service and security observability for Kubernetes using eBPF.                                                                                                                                                                                                                                      | 3813  | 2025-06-03  |
| [DeepFlow](https://github.com/deepflowio/deepflow)                                                 | Instant observability for cloud-native and AI applications based on eBPF.                                                                                                                                                                                                                                   | 3336  | 2025-06-09  |
| [Caretta](https://github.com/groundcover-com/caretta)                                              | Instant Kubernetes service dependency map generated by eBPF, right to a Grafana instance.                                                                                                                                                                                                                   | 1922  | 2025-03-17  |
| [InKeV: In-Kernel Distributed Network Virtualization for DCN](https://github.com/iovisor/bpf-docs) |                                                                                                                                                                                                                                                                                                             | 987   | 2022-09-20  |
| [parca-agent](https://github.com/parca-dev/parca-agent)                                            | eBPF based always-on continuous profiler for analysis of CPU and memory usage, down to the line number and throughout time.                                                                                                                                                                                 | 626   | 2025-05-28  |
| [SkyWalking Rover](https://github.com/apache/skywalking-rover)                                     | is an open-source Application Performance Monitoring (APM) platform specially designed for distributed systems with microservices, cloud-native and container-based (Kubernetes) architectures. SkyWalking Rover is an eBPF-based profiler and metrics collector for C, C++, Golang, and Rust applications. | 221   | 2025-06-09  |
| [rbperf](https://github.com/javierhonduco/rbperf)                                                  | Sampling profiler and tracer for Ruby.                                                                                                                                                                                                                                                                      | 120   | 2024-04-21  |

## Security

| Name                                                                          | Description                                                                                                                                                                                                                                                      | Stars | Last Commit |
|-------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Tetragon](https://github.com/cilium/tetragon)                                | Kubernetes-aware, eBPF-based security observability and runtime enforcement.                                                                                                                                                                                     | 4010  | 2025-06-09  |
| [Tracee](https://github.com/aquasecurity/tracee)                              | A runtime security and forensics tool for Linux which uses eBPF technology to trace the system and applications at runtime, and analyze collected events to detect suspicious behavioral patterns.                                                               | 3919  | 2025-06-06  |
| [Sysmon for Linux](https://github.com/Sysinternals/SysmonForLinux)            | A security monitoring tool. It depends on .                                                                                                                                                                                                                      | 1897  | 2025-05-20  |
| [harpoon](https://github.com/alegrey91/harpoon)                               | Trace syscalls from user-space functions, by using eBPF.                                                                                                                                                                                                         | 155   | 2025-06-04  |
| [bpflock - Lock Linux machines](https://github.com/linux-lock/bpflock)        | An eBPF driven security tool for locking and auditing Linux machines.                                                                                                                                                                                            | 146   | 2022-02-16  |
| [redcanary-ebpf-sensor](https://github.com/redcanaryco/redcanary-ebpf-sensor) | A set of BPF programs that gather security relevant event data from the Linux kernel. The BPF programs are combined into a single ELF file from which individual probes can be selectively loaded, depending on the running operating system and kernel version. | 107   | 2025-05-13  |

## Tools

| Name                                                            | Description                                                                                                                                                                                     | Stars | Last Commit |
|-----------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [kubectl trace](https://github.com/iovisor/kubectl-trace)       | A kubectl plug-in for executing bpftrace programs in a Kubernetes cluster.                                                                                                                      | 2111  | 2024-07-18  |
| [TripleCross](https://github.com/h3xduck/TripleCross)           | A Linux eBPF rootkit with a backdoor, C2, library injection, execution hijacking, persistence and stealth capabilities.                                                                         | 1855  | 2024-04-07  |
| [redbpf](https://github.com/foniod/redbpf)                      | Tooling and framework to write eBPF code in Rust efficiently.                                                                                                                                   | 1718  | 2023-06-30  |
| [ptcpdump](https://github.com/mozillazg/ptcpdump)               | A process-aware, eBPF-based tcpdump-like tool.                                                                                                                                                  | 1017  | 2025-06-02  |
| [ebpfkit](https://github.com/Gui774ume/ebpfkit)                 | A rootkit that leverages multiple eBPF features to implement offensive security techniques.                                                                                                     | 798   | 2023-02-28  |
| [bpfman](https://github.com/bpfman/bpfman)                      | An eBPF Manager for Linux and Kubernetes. Includes a built-in program loader that supports program cooperation for XDP and TC programs, as well as deployment of eBPF programs from OCI images. | 634   | 2025-06-09  |
| [Bad BPF](https://github.com/pathtofile/bad-bpf)                | A collection of malicious eBPF programs that make use of eBPF's ability to read and write user data in between the usermode program and the kernel.                                             | 618   | 2024-07-07  |
| [bpfd](https://github.com/genuinetools/bpfd)                    | Framework for running BPF programs with rules on Linux as a daemon. Container aware.                                                                                                            | 477   | 2021-05-07  |
| [adeb](https://github.com/joelagnel/adeb)                       | A Linux shell environment for using tracing tools on Android with BPFd.                                                                                                                         | 330   | 2023-02-04  |
| [upf-bpf](https://github.com/navarrothiago/upf-bpf)             | An in-kernel solution based on XDP for 5G UPF.                                                                                                                                                  | 200   | 2024-09-28  |
| [ebpfkit-monitor](https://github.com/Gui774ume/ebpfkit-monitor) | An utility to statically analyze eBPF bytecode or monitor suspicious eBPF activity at runtime. It was specifically designed to detect ebpfkit.                                                  | 133   | 2023-02-28  |
| [BPFd](https://github.com/joelagnel/bpfd)                       | A distinct BPF daemon, trying to leverage the flexibility of the bcc tools to trace and debug remote targets, and in particular devices running with Android.                                   | 96    | 2021-10-24  |
| [ebpfmon](https://github.com/redcanaryco/ebpfmon)               | A TUI (terminal user interface) application for real time monitoring of eBPF programs.                                                                                                          | 88    | 2024-07-04  |
| [ebpf-explorer](https://github.com/ebpfdev/explorer)            | A web interface to explore system's maps and programs.                                                                                                                                          | 87    | 2023-06-18  |
| [greggd](https://github.com/olcf/greggd)                        | System daemon to compile and load eBPF programs into the kernel, and forward program output to socket for metric aggregation.                                                                   | 6     | 2025-03-20  |

## Development and Community

| Name                                                                        | Description                                                                      | Stars | Last Commit |
|-----------------------------------------------------------------------------|----------------------------------------------------------------------------------|-------|-------------|
| [The XDP Collaboration Project](https://github.com/xdp-project/xdp-project) | A GitHub repository with notes and ideas regarding the future evolutions of XDP. | 290   | 2025-05-27  |

## Other Lists of Resources on eBPF

| Name                                                                  | Description | Stars | Last Commit |
|-----------------------------------------------------------------------|-------------|-------|-------------|
| [IO Visor's bcc documentation](https://github.com/iovisor/bcc)        |             | 21456 | 2025-06-08  |
| [IO Visor's bpf-docs repository](https://github.com/iovisor/bpf-docs) |             | 987   | 2022-09-20  |
