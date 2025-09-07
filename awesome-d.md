# awesome-d

  A curated list of awesome D documents, frameworks, libraries and software. Inspired by awesome-python.

## General Containers

- [dlib.container](https://github.com/gecko0307/dlib) - generic data structures (GC-free dynamic and associative arrays and more)
- [EMSI containers](https://github.com/dlang-community/containers) - Containers that do not use the GC
- [memutils](https://github.com/etcimon/memutils) - Overhead allocators, allocator-aware containers and lifetime management for D objects
- [std.rcstring](https://github.com/burner/std.rcstring) - A reference counted string implementation for D's build in string construct

## Articles

- [Porting D Runtime to ARM](https://github.com/JinShil/D_Runtime_ARM_Cortex-M_study) - A study about porting a minimal D runtime to ARM Cortex-M preprocessors.

## Build Tools

- [cmake-d](https://github.com/dcarp/cmake-d) - CMake D Projects
- [cook2](https://github.com/gecko0307/Cook2) - Fast incremental build tool intended for projects in D
- [dub](https://github.com/dlang/dub) - De facto official package and build management system for D. Will be included officially soon.
- [Makefile](https://github.com/bioinfornatics/MakefileForD) - Makefile template for D projects
- [premake](https://github.com/premake/premake-dlang) - Premake has built-in support for D projects
- [reggae](https://github.com/atilaneves/reggae) - meta build system in D
- [wild](https://github.com/Vild/Wild) - Wild build system, used to build the [PowerNex](https://github.com/PowerNex/PowerNex) kernel
- [wox](https://github.com/redthing1/wox) - A highly flexible recipe build system inspired by Make

## Alternative / WIP Compilers

- [SDC](https://github.com/snazzy-d/SDC) - The Snazzy D Compiler. Written in D. Grows Smarter every day.

## Package Management

- [dub](https://github.com/dlang/dub) - Official package and build management system for D.

## Testing Frameworks

- [unit-threaded](https://github.com/atilaneves/unit-threaded) - Multi-threaded unit test framework

## Scientific

- [bindbc-mecab](https://github.com/lempiji/bindbc-mecab) - bindbc MeCab binding (Part-of-Speech and Morphological Analyzer for Japanese)
- [dstats](https://github.com/DlangScience/dstats) - A statistics library for D.
- [mir](https://github.com/libmir/mir) - Sandbox for some mir packages: sparse tensors, Hoffman and others.
- [mir-algorithm](https://github.com/libmir/mir) - N-dimensional arrays (matrixes, tensors), algorithms, general purpose library.
- [mir-random](https://github.com/libmir/mir-random) - Advanced Random Number Generators.
- [scid](https://github.com/DlangScience/scid) - Scientific library for the D programming language

## Blog Engine

- [mood](https://github.com/mihails-strasuns/mood) - simple vibe.d based blog engine

## Parallel Computing

- [DCompute](https://github.com/libmir/dcompute) - [GPGPU with Native D for OpenCL and CUDA](https://dlang.org/blog/2017/07/17/dcompute-gpgpu-with-native-d-for-opencl-and-cuda/)
- [DerelictCL](https://github.com/DerelictOrg/DerelictCL) - Dynamic bindings to the OpenCL library for the D Programming Language.
- [DerelictCUDA](https://github.com/DerelictOrg/DerelictCUDA) - Dynamic bindings to the CUDA library for the D Programming Language.

## Core Utilities

- [Joka](https://github.com/Kapendev/joka) - A nogc utility library.
- [NuLib](https://github.com/Inochi2D/nulib) - D "standard" library built ontop of numem.
- [NuMem](https://github.com/Inochi2D/numem) - No-GC memory management utilities for DLang.

## Text Processing

- [eBay's TSV utilities](https://github.com/eBay/tsv-utils) - Filtering, statistics, sampling, joins and other operations on TSV files. Very fast, especially good for large datasets.
- [hunt-markdown](https://github.com/huntlabs/hunt-markdown) - A markdown parsing and rendering library for D programming language. Support commonMark.

## Web Frameworks

- [arsd](https://github.com/adamdruppe/arsd) - Adam D. Ruppe's web framework.
- [cmsed](https://github.com/rikkimax/Cmsed) - A component library for Vibe that functions as a CMS.
- [dlang-requests](https://github.com/ikod/dlang-requests) - HTTP client library inspired by python-requests
- [DSSG](https://github.com/kambrium/dssg) - A static site generator with a different approach.
- [Handy-Httpd](https://github.com/andrewlalis/handy-httpd) - A simple, lightweight, and well-documented HTTP server that lets you bootstrap ideas and have something up and running in minutes.
- [Hprose](https://github.com/hprose/hprose-d) - A very newbility RPC Library for D, and it support 25+ languages now.
- [libasync](https://github.com/etcimon/libasync) - Cross-platform event loop library of asynchronous objects
- [libhttp2](https://github.com/etcimon/libhttp2) - HTTP/2 library in D, translated from nghttp2
- [serverino](https://github.com/trikko/serverino) - Small and ready-to-go http server, in D

## GitHub Actions

- [dub-upgrade](https://github.com/WebFreak001/dub-upgrade) - Run `dub upgrade` trying to repeat on network failure and using package cache on GitHub Actions
- [setup-dlang](https://github.com/dlang-community/setup-dlang) - Install D compilers & DUB inside GitHub Actions

## CLI Applications

- [Literate](https://github.com/zyedidia/Literate) - A literate programming tool for any language.
- [onedrive](https://github.com/abraunegg/onedrive) - #1 Free OneDrive Client for Linux.
- [todod](https://github.com/BlackEdder/todod) - Todod is a command line based todo list manager. It also has support for shell interaction based on [linenoise](https://github.com/antirez/linenoise).
- [tshare](https://github.com/trikko/tshare) - Fast file sharing from cli, using transfer.sh.

## CLI Libraries

- [Argon](https://github.com/markuslaker/Argon) - A processor for command-line arguments, an alternative to Getopt, written in D.
- [argsd](https://github.com/burner/argsd) - A command line and config file parser for DLang
- [commandr](https://github.com/robik/commandr) - A modern, powerful command line argument parser.
- [dexpect](https://github.com/grogancolin/dexpect) - A D implementation of the expect framework. Handy for bash emulation.
- [gogga](https://github.com/deavmi/gogga) - simple easy-to-use colorful logger for command-line applications
- [luneta](https://github.com/fbeline/luneta) - A command-line fuzzy finder.
- [scriptlike](https://github.com/Abscissa/scriptlike) - Utility library to aid writing script-like programs in D.

## Preprocesors

- [warp](https://github.com/facebookarchive/warp) - A fast preprocessor for C and C++ used in Facebook infrastructure. Written by Walter Bright.

## Tutorials

- [D Template Tutorial](https://github.com/PhilippeSigaud/D-templates-tutorial) - A tutorial dedicated to D Templates. Very good explanation about templates. Has pdf version. by Philippe Sigaud.
- [OpenGL tutorials](https://github.com/d-gamedev-team/opengl-tutorials) - OpenGL tutorials in D.

## Compilers

- [DMD](https://github.com/dlang/dmd) - The reference compiler for the D programming language. Stable, builds insanely fast, very good for learning and rapid prototyping/development. Currently the frontend is implemented in D, and shared between dmd, ldc and gdc, the backend is implemented in C++.
- [GDC](https://github.com/D-Programming-GDC/GDC) - GNU D Compiler. Use DMD frontend and GCC backend. Currently targets the most platforms due to the use of GCC. Generated code runs faster than DMD in most cases, on par with LDC. In the process of integration with the official GCC toolchain.
- [LDC](https://github.com/ldc-developers/ldc) - The LLVM-based D compiler. Uses the DMD frontend and LLVM backend. Builds slower than dmd, but generates more optimized code than DMD. It supports all the target platforms of LLVM.

## Game Bindings

- [ALURE](https://github.com/DerelictOrg/DerelictALURE) - Audio library
- [bgfx](https://github.com/GoaLitiuM/bindbc-bgfx) - Cross-Platform renderer
- [Blend2D](https://github.com/kdmult/bindbc-blend2d) - Vector graphics
- [DAllegro5](https://github.com/SiegeLord/DAllegro5) - D binding/wrapper to Allegro 5, a modern game programming library.
- [DevIL](https://github.com/DerelictOrg/DerelictIL) - Image library
- [DSFML](https://github.com/Jebbs/DSFML) - A static binding of SFML in a way that makes sense for D. See <http://dsfml.com/>.
- [ENet](https://github.com/DerelictOrg/DerelictENet) - Networking library
- [FreeImage](https://github.com/BindBC/bindbc-freeimage) - Image loading
- [FreeType](https://github.com/BindBC/bindbc-freetype) - Font rendering
- [GLFW 3](https://github.com/BindBC/bindbc-glfw) - Window/Input library
- [Godot-D](https://github.com/godot-d/godot-d) - D language bindings for the Godot Engine's GDNative API.
- [HarfBuzz](https://github.com/DlangGraphicsWG/bindbc-harfbuzz) - Text shaping
- [Imgui](https://github.com/Inochi2D/bindbc-imgui) - Immediate mode GUI
- [JoyShockLibrary](https://github.com/ZILtoid1991/bindbc-JSL) - Gamepad/Gyro input
- [KiWi](https://github.com/aferust/bindbc-kiwi) - UI widget toolkit
- [libogg](https://github.com/DerelictOrg/DerelictOgg) - Audio codec
- [libpq](https://github.com/DerelictOrg/DerelictPQ) - PostgreSQL library
- [libtheora](https://github.com/DerelictOrg/DerelictTheora) - Video codec
- [libvorbis](https://github.com/DerelictOrg/DerelictVorbis) - Audio codec
- [Lua](https://github.com/BindBC/bindbc-lua) - Scripting language
- [nanomsg-next-gen](https://github.com/darkridder/bindbc-nng) - Messaging library
- [NanoVG](https://github.com/aferust/bindbc-nanovg) - Vector graphics
- [Newton Dynamics](https://github.com/gecko0307/bindbc-newton) - Physics library
- [Nuklear](https://github.com/Timu5/bindbc-nuklear) - Immediate mode GUI
- [Open Dynamics Engine (ODE)](https://github.com/DerelictOrg/DerelictODE) - Physics library
- [OpenAL](https://github.com/BindBC/bindbc-openal) - Audio library
- [OpenGL](https://github.com/BindBC/bindbc-opengl) - Graphics API
- [OpenGLES](https://github.com/DerelictOrg/DerelictGLES) - Graphics API
- [PhysicsFS](https://github.com/DerelictOrg/DerelictPHYSFS) - Virtual file system
- [raylib-d](https://github.com/schveiguy/raylib-d) - D bindings for raylib.
- [raylib3](https://github.com/o3o/bindbc-raylib3) - Game library
- [SDL 2](https://github.com/BindBC/bindbc-sdl) - Multimedia library
- [SDL2_gfx](https://github.com/aferust/bindbc-sdlgfx) - Drawing primitives for SDL2
- [SFML 2](https://github.com/BindBC/bindbc-sfml) - Multimedia library
- [sokol-d](https://github.com/kassane/sokol-d) - D bindings for the sokol headers.
- [SoLoud](https://github.com/gecko0307/bindbc-soloud) - Audio library
- [WebGPU](https://github.com/gecko0307/bindbc-wgpu) - Modern GPU API
- [Zstandard](https://github.com/ZILtoid1991/bindbc-zstandard) - Fast compression

## Data Serialization

- [asdf](https://github.com/libmir/asdf) - Cache oriented string based JSON representation for fast read & writes and serialisation.
- [cerealed](https://github.com/atilaneves/cerealed) - Serialisation library for D
- [dproto](https://github.com/msoucy/dproto) - Google Protocol Buffer support in D.
- [fast.json](https://github.com/etcimon/fast) - A library for D that aims to provide the fastest possible implementation of some every day routines.
- [newxml](https://github.com/ZILtoid1991/newxml) - Successor of std.experimental.xml. DOM compatible, and also has a SAX parser.
- [orange](https://github.com/jacob-carlborg/orange) - General purpose serializer (currently only supports XML)
- [painlessjson](https://github.com/BlackEdder/painlessjson) - Convert between D types and std.json.
- [std.data.json](https://github.com/dlang-community/std_data_json) - Phobos candidate for JSON serialization (based on Vibed)
- [std.experimental.xml](https://github.com/lodo1995/experimental.xml) - Phobos candidate for a XML serialization

## Image Processing

- [dlib.image](https://github.com/gecko0307/dlib) - image processing (8 and 16 bits per channel, floating point operations, filtering, FFT, HDRI, graphics formats support including JPEG and PNG)
- [opencvd](https://github.com/aferust/opencvd) - Unofficial OpenCV binding for D

## Operating Systems

- [PowerNex](https://github.com/PowerNex/PowerNex) - A kernel written in D
- [Trinix](https://github.com/Rikarin/Trinix) - Hybrid operating system for x64 PC written in D
- [XOmB](https://github.com/xomboverlord/xomb) - An exokernel operating system written in D

## Unmaintained

- [collie](https://github.com/huntlabs/collie) - An asynchronous event-driven network framework written in dlang, like netty framework in D.
- [dunit](https://github.com/nomad-software/dunit) - Advanced unit testing & mocking toolkit
- [DWT](https://github.com/d-widget-toolkit/dwt) - A library for creating cross-platform GUI applications. GWT is a port of the Java SWT library to D. DWT was promoted as a semi-standard GUI library for D, but unfortunately didn't catch up popularity yet.
- [flatbuffers](https://github.com/huntlabs/flatbuffers) - D Programming Language implementation of the google flatbuffers library.
- [grpc](https://github.com/huntlabs/grpc-dlang) - Grpc for D programming language, hunt-http library based.
- [hunt](https://github.com/huntlabs/hunt) - A refined core library for D programming language. The module has concurrency / collection / event / io / logging / text / serialize and more.
- [Hunt Framework](https://github.com/huntlabs/hunt-framework) - Hunt is a high-level D Programming Language Web framework that encourages rapid development and clean, pragmatic design. It lets you build high-performance Web applications quickly and easily.
- [hunt-cache](https://github.com/huntlabs/hunt-cache) - D language universal cache library, using radix, redis and memcached.
- [hunt-console](https://github.com/huntlabs/hunt-console) - Hunt console creation easier to create powerful command-line applications.
- [hunt-database](https://github.com/huntlabs/hunt-database) - Hunt database abstraction layer for D programing language, support PostgreSQL / MySQL / SQLite.
- [hunt-entity](https://github.com/huntlabs/hunt-entity) - Hunt entity is an object-relational mapping tool for the D programming language. Referring to the design idea of JPA, support PostgreSQL / MySQL / SQLite.
- [hunt-gossip](https://github.com/huntlabs/hunt-gossip) - A Apache V2 gossip protocol implementation for D programming language.
- [hunt-http](https://github.com/huntlabs/hunt-http) - HTTP/1 and HTTP/2 protocol library for D.
- [hunt-net](https://github.com/huntlabs/hunt-net) - High-performance network library for D programming language, event-driven asynchonous implemention(IOCP / kqueue / epoll).
- [hunt-time](https://github.com/huntlabs/hunt-time) - A time library and similar to Joda-time and Java.time api.
- [hunt-validation](https://github.com/huntlabs/hunt-validation) - A data validation library for DLang based on hunt library.
- [kissrpc](https://github.com/huntlabs/kissrpc) - Fast and light, flatbuffers based rpc framework.
- [LibUI](https://github.com/Extrawurst/DerelictLibui) - Dynamic Binding for [libui](https://github.com/andlabs/libui)

## Cryptography

- [Botan](https://github.com/etcimon/botan) - Block & stream ciphers, public key crypto, hashing, KDF, MAC, PKCS, TLS, ASN.1, BER/DER, etc.
- [Crypto](https://github.com/shove70/crypto) - A D Library of encryption, decryption, encode, hash, and message digital signatures.
- [OpenSSL](https://github.com/D-Programming-Deimos/openssl) - D version of the C headers for OpenSSL.

## GUI Applications

- [Inochi Creator](https://github.com/Inochi2D/inochi-creator) - Inochi2D Rigging Application.
- [Inochi Session](https://github.com/Inochi2D/inochi-session) - Application that allows streaming with Inochi2D puppets.
- [tilix](https://github.com/gnunn1/tilix) - A tiling terminal emulator for Linux using GTK+ 3.

## Database Clients

- [arsd](https://github.com/adamdruppe/arsd) - Adam D. Ruppe's library; in addition to a Web backend, it also has support for database access with database.d, sqlite.d, mysql.d and postgres.d.
- [ddb](https://github.com/pszturmaj/ddb) - Database access for D2. Currently only supports PostgreSQL.
- [ddbc](https://github.com/buggins/ddbc) - DDBC is a DB Connector for D language (similar to JDBC). HibernateD (see below) uses ddbc for database abstraction.
- [dvorm](https://github.com/rikkimax/Dvorm) - An ORM for D with Vibe support. Works with vibe.d and mysql-d, giving it the ability to access MongoDB and MySQL.
- [hibernated](https://github.com/buggins/hibernated) - HibernateD is an ORM for D (similar to [Hibernate](https://hibernate.org/)).
- [libpb](https://github.com/Hax-io/libpb) - Interact with a PocketBase database
- [mysql-native](https://github.com/mysql-d/mysql-native) - A MySQL client implemented in native D.
- [vibe.d](https://github.com/vibe-d/vibe.d) - Vibe.d has internal support for Redis and MongoDB, which are very stable. Soon, the database drivers will be separated into independent projects.

## Game Libraries

- [Dagon](https://github.com/gecko0307/dagon) - 3D game engine for D. See: <https://gecko0307.github.io/dagon/>
- [gfm](https://github.com/drug007/gfm7) - D gamedev toolkit.
- [HipremeEngine](https://github.com/MrcSnm/HipremeEngine) - Cross Platform D-Lang Game Engine with scripting support.
- [InMath](https://github.com/Inochi2D/inmath) - Games math library for D.
- [Parin](https://github.com/Kapendev/parin) - A delightfully simple 2D game engine.
- [PixelPerfectEngine](https://github.com/ZILtoid1991/pixelperfectengine) - 2D graphics engine written in D.
- [rengfx](https://github.com/bmchtech/rengfx) - lightweight, expressive, extensible 2D/3D game engine.
- [Voxelman](https://github.com/MrSmith33/voxelman) - Plugin-based client-server voxel game engine written in D language.

## Configuration

- [D:YAML](https://github.com/dlang-community/D-YAML) - YAML parser and emitter for the D programming language.
- [inifile-D](https://github.com/burner/inifiled) - A compile time ini file parser and writter generator for D
- [sdlang](https://github.com/Abscissa/SDLang-D) - An SDL (Simple Declarative Language) library for D.

## Internationalization

- [bindbc-icu](https://github.com/shoo/bindbc-icu) - bindbc bindings for the unicode ICU library.

## Version Managers

- [dvm](https://github.com/jacob-carlborg/dvm) - A small tool to install and manage DMD (self-hosting) compiler.
- [ldcup](https://github.com/kassane/ldcup) - A small tool to install and manage LDC2 (LLVM backend) compiler.

## Lexers, Parsers & Generators

- [ctpg](https://github.com/youxkei/ctpg) - Compile-Time Parser (with converter) Generator written in D.
- [dunnart](https://github.com/pwil3058/dunnart) - LALR(1) Parser Generator written in D.
- [libdparse](https://github.com/dlang-community/libdparse) - A D language lexer and parser, (possibly) future standard D parser/lexer.
- [Martin Nowak's Lexer](https://github.com/MartinNowak/lexer) - A lexer generator.
- [Mono-D's DParser](https://github.com/aBothe/D_Parser) - A D parser written in C# and used in Mono-D.
- [Pegged](https://github.com/PhilippeSigaud/Pegged) - A Parsing Expression Grammar (PEG) module written in D.

## GUI Libraries

- [DLangUI](https://github.com/buggins/dlangui) - Cross Platform GUI for D programming language. My personal favorite, because it is written in D(not a binding), and is cross platform. DLangUI also has a good showcase in the IDE [DLangIDE](https://github.com/buggins/dlangide).
- [dqml](https://github.com/filcuc/dqml) - Qt Qml bindings for the D programming language.
- [giD](https://github.com/Kymorphia/gid) - GObject Introspection D Package Repository.
- [GtkD](https://github.com/gtkd-developers/GtkD) - GtkD is a D binding and OO wrapper of GTK+. GtkD is actively maintained and is currently the most stable GUI lib for D.
- [microui-D](https://github.com/Kapendev/microui-d) - A tiny immediate-mode UI library.
- [Sciter-Dport](https://github.com/sciter-sdk/Sciter-Dport) - D bindings for the [Sciter](https://sciter.com) - crossplatform HTML/CSS/script desktop UI toolkit.
- [tkD](https://github.com/nomad-software/tkd) - GUI toolkit for the D programming language based on Tcl/Tk.

## IDEs & Editors

- [DCD](https://github.com/dlang-community/DCD) - Independent auto-complete program for the D programming language. Could be used with editors like vim, emacs, sublime text, textadept, and zeus. See [editors support](https://github.com/dlang-community/DCD/wiki/IDEs-and-Editors-with-DCD-support).
- [Dutyl](https://github.com/idanarye/vim-dutyl) - Vim plugin that integrates various D development tools
- [serve-d](https://github.com/Pure-D/serve-d) - Language Server Protocol (LSP) implementation for D. Adds modern IDE features to any editor with LSP support (VSCode, Atom, Vim/Neovim and others)
- [Visual D](https://github.com/dlang/visuald) - Visual Studio extension for the D programming language.

## Games

- [Backgammony](https://github.com/jonathanballs/backgammony) - A Backgammon GUI for Linux built with Gtk.
- [Dtanks](https://github.com/kingsleyh/dtanks) - Robot Tank Battle Game.
- [Electronvolt (formerly Atrium)](https://github.com/gecko0307/electronvolt) - FPS game with physics based puzzles using OpenGL.
- [Spacecraft](https://github.com/Ingrater/Spacecraft) - A 3d multiplayer deathmatch space game written in D 2.0.

## Dependency Injection

- [Poodinis](https://github.com/mbierlee/poodinis) - A dependency injection framework for D with support for autowiring.

## Logging

- [dlog](https://github.com/deavmi/dlog) - extensible logging framework with message transformation support and custom loggers and contexts
- [dlogg](https://github.com/NCrashed/dlogg) - Logging for concurrent applications and daemons with lazy and delayed logging, [logrotate](https://linux.die.net/man/8/logrotate) support.

## Javascript

- [higgs](https://github.com/higgsjs/Higgs) - Higgs JavaScript Virtual Machine, implemented in D.

## Dev Tools

- [D-Scanner](https://github.com/dlang-community/D-Scanner) - Swiss-army knife for D source code (linting, static analysis, D code parsing, etc.)
- [dfmt](https://github.com/dlang-community/dfmt) - formatter for D source code

## Machine Learning

- [bindbc-onnxruntime](https://github.com/lempiji/bindbc-onnxruntime) - bindbc bindings to Microsoft's cross-platform, high performance ML inferencing and training accelerator
- [grain2](https://github.com/ShigekiKarita/grain2) - Autograd and GPGPU library for dynamic neural networks in D
- [tfd](https://github.com/ShigekiKarita/tfd) - Tensorflow wrapper for D
- [vectorflow](https://github.com/Netflix/vectorflow) - Nexflix's opensource deep learning framework.
