module game.level_update;

import ultra64, types;

extern (C):

enum TIMER_CONTROL_SHOW  = 0;
enum TIMER_CONTROL_START = 1;
enum TIMER_CONTROL_STOP  = 2;
enum TIMER_CONTROL_HIDE  = 3;

enum WARP_OP_NONE          = 0x00;
enum WARP_OP_UNKNOWN_01    = 0x01;
enum WARP_OP_UNKNOWN_02    = 0x02;
enum WARP_OP_WARP_DOOR     = 0x03;
enum WARP_OP_WARP_OBJECT   = 0x04;
enum WARP_OP_TELEPORT      = 0x05;
enum WARP_OP_STAR_EXIT     = 0x11;
enum WARP_OP_DEATH         = 0x12;
enum WARP_OP_WARP_FLOOR    = 0x13;
enum WARP_OP_GAME_OVER     = 0x14;
enum WARP_OP_CREDITS_END   = 0x15;
enum WARP_OP_DEMO_NEXT     = 0x16;
enum WARP_OP_CREDITS_START = 0x17;
enum WARP_OP_CREDITS_NEXT  = 0x18;
enum WARP_OP_DEMO_END      = 0x19;

enum WARP_OP_TRIGGERS_LEVEL_SELECT = 0x10;

enum MARIO_SPAWN_DOOR_WARP             = 0x01;
enum MARIO_SPAWN_UNKNOWN_02            = 0x02;
enum MARIO_SPAWN_UNKNOWN_03            = 0x03;
enum MARIO_SPAWN_TELEPORT              = 0x04;
enum MARIO_SPAWN_INSTANT_ACTIVE        = 0x10;
enum MARIO_SPAWN_SWIMMING              = 0x11;
enum MARIO_SPAWN_AIRBORNE              = 0x12;
enum MARIO_SPAWN_HARD_AIR_KNOCKBACK    = 0x13;
enum MARIO_SPAWN_SPIN_AIRBORNE_CIRCLE  = 0x14;
enum MARIO_SPAWN_DEATH                 = 0x15;
enum MARIO_SPAWN_SPIN_AIRBORNE         = 0x16;
enum MARIO_SPAWN_FLYING                = 0x17;
enum MARIO_SPAWN_PAINTING_STAR_COLLECT = 0x20;
enum MARIO_SPAWN_PAINTING_DEATH        = 0x21;
enum MARIO_SPAWN_AIRBORNE_STAR_COLLECT = 0x22;
enum MARIO_SPAWN_AIRBORNE_DEATH        = 0x23;
enum MARIO_SPAWN_LAUNCH_STAR_COLLECT   = 0x24;
enum MARIO_SPAWN_LAUNCH_DEATH          = 0x25;
enum MARIO_SPAWN_UNKNOWN_27            = 0x27;

struct CreditsEntry
{
    /*0x00*/ ubyte levelNum;
    /*0x01*/ ubyte areaIndex;
    /*0x02*/ ubyte unk02;
    /*0x03*/ byte marioAngle;
    /*0x04*/ Vec3s marioPos;
    /*0x0C*/ const(char*)* unk0C;
}

extern __gshared CreditsEntry* gCurrCreditsEntry;

extern __gshared MarioState[] gMarioStates;
extern __gshared MarioState* gMarioState;

extern __gshared short sCurrPlayMode;
extern __gshared ushort D_80339ECA;
extern __gshared short sTransitionTimer;
extern __gshared void function (short*) sTransitionUpdate;
extern __gshared ubyte[4] unused3;

struct WarpDest
{
    ubyte type;
    ubyte levelNum;
    ubyte areaIdx;
    ubyte nodeId;
    uint arg;
}

extern __gshared WarpDest sWarpDest;

extern __gshared short D_80339EE0;
extern __gshared short sDelayedWarpOp;
extern __gshared short sDelayedWarpTimer;
extern __gshared short sSourceWarpNodeId;
extern __gshared int sDelayedWarpArg;
extern __gshared ubyte[2] unused4;
extern __gshared byte sTimerRunning;

struct HudDisplay
{
    /*0x00*/ short lives;
    /*0x02*/ short coins;
    /*0x04*/ short stars;
    /*0x06*/ short wedges;
    /*0x08*/ short keys;
    /*0x0A*/ short flags;
    /*0x0C*/ ushort timer;
}

extern __gshared HudDisplay gHudDisplay;
extern __gshared byte gNeverEnteredCastle;

enum HUDDisplayFlag
{
    HUD_DISPLAY_FLAG_LIVES            = 0x0001,
    HUD_DISPLAY_FLAG_COIN_COUNT       = 0x0002,
    HUD_DISPLAY_FLAG_STAR_COUNT       = 0x0004,
    HUD_DISPLAY_FLAG_CAMERA_AND_POWER = 0x0008,
    HUD_DISPLAY_FLAG_KEYS             = 0x0010,
    HUD_DISPLAY_FLAG_UNKNOWN_0020     = 0x0020,
    HUD_DISPLAY_FLAG_TIMER            = 0x0040,
    HUD_DISPLAY_FLAG_EMPHASIZE_POWER  = 0x8000,

    HUD_DISPLAY_NONE = 0x0000,
    HUD_DISPLAY_DEFAULT = HUD_DISPLAY_FLAG_LIVES | HUD_DISPLAY_FLAG_COIN_COUNT | HUD_DISPLAY_FLAG_STAR_COUNT | HUD_DISPLAY_FLAG_CAMERA_AND_POWER | HUD_DISPLAY_FLAG_KEYS | HUD_DISPLAY_FLAG_UNKNOWN_0020
}

ushort level_control_timer (int timerOp);
void fade_into_special_warp (uint arg, uint color);
void load_level_init_text (uint arg);
short level_trigger_warp (MarioState* m, int warpOp);
void level_set_transition (short length, void function (short*) updateFunction);

int lvl_init_or_update (short initOrUpdate, int unused);
int lvl_init_from_save_file (short arg0, int levelNum);
int lvl_set_current_level (short arg0, int levelNum);
int lvl_play_the_end_screen_sound (short arg0, int arg1);
void basic_update (short* arg);

// LEVEL_UPDATE_H
