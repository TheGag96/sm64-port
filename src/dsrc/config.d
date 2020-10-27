module config;

import util;

extern (C):

/**
 * @file config.h
 * A catch-all file for configuring various bugfixes and other settings
 * (maybe eventually) in SM64
 */

// Bug Fixes
// --| US Version Nintendo Bug Fixes
/// Fixes bug where obtaining over 999 coins sets the number of lives to 999 (or -25)
enum BUGFIX_MAX_LIVES                  = Version.SM64_US || Version.SM64_EU || Version.SM64_SH;
/// Fixes bug where the Boss music won't fade out after defeating King Bob-omb
enum BUGFIX_KING_BOB_OMB_FADE_MUSIC    = Version.SM64_US || Version.SM64_EU;
/// Fixes bug in Bob-Omb Battlefield where entering a warp stops the Koopa race music
enum BUGFIX_KOOPA_RACE_MUSIC           = Version.SM64_US || Version.SM64_EU || Version.SM64_SH;
/// Fixes bug where Piranha Plants do not reset their action state when the
/// player exits their activation radius.
enum BUGFIX_PIRANHA_PLANT_STATE_RESET  = Version.SM64_US || Version.SM64_EU || Version.SM64_SH;
/// Fixes bug where sleeping Piranha Plants damage players that bump into them
enum BUGFIX_PIRANHA_PLANT_SLEEP_DAMAGE = Version.SM64_US || Version.SM64_SH;
/// Fixes bug where it shows a star when you grab a key in bowser battle stages
enum BUGFIX_STAR_BOWSER_KEY            = Version.SM64_US || Version.SM64_EU;

// Screen Size Defines
enum SCREEN_WIDTH  = 320;
enum SCREEN_HEIGHT = 240;

// Border Height Define for NTSC Versions

// What's the point of having a border?
version (SM64_N64) {
    version (SM64_EU) {
        enum BORDER_HEIGHT = 1;
    } else {
        enum BORDER_HEIGHT = 8;
    }
} else {
    enum BORDER_HEIGHT = 0;
}

// CONFIG_H
