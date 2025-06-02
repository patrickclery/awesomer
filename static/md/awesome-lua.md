## Implementations, Interpreters, and Bindings

| Name                                                  | Description                                                                                                                                                                                                                               | Stars | Last Commit |
|-------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Lua Repo](https://github.com/lua/lua)                | The official Lua repo, as seen by the Lua team, mirrored to GitHub.                                                                                                                                                                       | 9102  | 2025-05-21  |
| [GopherLua](https://github.com/yuin/gopher-lua)       | Lua 5.1 VM and compiler implemented in Go with Go APIs.                                                                                                                                                                                   | 6598  | 2024-11-09  |
| [LuaBridge](https://github.com/vinniefalco/LuaBridge) | A lightweight library for mapping data, functions, and classes back and forth between C++ and Lua.<br>Note: From LuaJIT to Lua to lua.vm.js to Moonshine, a basic benchmark sees performance drop by roughly a factor of 6 with each hop. | 1694  | 2024-12-07  |
| [MoonSharp](https://github.com/xanathar/moonsharp)    | A Lua interpreter written entirely in C# for the .NET, Mono and Unity platforms.                                                                                                                                                          | 1482  | 2023-11-30  |
| [UniLua](https://github.com/xebecnan/UniLua)          | A pure C# implementation of Lua 5.2, focused on compatibility with the Unity game engine.                                                                                                                                                 | 1116  | 2024-06-22  |
| [lupa](https://github.com/scoder/lupa)                | Python bindings to LuaJIT2.                                                                                                                                                                                                               | 1076  | 2025-04-26  |
| [lua.vm.js](https://github.com/daurnimator/lua.vm.js) | Lua VM on the web; a direct port of the C interpreter via LLVM, emscripten, and asm.js.                                                                                                                                                   | 836   | 2018-07-27  |
| [golua](https://github.com/aarzilli/golua)            | Golang bindings to the Lua C API.                                                                                                                                                                                                         | 673   | 2025-02-17  |
| [Moonshine](https://github.com/gamesys/moonshine)     | A Lua VM implemented in JavaScript. Slower than lua.vm.js, but with better docs, examples, and JS interfacing.                                                                                                                            | 500   | 2021-05-28  |
| [LLVM-Lua](https://github.com/neopallium/llvm-lua)    | Compiles Lua to LLVM.                                                                                                                                                                                                                     | 159   | 2016-01-15  |

## Build Tools and Standalone Makers

| Name                                                 | Description                                                                        | Stars | Last Commit |
|------------------------------------------------------|------------------------------------------------------------------------------------|-------|-------------|
| [luastatic](https://github.com/ers35/luastatic)      | Simple tool for turning Lua programs into standalone executables.                  | 817   | 2023-10-28  |
| [Lake](https://github.com/stevedonovan/Lake)         | A build engine written in Lua, similar to Ruby's rake.                             | 134   | 2015-09-24  |
| [Luabuild](https://github.com/stevedonovan/luabuild) | Highly customizable Lua 5.2 build system.                                          | 79    | 2015-12-21  |
| [omnia](https://github.com/tongson/omnia)            | A batteries-included creator of standalone executables, built on top of luastatic. | 47    | 2020-11-05  |

## Debugging and Profiling

| Name                                                        | Description                                                                                             | Stars | Last Commit |
|-------------------------------------------------------------|---------------------------------------------------------------------------------------------------------|-------|-------------|
| [MobDebug](https://github.com/pkulchenko/MobDebug)          | Powerful remote debugger with breakpoints and stack inspection. Used by ZeroBraneStudio.                | 912   | 2023-10-17  |
| [lovebird](https://github.com/rxi/lovebird)                 | Browser-based debug console. Originally made for LÖVE, but works in any project with LuaSocket support. | 308   | 2021-05-08  |
| [StackTracePlus](https://github.com/ignacio/StackTracePlus) | Drop-in upgrade to Lua's stack traces which adds local context and improves readability.                | 198   | 2023-07-24  |
| [luatrace](https://github.com/geoffleyland/luatrace)        | Toolset for tracing/analyzing/profiling script execution and generating detailed reports.               | 173   | 2015-11-30  |

## IDEs and Plugins

| Name                                               | Description                       | Stars | Last Commit |
|----------------------------------------------------|-----------------------------------|-------|-------------|
| [lua-mode](https://github.com/immerrr/lua-mode)    | Emacs major mode for editing Lua. | 329   | 2025-03-10  |
| [vscode-lua](https://github.com/trixnz/vscode-lua) | VSCode intellisense and linting.  | 120   | 2024-03-21  |

## Utility Belts

| Name                                                     | Description                                                                                                                | Stars | Last Commit |
|----------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Lua Fun](https://github.com/luafun/luafun)              | High-performance functional programming library designed for LuaJIT.                                                       | 2187  | 2025-04-15  |
| [Penlight](https://github.com/stevedonovan/Penlight)     | Broad, heavyweight utility library, inspired by Python's standard libs. Provides the batteries that Lua doesn't.           | 2011  | 2025-05-19  |
| [Moses](https://github.com/Yonaba/Moses)                 | Functional programming utility belt, inspired by Underscore.js.                                                            | 640   | 2019-12-18  |
| [RxLua](https://github.com/bjornbytes/RxLua)             | Reactive Extensions, Observables, etc.                                                                                     | 529   | 2020-06-21  |
| [lua-stdlib](https://github.com/lua-stdlib/lua-stdlib)   | Middle-weight standard library extension; adds some useful data structures, utility functions, and basic functional stuff. | 297   | 2023-01-01  |
| [Microlight](https://github.com/stevedonovan/Microlight) | A little library of useful Lua functions; the 'extra light' version of Penlight.                                           | 171   | 2022-07-05  |

## Game Development

| Name                                                                                    | Description                                                                                                  | Stars | Last Commit |
|-----------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------|-------|-------------|
| [awesome-love2d](https://github.com/love2d-community/awesome-love2d)                    | A list like this one, but focused on game dev and the LÖVE platform.                                         | 3780  | 2025-03-20  |
| [Journey to the Center of Hawkthorne](https://github.com/hawkthorne/hawkthorne-journey) | 2D platformer based on Community's episode, made with LÖVE.                                                  | 1119  | 2024-11-26  |
| [lume](https://github.com/rxi/lume)                                                     | Utility belt library geared toward game development.                                                         | 1108  | 2023-11-19  |
| [bump.lua](https://github.com/kikito/bump.lua)                                          | Minimal rectangle-based collision detection which handles tunnelling and basic collision resolution.         | 1001  | 2023-09-29  |
| [Mari0](https://github.com/Stabyourself/mari0)                                          | Fusion of Mario and Portal, made with LÖVE. See also its .                                                   | 698   | 2023-09-15  |
| [Jumper](https://github.com/Yonaba/Jumper)                                              | Fast, lightweight, and easy-to-use pathfinding library for grid-based games.                                 | 636   | 2022-10-21  |
| [tween.lua](https://github.com/kikito/tween.lua)                                        | Small library for tweening, with several easing functions.                                                   | 627   | 2023-02-02  |
| [termtris](https://github.com/tylerneylon/termtris)                                     | A tetris clone, written in literate style with "an emphasis on learn-from-ability".                          | 455   | 2019-12-09  |
| [flux](https://github.com/rxi/flux)                                                     | A fast, lightweight tweening library for Lua with easing functions and the ability to group tweens together. | 422   | 2020-12-16  |
| [PacPac](https://github.com/tylerneylon/pacpac)                                         | A Pac-man clone, made with LÖVE.                                                                             | 346   | 2015-06-18  |
| [NoobHub](https://github.com/Overtorment/NoobHub)                                       | Network multiplayer for Corona, LÖVE, and more, following a simple pub-sub model.                            | 340   | 2024-07-16  |
| [lurker](https://github.com/rxi/lurker)                                                 | Shortens the iteration cycle by auto-swapping changed Lua files in a running LÖVE project.                   | 326   | 2023-07-22  |

## Logging

| Name                                                   | Description                                                                                     | Stars | Last Commit |
|--------------------------------------------------------|-------------------------------------------------------------------------------------------------|-------|-------------|
| [LuaLogging](https://github.com/Neopallium/lualogging) | Log4j-inspired logging library supporting various appenders.                                    | 146   | 2021-04-30  |
| [lua-log](https://github.com/moteus/lua-log)           | Asynchronous logging library with pluggable writers for file system, network, ZeroMQ, and more. | 109   | 2018-09-19  |

## Web/Networking Platforms

| Name                                                    | Description                                                                         | Stars | Last Commit |
|---------------------------------------------------------|-------------------------------------------------------------------------------------|-------|-------------|
| [Pegasus.lua](https://github.com/EvandroLG/pegasus.lua) | Pegasus.lua is a http server to work with web applications written in Lua language. | 439   | 2025-02-24  |

## OpenResty

| Name                                                          | Description                                                                                                                                               | Stars | Last Commit |
|---------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [Kong](https://github.com/Kong/kong)                          | Microservice &amp; API Management Layer.<br>Search this page for 'OpenResty' to find related packages under other categories (data stores in particular). | 40921 | 2025-05-29  |
| [awesome-resty](https://github.com/bungle/awesome-resty)      | A list like this one, but focused on OpenResty.                                                                                                           | 2440  | 2024-11-21  |
| [lua-resty-http](https://github.com/pintsized/lua-resty-http) | Lua HTTP client driver, built on the cosocket API.                                                                                                        | 2034  | 2024-06-21  |
| [Sailor](https://github.com/sailorproject/sailor)             |                                                                                                                                                           | 934   | 2022-10-28  |
| [ledge](https://github.com/pintsized/ledge)                   | Lua module providing scriptable, RFC-compliant HTTP cache functionality.                                                                                  | 455   | 2021-05-07  |

## Command-line Utilities

| Name                                                   | Description                                                         | Stars | Last Commit |
|--------------------------------------------------------|---------------------------------------------------------------------|-------|-------------|
| [argparse](https://github.com/mpeterv/argparse)        | A feature-rich command line parser inspired by argparse for Python. | 273   | 2020-11-25  |
| [lua-term](https://github.com/hoelzro/lua-term)        | Terminal operations and manipulations.                              | 163   | 2024-08-24  |
| [ansicolors](https://github.com/kikito/ansicolors.lua) | Simple function for printing to the console in color.               | 142   | 2024-05-25  |
| [cliargs](https://github.com/amireh/lua_cliargs)       | A simple command-line argument parsing module.                      | 126   | 2023-12-18  |

## Concurrency and Multithreading

| Name                                                     | Description                                                                                                                                                                                                                                                                                                               | Stars | Last Commit |
|----------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [lanes](https://github.com/LuaLanes/lanes)               | Library implementing a message passing model with one OS thread per Lua thread.                                                                                                                                                                                                                                           | 490   | 2025-05-22  |
| [ConcurrentLua](https://github.com/lefcha/concurrentlua) | Implements an Erlang-style message-passing concurrency model.                                                                                                                                                                                                                                                             | 160   | 2014-11-22  |
| [Lumen](https://github.com/xopxe/Lumen)                  | Simple concurrent task scheduling.                                                                                                                                                                                                                                                                                        | 156   | 2024-11-03  |
| [llthreads](https://github.com/Neopallium/lua-llthreads) | A simple wrapper for low-level pthreads &amp; WIN32 threads.                                                                                                                                                                                                                                                              | 149   | 2024-10-02  |
| [luaproc](https://github.com/askyrme/luaproc)            | Message-passing model which allows multiple threads per OS thread and easily generalizes across a network. See also where it originated.<br>For more on the differences (particularly between `lanes` and `luaproc`), see this of options; somewhat dated, but covers how each one works and the significant differences. | 122   | 2017-07-29  |
| [llthreads2](https://github.com/moteus/lua-llthreads2)   | Newer rewrite of llthreads.                                                                                                                                                                                                                                                                                               | 79    | 2023-10-16  |

## Templating

| Name                                                               | Description                                                      | Stars | Last Commit |
|--------------------------------------------------------------------|------------------------------------------------------------------|-------|-------------|
| [lua-resty-template](https://github.com/bungle/lua-resty-template) | Lua-oriented template engine for OpenResty, somewhat Jinja-like. | 917   | 2023-07-21  |
| [etlua](https://github.com/leafo/etlua)                            | Embedded Lua templates, ERB-style.                               | 231   | 2023-10-02  |

## Documentation

| Name                                           | Description                                                | Stars | Last Commit |
|------------------------------------------------|------------------------------------------------------------|-------|-------------|
| [docroc](https://github.com/bjornbytes/docroc) | Parse comments into a Lua table to generate documentation. | 14    | 2015-12-25  |

## Object-oriented Programming

| Name                                                 | Description                                                                                       | Stars | Last Commit |
|------------------------------------------------------|---------------------------------------------------------------------------------------------------|-------|-------------|
| [middleclass](https://github.com/kikito/middleclass) | Simple but robust OOP library with inheritance, methods, metamethods, class variables and mixins. | 1829  | 2023-03-05  |
| [30log](https://github.com/Yonaba/30log)             | Minimalist OOP library with basic classes, inheritance, and mixins in 30 lines.                   | 475   | 2021-05-08  |

## File system and OS

| Name                                             | Description                                | Stars | Last Commit |
|--------------------------------------------------|--------------------------------------------|-------|-------------|
| [luaposix](https://github.com/luaposix/luaposix) | Bindings for POSIX APIs, including curses. | 556   | 2025-02-16  |
| [lua-path](https://github.com/moteus/lua-path)   | File system path manipulation library.     | 88    | 2021-01-07  |

## Time and Date

| Name                                           | Description                                                                                              | Stars | Last Commit |
|------------------------------------------------|----------------------------------------------------------------------------------------------------------|-------|-------------|
| [LuaDate](https://github.com/Tieske/date)      | Date and time module with parsing, formatting, addition/subtraction, localization, and ISO 8601 support. | 270   | 2023-09-06  |
| [cron.lua](https://github.com/kikito/cron.lua) | Time-related functions for Lua, inspired by JavaScript's setTimeout and setInterval.                     | 183   | 2023-09-10  |
| [luatx](https://github.com/daurnimator/luatz)  | Time, date, and timezone library.                                                                        | 128   | 2024-02-29  |

## Image Manipulation

| Name                                      | Description                                       | Stars | Last Commit |
|-------------------------------------------|---------------------------------------------------|-------|-------------|
| [magick](https://github.com/leafo/magick) | Lua bindings to ImageMagick for LuaJIT using FFI. | 414   | 2024-05-17  |

## Digital Signal Processing

| Name                                     | Description                                                     | Stars | Last Commit |
|------------------------------------------|-----------------------------------------------------------------|-------|-------------|
| [LuaFFT](https://github.com/h4rm/luafft) | An easy to use Fast Fourier Transformation package in pure Lua. | 60    | 2024-05-04  |

## Parsing and Serialization

| Name                                                          | Description                                                                                      | Stars | Last Commit |
|---------------------------------------------------------------|--------------------------------------------------------------------------------------------------|-------|-------------|
| [json.lua](https://github.com/rxi/json.lua)                   | A fast and tiny JSON library in pure Lua.                                                        | 1989  | 2023-11-28  |
| [lua-cjson](https://github.com/mpx/lua-cjson)                 | Blazing fast JSON encoding/decoding implemented in C and exposed to Lua.                         | 964   | 2024-06-19  |
| [lua-cmsgpack](https://github.com/antirez/lua-cmsgpack)       | A MessagePack C implementation with Lua bindings, as used by Redis.=                             | 368   | 2021-12-28  |
| [lua-pb](https://github.com/Neopallium/lua-pb)                | Protocol Buffers implementation.                                                                 | 291   | 2018-05-31  |
| [LuLPeg](https://github.com/pygy/LuLPeg)                      | A pure Lua implementation of LPeg v0.12.                                                         | 265   | 2022-04-07  |
| [luajson](https://github.com/harningt/luajson)                | JSON encoder/decoder implemented in Lua on top of LPeg.                                          | 253   | 2023-10-10  |
| [lyaml](https://github.com/gvvaughan/lyaml)                   | YAML encoding/decoding via binding to LibYAML.                                                   | 216   | 2023-03-13  |
| [lunamark](https://github.com/jgm/lunamark)                   | Converts Markdown to other textual formats including HTML and LaTeX. Uses LPeg for fast parsing. | 212   | 2024-08-10  |
| [SLAXML](https://github.com/Phrogz/SLAXML)                    | Pure Lua SAX-like streaming XML parser.                                                          | 157   | 2024-07-12  |
| [LPegLabel](https://github.com/sqmedeiros/lpeglabel)          | An extension of LPeg adding support for labeled failures.                                        | 147   | 2023-05-02  |
| [lpeg_patterns](https://github.com/daurnimator/lpeg_patterns) | A collection of LPeg patterns.                                                                   | 126   | 2022-05-23  |
| [LPegLJ](https://github.com/sacek/LPegLJ)                     | A pure LuaJIT implementation of LPeg v1.0.                                                       | 112   | 2022-05-09  |
| [LXSH](https://github.com/xolox/lua-lxsh)                     | A collection of lexers and syntax highlighters written with LPeg.                                | 74    | 2022-11-07  |

## Humanize

| Name                                                 | Description                                                               | Stars | Last Commit |
|------------------------------------------------------|---------------------------------------------------------------------------|-------|-------------|
| [inspect.lua](https://github.com/kikito/inspect.lua) | Human-readable representation of Lua tables.                              | 1443  | 2025-04-29  |
| [serpent](https://github.com/pkulchenko/serpent)     | Serializer and pretty printer.                                            | 588   | 2022-05-21  |
| [i18n.lua](https://github.com/kikito/i18n.lua)       | Internationalization library with locales, formatting, and pluralization. | 261   | 2022-11-10  |
| [Ser](https://github.com/gvx/Ser)                    | Dead simple serializer with good performance.                             | 80    | 2016-05-19  |
| [say](https://github.com/Olivine-Labs/say)           | Simple string key-value store for i18n.                                   | 50    | 2023-08-12  |

## Compression

| Name                                              | Description                                         | Stars | Last Commit |
|---------------------------------------------------|-----------------------------------------------------|-------|-------------|
| [lua-zlib](https://github.com/brimworks/lua-zlib) | Simple streaming interface to zlib for gzip/gunzip. | 279   | 2025-04-20  |
| [lua-zip](https://github.com/brimworks/lua-zip)   | Lua binding to libzip. Reads and writes zip files.  | 84    | 2022-02-03  |

## Cryptography

| Name                                                    | Description                                                                                  | Stars | Last Commit |
|---------------------------------------------------------|----------------------------------------------------------------------------------------------|-------|-------------|
| [lua-lockbox](https://github.com/somesocks/lua-lockbox) | A collection of cryptographic primitives written in pure Lua.                                | 363   | 2024-01-27  |
| [luaossl](https://github.com/wahern/luaossl)            | "Most comprehensive OpenSSL module in the Lua universe" - used by lapis, kong, and lua-http. | 150   | 2024-07-08  |
| [LuaCrypto](https://github.com/mkottman/luacrypto)      | Lua bindings to OpenSSL.                                                                     | 103   | 2019-06-25  |
| [luatweetnacl](https://github.com/philanc/luatweetnacl) | Bindings to tweetnacl, modern high-security cryptographic library.                           | 17    | 2021-11-18  |

## Network

| Name                                                     | Description                                                                                             | Stars | Last Commit |
|----------------------------------------------------------|---------------------------------------------------------------------------------------------------------|-------|-------------|
| [LuaSocket](https://github.com/diegonehab/luasocket)     | Networking extension which provides a socket API for TCP and UDP, and implements HTTP, FTP, and SMTP.   | 1926  | 2025-03-31  |
| [lua-http](https://github.com/daurnimator/lua-http)      | Asynchronous HTTP and WebSocket library with client and server APIs, TLS, and HTTP/2; based on cqueues. | 838   | 2024-09-08  |
| [lua-websockets](https://github.com/lipp/lua-websockets) | WebSocket client and server modules. Webserver-agnostic, implemented in Lua on top of LuaSocket.        | 410   | 2022-11-14  |
| [lua-cURLv3](https://github.com/Lua-cURL/Lua-cURLv3)     | Lua binding to libcurl.                                                                                 | 287   | 2023-07-03  |

## Data Stores

| Name                                                                 | Description                                                                      | Stars | Last Commit |
|----------------------------------------------------------------------|----------------------------------------------------------------------------------|-------|-------------|
| [lua-resty-redis](https://github.com/openresty/lua-resty-redis)      | Lua Redis client driver for OpenResty.                                           | 1929  | 2025-04-16  |
| [redis-lua](https://github.com/nrk/redis-lua)                        | Pure Lua client library for Redis.                                               | 741   | 2023-11-06  |
| [lua-resty-mysql](https://github.com/openresty/lua-resty-mysql)      | Lua MySQL driver for OpenResty.                                                  | 713   | 2025-05-08  |
| [pgmoon](https://github.com/leafo/pgmoon)                            | Lua PostgreSQL driver for OpenResty, LuaSocket, and cqueues.                     | 404   | 2023-09-06  |
| [lua-resty-cassandra](https://github.com/jbochi/lua-resty-cassandra) | Lua Cassandra client driver for OpenResty and others.                            | 68    | 2017-06-09  |
| [lredis](https://github.com/daurnimator/lredis)                      | Asynchronous Redis client with pipelining and Pub/Sub support; based on cqueues. | 42    | 2021-02-15  |

## Message Brokers

| Name                                                                          | Description                                           | Stars | Last Commit |
|-------------------------------------------------------------------------------|-------------------------------------------------------|-------|-------------|
| [lua-resty-kafka](https://github.com/doujiang24/lua-resty-kafka)              | Kafka client driver based on OpenResty cosockets.     | 809   | 2023-11-03  |
| [lua-resty-rabbitmqstomp](https://github.com/wingify/lua-resty-rabbitmqstomp) | RabbitMQ client library based on OpenResty cosockets. | 193   | 2020-04-27  |
| [lua-zmq](https://github.com/Neopallium/lua-zmq)                              | Lua bindings to ZeroMQ.                               | 155   | 2024-10-03  |
| [lzmq](https://github.com/zeromq/lzmq)                                        | A newer Lua binding to ZeroMQ.                        | 140   | 2020-07-20  |

## Testing

| Name                                                 | Description                                            | Stars | Last Commit |
|------------------------------------------------------|--------------------------------------------------------|-------|-------------|
| [luassert](https://github.com/Olivine-Labs/luassert) | Assertion library extending Lua's built-in assertions. | 224   | 2024-11-07  |
| [telescope](https://github.com/norman/telescope)     | Flexible and highly customizable testing library.      | 163   | 2017-08-05  |
| [lust](https://github.com/bjornbytes/lust)           | Minimal test framework.                                | 120   | 2024-10-03  |

## Foreign Function Interfaces

| Name                                           | Description                                                       | Stars | Last Commit |
|------------------------------------------------|-------------------------------------------------------------------|-------|-------------|
| [luaffi](https://github.com/jmckaskill/luaffi) | Standalone FFI library, compatible with the LuaJIT FFI interface. | 474   | 2020-12-19  |

## Analysis Tools and ASTs

| Name                                                           | Description                                                                                                                 | Stars | Last Commit |
|----------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [luacheck](https://github.com/mpeterv/luacheck)                | Simple static analyzer which detects accidental globals and undefined or shadowed locals.                                   | 1958  | 2022-12-18  |
| [Typed Lua](https://github.com/andremm/typedlua)               | A typed superset of Lua that compiles to plain Lua.                                                                         | 577   | 2020-03-11  |
| [Metalua](https://github.com/fab13n/metalua)                   | Pure Lua parser and compiler, used for generating ASTs. A number of other tools make use of the Metalua parser in this way. | 355   | 2024-01-16  |
| [luadec51](https://github.com/sztupy/luadec51)                 | Lua Decompiler for Lua version 5.1.                                                                                         | 332   | 2022-03-14  |
| [LuaMinify](https://github.com/stravant/LuaMinify)             | Minifier which also brings its own static analysis tools, lexer, and parser.                                                | 261   | 2022-11-05  |
| [lua-parser](https://github.com/andremm/lua-parser)            | A Lua 5.3 parser written using LPegLabel, with improved error messages.                                                     | 205   | 2025-03-11  |
| [LuaInspect](https://github.com/davidm/lua-inspect)            | Lua's most powerful code analysis and linting tool, built on Metalua. Used by ZeroBraneStudio, among others.                | 174   | 2016-04-22  |
| [luacov-coveralls](https://github.com/moteus/luacov-coveralls) | LuaCov reporter for coveralls.io.                                                                                           | 49    | 2022-04-06  |

## Experimental, etc

| Name                                                          | Description                                                                      | Stars | Last Commit |
|---------------------------------------------------------------|----------------------------------------------------------------------------------|-------|-------------|
| [luvit](https://github.com/luvit/luvit)                       | Node.js's underlying architecture (libUV) with Lua on top instead of JavaScript. | 3890  | 2025-01-16  |
| [graphql-lua](https://github.com/bjornbytes/graphql-lua)      | Lua implementation of .                                                          | 189   | 2023-03-13  |
| [punchdrunk.js](https://github.com/TannerRogalsky/punchdrunk) | Moonshine + LÖVE API reimplementation = run LÖVE games in the browser.           | 81    | 2016-02-07  |

## Scriptable by Lua

| Name                                             | Description                                                                                                                       | Stars | Last Commit |
|--------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------|-------|-------------|
| [KoReader](https://github.com/koreader/koreader) | An ebook reader application supports PDF, DJVU, EPUB, FB2 and much more, running on Kindle, Kobo, PocketBook and Android devices. | 21709 | 2025-05-29  |
| [kpie](https://github.com/skx/kpie)              | A scripting utility to juggle windows.                                                                                            | 80    | 2020-12-21  |

## Style Guides

| Name                                                                   | Description                                                          | Stars | Last Commit |
|------------------------------------------------------------------------|----------------------------------------------------------------------|-------|-------------|
| [Olivine style guide](https://github.com/Olivine-Labs/lua-style-guide) | A more opinionated and specific, and therefore more rigorous, guide. | 535   | 2021-08-29  |

## Tutorials

| Name                                                   | Description                                                                                      | Stars | Last Commit |
|--------------------------------------------------------|--------------------------------------------------------------------------------------------------|-------|-------------|
| [Lua Missions](https://github.com/kikito/lua_missions) | A series of 'Missions' to work through which are designed to teach aspects of Lua along the way. | 389   | 2024-06-08  |

## Other Lists

| Name                                                                 | Description                                                          | Stars | Last Commit |
|----------------------------------------------------------------------|----------------------------------------------------------------------|-------|-------------|
| [awesome-love2d](https://github.com/love2d-community/awesome-love2d) | A list like this one, but focused on game dev and the LÖVE platform. | 3780  | 2025-03-20  |
| [awesome-resty](https://github.com/bungle/awesome-resty)             | A list like this one, but focused on OpenResty.                      | 2440  | 2024-11-21  |
