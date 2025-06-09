## Tutorials

| Name                                                                          | Description                                                                                                      | Stars | Last Commit |
|-------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [D Template Tutorial](https://github.com/PhilippeSigaud/D-templates-tutorial) | A tutorial dedicated to D Templates. Very good explanation about templates. Has pdf version. by Philippe Sigaud. | 233   | 2021-09-21  |

## Package Management

| Name                                | Description                                         | Stars | Last Commit |
|-------------------------------------|-----------------------------------------------------|-------|-------------|
| [dub](https://github.com/dlang/dub) | Official package and build management system for D. | 700   | 2025-05-27  |

## Compilers

| Name                                            | Description                                                                                                                                                                                                                                                        | Stars | Last Commit |
|-------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [dmd](https://github.com/dlang/dmd)             | The reference compiler for the D programming language. Stable, builds insanely fast, very good for learning and rapid prototyping/development. Currently the frontend is implemented in D, and shared between dmd, ldc and gdc, the backend is implemented in C++. | 3129  | 2025-06-09  |
| [ldc](https://github.com/ldc-developers/ldc)    | The LLVM-based D compiler. Uses the DMD frontend and LLVM backend. Builds slower than dmd, but generates more optimized code than DMD. It supports all the target platforms of LLVM.                                                                               | 1274  | 2025-06-08  |
| [gdc](https://github.com/D-Programming-GDC/GDC) | GNU D Compiler. Use DMD frontend and GCC backend. Currently targets the most platforms due to the use of GCC. Generated code runs faster than DMD in most cases, on par with LDC. In the process of integration with the official GCC toolchain.                   | 358   | 2018-12-25  |

## WIP Compilers

| Name                                   | Description                                                   | Stars | Last Commit |
|----------------------------------------|---------------------------------------------------------------|-------|-------------|
| [sdc](https://github.com/snazzy-d/SDC) | The Snazzy D Compiler. Written in D. Grows Smarter every day. | 254   | 2025-05-30  |

## Dev Tools

| Name                                                      | Description                                                                         | Stars | Last Commit |
|-----------------------------------------------------------|-------------------------------------------------------------------------------------|-------|-------------|
| [D-Scanner](https://github.com/dlang-community/D-Scanner) | Swiss-army knife for D source code (linting, static analysis, D code parsing, etc.) | 245   | 2025-03-23  |
| [dfmt](https://github.com/dlang-community/dfmt)           | formatter for D source code                                                         | 207   | 2024-08-21  |

## Build Tools

| Name                                                       | Description                                                                                    | Stars | Last Commit |
|------------------------------------------------------------|------------------------------------------------------------------------------------------------|-------|-------------|
| [dub](https://github.com/dlang/dub)                        | De facto official package and build management system for D. Will be included officially soon. | 700   | 2025-05-27  |
| [reggae](https://github.com/atilaneves/reggae)             | meta build system in D                                                                         | 186   | 2025-03-19  |
| [cmake-d](https://github.com/dcarp/cmake-d)                | CMake D Projects                                                                               | 66    | 2023-06-09  |
| [cook2](https://github.com/gecko0307/Cook2)                | Fast incremental build tool intended for projects in D                                         | 25    | 2023-04-30  |
| [Makefile](https://github.com/bioinfornatics/MakefileForD) | Makefile template for D projects                                                               | 20    | 2016-04-19  |
| [wild](https://github.com/Vild/Wild)                       | Wild build system, used to build the kernel                                                    | 6     | 2016-08-14  |
| [premake](https://github.com/premake/premake-dlang)        | Premake has built-in support for D projects                                                    | 2     | 2016-11-16  |
| [wox](https://github.com/redthing1/wox)                    | A highly flexible recipe build system inspired by Make                                         | 0     | 2023-05-18  |

## IDEs & Editors

| Name                                           | Description                                                                                                                                            | Stars | Last Commit |
|------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [DCD](https://github.com/dlang-community/DCD)  | Independent auto-complete program for the D programming language. Could be used with editors like vim, emacs, sublime text, textadept, and zeus. See . | 355   | 2025-03-01  |
| [Visual D](https://github.com/dlang/visuald)   | Visual Studio extension for the D programming language.                                                                                                | 297   | 2025-05-13  |
| [serve-d](https://github.com/Pure-D/serve-d)   | Language Server Protocol (LSP) implementation for D. Adds modern IDE features to any editor with LSP support (VSCode, Atom, Vim/Neovim and others)     | 232   | 2025-01-11  |
| [Dutyl](https://github.com/idanarye/vim-dutyl) | Vim plugin that integrates various D development tools                                                                                                 | 79    | 2020-04-02  |

## Lexers, Parsers, Parser Generators

| Name                                                         | Description                                                               | Stars | Last Commit |
|--------------------------------------------------------------|---------------------------------------------------------------------------|-------|-------------|
| [Pegged](https://github.com/PhilippeSigaud/Pegged)           | A Parsing Expression Grammar (PEG) module written in D.                   | 535   | 2023-09-08  |
| [libdparse](https://github.com/dlang-community/libdparse)    | A D language lexer and parser, (possibly) future standard D parser/lexer. | 117   | 2025-03-01  |
| [ctpg](https://github.com/youxkei/ctpg)                      | Compile-Time Parser (with converter) Generator written in D.              | 45    | 2015-05-06  |
| [Mono-D's DParser](https://github.com/aBothe/D_Parser)       | A D parser written in C# and used in Mono-D.                              | 30    | 2020-06-04  |
| [dunnart](https://github.com/pwil3058/dunnart)               | LALR(1) Parser Generator written in D.                                    | 14    | 2017-07-14  |
| [Martin Nowak's Lexer](https://github.com/MartinNowak/lexer) | A lexer generator.                                                        | 14    | 2014-05-18  |

## Preprocesors

| Name                                            | Description                                                                                  | Stars | Last Commit |
|-------------------------------------------------|----------------------------------------------------------------------------------------------|-------|-------------|
| [warp](https://github.com/facebookarchive/warp) | A fast preprocessor for C and C++ used in Facebook infrastructure. Written by Walter Bright. | 531   | 2021-09-26  |

## Version Manager

| Name                                         | Description                                                      | Stars | Last Commit |
|----------------------------------------------|------------------------------------------------------------------|-------|-------------|
| [dvm](https://github.com/jacob-carlborg/dvm) | A small tool to install and manage DMD (self-hosting) compiler.  | 58    | 2025-05-08  |
| [ldcup](https://github.com/kassane/ldcup)    | A small tool to install and manage LDC2 (LLVM backend) compiler. | 1     | 2025-06-02  |

## Javascript

| Name                                      | Description                                         | Stars | Last Commit |
|-------------------------------------------|-----------------------------------------------------|-------|-------------|
| [higgs](https://github.com/higgsjs/Higgs) | Higgs JavaScript Virtual Machine, implemented in D. | 884   | 2023-06-09  |

## Basic

| Name                                                           | Description                                                                                                                                    | Stars | Last Commit |
|----------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [hunt](https://github.com/huntlabs/hunt)                       | A refined core library for D programming language. The module has concurrency / collection / event / io / logging / text / serialize and more. | 98    | 2024-01-17  |
| [NuMem](https://github.com/Inochi2D/numem)                     | No-GC memory managment utilities for DLang.                                                                                                    | 29    | 2025-06-05  |
| [Joka](https://github.com/Kapendev/joka)                       | A nogc utility library.                                                                                                                        | 9     | 2025-06-08  |
| [hunt-validation](https://github.com/huntlabs/hunt-validation) | A data validation library for DLang based on hunt library.                                                                                     | 3     | 2024-01-18  |
| [hunt-time](https://github.com/huntlabs/hunt-time)             | A time library and similar to Joda-time and Java.time api.                                                                                     | 2     | 2021-03-17  |

## Containers

| Name                                                             | Description                                                                           | Stars | Last Commit |
|------------------------------------------------------------------|---------------------------------------------------------------------------------------|-------|-------------|
| [dlib.container](https://github.com/gecko0307/dlib)              | generic data structures (GC-free dynamic and associative arrays and more)             | 220   | 2025-05-01  |
| [EMSI containers](https://github.com/dlang-community/containers) | Containers that do not use the GC                                                     | 111   | 2023-11-15  |
| [memutils](https://github.com/etcimon/memutils)                  | Overhead allocators, allocator-aware containers and lifetime management for D objects | 43    | 2025-03-14  |
| [std.rcstring](https://github.com/burner/std.rcstring)           | A reference counted string implementation for D's build in string construct           | 9     | 2019-09-12  |

## GitHub Actions

| Name                                                          | Description                                                                                     | Stars | Last Commit |
|---------------------------------------------------------------|-------------------------------------------------------------------------------------------------|-------|-------------|
| [setup-dlang](https://github.com/dlang-community/setup-dlang) | Install D compilers &amp; DUB inside GitHub Actions                                             | 50    | 2025-05-11  |
| [dub-upgrade](https://github.com/WebFreak001/dub-upgrade)     | Run `dub upgrade` trying to repeat on network failure and using package cache on GitHub Actions | 1     | 2023-07-11  |

## Testing Frameworks

| Name                                                         | Description                                 | Stars | Last Commit |
|--------------------------------------------------------------|---------------------------------------------|-------|-------------|
| [unit-threaded](https://github.com/atilaneves/unit-threaded) | Multi-threaded unit test framework          | 122   | 2025-03-18  |
| [dunit](https://github.com/nomad-software/dunit)             | Advanced unit testing &amp; mocking toolkit | 60    | 2020-02-04  |

## Web Frameworks

| Name                                                         | Description                                                                                                                                                                                                         | Stars | Last Commit |
|--------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [arsd](https://github.com/adamdruppe/arsd)                   | Adam D. Ruppe's web framework.                                                                                                                                                                                      | 537   | 2025-06-06  |
| [Hunt Framework](https://github.com/huntlabs/hunt-framework) | Hunt is a high-level D Programming Language Web framework that encourages rapid development and clean, pragmatic design. It lets you build high-performance Web applications quickly and easily.<br>*RPC libraries* | 306   | 2024-03-11  |
| [dlang-requests](https://github.com/ikod/dlang-requests)     | HTTP client library inspired by python-requests                                                                                                                                                                     | 158   | 2025-04-13  |
| [libasync](https://github.com/etcimon/libasync)              | Cross-platform event loop library of asynchronous objects                                                                                                                                                           | 149   | 2024-07-04  |
| [serverino](https://github.com/trikko/serverino)             | Small and ready-to-go http server, in D                                                                                                                                                                             | 71    | 2025-06-04  |
| [collie](https://github.com/huntlabs/collie)                 | An asynchronous event-driven network framework written in dlang, like netty framework in D.                                                                                                                         | 61    | 2018-09-12  |
| [grpc](https://github.com/huntlabs/grpc-dlang)               | Grpc for D programming language, hunt-http library based.                                                                                                                                                           | 44    | 2022-03-12  |
| [kissrpc](https://github.com/huntlabs/kissrpc)               | Fast and light, flatbuffers based rpc framework.                                                                                                                                                                    | 40    | 2018-03-22  |
| [Handy-Httpd](https://github.com/andrewlalis/handy-httpd)    | A simple, lightweight, and well-documented HTTP server that lets you bootstrap ideas and have something up and running in minutes.                                                                                  | 37    | 2025-05-30  |
| [libhttp2](https://github.com/etcimon/libhttp2)              | HTTP/2 library in D, translated from nghttp2                                                                                                                                                                        | 35    | 2023-03-02  |
| [hunt-http](https://github.com/huntlabs/hunt-http)           | HTTP/1 and HTTP/2 protocol library for D.<br>*Full stack web frameworks*                                                                                                                                            | 31    | 2022-05-17  |
| [Hprose](https://github.com/hprose/hprose-d)                 | A very newbility RPC Library for D, and it support 25+ languages now.                                                                                                                                               | 26    | 2016-11-14  |
| [DSSG](https://github.com/kambrium/dssg)                     | A static site generator with a different approach.                                                                                                                                                                  | 20    | 2023-03-12  |
| [hunt-net](https://github.com/huntlabs/hunt-net)             | High-performance network library for D programming language, event-driven asynchonous implemention(IOCP / kqueue / epoll).                                                                                          | 20    | 2022-02-21  |
| [cmsed](https://github.com/rikkimax/Cmsed)                   | A component library for Vibe that functions as a CMS.                                                                                                                                                               | 19    | 2015-01-23  |
| [hunt-cache](https://github.com/huntlabs/hunt-cache)         | D language universal cache library, using radix, redis and memcached.<br>*Static Site Generator*                                                                                                                    | 6     | 2022-12-26  |
| [hunt-gossip](https://github.com/huntlabs/hunt-gossip)       | A Apache V2 gossip protocol implementation for D programming language.<br>*Cache*                                                                                                                                   | 0     | 2019-03-11  |

## Binary Serilization

| Name                                                   | Description                                                              | Stars | Last Commit |
|--------------------------------------------------------|--------------------------------------------------------------------------|-------|-------------|
| [cerealed](https://github.com/atilaneves/cerealed)     | Serialisation library for D                                              | 92    | 2023-06-02  |
| [dproto](https://github.com/msoucy/dproto)             | Google Protocol Buffer support in D.                                     | 37    | 2020-05-02  |
| [flatbuffers](https://github.com/huntlabs/flatbuffers) | D Programming Language implementation of the google flatbuffers library. | 10    | 2017-07-21  |

## JSON

| Name                                                              | Description                                                                                          | Stars | Last Commit |
|-------------------------------------------------------------------|------------------------------------------------------------------------------------------------------|-------|-------------|
| [fast.json](https://github.com/etcimon/fast)                      | A library for D that aims to provide the fastest possible implementation of some every day routines. | 112   | 2023-03-03  |
| [std.data.json](https://github.com/dlang-community/std_data_json) | Phobos candidate for JSON serialization (based on Vibed)                                             | 25    | 2024-05-30  |
| [painlessjson](https://github.com/BlackEdder/painlessjson)        | Convert between D types and std.json.                                                                | 24    | 2019-07-12  |
| [asdf](https://github.com/libmir/asdf)                            | Cache oriented string based JSON representation for fast read &amp; writes and serialisation.        | 23    | 2024-08-20  |

## XML

| Name                                                                 | Description                                                                   | Stars | Last Commit |
|----------------------------------------------------------------------|-------------------------------------------------------------------------------|-------|-------------|
| [orange](https://github.com/jacob-carlborg/orange)                   | General purpose serializer (currently only supports XML)                      | 72    | 2020-03-21  |
| [std.experimental.xml](https://github.com/lodo1995/experimental.xml) | Phobos candidate for a XML serialization                                      | 20    | 2017-07-27  |
| [newxml](https://github.com/ZILtoid1991/newxml)                      | Successor of std.experimental.xml. DOM compatible, and also has a SAX parser. | 8     | 2024-01-08  |

## Database clients

| Name                                                       | Description                                                                                                                                                | Stars | Last Commit |
|------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [vibe.d](https://github.com/vibe-d/vibe.d)                 | Vibe.d has internal support for Redis and MongoDB, which are very stable. Soon, the database drivers will be separated into independent projects.          | 1177  | 2025-05-20  |
| [arsd](https://github.com/adamdruppe/arsd)                 | Adam D. Ruppe's library; in addition to a Web backend, it also has support for database access with database.d, sqlite.d, mysql.d and postgres.d.          | 537   | 2025-06-06  |
| [hibernated](https://github.com/buggins/hibernated)        | HibernateD is an ORM for D (similar to ).                                                                                                                  | 83    | 2024-12-22  |
| [mysql-native](https://github.com/mysql-d/mysql-native)    | A MySQL client implemented in native D.                                                                                                                    | 82    | 2024-01-10  |
| [ddbc](https://github.com/buggins/ddbc)                    | DDBC is a DB Connector for D language (similar to JDBC). HibernateD (see below) uses ddbc for database abstraction.                                        | 79    | 2025-02-17  |
| [hunt-entity](https://github.com/huntlabs/hunt-entity)     | Hunt entity is an object-relational mapping tool for the D programming language. Referring to the design idea of JPA, support PostgreSQL / MySQL / SQLite. | 58    | 2022-07-22  |
| [hunt-database](https://github.com/huntlabs/hunt-database) | Hunt database abstraction layer for D programing language, support PostgreSQL / MySQL / SQLite.                                                            | 50    | 2023-11-15  |
| [ddb](https://github.com/pszturmaj/ddb)                    | Database access for D2. Currently only supports PostgreSQL.                                                                                                | 39    | 2022-07-31  |
| [dvorm](https://github.com/rikkimax/Dvorm)                 | An ORM for D with Vibe support. Works with vibe.d and mysql-d, giving it the ability to access MongoDB and MySQL.                                          | 17    | 2016-05-12  |
| [libpb](https://github.com/Hax-io/libpb)                   | INteract with a PocketBase database                                                                                                                        | 6     | 2023-06-18  |

## Command Line

| Name                                                     | Description                                                                                           | Stars | Last Commit |
|----------------------------------------------------------|-------------------------------------------------------------------------------------------------------|-------|-------------|
| [terminal.d](https://github.com/adamdruppe/arsd)         | Part of Adam Ruppe's library supporting cursor and color manipulation on the console.                 | 537   | 2025-06-06  |
| [scriptlike](https://github.com/Abscissa/scriptlike)     | Utility library to aid writing script-like programs in D.                                             | 93    | 2021-03-10  |
| [luneta](https://github.com/fbeline/luneta)              | A command-line fuzzy finder.                                                                          | 62    | 2023-08-14  |
| [commandr](https://github.com/robik/commandr)            | A modern, powerful commmand line argument parser.                                                     | 43    | 2024-08-21  |
| [Argon](https://github.com/markuslaker/Argon)            | A processor for command-line arguments, an alternative to Getopt, written in D.                       | 17    | 2017-11-10  |
| [argsd](https://github.com/burner/argsd)                 | A command line and config file parser for DLang                                                       | 16    | 2021-08-25  |
| [todod](https://github.com/BlackEdder/todod)             | Todod is a command line based todo list manager. It also has support for shell interaction based on . | 16    | 2017-03-22  |
| [dexpect](https://github.com/grogancolin/dexpect)        | A D implementation of the expect framework. Handy for bash emulation.                                 | 13    | 2020-12-21  |
| [hunt-console](https://github.com/huntlabs/hunt-console) | Hunt console creation easier to create powerful command-line applications.                            | 4     | 2021-10-29  |
| [gogga](https://github.com/deavmi/gogga)                 | simple easy-to-use colorful logger for command-line applications                                      | 2     | 2025-03-21  |
| [dlog](https://github.com/deavmi/dlog)                   | extensible logging framework with message transformation support and custom loggers and contexts      | 1     | 2025-03-21  |

## GUI Libraries

| Name                                                       | Description                                                                                                                                                                                                  | Stars | Last Commit |
|------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [DLangUI](https://github.com/buggins/dlangui)              | Cross Platform GUI for D programming language. My personal favorate, because it is written in D(not a binding), and is cross platform. DLangUI also has a good showcase in the IDE .                         | 845   | 2024-12-08  |
| [GtkD](https://github.com/gtkd-developers/GtkD)            | GtkD is a D binding and OO wrapper of GTK+. GtkD is actively maintained and is currently the most stable GUI lib for D.                                                                                      | 327   | 2024-12-31  |
| [DWT](https://github.com/d-widget-toolkit/dwt)             | A library for creating cross-platform GUI applications. GWT is a port of the Java SWT library to D. DWT was promoted as a semi-standard GUI library for D, but unfortunately didn't catch up popularity yet. | 140   | 2023-09-19  |
| [tkD](https://github.com/nomad-software/tkd)               | GUI toolkit for the D programming language based on Tcl/Tk.                                                                                                                                                  | 120   | 2021-10-15  |
| [dqml](https://github.com/filcuc/dqml)                     | Qt Qml bindings for the D programming language.                                                                                                                                                              | 43    | 2022-10-12  |
| [LibUI](https://github.com/Extrawurst/DerelictLibui)       | Dynamic Binding for <br>*Note*: You can also find a list of GUI libs on , but not all of the libraries are actively maintained now.                                                                          | 34    | 2021-05-28  |
| [Sciter-Dport](https://github.com/sciter-sdk/Sciter-Dport) | D bindings for the - crossplatform HTML/CSS/script desktop UI toolkit.                                                                                                                                       | 34    | 2017-06-12  |
| [giD](https://github.com/Kymorphia/gid)                    | GObject Introspection D Package Repository.                                                                                                                                                                  | 22    | 2025-05-30  |

## GUI Apps

| Name                                                         | Description                                              | Stars | Last Commit |
|--------------------------------------------------------------|----------------------------------------------------------|-------|-------------|
| [tilix](https://github.com/gnunn1/tilix)                     | A tiling terminal emulator for Linux using GTK+ 3.       | 5526  | 2025-04-20  |
| [Inochi Creator](https://github.com/Inochi2D/inochi-creator) | Inochi2D Rigging Application.                            | 966   | 2025-04-28  |
| [Inochi Session](https://github.com/Inochi2D/inochi-session) | Application that allows streaming with Inochi2D puppets. | 335   | 2025-01-27  |

## OS

| Name                                             | Description                                     | Stars | Last Commit |
|--------------------------------------------------|-------------------------------------------------|-------|-------------|
| [PowerNex](https://github.com/PowerNex/PowerNex) | A kernel written in D                           | 498   | 2019-03-02  |
| [XOmB](https://github.com/xomboverlord/xomb)     | An exokernel operating system written in D      | 347   | 2013-05-31  |
| [Trinix](https://github.com/Rikarin/Trinix)      | Hybrid operating system for x64 PC written in D | 110   | 2021-10-26  |

## Game Bindings

| Name                                                | Description                                                        | Stars | Last Commit |
|-----------------------------------------------------|--------------------------------------------------------------------|-------|-------------|
| [Godot-D](https://github.com/godot-d/godot-d)       | D language bindings for the Godot Engine's GDNative API            | 211   | 2023-09-04  |
| [DSFML](https://github.com/Jebbs/DSFML)             | A static binding of SFML in a way that makes sense for D. See .    | 95    | 2019-04-28  |
| [raylib-d](https://github.com/schveiguy/raylib-d)   | D bindings for raylib.                                             | 73    | 2024-11-21  |
| [DAllegro5](https://github.com/SiegeLord/DAllegro5) | D binding/wrapper to Allegro 5, a modern game programming library. | 44    | 2024-10-31  |
| [sokol-d](https://github.com/kassane/sokol-d)       | D bindings for the sokol headers.                                  | 17    | 2025-06-08  |

## Game Frameworks

| Name                                                                    | Description                                                        | Stars | Last Commit |
|-------------------------------------------------------------------------|--------------------------------------------------------------------|-------|-------------|
| [Dagon](https://github.com/gecko0307/dagon)                             | 3D game engine for D. see                                          | 362   | 2025-06-06  |
| [Voxelman](https://github.com/MrSmith33/voxelman)                       | Plugin-based client-server voxel game engine written in D language | 127   | 2022-05-10  |
| [HipremeEngine](https://github.com/MrcSnm/HipremeEngine)                | Cross Platform D-Lang Game Engine with scripting support.          | 125   | 2025-06-02  |
| [PixelPerfectEngine](https://github.com/ZILtoid1991/pixelperfectengine) | 2D graphics engine written in D.                                   | 103   | 2025-06-05  |
| [rengfx](https://github.com/bmchtech/rengfx)                            | lightweight, expressive, extensible 2D/3D game engine.             | 88    | 2024-10-12  |
| [Parin](https://github.com/Kapendev/parin)                              | A delightfully simple 2D game engine.                              | 23    | 2025-06-08  |
| [InMath](https://github.com/Inochi2D/inmath)                            | Games math library for D.                                          | 8     | 2024-09-11  |
| [gfm](https://github.com/drug007/gfm7)                                  | D gamedev toolkit.                                                 | 3     | 2024-07-27  |

## Games

| Name                                                                        | Description                                              | Stars | Last Commit |
|-----------------------------------------------------------------------------|----------------------------------------------------------|-------|-------------|
| [Electronvolt (formerly Atrium)](https://github.com/gecko0307/electronvolt) | FPS game with physics based puzzles using OpenGL.        | 112   | 2025-05-11  |
| [Backgammony](https://github.com/jonathanballs/backgammony)                 | A Backgammon GUI for Linux built with Gtk.               | 42    | 2024-06-19  |
| [Spacecraft](https://github.com/Ingrater/Spacecraft)                        | A 3d multiplayer deathmatch space game written in D 2.0. | 18    | 2014-06-11  |
| [Dtanks](https://github.com/kingsleyh/dtanks)                               | Robot Tank Battle Game.                                  | 11    | 2016-01-28  |

## Internationalization

| Name                                             | Description                                  | Stars | Last Commit |
|--------------------------------------------------|----------------------------------------------|-------|-------------|
| [bindbc-icu](https://github.com/shoo/bindbc-icu) | bindbc bindings for the unicode ICU library. | 2     | 2025-03-11  |

## Video applications

| Name                                                      | Description                                                 | Stars | Last Commit |
|-----------------------------------------------------------|-------------------------------------------------------------|-------|-------------|
| [DerelictGL3](https://github.com/DerelictOrg/DerelictGL3) | A dynamic binding to OpenGL for the D Programming Language. | 79    | 2019-03-28  |

## Image Processing

| Name                                                  | Description                                                                                                                                    | Stars | Last Commit |
|-------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [color.d](https://github.com/adamdruppe/arsd)         |                                                                                                                                                | 537   | 2025-06-06  |
| [dlib.image](https://github.com/gecko0307/dlib)       | image processing (8 and 16 bits per channel, floating point operations, filtering, FFT, HDRI, graphics formats support including JPEG and PNG) | 220   | 2025-05-01  |
| [ArmageddonEngine](https://github.com/CyberShadow/ae) | Vladimir Panteleev's ae library has a package for image processing in functional style, which is described in the article .                    | 171   | 2025-05-28  |
| [opencvd](https://github.com/aferust/opencvd)         | Unofficial OpenCV binding for D                                                                                                                | 23    | 2021-09-06  |

## End-user applications

| Name                                                         | Description                                   | Stars | Last Commit |
|--------------------------------------------------------------|-----------------------------------------------|-------|-------------|
| [onedrive](https://github.com/abraunegg/onedrive)            | #1 Free OneDrive Client for Linux             | 11055 | 2025-06-08  |
| [Inochi Creator](https://github.com/Inochi2D/inochi-creator) | Tool to create and edit Inochi2D puppets      | 966   | 2025-04-28  |
| [Literate](https://github.com/zyedidia/Literate)             | A literate programming tool for any language  | 685   | 2022-07-10  |
| [tshare](https://github.com/trikko/tshare)                   | fast file sharing from cli, using transfer.sh | 137   | 2023-12-13  |

## Machine Learning

| Name                                                                | Description                                                                                             | Stars | Last Commit |
|---------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------|-------|-------------|
| [vectorflow](https://github.com/Netflix/vectorflow)                 | Nexflix's opensource deep learning framework.                                                           | 1294  | 2024-05-02  |
| [tfd](https://github.com/ShigekiKarita/tfd)                         | Tensorflow wrapper for D                                                                                | 32    | 2021-06-15  |
| [bindbc-onnxruntime](https://github.com/lempiji/bindbc-onnxruntime) | bindbc bindings to Microsoft's cross-platform, high performance ML inferencing and training accelerator | 11    | 2023-03-05  |
| [grain2](https://github.com/ShigekiKarita/grain2)                   | Autograd and GPGPU library for dynamic neural networks in D                                             | 7     | 2020-03-14  |

## Parallel computing

| Name                                                        | Description                                                            | Stars | Last Commit |
|-------------------------------------------------------------|------------------------------------------------------------------------|-------|-------------|
| [DCompute](https://github.com/libmir/dcompute)              |                                                                        | 138   | 2022-12-23  |
| [DerelictCUDA](https://github.com/DerelictOrg/DerelictCUDA) | Dynamic bindings to the CUDA library for the D Programming Language.   | 17    | 2019-02-22  |
| [DerelictCL](https://github.com/DerelictOrg/DerelictCL)     | Dynamic bindings to the OpenCL library for the D Programming Language. | 7     | 2019-10-30  |

## Scientific

| Name                                               | Description                                                                    | Stars | Last Commit |
|----------------------------------------------------|--------------------------------------------------------------------------------|-------|-------------|
| [mir](https://github.com/libmir/mir)               | Sandbox for some mir packages: sparse tensors, Hoffman and others.             | 211   | 2022-06-05  |
| [mir-algorithm](https://github.com/libmir/mir)     | N-dimensional arrays (matrixes, tensors), algorithms, general purpose library. | 211   | 2022-06-05  |
| [scid](https://github.com/DlangScience/scid)       | Scientific library for the D programming language                              | 91    | 2020-04-30  |
| [mir-random](https://github.com/libmir/mir-random) | Advanced Random Number Generators.                                             | 32    | 2024-12-17  |
| [dstats](https://github.com/DlangScience/dstats)   | A statistics library for D.                                                    | 26    | 2022-12-10  |

## Language Processing

| Name                                                    | Description                                                                   | Stars | Last Commit |
|---------------------------------------------------------|-------------------------------------------------------------------------------|-------|-------------|
| [bindbc-mecab](https://github.com/lempiji/bindbc-mecab) | bindbc MeCab binding (Part-of-Speech and Morphological Analyzer for Japanese) | 1     | 2020-07-24  |

## Text Processing

| Name                                                       | Description                                                                                                              | Stars | Last Commit |
|------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [eBay's TSV utilities](https://github.com/eBay/tsv-utils)  | Filtering, statistics, sampling, joins and other operations on TSV files. Very fast, especially good for large datasets. | 1446  | 2022-09-14  |
| [hunt-markdown](https://github.com/huntlabs/hunt-markdown) | A markdown parsing and rendering library for D programming language. Support commonMark.                                 | 12    | 2022-04-15  |

## Logging

| Name                                       | Description                                                                             | Stars | Last Commit |
|--------------------------------------------|-----------------------------------------------------------------------------------------|-------|-------------|
| [dlogg](https://github.com/NCrashed/dlogg) | Logging for concurrent applications and daemons with lazy and delayed logging, support. | 14    | 2017-11-10  |

## Configuration

| Name                                                | Description                                                | Stars | Last Commit |
|-----------------------------------------------------|------------------------------------------------------------|-------|-------------|
| [sdlang](https://github.com/Abscissa/SDLang-D)      | An SDL (Simple Declarative Language) library for D.        | 121   | 2023-04-30  |
| [D:YAML](https://github.com/dlang-community/D-YAML) | YAML parser and emitter for the D programming language.    | 120   | 2025-02-03  |
| [inifile-D](https://github.com/burner/inifiled)     | A compile time ini file parser and writter generator for D | 21    | 2022-10-19  |

## Blog Engine

| Name                                             | Description                     | Stars | Last Commit |
|--------------------------------------------------|---------------------------------|-------|-------------|
| [mood](https://github.com/mihails-strasuns/mood) | simple vibe.d based blog engine | 43    | 2020-11-20  |

## Dependency Injection

| Name                                             | Description                                                         | Stars | Last Commit |
|--------------------------------------------------|---------------------------------------------------------------------|-------|-------------|
| [Poodinis](https://github.com/mbierlee/poodinis) | A dependency injection framework for D with support for autowiring. | 73    | 2025-05-18  |
