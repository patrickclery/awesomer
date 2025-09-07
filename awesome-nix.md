# awesome-nix

😎 A curated list of the best resources in the Nix community [maintainer=@cyntheticfox]

## NixOS Modules

- [base16.nix](https://github.com/SenchoPens/base16.nix) - Flake way to theme programs in [base16](https://github.com/chriskempson/base16) colorschemes, mustache template support included.
- [Home Manager](https://github.com/nix-community/home-manager) - Manage your user configuration just like NixOS.
- [impermanence](https://github.com/nix-community/impermanence) - Lets you choose what files and directories you want to keep between reboots.
- [musnix](https://github.com/musnix/musnix) - Do real-time audio work in NixOS.
- [nix-bitcoin](https://github.com/fort-nix/nix-bitcoin) - Modules and packages for Bitcoin nodes with higher-layer protocols with an emphasis on security.
- [nix-darwin](https://github.com/nix-darwin/nix-darwin) - Manage macOS configuration just like on NixOS.
- [nix-mineral](https://github.com/cynicsketch/nix-mineral) - Conveniently and reasonably harden NixOS.
- [nix-topology](https://github.com/oddlama/nix-topology) - Generate infrastructure and network diagrams directly from your NixOS configuration.
- [NixOS hardware](https://github.com/NixOS/nixos-hardware) - NixOS profiles to optimize settings for different hardware.
- [NixOS-WSL](https://github.com/nix-community/NixOS-WSL) - Modules for running NixOS on the Windows Subsystem for Linux.
- [NixVim](https://github.com/nix-community/nixvim) - A NeoVim distribution built with Nix modules and Nixpkgs.
- [Self Host Blocks](https://github.com/ibizaman/selfhostblocks) - Modular server management based on NixOS modules and focused on best practices.
- [Stylix](https://github.com/nix-community/stylix) - System-wide colorscheming and typography for NixOS.

## Distributions

- [nixbsd](https://github.com/nixos-bsd/nixbsd) - A NixOS fork with a FreeBSD kernel.
- [NixNG](https://github.com/nix-community/NixNG) - A GNU/Linux distribution similar to NixOS, defining difference is a focus on containers and lightweightness.

## NixOS Configuration Editors

- [Nix Software Center](https://github.com/snowfallorg/nix-software-center) - Install and manage Nix packages. Desktop app in Rust and GTK.
- [NixOS Configuration Editor](https://github.com/snowfallorg/nixos-conf-editor) - Graphical editor for NixOS configuration. Desktop app in Rust and GTK.

## Programming Languages

- [Bundix](https://github.com/nix-community/bundix) - Generates a Nix expression for your Bundler-managed application.
- [cabal2nix](https://github.com/NixOS/cabal2nix) - Converts a Cabal file into a Nix build expression.
- [cargo2nix](https://github.com/cargo2nix/cargo2nix) - Granular caching, development shell, Nix & Rust integration.
- [clj-nix](https://github.com/jlesquembre/clj-nix) - Nix helper functions for Clojure projects.
- [composer-plugin-nixify](https://github.com/stephank/composer-plugin-nixify) - Composer plugin to help with Nix packaging.
- [composer2nix](https://github.com/svanderburg/composer2nix) - Generate Nix expressions to build composer packages.
- [composition-c4](https://github.com/fossar/composition-c4) - Support for building composer packages from a `composer.lock` (using IFD).
- [crane](https://github.com/ipetkov/crane) - A Nix library for building Cargo projects with incremental artifact caching.
- [crystal2nix](https://github.com/nix-community/crystal2nix) - Convert `shard.lock` into Nix expressions.
- [Easy PureScript Nix](https://github.com/justinwoo/easy-purescript-nix) - A project to easily use PureScript and other tools with Nix.
- [elm2nix](https://github.com/cachix/elm2nix) - Convert `elm.json` into Nix expressions.
- [fenix](https://github.com/nix-community/fenix) - Rust toolchains and Rust analyzer nightly for nix.
- [haskell-flake](https://github.com/srid/haskell-flake) - A `flake-parts` Nix module for Haskell development.
- [haskell.nix](https://github.com/input-output-hk/haskell.nix) - Alternative Haskell Infrastructure for Nixpkgs.
- [haxix](https://github.com/MadMcCrow/haxix) - Nix flake to build haxe/Heaps.io projects.
- [kebab](https://github.com/bwkam/kebab) - Haxe packages for Nix.
- [lean4-nix](https://github.com/lenianiva/lean4-nix) - Nix flake build for Lean 4, and `lake2nix`.
- [naersk](https://github.com/nix-community/naersk) - Build Rust packages directly from `Cargo.lock`. No conversion step needed.
- [Napalm](https://github.com/nix-community/napalm) - Support for building npm packages in Nix with a lightweight npm registry.
- [nix-cargo-integration](https://github.com/90-008/nix-cargo-integration) - A library that allows easy and effortless integration for Cargo projects.
- [nix-gleam](https://github.com/arnarg/nix-gleam) - Generic Nix builder for Gleam applications.
- [nix-haskell-mode](https://github.com/matthewbauer/nix-haskell-mode) - Automatic Haskell setup in Emacs.
- [nix-phps](https://github.com/fossar/nix-phps) - Flake containing old and unmaintained PHP versions (intended for CI use).
- [nix-shell](https://github.com/loophp/nix-shell) - Nix shells for PHP development.
- [nixduino](https://github.com/boredom101/nixduino) - Nix-based tool to help build Arduino sketches.
- [nixkell](https://github.com/pwm/nixkell) - A Haskell project template using Nix and direnv.
- [nixpkgs-mozilla](https://github.com/mozilla/nixpkgs-mozilla) - Mozilla's overlay with Rust toolchains and Firefox.
- [node2nix](https://github.com/svanderburg/node2nix) - Generate Nix expression from a `package.json` (or `package-lock.json`) (to be stored as files).
- [npmlock2nix](https://github.com/nix-community/npmlock2nix) - Generate Nix expressions from a `package-lock.json` (in-memory), primarily for web projects.
- [opam2nix](https://github.com/timbertson/opam2nix) - Generate Nix expressions from opam packages.
- [poetry2nix](https://github.com/nix-community/poetry2nix) - Build Python packages directly from [Poetry's](https://python-poetry.org/) `poetry.lock`. No conversion step needed.
- [purs-nix](https://github.com/purs-nix/purs-nix) - CLI and library combo designed for managing PureScript projects using Nix. It provides a Nix API that can be used within your projects, as well as a command-line interface for managing your development process.
- [ruby-nix](https://github.com/inscapist/ruby-nix) - Generates reproducible ruby/bundler app environment with Nix.
- [rust-nix-templater](https://github.com/90-008/rust-nix-templater) - Generates Nix build and development files for Rust projects.
- [rust-overlay](https://github.com/oxalica/rust-overlay) - Pure and reproducible nix overlay of binary distributed Rust toolchains.
- [sbt-derivation](https://github.com/zaninime/sbt-derivation) - mkDerivation for sbt, similar to buildGoModule.
- [zon2nix](https://github.com/nix-community/zon2nix) - Convert the dependencies in `build.zig.zon` to a Nix expression.

## Overlays

- [awesome-nix-hpc](https://github.com/freuk/awesome-nix-hpc) - High Performance Computing package sets.
- [chaotic-nyx](https://github.com/chaotic-cx/nyx) - Daily bumped bleeding edge packages like `mesa_git` & others that aren't yet in Nixpkgs. Created by the makers of [Chaotic-AUR](https://github.com/chaotic-aur/).
- [nixpkgs-firefox-darwin](https://github.com/bandithedoge/nixpkgs-firefox-darwin) - Automatically updated Firefox binary packages for macOS.
- [nixpkgs-wayland](https://github.com/nix-community/nixpkgs-wayland) - Bleeding-edge Wayland packages.
- [NUR](https://github.com/nix-community/NUR) - Nix User Repositories. The mother of all overlays, allowing access to user repositories and installing packages via attributes.
- [System Manager](https://github.com/numtide/system-manager) - A non-NixOS Linux system configuration tool built on Nix.

## Resources

- [Nix Notes](https://github.com/noteed/nix-notes) - A collection of short notes about Nix, each contributing to the same virtual machine image.
- [Nix Shorts](https://github.com/alper/nix-shorts) - A collection of short notes about how to use Nix, updated for Nix Flakes.
- [Nix Starter Config](https://github.com/Misterio77/nix-starter-configs) - A few simple Nix Flake templates for getting started with NixOS + home-manager.
- [nix-search-tv](https://github.com/3timeslazy/nix-search-tv) - CLI fuzzy finder for packages and options from Nixpkgs, Home Manager, and more.
- [NixOS & Flakes Book](https://github.com/ryan4yin/nixos-and-flakes-book) - An unofficial and opinionated NixOS & Flakes book for beginners.
- [NüschtOS Search](https://github.com/NuschtOS/search) - Simple and fast static-page NixOS option search.

## Command-Line Tools

- [alejandra](https://github.com/kamadorueda/alejandra) - An opinionated Nix code formatter optimized for speed and consistency.
- [angrr](https://github.com/linyinfeng/angrr) - Auto Nix GC Roots Retention. This tool simply deletes auto GC roots based on the modified time of their symbolic link target.
- [comma](https://github.com/nix-community/comma) - Quickly run any binary; wraps together `nix run` and `nix-index`.
- [deadnix](https://github.com/astro/deadnix) - Scan Nix files for dead code.
- [devenv](https://github.com/cachix/devenv) - A Nix-based tool for creating developer shell environments quickly and reproducibly.
- [dix](https://github.com/faukah/dix) - Diff Nix; a super-fast tool to diff Nix related things.
- [manix](https://github.com/mlvzk/manix) - Find configuration options and function documentation for Nixpkgs, NixOS, and Home Manager.
- [nh](https://github.com/nix-community/nh) - Better output for `nix`, `nixos-rebuild`, `home-manager` and nix-darwin CLI leveraging `dix` and `nix-output-monitor`.
- [nix-alien](https://github.com/thiagokokada/nix-alien) - Run unpatched binaries on Nix/NixOS easily.
- [nix-diff](https://github.com/Gabriella439/nix-diff) - A tool to explain why two Nix derivations differ.
- [nix-du](https://github.com/symphorien/nix-du) - Visualise which gc-roots to delete to free some space in your Nix store.
- [nix-index](https://github.com/nix-community/nix-index) - Quickly locate Nix packages with specific files.
- [nix-init](https://github.com/nix-community/nix-init) - Generate Nix packages from URLs with hash prefetching, dependency inference, license detection, and more.
- [nix-melt](https://github.com/nix-community/nix-melt) - A ranger-like flake.lock viewer.
- [nix-output-monitor](https://github.com/maralorn/nix-output-monitor) - A tool to produce useful graphs and statistics when building derivations.
- [nix-prefetch](https://github.com/msteen/nix-prefetch) - A universal tool for updating source checksums.
- [nix-tree](https://github.com/utdemir/nix-tree) - Interactively browse the dependency graph of Nix derivations.
- [nixfmt](https://github.com/NixOS/nixfmt) - A formatter for Nix code, intended to easily apply a uniform style.
- [nixpkgs-hammering](https://github.com/jtojnar/nixpkgs-hammering) - An opinionated linter for Nixpkgs package expressions.
- [nurl](https://github.com/nix-community/nurl) - Generate Nix fetcher calls from repository URLs.
- [statix](https://github.com/oppiliappan/statix) - A linter/fixer to check for and fix antipatterns in Nix code.

## Development

- [Arion](https://github.com/hercules-ci/arion) - Run `docker-compose` with help from Nix/NixOS.
- [attic](https://github.com/zhaofengli/attic) - Multi-tenant Nix Binary Cache.
- [cached-nix-shell](https://github.com/xzfc/cached-nix-shell) - A `nix-shell` replacement that uses caching to open subsequent shells quickly.
- [compose2nix](https://github.com/aksiksi/compose2nix) - Generate a NixOS config from a Docker Compose project.
- [Devbox](https://github.com/jetify-com/devbox) - Instant, portable, and predictable development environments.
- [devshell](https://github.com/numtide/devshell) - `mkShell` with extra bits and a toml config option to be able to onboard non-nix users.
- [dream2nix](https://github.com/nix-community/dream2nix) - A framework for automatically converting packages from other build systems to Nix.
- [flake-utils](https://github.com/numtide/flake-utils) - Pure Nix flake utility functions to help with writing flakes.
- [flake-utils-plus](https://github.com/gytis-ivaskevicius/flake-utils-plus) - A lightweight Nix library flake for painless NixOS flake configuration.
- [flake.parts](https://github.com/hercules-ci/flake-parts) - Minimal Nix modules framework for Flakes: split your flakes into modules and get things done with community modules.
- [flakelight](https://github.com/nix-community/flakelight) - A modular flake framework aiming to minimize boilerplate.
- [flox](https://github.com/flox/flox) - Manage and share development environments, package projects, and publish artifacts anywhere.
- [gitignore.nix](https://github.com/hercules-ci/gitignore.nix) - The most feature-complete and easy-to-use `.gitignore` integration.
- [haumea](https://github.com/nix-community/haumea) - Filesystem-based module system for the Nix language similar to traditional programming languages, with support for file hierarchy and visibility.
- [lorri](https://github.com/nix-community/lorri) - A much better `nix-shell` for development that augments direnv.
- [make-shell](https://github.com/nicknovitski/make-shell) - `mkShell` meets modules, a modular almost-drop-in replacement for `pkgs.mkShell` function.
- [MCP-NixOS](https://github.com/utensils/mcp-nixos) - An MCP server that provides AI assistants with accurate information about NixOS packages, options, Home Manager, and nix-darwin configurations.
- [namaka](https://github.com/nix-community/namaka) - Snapshot testing for Nix based on haumea.
- [nil](https://github.com/oxalica/nil) - NIx Language server, an incremental analysis assistent for writing in Nix.
- [niv](https://github.com/nmattia/niv) - Easy dependency management for Nix projects with package pinning.
- [nix-direnv](https://github.com/nix-community/nix-direnv) - A fast loader and flake-compliant configuration for the direnv environment auto-loader.
- [nix-health](https://github.com/juspay/nix-health) - A program to check the health of your Nix install. Furthermore, individual projects can configure their own health checks in their `flake.nix`.
- [nix-update](https://github.com/Mic92/nix-update) - Update versions/source hashes of nix packages.
- [nixd](https://github.com/nix-community/nixd) - Nix language server, based on Nix libraries.
- [nixpkgs-review](https://github.com/Mic92/nixpkgs-review) - The best tool to verify that a pull-request in Nixpkgs is building properly.
- [npins](https://github.com/andir/npins) - A simple tool for handling different types of dependencies in a Nix project. It is inspired by and comparable to Niv.
- [pog](https://github.com/jpetrucciani/pog) - A new, powerful way to do bash scripts. Pog is a powerful Nix library that transforms the way developers create command-line interfaces (CLIs).
- [pre-commit-hooks.nix](https://github.com/cachix/git-hooks.nix) - Run linters/formatters at commit time and on your CI.
- [rnix-lsp](https://github.com/nix-community/rnix-lsp) - A syntax-checking language server for Nix.
- [robotnix](https://github.com/nix-community/robotnix) - A declarative and reproducible build system for Android (AOSP) images.
- [services-flake](https://github.com/juspay/services-flake) - A NixOS-like service configuration framework for Nix flakes.
- [Snowfall Lib](https://github.com/snowfallorg/lib) - A library that makes it easy to manage your Nix flake by imposing an opinionated file structure.
- [templates](https://github.com/nix-community/templates) - Project templates for many languages using Nix flakes.
- [treefmt-nix](https://github.com/numtide/treefmt-nix) - A formatter that allows formatting all your project files with a single command, all via a single `.nix` file.

## Installation Media

- [nix-installer](https://github.com/DeterminateSystems/nix-installer) - Opinionated alternative to the official Nix install scripts.
- [nix-installer-scripts](https://github.com/dnkmmr69420/nix-installer-scripts) - Runs the official installer but does some tweaking as well such as adding fcontext for selinux and installing nix outside of the default profile so you don't accidently uninstall it.
- [nixos-anywhere](https://github.com/nix-community/nixos-anywhere) - Install NixOS everywhere via SSH.
- [nixos-generators](https://github.com/nix-community/nixos-generators) - Take a NixOS config and build multiple different images types including VirtualBox VMs, Azure images, and installation ISOs.
- [nixos-infect](https://github.com/elitak/nixos-infect) - Replace a running non-NixOS Linux host with NixOS.
- [nixos-up](https://github.com/samuela/nixos-up) - Super easy NixOS installer that can be used from the installation ISO.

## Deployment Tools

- [bento](https://github.com/rapenne-s/bento) - A KISS deployment tool to keep your NixOS fleet (servers & workstations) up to date.
- [Colmena](https://github.com/zhaofengli/colmena) - A simple, stateless NixOS deployment tool modeled after NixOps and morph.
- [comin](https://github.com/nlewo/comin) - A deployment tool to continuously pull from Git repositories.
- [deploy-rs](https://github.com/serokell/deploy-rs) - A simple multi-profile Nix-flake deploy tool.
- [KubeNix](https://github.com/hall/kubenix) - A Kubernetes resource builder using Nix.
- [KuberNix](https://github.com/saschagrunert/kubernix) - Single-dependency Kubernetes clusters via Nix packages.
- [morph](https://github.com/DBCDK/morph) - A tool for managing existing NixOS hosts.
- [Nixery](https://github.com/tazjin/nixery) - A Docker-compatible container registry which builds images ad-hoc via Nix.
- [Nixinate](https://github.com/MatthewCroughan/nixinate) - A Nix flake library to provide app outputs for managing existing NixOS hosts over SSH.
- [NixOps](https://github.com/NixOS/nixops) - The official Nix deployment tool, compatible with AWS, Hetzner, and more.
- [pushnix](https://github.com/arnarg/pushnix) - Simple cli utility that pushes NixOS configuration and triggers a rebuild using ssh.
- [terraform-nixos](https://github.com/nix-community/terraform-nixos) - A set of Terraform modules designed to deploy NixOS.

## DevOps

- [Makes](https://github.com/fluidattacks/makes) - A Nix-based CI/CD pipeline framework for building, testing, and releasing projects in any language, from anywhere.
- [nixidy](https://github.com/arnarg/nixidy) - Kubernetes GitOps with Nix and Argo CD.
- [Standard](https://github.com/divnix/std) - An opinionated Nix Flakes framework to keep Nix code in large projects organized, accompanied by a friendly CLI/TUI optized for DevOps scenarios.

## Virtualisation

- [extra-container](https://github.com/erikarvstedt/extra-container) - Run declarative NixOS containers from the command line.
- [microvm](https://github.com/microvm-nix/microvm.nix) - NixOS-based MicroVMs.
- [nixos-shell](https://github.com/Mic92/nixos-shell) - Simple headless VM configuration using Nix (similar to Vagrant).
