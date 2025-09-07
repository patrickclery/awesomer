# awesome-dos

Curated list of references for development of DOS applications.

## Source code

- [Catacomb](https://github.com/CatacombGames/Catacomb) - 2D top-down shooter developed by Softdisk (later becoming id Software). Supports EGA and CGA graphics. Written in Turbo Pascal and assembly.
- [Catacomb 3D](https://github.com/CatacombGames/Catacomb3D) - First-person shooter in fantasy setting developed by Softdisk (later becoming id Software). Features pseudo-3D graphics with raycasting technique. Supports EGA graphics. Written in C and assembly. Compiled with Borland C++ 3.1.
- [Commander Keen in Keen Dreams](https://github.com/keendreams/keen) - Side-scrolling platform game developed by id Software. Keen Dreams is the Commander Keen game created between Keen 3 and Keen 4 (often considered "Keen 3.5"), but was not widely released. Written in C and assembly.
- [Descent](https://github.com/videogamepreservation/descent) - First sci-fi FPS/space shooter to feature entirely true 3D graphics. Written in C and assembly.
- [Descent II](https://github.com/videogamepreservation/descent2) - Sequel to Descent. Written in C and assembly.
- [DIGPAK sound drivers source code](https://github.com/jratcliff63367/digpak) - Original source code for the DIGPAK sound drivers uploaded to GitHub by John W. Ratcliff. List of all homebrew DOS games: http://www.doshaven.eu
- [Doom](https://github.com/id-Software/DOOM) - Sci-fi FPS developed by id Software where you fight demons from hell on Mars. The DOS-specific code for Doom could not be published because of a dependency to the licensed DMX sound library, hence why it's cleaned up and only the Linux source is there. However, the Heretic and Hexen projects contain the original DOS code in a way where DMX-related code is removed.
- [DOS Defender](https://github.com/skeeto/dosdefender-ld31) - Christopher Wellons's x86 real mode DOS Asteroids clone created as an entry for Lundum Dare #31.
- [DOS-VGA-Game](https://github.com/marcomarrero/DOS-VGA-Game) - Marco A. Marrero's DOS VGA/hardware library implemented in assembly and Turbo Pascal.
- [Dungeons of Noudar](https://github.com/TheFakeMontyOnTheRun/dungeons-of-noudar) - First-person 2.5D dungeon-crawler on protected mode. Written in C++, includes software rendering, fixed point math, test coverage and sound (PC speaker, Adlib, OPL2LPT).
- [Floppy Bird](https://github.com/icebreaker/floppybird) - Flappy Bird clone written in 16 bit assembly. Not a DOS program, but a PC-Booter application instead (although it's also possible to build a COM executable for DOS).
- [GitHub repository](https://github.com/porta2note/gridfighter3d)
- [Heretic](https://github.com/OpenSourcedGames/Heretic) - Dark fantasy FPS running on id Software's Doom engine.
- [Hexen: Beyond Heretic](https://github.com/OpenSourcedGames/Hexen) - Indirect sequel to Heretic.
- [Hovertank 3D](https://github.com/FlatRockSoft/Hovertank3D) - FPS developed by id Software. Features pseudo-3D graphics with raycasting technique, before Catacomb 3D and Wolfeinstein 3D. Written in C and assembly.
- [LoveDOS](https://github.com/rxi/lovedos) - A framework for making 2D DOS games in Lua. API based on a subset of the LÖVE API.
- [MS-DOS](https://github.com/microsoft/MS-DOS) - GitHub repository of the original source code for MS-DOS v1.25, v2.0 and v4.0, open-sourced by Microsoft.
- [NetHack](https://github.com/NetHack/NetHack) - Descendant of the original [NetHack](https://en.wikipedia.org/wiki/NetHack) rougelike game first released in 1987 available on multiple platforms.
- [Piskworks](https://github.com/berk76/piskworks) - Gomoku clone written in C. Works on DOS, ZX Spectrum, ZX81, ZX80, APPLE1, AS400 and Windows.
- [Plutonium Caverns](https://github.com/jani-nykanen/plutonium-caverns) - Overhead puzzle game written in C. Web version uses [DOSBox ported to Emscripten](https://github.com/dreamlayers/em-dosbox) to embed DOSBox into HTML5. However, the original executable is also downloadable and buildable with Open Watcom.
- [Ptakovina](https://github.com/berk76/tetris) - Tetris clone written in C. Runs on DOS, Unix/Linux, ZX Spectrum and Windows.
- [Quake](https://github.com/id-Software/Quake) - FPS developed by id Software set in a fully 3D world. Written in C. Compiled with DJGPP for DOS.
- [Rise of the Triad: Dark War](https://github.com/videogamepreservation/rott) - FPS developed by Apogee. It was developed as a follow-up to Wolfenstein 3D, but was altered and became a standalone game instead. Uses a heavily modified Wolfenstein 3D engine. Written in C.
- [Towers of Hanoi](https://github.com/sblendorio/hanoi-dos) - [Tower of Hanoi](https://en.wikipedia.org/wiki/Tower_of_Hanoi) puzzle game written in Turbo Pascal. Originally released in 1996.
- [Wolfenstein 3D](https://github.com/id-Software/wolf3d) - FPS developed by id Software set in the Nazi German prison Castle Wolfenstein. Features pseudo-3D graphics with raycasting technique. Written in C and assembly.
- [x86 pong](https://github.com/spacerace/x86-pong) - Text-mode Pong clone written in C. Runs as PC-Booter game and under DOS.

## Drivers and emulators

- [SBEMU](https://github.com/crazii/SBEMU) - A TSR that emulates Sound Blaster and OPL3 in pure DOS using modern PCI-based (onboard and add-in card) sound cards. Supports both real mode and protected mode games!
- [VSB](https://github.com/Baron-von-Riedesel/VSBHDA) - A fork of SBEMU (see above), which also aims to offer Sound Blaster emulation for modern PC hardware, in both real mode and protected mode games.

## Development tools

- [386MAX](https://github.com/sudleyplace/386MAX) - Memory manager for DOS PCs with 386 or higher CPUs, [released by Qualitas company in 1992](https://winworldpc.com/product/386max/6x). Source code was released in June 2022 on GitHub with GPL-3.0 license.
- [DOjS](https://github.com/SuperIlu/DOjS) - JavaScript programming environment for MS-DOS, FreeDOS or any DOS-based Windows (like 95, 98, ME).
- [Micropython for FreeDOS](https://github.com/pohmelie/micropython-freedos) - FreeDOS ad-hoc module for [micropython](https://github.com/micropython/micropython).
- [Open Watcom V2](https://github.com/open-watcom/open-watcom-v2) - GitHub fork which is actively maintained and is ported to 64-bit Windows and Linux.
- [Small-C Toolkit](https://github.com/humbertocsjr/Small-C) - A self-hosting Small-C Compiler Toolkit for DOS(8086) with: K&R C Compiler, Make, Linker, Assembler. First released in 1982 by Jim E. Hendrix.
- [SmallerC](https://github.com/alexfru/SmallerC) - Portable self-hosting C compiler capable of producing executables for a number of platforms, including real and protected mode DOS programs, by Alexei A. Frounze.
