# Extended Moveset for SM64

This is a mod for Super Mario 64 that attempts to add various new moves for Mario from games like Sunshine and Odyssey without replacing any existing ones. The aim is for to have each addition be balanced, natural, fitting, and (most of all) fun to use. Many of these changes were inspired by (and in some cases direct recreations of) Kaze's moveset changes for Super Mario Odyssey 64 and Super Mario 64 Land, but there's some new stuff here too.

## Changes

* **Wall Slide** ([video](https://imgur.com/zBjdMZN)) - Works much like Sunshine. Your reflected angle going at the wall is maintained after jumping off, and firsties are still possible. Going at the wall too fast (e.g. by doing a long jump) will bonk, but you still have the opportunity to do the old-style wall kick input during it. It's like a skill check for those trying to wall jump with a lot of momentum.
* **Dive Hop** ([video](https://imgur.com/07gii0H)) - Taken from Sunshine (uses the same Y-speed values too!). Done by pressing B while belly sliding.
* **Ground Pound Dive** ([video](https://imgur.com/QQTZMSa)) - Taken from Odyssey. Press B while in ground pound to do a somewhat slow dive with a bit of height. This move was also added in Kaze's hacks, but I was never a fan of the fact that it put you at full speed - it obsoleted the normal dive almost entirely. Now its clear use is to get that last-ditch bit of height/distance.
* **Ground Pound Jump** ([video](https://imgur.com/xTkY8FH)) - Taken from Odyssey. Jumping just after landing from a ground pound will do a straight-up jump with a height between a backflip/sideflip and a triple jump.
* **Roll** ([video](https://imgur.com/letp7qt)) - Taken from Odyssey, trying to be as close to it as possible. You can enter it by crouching and pressing R. You can gain speed by repeatedly pressing R (star particles indicate a speedup). You can also enter it by holding crouch (Z) before landing after long jump or dive. Additionally, pressing R just after landing from a ground pound will start a roll with a great amount of speed. During the roll, you can press A to cancel into a long jump or B to cancel into a dive recover. Letting go of R will also cancel the roll after a short lockout period (which won't occur if you accidentally triggered roll from long jump or dive for a couple frames). Cancelling this way will lift your firm speed cap slightly until you switch actions (explained further below).
* **Spin Jump** ([video](https://imgur.com/tz71HgT)) - Taken from Sunshine. The way gravity works should be to-the-numbers accurate, but it goes as high as a ground pound jump. Perform it by rotating the control stick a little more than half a circle, then jumping. Remember that you can choose the direction you want to face after the jump just before pressing A. You can also turn almost any jump into a spin jump after the fact by doing a spin input. You cannot grab ledges during it.
* **Spin Pound** ([video](https://imgur.com/ysYiMTw)) - Adapted from Odyssey. Simply press Z during a spin jump. You'll immediately plummet down much like a normal ground pound. When you land, you'll face the direction you're holding with the analog stick. You can do this very quickly after spin jumping, and you can roll after landing just like a normal ground pound... Meaning yes, you can [bump](https://smo-speedrun.fandom.com/wiki/Spinpound) like you're doing an Odyssey speedrun!
* **Underwater Ground Pound (+ Stroke and Jump)** ([video](https://imgur.com/tgaRiM6)) - Taken from Odyssey. You can now do a ground pound underwater! This helps you descend into the depths faster. Additionally, if you press A during it, you'll do a stroke straight forward that's decently quick. If you land the ground pound underwater, pressing A will do an underwater ground pound jump. Ground pounding into water will now carry into the underwater version, and ground pound jumping underwater to the surface will carry into a jump out of the water.
* **Ledge Parkour** ([video](https://imgur.com/4C563j2)) - Adapted from Super Mario Run (of all places). When grabbing ledge when going at least full walking speed, pressing B within a 3 frame window will vault you over the ledge. It'll maintain your speed prior to grabbing ledge and give you a little bit more as well. If the level geometry was a perfectly-made set of stairs, you could continually parkour over each ledge, accumulating ludicrious speed in the process...
* **Modified Tight Controls Patch** ([video](https://imgur.com/67xK6i3)) - The Tight Controls patch by Keanine is a great idea - being able to easily change directions without doing awkward half/circles is a great idea. However, with this patch, if you're on the ground with a lot of backwards speed, pressing back will change your direction, but you'll still be going backwards in that new direction. This looks and feels very strange, so I've modified it to also convert your speed into forward speed when changing directions due to Tight Controls. Additonally, since it feels a little limiting to have a bunch of speed only for it to be limited by the hard walking speed cap, I've decided to significantly raise that hard cap and also turn the old cap into a "firm" cap. Over that "firm" cap, you'll lose speed twice as fast normal. Doing this maintains a bit of that feeling of riding the insane momentum backwards from a slope in vanilla while still getting the benefits of a more responsive normal control.

[(Gallery containing all videos from above)](https://imgur.com/a/kuPPS9V)

## Installation:

### PC Port

Just apply the `.patch` file from the Releases page in this repo like so:

```sh
git apply --reject --ignore-whitespace "Extended Moveset.patch"
```

Then recompile:

```sh
make -j16       # if your CPU has 16 cores
```

### N64 ROM

Apply the `.xdelta` patch from the Releases page in this repo onto a clean SM64 ROM using your favorite Xdelta patcher (e.g. some online one like [this one](https://hack64.net/tools/patcher.php) or [this one](https://www.marcrobledo.com/RomPatcher.js/)).

If you have any bug reports, suggestions, etc. Please feel to let me know! Thanks for trying out the mod!

Original README begins below:

# Super Mario 64 Port

- This repo contains a full decompilation of Super Mario 64 (J), (U), and (E) with minor exceptions in the audio subsystem.
- Naming and documentation of the source code and data structures are in progress.
- Efforts to decompile the Shindou ROM steadily advance toward a matching build.
- Beyond Nintendo 64, it can also target Linux and Windows natively.

This repo does not include all assets necessary for compiling the game.
A prior copy of the game is required to extract the assets.

## Building native executables

### Linux

1. Install prerequisites (Ubuntu): `sudo apt install -y git build-essential pkg-config libusb-1.0-0-dev libsdl2-dev`.
2. Clone the repo: `git clone https://github.com/sm64-port/sm64-port.git`, which will create a directory `sm64-port` and then **enter** it `cd sm64-port`.
3. Place a Super Mario 64 ROM called `baserom.<VERSION>.z64` into the repository's root directory for asset extraction, where `VERSION` can be `us`, `jp`, or `eu`.
4. Run `make` to build. Qualify the version through `make VERSION=<VERSION>`. Add `-j4` to improve build speed (hardware dependent based on the amount of CPU cores available).
5. The executable binary will be located at `build/<VERSION>_pc/sm64.<VERSION>.f3dex2e`.

### Windows

1. Install and update MSYS2, following all the directions listed on https://www.msys2.org/.
2. From the start menu, launch MSYS2 MinGW and install required packages depending on your machine (do **NOT** launch "MSYS2 MSYS"):
  * 64-bit: Launch "MSYS2 MinGW 64-bit" and install: `pacman -S git make python3 mingw-w64-x86_64-gcc`
  * 32-bit (will also work on 64-bit machines): Launch "MSYS2 MinGW 32-bit" and install: `pacman -S git make python3 mingw-w64-i686-gcc`
  * Do **NOT** by mistake install the package called simply `gcc`.
3. The MSYS2 terminal has a _current working directory_ that initially is `C:\msys64\home\<username>` (home directory). At the prompt, you will see the current working directory in yellow. `~` is an alias for the home directory. You can change the current working directory to `My Documents` by entering `cd /c/Users/<username>/Documents`.
4. Clone the repo: `git clone https://github.com/sm64-port/sm64-port.git`, which will create a directory `sm64-port` and then **enter** it `cd sm64-port`.
5. Place a *Super Mario 64* ROM called `baserom.<VERSION>.z64` into the repository's root directory for asset extraction, where `VERSION` can be `us`, `jp`, or `eu`.
6. Run `make` to build. Qualify the version through `make VERSION=<VERSION>`. Add `-j4` to improve build speed (hardware dependent based on the amount of CPU cores available).
7. The executable binary will be located at `build/<VERSION>_pc/sm64.<VERSION>.f3dex2e.exe` inside the repository.

#### Troubleshooting

1. If you get `make: gcc: command not found` or `make: gcc: No such file or directory` although the packages did successfully install, you probably launched the wrong MSYS2. Read the instructions again. The terminal prompt should contain "MINGW32" or "MINGW64" in purple text, and **NOT** "MSYS".
2. If you get `Failed to open baserom.us.z64!` you failed to place the baserom in the repository. You can write `ls` to list the files in the current working directory. If you are in the `sm64-port` directory, make sure you see it here.
3. If you get `make: *** No targets specified and no makefile found. Stop.`, you are not in the correct directory. Make sure the yellow text in the terminal ends with `sm64-port`. Use `cd <dir>` to enter the correct directory. If you write `ls` you should see all the project files, including `Makefile` if everything is correct.
4. If you get any error, be sure MSYS2 packages are up to date by executing `pacman -Syu` and `pacman -Su`. If the MSYS2 window closes immediately after opening it, restart your computer.
5. When you execute `gcc -v`, be sure you see `Target: i686-w64-mingw32` or `Target: x86_64-w64-mingw32`. If you see `Target: x86_64-pc-msys`, you either opened the wrong MSYS start menu entry or installed the incorrect gcc package.

### Debugging

The code can be debugged using `gdb`. On Linux install the `gdb` package and execute `gdb <executable>`. On MSYS2 install by executing `pacman -S winpty gdb` and execute `winpty gdb <executable>`. The `winpty` program makes sure the keyboard works correctly in the terminal. Also consider changing the `-mwindows` compile flag to `-mconsole` to be able to see stdout/stderr as well as be able to press Ctrl+C to interrupt the program. In the Makefile, make sure you compile the sources using `-g` rather than `-O2` to include debugging symbols. See any online tutorial for how to use gdb.

## ROM building

It is possible to build N64 ROMs as well with this repository. See https://github.com/n64decomp/sm64 for instructions.

## Project Structure

```
sm64
├── actors: object behaviors, geo layout, and display lists
├── asm: handwritten assembly code, rom header
│   └── non_matchings: asm for non-matching sections
├── assets: animation and demo data
│   ├── anims: animation data
│   └── demos: demo data
├── bin: C files for ordering display lists and textures
├── build: output directory
├── data: behavior scripts, misc. data
├── doxygen: documentation infrastructure
├── enhancements: example source modifications
├── include: header files
├── levels: level scripts, geo layout, and display lists
├── lib: SDK library code
├── rsp: audio and Fast3D RSP assembly code
├── sound: sequences, sound samples, and sound banks
├── src: C source code for game
│   ├── audio: audio code
│   ├── buffers: stacks, heaps, and task buffers
│   ├── engine: script processing engines and utils
│   ├── game: behaviors and rest of game source
│   ├── goddard: Mario intro screen
│   ├── menu: title screen and file, act, and debug level selection menus
│   └── pc: port code, audio and video renderer
├── text: dialog, level names, act names
├── textures: skybox and generic texture data
└── tools: build tools
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to
discuss what you would like to change.

Run `clang-format` on your code to ensure it meets the project's coding standards.

Official Discord: https://discord.gg/7bcNTPK
