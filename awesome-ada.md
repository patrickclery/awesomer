# awesome-ada

A curated list of awesome resources related to the Ada and SPARK programming language

## Compilers

- [augusta](https://github.com/pchapin/augusta) - Ada compiler written in Scala that targets LLVM.
- [byron](https://github.com/OneWingedShark/Byron) - Byron is a community project to build an Ada compiler, toolchain, and IDE-system.
- [hac](https://github.com/zertovitch/hac) - HAC Ada Compiler - a small, quick Ada compiler fully in Ada.

## OS and Kernels

- [bare-bones](https://github.com/Lucretia/bare_bones) - An Ada port of the [osdev.org](https://wiki.osdev.org/Ada_Bare_Bones) minimal 32-bit x86 kernel.
- [cubit](https://github.com/docandrew/CuBit) - CuBitOS is a multi-processor, 64-bit, (partially) formally-verified, general-purpose operating system, currently for the x86-64 architecture.
- [cxos](https://github.com/ajxs/cxos) - Ada Operating System development example.
- [ewok](https://github.com/wookey-project/ewok-kernel) - EwoK is a microkernel targeting micro-controllers and embedded systems.
- [havk](https://github.com/RavSS/HAVK) - x86-64 security-focused OS being created with SPARK.
- [hirtos](https://github.com/jgrivera67/HiRTOS) - A high-integrity RTOS written in SPARK Ada.

## Deployment

- [ada-actions](https://github.com/ada-actions/toolchain) - Ada Toolchains for GitHub Actions.
- [ada4cmake](https://github.com/mosteo/ada4cmake) - CMake macros for simple gnat project inclusion.
- [alire](https://github.com/alire-project/alire) - A catalog of ready-to-use Ada libraries plus a command-line tool (alr) to obtain, compile, and incorporate them into your own projects. It aims to fulfill a similar role to Rust's cargo or OCaml's opam.
- [alr2appimage](https://github.com/mgrojo/alr2appimage) - A tool for automatically creating an AppImage executable from an Alire crate.
- [aura](https://github.com/annexi-strayline/AURA) - An integrated build and source/package management tool with a more hands-on versioning approach. Alternative to alire and gprbuild. Optimized for CI/CD pipelines.
- [cmake-ada-cho3](https://github.com/cho3/cmake-ada) - CMake language support for Ada, fork of [plplot]'s cross-platform support code.
- [cmake-ada-offa](https://github.com/offa/cmake-ada) - Ada language support for CMake.
- [continuous-verification](https://github.com/jklmnn/continuous-verification) - SPARK formal verification automated with Travis CI.
- [gprbuild](https://github.com/AdaCore/gprbuild) - Adacore multi-language software build tool.
- [ravenadm](https://github.com/jrmarino/ravenadm) - Administration tool for Ravenports http://www.ravenports.com.
- [synth](https://github.com/jrmarino/synth) - Next D/Ports build tool for live systems (Alternative for Portmaster and Portupgrade tools).

## Libraries

- [a-stream-tools](https://github.com/persan/a-stream-tools) - Stream utilities for Ada2005 and 2012.
- [abf-io](https://github.com/gerr135/abf_io) - A library of access routines to Axon's ABF file format (electrophysiology, most common) in Ada.
- [ada-bar-codes](https://github.com/zertovitch/ada-bar-codes) - Ada Bar Codes provides a package for generating various types of bar codes (1D, or 2D like QR codes) on different output formats, such as PDF or SVG.
- [ada-bfd](https://github.com/stcarrez/ada-bfd) - An Ada binding for the GNU Binutils BFD library. It allows to read binary ELF, COFF files by using the GNU BFD.
- [ada-bin2asc](https://github.com/jhumphry/Ada_BinToAsc) - Various binary-to-ASCII codecs such as Base64.
- [ada-bundler](https://github.com/flyx/ada-bundler) - Library and tool for transparently handling data and configuration file access in an Ada application. Supports macOS, Linux and Windows.
- [ada-crypto-library](https://github.com/cforler/Ada-Crypto-Library) - This is a crypto library for Ada with a nice API and is written for the i386 and x86_64 hardware architecture.
- [ada-fuzzy](https://github.com/briot/adafuzzy) - A fuzzy inference system library for Ada.
- [ada-ga](https://github.com/frett27/Ada-GA) - Genetic Algorithm Implementation for Ada.
- [ada-id](https://github.com/anthony-arnold/AdaID) - Simple Ada library for generating UUIDs.
- [ada-language-server](https://github.com/AdaCore/ada_language_server) - Adacore server implemention of the the Microsoft Language Protocol for Ada and SPARK.
- [ada-libsecret](https://github.com/stcarrez/ada-libsecret) - Ada Binding for the libsecret library.
- [ada-lisp-embedded](https://github.com/BrentSeidel/Ada-Lisp-Embedded) - Embeddable Lisp interpreter.
- [ada-lsp](https://github.com/reznikmm/ada-lsp) - Language Server Protocol for Ada.
- [ada-lsp-client](https://github.com/Alex-Gamper/Ada-LanguageServer) - Prototype implementation of LSP client - Visual Studio 2017.
- [ada-lua](https://github.com/AdaCore/ada-lua) - Ada binding for Lua.
- [ada-lzma](https://github.com/stcarrez/ada-lzma) - Ada binding for liblzma compression library.
- [ada-midi](https://github.com/frett27/Ada-Midi) - Implementation of Midi / MidiFile reading and writing.
- [ada-nanovg](https://github.com/raph-amiard/ada-nanovg) - Ada bindings to NanoVG.
- [ada-net-framework](https://github.com/Alex-Gamper/Ada-NetFramework) - Ada bindings to the Microsoft NetFramework Api.
- [ada-pdf-writer](https://github.com/zertovitch/ada-pdf-writer) - Ada package for producing easily and automatically PDF files, from an Ada program, with text, vector graphics, images (JPEG).
- [ada-pretty](https://github.com/reznikmm/ada-pretty) - Pretty printing library for Ada.
- [ada-promises](https://github.com/briot/Ada-promises) - Implementing promises in Ada. Type-safe, efficient, thread-safe.
- [ada-sodoku](https://github.com/frett27/Ada-Sodoku) - Small Library for Sodoku grid solving / finding.
- [ada-soundio](https://github.com/raph-amiard/ada-soundio) - Ada bindings for libsoundio.
- [ada-synthetizer](https://github.com/frett27/Ada-Synthetizer) - Sound Synthetizer Library implemented in Ada.
- [ada-toml](https://github.com/pmderodat/ada-toml) - TOML parser for Ada.
- [ada-traits-containers](https://github.com/AdaCore/ada-traits-containers) - Generic Ada Library for Algorithms and Containers.
- [ada-v4l2](https://github.com/frett27/AdaV4L2) - Ada Posix Binding to Video 4 Linux, used for RPI.
- [ada-win32](https://github.com/Alex-Gamper/Ada-Win32) - Ada bindings for the Microsoft Win32 Api.
- [ada-winrt](https://github.com/Alex-Gamper/Ada-WinRT) - Ada bindings for the Microsft WinRT Api.
- [ada-yaml](https://github.com/yaml/AdaYaml) - Experimental YAML 1.3 implementation in Ada.
- [adagio](https://github.com/mosteo/adagio) - Gnutella2 (G2) network server leaf.
- [adagl](https://github.com/godunko/adagl) - Multiplatform Ada/OpenGL bindings (ported to native/OpenGL, A2JS/WebGL and WASM/WebGL).
- [adasockets](https://github.com/samueltardieu/adasockets) - IPv4 socket library (TCP, UDP, and multicast).
- [aforth](https://github.com/samueltardieu/aforth) - Embeddable Forth interpreter written in Ada.
- [agpl](https://github.com/mosteo/agpl) - Ada General Purpose Library (Miscellaneous utilities, with a robotic flavor).
- [anagram](https://github.com/reznikmm/anagram) - Grammar handling and parser generation Ada library.
- [ascon-spark](https://github.com/jhumphry/Ascon_SPARK) - Ada/SPARK implementation of the Ascon Authenticated Encryption with Additional Data Algorithm.
- [asfml](https://github.com/mgrojo/ASFML) - Ada binding to the Simple and Fast Multimedia Library.
- [auto-counters](https://github.com/jhumphry/auto_counters) - Reference counting approaches to resource management.
- [axmpp](https://github.com/coopht/axmpp) - With the AXMPP library you can connect to a Jabber server to send and receive messages.
- [az3](https://github.com/Componolit/AZ3) - Ada binding for Z3.
- [base58-ada](https://github.com/MichaelAllenHardeman/base58_ada) - Base58 encoding and decoding in Ada.
- [blake2s](https://github.com/lkujaw/blake2s) - SPARK83 implementation of the BLAKE2s hash function.
- [boehmgc-ada](https://github.com/ytomino/boehmgc-ada) - Ada binding to the Boehm-Demers-Weiser conservative garbage collector.
- [canberra-ada](https://github.com/onox/canberra-ada) - Ada 2012 bindings for libcanberra, an implementation of the XDG Sound Theme and Name Specifications.
- [chests](https://github.com/JeremyGrosser/chests) - Chests are bounded containers. [ada-language-server]: https://github.com/AdaCore/ada_language_server
- [coreland-lua-ada](https://github.com/io7m/coreland-lua-ada) - Ada bindings to the Lua language.
- [coreland-openal-ada](https://github.com/io7m/coreland-openal-ada) - Ada binding to OpenAL.
- [cstrings](https://github.com/mosteo/cstrings) - Convenience subprograms to interact with C strings.
- [cuda](https://github.com/AdaCore/cuda) - CUDA support from AdaCore.
- [cvsweb2git](https://github.com/reznikmm/cvsweb2git) - Tool to imports CVS repository shared on Ada Conformity Assessment Authority into the Git repository.
- [dcf-ada](https://github.com/onox/dcf-ada) - An Ada 2012 library for document container files (Based on [zip-ada]). [zip-ada]: https://github.com/zertovitch/zip-ada
- [dl-ada](https://github.com/mosteo/dl-ada) - Minimal binding to libdl.
- [excel-writer](https://github.com/zertovitch/excel-writer) - Create Excel files with basic formats.
- [fletcher](https://github.com/darkestkhan/fletcher) - Trivial implementation of fletcher_16 checksum computation algorithm.
- [free-type-ada](https://github.com/flyx/FreeTypeAda) - FreeType binding for Ada 2005.
- [gela](https://github.com/reznikmm/gela) - Ada code analyzer.
- [generic-image-decoder](https://github.com/zertovitch/gid) - Multi-format image decoder library for Ada.
- [geo-energy-math](https://github.com/pukpr/GeoEnergyMath) - Software libraries for solving models described in Mathematical GeoEnergy (Wiley, 2018).
- [hungarian](https://github.com/mosteo/hungarian) - Ada binding to the fast Stachniss' Hungarian solver.
- [hungarian-algorithm](https://github.com/fastrgv/HungarianAlgorithm) - Hungarian Algorithm implementation in Ada.
- [increment](https://github.com/reznikmm/increment) - Incremental analysis in Ada.
- [ini-files](https://github.com/zertovitch/ini-files) - The Ini file manager consists of a package, Config, which can read and modify informations from various configuration files known as "ini" files.
- [inotify-ada](https://github.com/onox/inotify-ada) - An Ada 2012 library for monitoring filesystem events using Linux' inotify API.
- [json-ada](https://github.com/onox/json-ada) - An Ada 2012 library for parsing JSON.
- [jwx](https://github.com/Componolit/jwx) - A formally verified JSON library in SPARK.
- [kafka-ada](https://github.com/Latence-Technologies/Kafka-Ada) - Binding for the C librdkafka library, allows sending and receiving from a Kafka bus.
- [lalg](https://github.com/jhumphry/LALG) - Interface to dense linear algebra packages.
- [libadalang](https://github.com/AdaCore/libadalang) - Libadalang is a library for parsing and semantic analysis of Ada code. It is meant as a building block for integration into other tools (IDE, static analyzers, etc).
- [libkeccak](https://github.com/damaki/libkeccak) - A SPARK implementation of the Keccak family of sponge functions and related constructions.
- [libsodium-ada](https://github.com/jrmarino/libsodium-ada) - A secure cryptographic library (libsodium for Ada).
- [libsparkcrypto](https://github.com/Componolit/libsparkcrypto) - A cryptographic library implemented in SPARK.
- [licensing](https://github.com/mosteo/licensing) - Open Source Licenses library for Ada.
- [macos-sdks-vs-gcc](https://github.com/simonjwright/macos-sdks-vs-gcc) - Provides GCC 'specs' files to cope with SDK policy changes.
- [mandelbrot-ascii](https://github.com/mosteo/mandelbrot_ascii) - Mandelbrot renderer in "ASCII" (unicode actually, but text nonetheless).
- [math-packages](https://github.com/jscparker/math_packages) - Collection of basic math routines in Ada.
- [mathpaqs](https://github.com/zertovitch/mathpaqs) - Mathpaqs is a collection of mathematical, 100% portable, packages in the Ada programming language.
- [mosquitto-ada](https://github.com/persan/mosquitto-ada) - Binding for the MQTT broker Mosquitto.
- [nb-ada](https://github.com/andgi/NBAda) - NBAda : An Ada library of lock-free data structures and algorithms.
- [opencl-ada](https://github.com/flyx/OpenCLAda) - An Ada binding for the OpenCL host API.
- [opengl-ada](https://github.com/flyx/OpenGLAda) - Thick Ada binding for OpenGL and GLFW.
- [opus-ada](https://github.com/onox/opus-ada) - Ada 2012 bindings for the Opus audio codec.
- [oto](https://github.com/darkestkhan/oto) - Ada binding to OpenAL which tries to mimic original API while using Ada types.
- [parse-args](https://github.com/jhumphry/parse_args) - Simple command-line argument parsing.
- [parser-tools](https://github.com/flyx/ParserTools) - Tools for writing lexers / parsers in Ada.
- [player-ada](https://github.com/mosteo/player-ada) - Ada bindings for the player robotic platform.
- [portable-openal-sound](https://github.com/fastrgv/portable-openal-sound) - A linux-sound-playing package for Ada apps that can asynchronously start and stop music loops, as well as initiate transient sounds.
- [pragmarc](https://github.com/jrcarter/PragmARC) - PragmAda Reusable Components (PragmARCs) from PragmAda S/W Engineering.
- [protobuf](https://github.com/reznikmm/protobuf) - A Google Protocol Buffers implementation in Ada, using [matreshka].
- [protobuf-ada](https://github.com/persan/protobuf-ada) - Experimental Ada code generation support for Google Protocol Buffers.
- [radalib](https://github.com/sergio-gomez/Radalib) - Ada library and tools for the analysis of Complex Networks and more.
- [rclada](https://github.com/ada-ros/rclada) - Ada client library for ROS2/RCL.
- [reqrep-task-pools](https://github.com/jhumphry/Reqrep_Task_Pools) - Task pool system for jobs.
- [rsfile](https://github.com/mosteo/rsfile) - Command-line utility that picks a file from a folder hierarchy with probability proportional to its size.
- [rxada](https://github.com/mosteo/rxada) - An Ada 2012 implementation of the Rx methodology.
- [sdlada](https://github.com/Lucretia/sdlada) - Ada 2012 bindings to SDL 2.
- [si_units](https://github.com/HeisenbugLtd/si_units) - Utility library to pretty print physical values in proper metric units.
- [simple-blockchain](https://github.com/tomekw/simple_blockchain) - Simple blockchain in Ada.
- [simple-logging](https://github.com/alire-project/simple_logging) - Easy to use logging facilities for output to console in Ada programs.
- [sip-hash](https://github.com/grim7reaper/SipHash) - A pure Ada implementation of the SipHash PRF.
- [sl3p](https://github.com/jklmnn/sl3p) - Simple Layer 3 Protocol.
- [smart-pointers](https://github.com/alire-project/smart_pointers) - A package providing a reference-counted access type Smart_Pointer.
- [spark-nacl](https://github.com/rod-chapman/SPARKNaCl) - SPARK 2014 re-implementation of the TweetNaCl crypto library.
- [spark-norx](https://github.com/jhumphry/SPARK_NORX) - Ada/SPARK implementation of the NORX Authenticated Encryption with Additional Data Algorithm.
- [spark-sip-hash](https://github.com/jhumphry/SPARK_SipHash) - Ada/SPARK implementation of the SipHash keyed hash function.
- [spark-xml](https://github.com/Componolit/SXML) - A formally verified XML library in SPARK.
- [ssprep](https://github.com/persan/ssprep) - An extensible template engine akin to jinja but using [template-parser] and intended for command line usage.
- [stotp](https://github.com/jklmnn/STOTP) - Timed One-Time-Pad (RFC 6238) implementation in SPARK.
- [tashy](https://github.com/thindil/tashy) - Tashy is short from Tcl Ada SHell Younger. It is derivate of Tash, focused mostly on Tk binding.
- [tashy2](https://github.com/thindil/tashy2) - Tashy2 is short from Tcl Ada SHell Younger. It is derivate of Tashy, and aims to be more idiomatic and uses a more permisive license.
- [tcl-ada-shell](https://github.com/simonjwright/tcladashell) - Tcl Ada SHell (Tash) is an Ada binding to Tcl/Tk.
- [template-parser](https://github.com/AdaCore/templates-parser) - AWS templates engine. [template-parser]: https://github.com/AdaCore/templates-parser
- [threefish](https://github.com/jrcarter/Threefish) - Ada Implementation of the Threefish-256 Encryption Algorithm.
- [ux-strings](https://github.com/Blady-Com/UXStrings) - Unicode extended strings.
- [weechat-ada](https://github.com/onox/weechat-ada) - Ada 2012 library for WeeChat plug-ins.
- [weechat-canberra](https://github.com/onox/weechat-canberra) - A WeeChat plug-in written in Ada 2012 that plays sounds using Canberra.
- [weechat-emoji](https://github.com/onox/weechat-emoji) - A WeeChat plug-in written in Ada 2012 that displays emoji.
- [win32ada](https://github.com/AdaCore/win32ada) - Ada API to the Windows library.
- [wposix](https://github.com/AdaCore/wposix) - Ada Windows POSIX binding.
- [xia](https://github.com/simonjwright/xia) - An Ada implementation of XPath 1.0.
- [xml-ez-out](https://github.com/alire-project/xmlezout) - Library for emitting XML from Ada programs.
- [xmlada](https://github.com/AdaCore/xmlada) - The XML/Ada toolkit.
- [xxhash-ada](https://github.com/lyarbean/xxhash-ada) - Extremely fast non-cryptographic Hash algorithm, xxhash is working at speeds close to RAM limits.
- [zeromq-ada](https://github.com/persan/zeromq-Ada) - Binding to the ZeroMQ comunications-library.
- [zip-ada](https://github.com/zertovitch/zip-ada) - Zip-Ada is a programming library for dealing with the Zip compressed archive file format.

## Education

- [ada-composition](https://github.com/gerr135/ada_composition) - A collections of small nifty demos/sample code that may help better layout data or structure project.
- [adalib](https://github.com/reznikmm/adalib) - Standard Ada library specification as defined in Reference Manual.
- [spark-by-example](https://github.com/tofgarion/spark-by-example) - Collection of verified functions and data types in SPARK.

## Tools

- [acats](https://github.com/simonjwright/ACATS) - The Ada Conformity Assessment Test Suite, customised for GCC.
- [acats-grading](https://github.com/simonjwright/ACATS-grading) - Tools for grading ACATS results, modified for Unix-like systems.
- [ada-keystore](https://github.com/stcarrez/ada-keystore) - Ada Keystore - protect your sensitive data with secure storage.
- [ada-ml](https://github.com/rocher/AdaML) - Ada-tailored UML Modeling Language.
- [ajunitgen](https://github.com/mosteo/ajunitgen) - Generator of JUnit-compatible XML reports in Ada.
- [asn1scc](https://github.com/ttsiodras/asn1scc) - ASN1SCC: An open source ASN.1 generator to Ada type declarations and encoders/decoders.
- [automate](https://github.com/Blady-Com/Automate) - Finite-state machine generator.
- [coldframe](https://github.com/simonjwright/coldframe) - ColdFrame generates Ada framework code and documentation from UML models.
- [gnat-coverage](https://github.com/AdaCore/gnatcoverage) - GNATcoverage is a tool to analyze and report program coverage.
- [mat](https://github.com/stcarrez/mat) - MAT is a simple memory analysis tool intended to help understand where the memory is used in a program.
- [ocarina](https://github.com/OpenAADL/ocarina) - AADL model processor: mappings to Ada code; Petri Nets; scheduling tools (MAST, Cheddar); WCET; REAL.
- [powerjoular](https://github.com/joular/powerjoular) - PowerJoular allows monitoring power consumption of multiple platforms and processes.
- [record-flux](https://github.com/Componolit/RecordFlux) - RecordFlux: Toolset for the formal specification of messages and the generation of verifiable binary parsers and message generators in SPARK.
- [septum](https://github.com/pyjarrett/septum) - An interactive context-based text search tool for searching large codebases.
- [spark-2014](https://github.com/AdaCore/spark2014) - SPARK formal verification toolset.

## Runtimes

- [ada-runtime](https://github.com/Componolit/ada-runtime) - A downsized Ada runtime which can be adapted to different platforms.
- [adawebpack](https://github.com/godunko/adawebpack) - GNAT RTL for WASM and bindings for Web API. [ada-runtime]: https://github.com/Componolit/ada-runtime [adawebpack]: https://github.com/godunko/adawebpack
- [bb-runtimes](https://github.com/AdaCore/bb-runtimes) - GNAT bare metal board support package (BSP).
- [cortex-gnat-rts](https://github.com/simonjwright/cortex-gnat-rts) - This package includes GNAT Ada Run Time Systems (RTSs) based on FreeRTOS and targeted at boards with Cortex-M0, M3, -M4, -M4F MCUs.

## Applications

- [a-shell](https://github.com/charlie5/aShell) - A component to aid in writing shell-like applications in Ada.
- [acnc](https://github.com/Fabien-Chouteau/ACNC) - A G-code parser and CNC controller (in Ada).
- [ada-3ds](https://github.com/AdaDoom3/Ada3DS) - A simple 3DS Max model renderer.
- [ada-chess](https://github.com/adachess/AdaChess) - Chess engine written in Ada.
- [adage](https://github.com/atalii/adage) - An Ada/SPARK alternative to sudo and doas.
- [analytical-engine](https://github.com/simonjwright/analytical-engine) - An Ada 2012 emulation of Charles Babbage's Analytical Engine.
- [asis2xml](https://github.com/simonjwright/asis2xml) - Converts Ada sources' ASIS representation to XML, so as to make it easier to develop reporting and transformational tools using (for example) XSLT.
- [azip](https://github.com/zertovitch/azip) - A free, portable Zip Archive Manager.
- [cappulada](https://github.com/Componolit/Cappulada) - Ada binding generator for C++.
- [cbsg](https://github.com/zertovitch/cbsg) - The Corporate Bullshit Generator.
- [covid-19-simulator](https://github.com/ohenley/COVID-19_Simulator) - Multi engine/algorithms COVID-19 simulator. Ada, Qt code under the hood.
- [dashera](https://github.com/SMerrony/dashera) - Data General DASHER terminal emulator using [gtkada].
- [dhondt](https://github.com/simonjwright/dhondt) - Ada implementation of D'Hondt electoral result calculator.
- [doppler-effect-sample2](https://github.com/moriyasum/GtkAda_OpenAL_Doppler_Effect_Sample2) - Moving airplane causes Stereo Sound Doppler effect ([gtkada]).
- [eagle-lander](https://github.com/Fabien-Chouteau/eagle-lander) - Apollo 11 lunar lander simulator ([gtkada]/Cairo).
- [ghdl](https://github.com/ghdl/ghdl) - VHDL 2008/93/87 simulator.
- [gsh](https://github.com/AdaCore/gsh) - GSH is non interactive POSIX shell for Windows, aimed at GNU software builds. 2-3 times faster than Cygwin.
- [hunter](https://github.com/thindil/hunter) - Graphical ([gtkada]) file manager for Linux.
- [j2ada](https://github.com/Blady-Com/j2ada) - Translator for a Java valid source code in Ada source code.
- [mars-mpl](https://github.com/Jellix/mars_mpl) - Mars Polar Lander (Crash) Simulator ([gtkada], [aicwl]).
- [parallel-sim](https://github.com/JulianSchutsch/ParallelSim) - Distributed Simulation of Transport Networks.
- [pascal-to-ada](https://github.com/zertovitch/pascal-to-ada) - A Pascal to Ada translator.
- [texcad](https://github.com/zertovitch/texcad) - TeXCAD is a program for drawing or retouching {picture}s in LaTeX.
- [tiled-code-gen](https://github.com/Fabien-Chouteau/tiled-code-gen) - Code generator for Tiled the map editor.
- [tp7-ada-gnoga](https://github.com/Blady-Com/tp7ada-gnoga) - Implementation of Turbo Pascal 7.0 units with [gnoga].
- [tp7-ada-gtkada](https://github.com/Blady-Com/tp7ada-gtkada) - Implementation of Turbo Pascal 7.0 units with [gtkada].
- [wasabee](https://github.com/zertovitch/wasabee) - A Web browser with safety focus.
- [whitakers-words](https://github.com/mk270/whitakers-words) - William Whitaker's WORDS, a Latin dictionary.
- [winforms2gtk](https://github.com/fdesp87/winforms2gtk) - Helper conversor of Visual Basic Microsoft Windows Forms applications to Gtk and Ada.
- [yass](https://github.com/yet-another-static-site-generator/yass) - Yet Another Static Site Generator (like Jekyll or Hugo).
- [yotroc](https://github.com/docandrew/YOTROC) - Assembler/Emulator for a fictional CPU architecture. IDE implemented in [gtkada].

## Games

- [ada-gate](https://github.com/fastrgv/AdaGate) - AdaGate is a first-person 3D sokoban puzzle game within a Stargate / Portal fantasy setting for Windows, OS-X and Linux.
- [ada-venture](https://github.com/fastrgv/AdaVenture) - AdaVenture is a kid-friendly retro point&click game with mazes, dragons, bats & snakes.
- [bingada](https://github.com/jfuica/bingada) - Bingo application in [gtkada].
- [buttons](https://github.com/andreacervetti/buttons) - A simple [gtkada] Button Mania game.
- [civ-klon](https://github.com/HonkiTonk/Civ-Klon) - Civilization-style turn-based strategy game. Requires [asfml].
- [eepers](https://github.com/tsoding/eepers) - A simple Turn-based Game in Ada (made with [raylib](https://github.com/raysan5/raylib)).
- [mine-detector](https://github.com/jrcarter/Mine_Detector) - Mine Detector: a mine-finding game that never requires guessing.
- [play-2048](https://github.com/mgrojo/play_2048) - Play 2048! is a clone of the popular 2048 game, implemented in Ada using [asfml] for graphics and [ada-toml] for saving state.
- [retro-arcade](https://github.com/fastrgv/RetroArcade) - Space Invaders, Pacman, & Frogger games that run in a terminal on Windows, OS-X & Linux.
- [rufas-cube](https://github.com/fastrgv/RufasCube) - RufasCube is a puzzle game for Windows, OS-X and GNU Linux (it looks like a rubic cube but it's a slider, not a twister).
- [steamsky](https://github.com/thindil/steamsky) - Roguelike in sky with a steampunk setting.
- [tictactoe](https://github.com/AdaCore/tictactoe) - A tictactoe game written and proven in SPARK/Ada.
- [world-cup-sokerban](https://github.com/fastrgv/WorldCupSokerban) - This is a soccer-themed, 3D sokoban puzzle game that runs on Windows, Mac OS-X and GNU Linux.

## Hardware and Embedded

- [ada-drivers-library](https://github.com/AdaCore/Ada_Drivers_Library) - Ada drivers for various MCU and sensors.
- [ada-enet](https://github.com/stcarrez/ada-enet) - Embedded network stack (Ethernet driver, IPv4, UDP, DNS, DHCP, NTP) for STM32F746 or STM32F769.
- [ada-synth-lib](https://github.com/raph-amiard/ada-synth-lib) - Simple audio synthesis library that can run on bareboard devices.
- [ada-time](https://github.com/Fabien-Chouteau/Ada_Time) - Ada binding for the Pebble Time smartwatch.
- [adamant](https://github.com/lasp/adamant) - A component-based, model-driven framework for constructing reliable and reusable real-time software.
- [certiflie](https://github.com/AdaCore/Certyflie) - Source code for the full Ada + SPARK Crazyflie 2.0 firmware.
- [coffee-clock](https://github.com/Fabien-Chouteau/coffee-clock) - Waking up with a fresh cup of coffee.
- [dw1000](https://github.com/damaki/DW1000) - Ada/SPARK driver for the DecaWave DW1000 ultra-wideband (UWB) radio chip.
- [em-brick](https://github.com/it-cosmos/emBRICK) - emBRICK driver and support for emBRICK in Ada.
- [etherscope](https://github.com/stcarrez/etherscope) - Ethernet traffic monitor on a STM32F746 board.
- [evb1000](https://github.com/damaki/EVB1000) - Ada/SPARK drivers to control the on-board peripherals of the DecaWave EVB1000 evaluation board.
- [geste](https://github.com/Fabien-Chouteau/GESTE) - GESTE is a sprite and tile 2D render engine designed to run on micro-controllers.
- [giza](https://github.com/Fabien-Chouteau/Giza) - Giza is trying to be a simple widget tool kit for embedded platforms.
- [libgfxinit](https://github.com/coreboot/libgfxinit) - A graphics initialization (aka modesetting) library for embedded environments, implemented in SPARK.
- [lunar-lander-rotation](https://github.com/AdaCore/Lunar_Lander_Rotation_Demo) - Program that interacts with the AdaFruit BNO055 breakout board in order to send orientation data to a host computer.
- [micro-tem-pi](https://github.com/jklmnn/MicroTemPi) - Raspberry Pi using a BBC Micro:Bit as temperature sensor.
- [multiplexed-io](https://github.com/simonjwright/multiplexed-io) - This contains explorations, for AdaPilot, of implementing drivers for the AdaRacer MCU, using the Ravenscar profile of Ada 2012 from AdaCore and device bindings generated using SVD2Ada.
- [noise-nugget](https://github.com/Fabien-Chouteau/noise-nugget) - Square Inch Synthesizer.
- [railway-simulation](https://github.com/AdaCore/SPARK_Railway_Simulation_Demo) - Program simulating a railway network with trains, switches and signaling. The signaling system is proven with SPARK/Ada to ensure that trains cannot collide.
- [robotics-with-ada](https://github.com/AdaCore/Robotics_with_Ada) - Robotics with Ada, ARM, and Lego.
- [sancta](https://github.com/mosteo/sancta) - SANCTA multi-robot task allocation library.
- [solenoid-engine-controller](https://github.com/Fabien-Chouteau/solenoid-engine-controller) - Software controller for solenoid engines (Ada/STM32F4).
- [spark-railway-demo](https://github.com/Fabien-Chouteau/spark-railway-demo) - Simulated railway network in SPARK/Ada.
- [stm32-ui](https://github.com/stcarrez/stm32-ui) - STM32 UI library and tools (graphs, images, 12 hour clock).
- [svd2ada](https://github.com/AdaCore/svd2ada) - An Ada binding generator from SVD descriptions for bare board ARM devices.
- [SweetAda](https://github.com/gabriele-galeotti/SweetAda) - A lightweight development framework whose purpose is the implementation of Ada-based software systems. It supports a plethora or CPU architectures and development boards.
- [wee-noise-maker](https://github.com/Fabien-Chouteau/Wee-Noise-Maker) - Wee Noise Maker is an open source pocket synthesizer.
- [wiring-pi-ada](https://github.com/jklmnn/wiringPi-Ada) - Ada bindings for wiringPi.

## Edit

- [ada-tmbundle](https://github.com/textmate/ada.tmbundle) - TextMate support for Ada.
- [ada-utilities](https://github.com/Lucretia/ada-utilities) - VSCode extension Ada programmers which provides a few utility functions.
- [ada-vscode](https://github.com/Lucretia/ada-vscode) - Basic syntax highlighting for Ada and GPR.
- [lea](https://github.com/zertovitch/lea) - LEA, a Lightweight Editor for Ada, aims to provide an easy, script-world-like, "look & feel" for developing Ada projects of any size and level, while enabling access to full-scale development tools like GNAT. LEA includes HAC, the HAC Ada Compiler.
- [ob-ada-spark](https://github.com/rocher/ob-ada-spark) - Ada/SPARK support for org-babel : Evaluate source code blocks with Gnu Emacs and org files.
- [vim-ada-bundle](https://github.com/thindil/Ada-Bundle) - Maintained Ada Bundle : Complete Ada-Mode for Vim/NeoVim.

## Frameworks

- [ada-ado](https://github.com/stcarrez/ada-ado) - Ada Database Objects is an Ada05 library that provides object relational mapping to access a database in Ada05. The library supports Postgresql, MySQL, SQLite as databases. Most of the concepts developped for ADO come from the Java Hibernate ORM.
- [ada-asf](https://github.com/stcarrez/ada-asf) - Ada Server Faces allows to create web applications using the same pattern as the Java Server Faces (See JSR 252, JSR 314 and JSR 344).
- [ada-base](https://github.com/jrmarino/AdaBase) - Thick database bindings to MySQL, PostgreSQL and SQLite for Ada.
- [ada-doom-3](https://github.com/AdaDoom3/AdaDoom3) - Id Software's Id-tech-4-BFG in the Ada programming language.
- [ada-el](https://github.com/stcarrez/ada-el) - This library provides the support for a simple Expression Language close to the Java Unified Expression Language (EL).
- [ada-gui](https://github.com/jrcarter/Ada_GUI) - GUI implemented on its own task, so it doesn't require that its client give up a thread of control. Derived from [gnoga].
- [ada-ogl](https://github.com/JulianSchutsch/AdaOGL) - Ada OpenGL Framework.
- [ada-security](https://github.com/stcarrez/ada-security) - OAuth 2.0 client and server framework to secure web applications.
- [ada-servlet](https://github.com/stcarrez/ada-servlet) - Ada Servlet allows to create web applications using the same pattern as the Java Servlet (See JSR 154, JSR 315).
- [ada-util](https://github.com/stcarrez/ada-util) - A logging framework close to Java log4j framework, support for properties, serialization/deserialization framework for XML/JSON/CSV, Ada beans framework, encoding/decoding framework (Base16, Base64, SHA, HMAC-SHA), a composing stream framework (raw, files, buffers, pipes, sockets), several concurrency tools (reference counters, counters, pools, fifos, arrays), process creation and pipes, support for loading shared libraries (on Windows or Unix), HTTP client library on top of CURL or AWS.
- [ada-wiki](https://github.com/stcarrez/ada-wiki) - Ada Wiki is a small library that provides a Wiki engine.
- [adawebui](https://github.com/godunko/adawebui) - GUI based on [adawebpack].
- [anuklear](https://github.com/ada-game-framework/anuklear) - Ada binding to the Nuklear GUI library and the Nuklear-SDL renderer. [gnoga]: https://sourceforge.net/projects/gnoga/ [gtkada]: https://github.com/AdaCore/gtkada
- [apq-base](https://github.com/ada-apq/apq) - APQ is a database interface library written in Ada95.
- [areadline](https://github.com/samueltardieu/areadline) - Ada binding to the readline library.
- [asap](https://github.com/annexi-strayline/ASAP) - A set of general libraries and thick bindings for use with the AURA package management/build tool. Includes TCP, TLS, HTTP, a high-performance JSON parser/generator, and a formally verified (SPARK) UTF-8 stream decoder.
- [aunit](https://github.com/AdaCore/aunit) - Ada unit testing framework.
- [awa](https://github.com/stcarrez/ada-awa) - Ada Web Application is a framework to build a Web Application in Ada 2012. The framework provides several ready to use and extendable modules that are common to many web application. This includes the login, authentication, users, permissions, managing comments, tags, votes, documents, images.
- [aws](https://github.com/AdaCore/aws) - AWS is a complete framework to develop Web based applications in Ada.
- [bbt](https://github.com/LionelDraghi/bbt) - Simple tool to black box check the behavior of an executable through the command line.
- [curses](https://github.com/annexi-strayline/Curses) - Advanced UNIX Terminal UI Ada Binding Package.
- [dynamo](https://github.com/stcarrez/dynamo) - Code generator used to generate an Ada Web Application or database mappings from hibernate-like XML description, YAML doctrine model or UML models.
- [elogs](https://github.com/kevlar700/elogs) - Logging framework for embedded systems absent of runtime errors.
- [engine-3d](https://github.com/zertovitch/engine-3d) - A 3D engine for DOS-talgics.
- [ews](https://github.com/simonjwright/ews) - Embedded Web Server is a web server construction kit, designed for embedded applications using the GNAT Ada compiler.
- [globe-3d](https://github.com/zertovitch/globe-3d) - GL Object Based Engine for 3D.
- [gnatbdd](https://github.com/briot/gnatbdd) - Behavior Driven Development in Ada.
- [gnatcoll-bindings](https://github.com/AdaCore/gnatcoll-bindings) - This is the bindings module of the GNAT Components Collection.
- [gnatcoll-core](https://github.com/AdaCore/gnatcoll-core) - This is the core module of the GNAT Components Collection.
- [gnatcoll-db](https://github.com/AdaCore/gnatcoll-db) - This is the DB module of the GNAT Components Collection.
- [gnatcoll-json](https://github.com/persan/gnatcoll-json) - This is a set of helpers for writing JSON-intefaces it contains JSON parses for most of the Ada runtime components.
- [gneiss](https://github.com/Componolit/gneiss) - Gneiss is an interface collection to be used with applications for component based systems. It aims to be easily portable/platform independent and is compatible with the [ada-runtime].
- [gtkada](https://github.com/AdaCore/gtkada) - Ada graphical toolkit based on Gtk3 components.
- [gwindows](https://github.com/zertovitch/gwindows) - GNU Ada Visual Interface.
- [imgui-ada](https://github.com/Cre8or/ImGui-Ada) - Ada binding of the ImGui library.
- [lace](https://github.com/charlie5/lace) - A set of Ada components to allow 3D simulations, games and GUI's in Ada.
- [matreshka](https://github.com/godunko/matreshka) - Matreshka is an Ada framework to develop information systems consisting of five major components: League, XML processor, Web framework, SQL access, and the Modeling framework. [matreshka]: https://github.com/godunko/matreshka
- [poly-orb](https://github.com/AdaCore/PolyORB) - PolyORB provides a uniform solution to build distributed applications relying either on middleware standards.
- [scripted-testing](https://github.com/simonjwright/scripted_testing) - Supports functional testing using Tcl scripts.
- [swagger-ada](https://github.com/stcarrez/swagger-ada) - Ada support for Swagger codegen: OpenAPI Generator is a code generator that supports generation of API client libraries, server stubs and documentation automatically given an OpenAPI Spec.
