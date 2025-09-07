# awesome-love2d

A curated list of amazingly awesome LÖVE libraries, resources and shiny things.

## Serialization

- [arson](https://github.com/flamendless/arson.lua) - Companion library for registering custom data types that can be encoded and decoded by json.lua.
- [binser](https://github.com/bakpakin/binser) - Customizable Lua Serializer.
- [bitser](https://github.com/gvx/bitser) - Serializes and deserializes Lua values with LuaJIT.
- [cdata](https://github.com/excessive/cdata) - Serialize between Lua data and C data using LuaJIT's FFI.
- [Lady](https://github.com/gvx/Lady) - Saving and loading savegames; based on Ser.
- [moonblob](https://github.com/megagrump/moonblob) - Binary serialization and data parsing library.
- [Ser](https://github.com/gvx/Ser) - Fast, robust, richly-featured table serialization library for Lua.
- [Smallfolk](https://github.com/gvx/Smallfolk) - A fast, robust, secure, richly-featured table serialization library for Lua.
- [trickle](https://github.com/bjornbytes/trickle) - A bitstream library focused on high compression for use in networking.

## Drawing

- [Artal](https://github.com/unXedDani/Artal) - A .PSD parsing library for LÖVE.
- [Autobatch](https://github.com/rxi/autobatch) - Small LÖVE module to automate the use of SpriteBatches.
- [center](https://github.com/S-Walrus/center) - A simple module to dynamically align and fit content to screens of any size.
- [deep](https://github.com/Nikaoto/deep) - Adds Z axis; allows you to queue actions and draw calls.
- [draft](https://github.com/pelevesque/draft) - A module for drawing complex shapes.
- [Hot particles](https://github.com/ReFreezed/HotParticles) - "Hot Particles is a particle editor for the LÖVE game framework."
- [HSLUV](https://github.com/hsluv/hsluv-lua) - Lua implementation of HSLuv (a human-friendly alternative to HSL).
- [Maid64](https://github.com/adekto/maid64) - Low resolution scaler for LÖVE.
- [Push](https://github.com/Ulydev/push) - A simple resolution-handling library for LÖVE.
- [renderplanet](https://github.com/meric/renderplanet) - Realistic orthographic planet rendering.
- [Resolution Solution](https://github.com/grif-on/love2d_resolution_solution) - Scale library, that help you add resolution support to your games!
- [Shöve](https://github.com/Oval-Tutu/shove) - A powerful resolution-handler and rendering library for LÖVE.
- [svglover](https://github.com/globalcitizen/svglover) - Library to import and display simple SVGs in LÖVE.
- [SYSL-Pixel](https://github.com/SystemLogoff/Sysl-Pixel) - Pixel art focused scaler for graphics, position, screen-captures and shaders.
- [Sölar](https://github.com/JanWerder/soelar) - A fairly simple solar system simulator.
- [Tove2d](https://github.com/poke1024/tove2d) - Animated vector graphics for LÖVE.
- [turtle.lua](https://github.com/arthurealike/turtle.lua) - Turtle graphics library for LÖVE.
- [Runtime-TextureAtlas](https://github.com/EngineerSmith/Runtime-TextureAtlas) - Texture atlas packer and renderer at runtime; no external tools.
- [Export-TextureAtlas](https://github.com/EngineerSmith/Export-TextureAtlas) - Extends Runtime-TextureAtlas as a commandline tool to export an atlas.

## Performance

- [AppleCake](https://github.com/EngineerSmith/AppleCake) - Profiling library for LÖVE, with detailed profiling and thread support.
- [jprof](https://github.com/pfirsich/jprof) - Profiling library/tool for LÖVE.
- [Piefiller](https://github.com/Polynominal/Piefiller) - Graphical profiler for LÖVE.

## Distribution

- [lover](https://github.com/Wolfyxon/lover) - Bringing the joys of rust's package manager (`Cargo`) to love.
- [love-packager](https://github.com/simplifylabs/love-packager) - Simple CLI to package your LÖVE Game in seconds.
- [boon](https://github.com/camchenry/boon) - Multi-platform, easy to use tool supporting Windows, macOS, Linux.
- [LÖVE Game Development & Automated Build System](https://github.com/Oval-Tutu/bootstrap-love2d-project) - Preconfigured VSCode/Codium. Build for Android, iOS, HTML5, Linux, macOS and Windows and automatically publish to Itch.io.
- [love-export](https://github.com/dmoa/love-export) - Fast and simple command-line tool that builds binaries for you. Supports Windows, macOS, and Linux.
- [love-release](https://github.com/MisterDA/love-release) - A Lua script that automates game distribution. Supports Windows, macOS, Debian, Linux.
- [lovesfx](https://github.com/tpimh/lovesfx) - Packs love games in a single file for windows.
- [makelove](https://github.com/pfirsich/makelove) - Advanced multi-platform tool to fuse your game written in Python 3. Supports Windows and Linux with AppImage.
- [love-build](https://github.com/ellraiser/love-build) - Downloadable application (made in LÖVE!) that can build games for Windows, macOS, and Linux regardless of your own OS.
- [love-deploy](https://github.com/tducasse/love-deploy) - Build and deploy games on itch.io (supports windows and web exports).
- [love-fuser](https://github.com/MikuAuahDark/love-fuser) - Packages LÖVE Games using GitHub Actions. Supports Windows, Linux, and Android.

## Physics

- [breezefield](https://github.com/HDictus/breezefield) - A lightweight and easy love.physics wrapper (windfield alternative).
- [Bump](https://github.com/kikito/bump.lua) - Collision detection library for Lua.
- [loveblobs](https://github.com/exezin/loveblobs) - A softbody library with support for both dynamic and static arbitrary softbodies.
- [slick](https://github.com/erinmaus/slick) - A simple to use polygon collision library inspired by bump.lua.
- [Strike](https://github.com/Aweptimum/Strike) - 2D collision detection library. Extendable, based on Separating-Axis-Theorem.

## Networking

- [LoverNet](https://github.com/josefnpat/LoverNet) - A networking library that leverages bitser and enet. (IPv4)
- [NoobHub](https://github.com/Overtorment/NoobHub) - OpenSource multiplayer and network messaging. (IPv6)
- [Sock.lua](https://github.com/camchenry/sock.lua) - A Lua networking library for LÖVE games. (IPv4)
- [löve-ws](https://github.com/holywyvern/love-ws) - A websocket client and server library.
- [love2d-lua-websocket](https://github.com/flaribbit/love2d-lua-websocket) - A simple event-driven websocket client library. (IPv4)
- [fetch-lua](https://github.com/elloramir/fetch-lua) - An HTTPS/HTTP requests library made only with luajjit.

## Lighting

- [bitumbra](https://github.com/a13X-B/bitumbra) - GPU accelerated many lights 2D shadows.
- [lighter](https://github.com/speakk/lighter) - A performant dynamic light implementation with a simple API.
- [Shädows](https://github.com/matiasah/shadows) - A Shadows & Lights engine for LÖVE.
- [Light World](https://github.com/tanema/light_world.lua) - A lighting model.
- [Simple Love Lights](https://github.com/dylhunn/simple-love-lights) - A very simple raycasting light implementation.
- [Light](https://github.com/xiejiangzhi/light) - A simple dynamic light implementation.

## UI

- [CatUI](https://github.com/wilhantian/catui) - A very light-weight GUI library for LÖVE.
- [GOOi](https://github.com/tavuntu/gooi) - Android-oriented GUI library.
- [Helium](https://github.com/qeffects/helium) - A modern, customizable, high performance retained UI framework.
- [Layouter](https://github.com/nekromoff/layouter) - A simple UI **grid layout** library for LÖVE 2D game engine.
- [ListBox](https://github.com/darkmetalic/ListBox) - A dynamic ListBox for LÖVE that supports touch, mouse, and keyboard inputs.
- [LoveFrames Fork](https://github.com/linux-man/LoveFrames) - 11.2 Fork of a GUI library.
- [Love Imgui](https://github.com/slages/love-imgui) - Imgui module for the LÖVE game engine.
- [Löve-Nuklear](https://github.com/keharriso/love-nuklear) - Lightweight immediate mode GUI for LÖVE games.
- [lovr-ui2d](https://github.com/immortalx74/lovr-ui2d) - An immediate mode GUI library for LÖVR and LÖVE.
- [Luis](https://github.com/SiENcE/luis) - LUIS (Love UI System) - A retained Mode UI Framework for LÖVE with Input processing (mouse, keyboard, touch, gamepad),  Layer-, Grid-, State-, Theming-system, UI Editor, 16+ Widgets (for Desktop & Mobile).
- [NLay](https://github.com/MikuAuahDark/NPad93) - Flexible layouting library.
- [Patchy](https://github.com/excessive/patchy) - 9patch library.
- [Slicy](https://github.com/wqferr/slicy) - A newer 9patch/9slice library fixing some issues with Patchy.
- [Plan](https://github.com/zombrodo/plan) - A super simple Rule-based layout library.
- [SafeWord](https://github.com/josefnpat/safeword) - An overscan detection library for LÖVE.
- [Slab](https://github.com/flamendless/Slab) - Slab is an immediate mode GUI toolkit for the LÖVE framework.
- [SUIT](https://github.com/vrld/SUIT) - Small immediate mode GUI library.
- [TuxRedux](https://github.com/KINGTUT10101/TuxRedux) - An immediate-mode UI system for LOVE2D inspired by SUIT.
- [YALG](https://github.com/sasszem/yalg) - A very simple, cross-platform, reactive UI for last minute UIs.
- [Inky](https://github.com/Keyslam/Inky) - Any-purpose GUI framework.
- [Badar 🌕](https://github.com/Nabeel20/Badar) - Simple **custom UI syntax** for easy components compositions.
- [MeowUI](https://github.com/MoonGameLab/MeowUI) - Extensible library written in MoonScript that enables you to create your own GUI controls based on provided core modules for Löve2D.

## Music

- [denver](https://github.com/superzazu/denver.lua) - A Löve custom waveform generation library.
- [lovebpm](https://github.com/rxi/lovebpm) - A LÖVE library for syncing events to the BPM of an audio track.
- [ripple](https://github.com/tesselode/ripple) - An audio manager with tagging support.
- [wave](https://github.com/Ulydev/wave) - A sound manager with audio parsing and rhythm functionalities.

## Utilities

- [andromeda](https://github.com/itzKiwiSky/Andromeda) - Asset database and loader for love.
- [bar128-love](https://github.com/Nawias/bar128-love) - Barcode rendering library for LÖVE.
- [cargo](https://github.com/bjornbytes/cargo) - Asset manager.
- [colorchanger](https://github.com/santoslove/colorchanger) - Change the colors in your LÖVE game.
- [Flirt](https://github.com/Alloyed/flirt) - LÖVE version manager; allows to switch between multiple versions of engine on same machine.
- [GifCat](https://github.com/WetDesertRock/GifCat) - A simple module for saving gifs from LÖVE.
- [hex2color](https://github.com/S-Walrus/hex2color) - A single function to use HEX color values.
- [i18n](https://github.com/excessive/i18n) - Internationalization library designed to help localize your game.
- [Ini Parser](https://github.com/FivosM/ini_parser) - General purpose ini configuration parser.
- [KeyedArray](https://github.com/KINGTUT10101/KeyedArray) - A special data structure where items can be found by their position or key. Similar to an ordered dictionary.
- [log.lua](https://github.com/rxi/log.lua) - Library for configurable log output.
- [love-loader](https://github.com/kikito/love-loader) - Threaded resource loading.
- [love-qrcode](https://github.com/Nawias/love-qrcode) - QR Code rendering library for LÖVE.
- [love2d-assets-loader](https://github.com/Yonaba/love2d-assets-loader) - Assets Loader.
- [love-pe](https://github.com/RamiLego4Game/love-pe) - A tool made in LÖVE for changing LÖVE icon itself.
- [lovely-engine](https://github.com/vinnyhorgan/lovely-engine) - A tool that makes setting up and using LÖVE easier and with Moonscript support.
- [Lily](https://github.com/MikuAuahDark/lily) - Async Asset Loader.
- [LuaRequireExtended](https://github.com/KINGTUT10101/LuaRequireExtended) - A Lua module that lets you require files with input parameters and multiple output values.
- [luasteam](https://github.com/uspgamedev/luasteam) - Lua bindings for the Steamworks API.
- [Luvent](https://github.com/ejmr/Luvent) - Simple event-driven programming.
- [nativefs](https://github.com/EngineerSmith/nativefs) - Read and write files outside of LÖVE's allowed paths.
- [ParticleEditor](https://github.com/MusouCrow/ParticleEditor) - An editor of particle for LÖVE.
- [particle-system-playground](https://github.com/santoslove/particle-system-playground) - A basic LÖVE particle system editor.
- [require.lua](https://github.com/premek/require.lua) - Require all files in a folder.
- [smiti18n](https://github.com/Oval-Tutu/smiti18n) - A very complete internationalization library for Lua with LÖVE support.
- [splashy](https://github.com/videah/splashy) - Splash Screen Library.
- [ShakeDetectorLua](https://github.com/azoyan/ShakeDetectorLua) - Uses accelerometer data for shake device detection written in Lua.
- [tick](https://github.com/bjornbytes/tick) - Useful timing tweaks for LÖVE's run loop.
- [servelove](https://github.com/YellowButShort/servelove) - A web server library that runs on love.

## Publishing

- [Love-Snap-Template](https://github.com/popey/love-snap-template) - A template for packaging LÖVE games for distribution in the Snappy Store.
- [AppImageKit](https://github.com/AppImage/AppImageKit) - Using AppImageKit you can package LÖVE games as AppImages that run on common Linux-based operating systems, such as RHEL, CentOS, Ubuntu, Fedora, debian and derivatives; one game = one file.

## Platforms

- [LoveDos](https://github.com/rxi/lovedos) - A Lua framework for 2D DOS games, implementing a subset of the LÖVE API.
- [LÖVE Potion](https://github.com/lovebrew/lovepotion) - Unofficial implementation of the LÖVE for Nintendo (3DS, Switch and Wii U) Homebrew.
- [LOVE-WrapLua](https://github.com/LukeZGD/LOVE-WrapLua) - A small and simple wrapper for OneLua, lpp-vita, and Lua Player PS3.
- [Love.js](https://github.com/Davidobot/love.js) - LÖVE ported to the web using Emscripten.
- [LÖVR](https://github.com/bjornbytes/lovr) - LÖVE for virtual reality devices.

## Animation

- [andross](https://github.com/pfirsich/andross) - A Lua library for 2D skeletal/bone animations with a Löve backend.
- [anim8](https://github.com/kikito/anim8) - Animation library.
- [animx](https://github.com/YoungNeer/animx) - A featureful Animation library for loading animations from XML files!.
- [Aseprite loader](https://github.com/elloramir/love-ase) - Complete ase/aseprite file loader (no json).
- [chiro](https://github.com/bjornbytes/chiro) - Convenience wrapper around [Spine](http://esotericsoftware.com).
- [Peachy](https://github.com/josh-perry/peachy) - A parser/renderer for Aseprite animations in LÖVE.
- [skeletor](https://github.com/pelevesque/skeletor) - 2D skeletal animation system.
- [Walt](https://github.com/davisdude/Walt) - Animation library.
- [Lump](https://github.com/sixFingers/lump) - Adobe Flash animation runtime.
- [lovanim](https://github.com/patrixr/love-animation) - A minimal stateful animation library.
- [SYSL-Text](https://github.com/SystemLogoff/SYSL-Text) - Text animation and automatic wrapping library based on tags.

## AI

- [Jumper](https://github.com/Yonaba/Jumper) - Grid-based pathfinding library.
- [Lua-star](https://github.com/wesleywerner/lua-star) - Easy and pure Lua A* path finding.
- [astar](https://github.com/xiejiangzhi/astar) - An other A* library. Any map (grid, point, mesh or infinite map) and support path cost.
- [beehive.lua](https://github.com/drhayes/beehive.lua) - A functional behavior tree implementation.
- [Luafinding](https://github.com/GlorifiedPig/Luafinding) - Class-based A* implementation written purely in Lua.
- [LÖVElyTrees](https://github.com/Nrosa01/LOVElyTrees) - Fully featured behaviour tree implementation with tree rendering.

## 3D

- [3DreamEngine](https://github.com/3dreamengine/3DreamEngine) - An awesome 3D engine for LÖVE.
- [anim9](https://github.com/excessive/anim9) - 3D skeletal animation library (design to be used with IQM and IQE).
- [Brinevector3D](https://github.com/flamendless/brinevector3D) - FFI-enabled vector library for 3D (x,y,z).
- [bump-3dpd](https://github.com/oniietzschan/bump-3dpd) - A 3D collision detection library for Lua.
- [IQE](https://github.com/excessive/iqe) - Inter-Quake Export loader (text).
- [IQM](https://github.com/excessive/iqm-exm) - Inter-Quake Model loader (binary).
- [Lovox](https://github.com/tjakka5/Lovox) - Pseudo-3D library for working with voxels.
- [g3d](https://github.com/groverburger/g3d) - Simple and easy 3D engine for LÖVE.
- [Menori](https://github.com/rozenmad/Menori) - Library for 3D rendering with LÖVE.

## Testing

- [busted](https://github.com/Olivine-Labs/busted) - Simple unit-testing framework with customizable assertions.
- [Luassert](https://github.com/Olivine-Labs/luassert) - Extends `assert()` with additional, customizable tests.
- [Lunatest](https://github.com/silentbicycle/lunatest) - xUnit-style randomized unit testing framework.
- [lust](https://github.com/bjornbytes/lust) - Minimal test framework.

## Math

- [Bresenham](https://github.com/rm-code/Bresenham) - Bresenham's line algorithm written in Lua.
- [brinevector](https://github.com/novemberisms/brinevector) - Standalone lightweight luajit ffi-accelerated 2D vector library for great performance.
- [Cirno's Perfect Math Library](https://github.com/excessive/cpml) - Math/intersection library designed for games.
- [delaunay](https://github.com/Yonaba/delaunay) - Delaunay triangulation for convex polygons.
- [loaded_dice](https://github.com/a13X-B/loaded_dice) - Walker-Vose alias method implementation (loaded dice-like RNG) useful for rolling loot tables, etc.
- [MLib](https://github.com/davisdude/mlib) - Math and shape-intersection detection library written in Lua. It's aim is to be robust and easy to use.
- [shash](https://github.com/rxi/shash) - A simple, lightweight spatial hash for Lua.
- [vector.lua](https://github.com/themousery/vector.lua) - A simple vector library based on the PVector class from processing.
- [Vornmath](https://github.com/DUznanski/vornmath) - The most comprehensive small vector & matrix, complex number, and quaternion library for Lua.
- [polysec](https://github.com/dknight/polysec) - A performant and lightweight library to detect polygon and rectangle intersections.

## OO

- [30log](https://github.com/Yonaba/30log) - Minified framework for object-orientation in Lua. It features named (and unnamed) classes, single inheritance and a basic support for mixins.
- [classic](https://github.com/rxi/classic) - Tiny class module for Lua. Attempts to stay simple and provide decent performance by avoiding unnecessary over-abstraction.
- [middleclass](https://github.com/kikito/middleclass) - Simple OOP library for Lua; has inheritance, metamethods (operators), class variables and weak mixin support (class-commons).
- [muun](https://github.com/megagrump/muun) - Moonscript compatible class implementation.
- [selene](https://github.com/novafacing/selene) - Project template for writing games in Moonscript instead of Lua without precompiling.
- [Object-Library](https://github.com/Virus01Official/Object-Library) - ObjectLibrary is a simple library for the LÖVE2D game engine that allows users to create objects with collision detection and optional textures.
- [LowerClass](https://github.com/DevonPalma/LowerClass) - A MiddleClass Inspired library with extended features.

## Entity

- [adorbs](https://github.com/JosephShering/adorbs) - Minimal, Functional Entity Component System.
- [Concord](https://github.com/Tjakka5/Concord) - A feature-complete ECS library.
- [ecs-lua](https://github.com/nidorx/ecs-lua) - ECS Lua is a fast and easy to use ECS (Entity Component System) engine for game development.
- [evolved.lua](https://github.com/BlackMATov/evolved.lua) - Evolved ECS (Entity-Component-System) for Lua.
- [nata](https://github.com/tesselode/nata) - Hybrid OOP/ECS entity management.
- [tiny-ecs](https://github.com/bakpakin/tiny-ecs) - Entity Component System for Lua that's simple, flexible, and useful.

## Development

- [FPSGraph](https://github.com/icrawler/FPSGraph) - Small FPS graphing utility.
- [debugGraph](https://github.com/Mechazawa/Love-Debug-Graph) - Small OO FPS graphing utillity based on FPSGraph.
- [Lovebird](https://github.com/rxi/lovebird) - Browser-based debug console.
- [LoveDebug](https://github.com/flamendless/lovedebug) - Inline console-like debugger utility.
- [lurker](https://github.com/rxi/lurker) - Auto-swaps changed Lua files in a running game.
- [LÖVE API](https://github.com/love2d-community/love-api) - The complete API documentation of LÖVE in a Lua table.
- [LÖVE Build](https://github.com/nhartland/love-build) - GitHub Action for automated cross-platform builds.
- [LÖVE TypeScript Definitions](https://github.com/hazzard993/love-typescript-definitions) - Write LÖVE games with TypeScript.
- [lovelier](https://github.com/patrixr/lovelier) - A LÖVE live reloader with Moonscript support.
- [loveprofiler](https://github.com/dknight/loveprofiler) - LoveProfiler is an extremely simple logger and profiler.
- [vudu](https://github.com/deltadaedalus/vudu) - Broad in-game debugging gui with a console, variable browser/editor, speed controls, and more.

## Related

- [awesome-lua](https://github.com/LewisJEllis/awesome-lua) - A list like this one, but more general and encompassing all of Lua's uses.
- [awesome-love-shaders](https://github.com/karai17/awesome-love-shaders) - A collection of shaders designed to work in LÖVE.
- [awesome-pico8](https://github.com/pico-8/awesome-PICO-8) - A curated list of PICO-8 resources, tutorials, tools and more. Other awesome lists can be found in the [awesome-awesomeness](https://github.com/bayandin/awesome-awesomeness) list.

## IDEs

- [Lua Syntax Highlighter](https://github.com/ForbesLindesay/brackets-language-extensions) - Add Lua syntax highlighting in Brackets.
- [Run LÖVE](https://github.com/instilledbee/run-love2d) - Run LÖVE projects with a hotkey.
- [API Syntax Hightlight](https://github.com/flamendless/LOVE-API-Extractor-for-ZeroBraneStudio) - Script to add LOVE API syntax highlighting to ZBS.
- [EmmyLua](https://github.com/EmmyLua/VSCode-EmmyLua) - Lua IDE/Debugger Plugin for VSCode.
- [LÖVE IDEA](https://github.com/rm-code/love-IDEA-plugin) - Snippets and code completion for IntelliJ-IDEA.
- [Vim LOVE Docs](https://github.com/davisdude/vim-love-docs) - Syntax highlighting for Vim.
- [LÖVE API for Notepad++](https://github.com/dail8859/love-api-npp) - Code completion and documentation for Notepad++.
- [autocomplete-love](https://github.com/rameshvarun/autocomplete-love) - Auto-complete and snippets for LÖVE.
- [love-ide](https://github.com/rameshvarun/love-ide) - Auto-installs several utilities for writing Love2D games in Pulsar.
- [language-lua](https://github.com/FireZenk/language-lua) - Add syntax highlighting and snippets to lua files.
- [atom-autocomplete-lua](https://github.com/dapetcu21/atom-autocomplete-lua) - Autocomplete for Lua.
- [love2z](https://github.com/alejandro-alzate/love2z) - Alejandro's Beta typing hints for Zed.
- [love2d](https://github.com/LuaCATS/love2d) - LuaCATS typing hints for the lua language server.

## Shaders

- [LoveShaderConverter](https://github.com/tsteinholz/LoveShaderConverter) - Convert Shadertoy Shader files to LÖVE GLSL Files with handy utilities for infinite purposes.
- [Moonshine](https://github.com/vrld/moonshine) - Repository of common post-processing effects like blur, vignette, color-grading, etc.
- [ShaderScan](https://github.com/idbrii/love-shaderscan) - Adds hot reload, includes, and better error messages for faster shader iteration.

## Input

- [baton](https://github.com/tesselode/baton) - Input library for LÖVE that bridges the gap between keyboard and gamepad controls.
- [GamepadGuesser](https://github.com/idbrii/love-gamepadguesser) - Get the right button icons for gamepads; load updated gamepad db.
- [input](https://github.com/xiejiangzhi/input) - Simple and powerful input library. support check operation time, sequence.
- [Kazari](https://github.com/MikuAuahDark/Kazari) - Multitouch gesture and input library.
- [love-microphone](https://github.com/LPGhatguy/love-microphone) - Simple microphone support for LÖVE.
- [LoveKeys](https://github.com/SpaceCat-Chan/LoveKeys) - A simple input handeling library that keeps track of things for you.
- [Swipe](https://github.com/zombrodo/swipe) - A simple radial keyboard library.
- [tactile](https://github.com/tesselode/tactile) - A straightforward and flexible input library.

## Camera

- [Brady](https://github.com/davisdude/Brady) - Camera library with parallax scrolling.
- [Editgrid](https://github.com/bakpakin/Editgrid) - Gamera and HUMP compatible scaling grid.
- [gamera](https://github.com/kikito/gamera) - Camera system.
- [parallax](https://github.com/idbrii/love-parallax) - Parallax scrolling with any camera system; seamlessly tile background images.

## Tweening

- [Flux](https://github.com/rxi/flux) - A fast, lightweight tweening library for Lua.
- [tick](https://github.com/rxi/tick) - Lua module for delaying function calls.
- [tween.lua](https://github.com/kikito/tween.lua) - Tweening/Easing/Interpolating functions for Lua inspired on jQuery's animate method.

## Helpers

- [astray](https://github.com/SiENcE/astray) - Astray is a lua based maze, room and dungeon generation library for dungeon crawlers and roguelike video games.
- [batteries](https://github.com/1bardesign/batteries) - Fills out lua's sparse standard library and provides implementations of common algorithms and data structures useful for games.
- [cartographer](https://github.com/tesselode/cartographer) - Small Tiled map loader and drawer.
- [clove](https://github.com/YoungNeer/clove) - A helper library which allows you to quickly loads huge amount of assets.
- [hump](https://github.com/HDictus/hump) - Collection of tools for developing games with LÖVE (Gamestates, Timers/Tweens, Vectors, Classes, Signals, Cameras).
- [iffy](https://github.com/YoungNeer/iffy) - A SpriteSheet and Tileset helper library for LÖVE.
- [knife](https://github.com/airstruck/knife) - Collection of useful micro-modules for Lua (Class, State Machines, Bind, Chain, Coroutines, Event, Memoize, Entity, Tests, Timer).
- [shard](https://github.com/MineGame159/shard) - Collection of useful mini modules.
- [lovely-windows](https://github.com/flamendless/lovely-windows) - A Window/Screen Manager Module for virtual windows.
- [love-state-switcher](https://github.com/nekromoff/love-state-switcher) - State switcher class for Lua LÖVE Engine.
- [lua-state-machine](https://github.com/kyleconroy/lua-state-machine) - Lua Finite State Machine.
- [lue](https://github.com/Ulydev/lue) - Lue is a LÖVE library that allows you to display hue color effects in your game.
- [lume](https://github.com/rxi/lume) - Collection of functions for Lua, geared towards game development.
- [narrator](https://github.com/astrochili/narrator) - An Ink narrative scripting language parser and runtime implementation.
- [reflowprint](https://github.com/josefnpat/reflowprint) - A library designed for alignment of text that is shown one character at a time.
- [roomy](https://github.com/tesselode/roomy) - Screen management library for LÖVE.
- [rotLove](https://github.com/paulofmandown/rotLove) - Roguelike Toolkit in LÖVE. A LÖVE/lua port of rot.js.
- [YAS](https://github.com/kithf/yas) - Yet Another Screen manager.
- [SceneMan](https://github.com/KINGTUT10101/SceneMan) - A simple, but powerful scene/gamestate manager that uses a stack, allowing you to run multiple scenes at once.
- [Scenery](https://github.com/paltze/scenery) - A dead simple scene/state management system.
- [ScreenManager](https://github.com/rm-code/screenmanager) - Screen/State Management for the LÖVE framework.
- [shack](https://github.com/Ulydev/shack) - Shack is a LÖVE library that lets you easily add screen effects such as shake and rotation.
- [Simple Tiled Implementation](https://github.com/karai17/Simple-Tiled-Implementation) - Tiled map loader and renderer.
- [Vivid](https://github.com/WetDesertRock/vivid) - Color math, manipulation and conversion library.
- [Yonder](https://github.com/thenerdie/Yonder) - A ridiculously easy to use game state management library for LOVE2D.
- [GameStateManager](https://github.com/GwyrddGlas/GameStateManager) - A lightweight, optimized, and easy-to-implement solution for efficient game state management.
- [Love dialogue](https://github.com/Miisan-png/Love-Dialogue) - Simple to use Dialogue Library for Love2d with custom scripting language for dialogues .
