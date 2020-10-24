module game.area;

import gbi, types, game.camera, engine.graph_node;

extern (C):

struct WarpNode
{
    /*00*/
    ubyte id;
    /*01*/
    ubyte destLevel;
    /*02*/
    ubyte destArea;
    /*03*/
    ubyte destNode;
}

struct ObjectWarpNode
{
    /*0x00*/
    WarpNode node;
    /*0x04*/
    Object_* object;
    /*0x08*/
    ObjectWarpNode* next;
}

// From Surface 0x1B to 0x1E
enum INSTANT_WARP_INDEX_START = 0x00; // Equal and greater than Surface 0x1B
enum INSTANT_WARP_INDEX_STOP = 0x04; // Less than Surface 0x1F

struct InstantWarp
{
    /*0x00*/
    ubyte id; // 0 = 0x1B / 1 = 0x1C / 2 = 0x1D / 3 = 0x1E
    /*0x01*/
    ubyte area;
    /*0x02*/
    Vec3s displacement;
}

struct SpawnInfo
{
    /*0x00*/
    Vec3s startPos;
    /*0x06*/
    Vec3s startAngle;
    /*0x0C*/
    byte areaIndex;
    /*0x0D*/
    byte activeAreaIndex;
    /*0x10*/
    uint behaviorArg;
    /*0x14*/
    void* behaviorScript;
    /*0x18*/
    GraphNode* unk18;
    /*0x1C*/
    SpawnInfo* next;
}

struct UnusedArea28
{
    /*0x00*/
    short unk00;
    /*0x02*/
    short unk02;
    /*0x04*/
    short unk04;
    /*0x06*/
    short unk06;
    /*0x08*/
    short unk08;
}

struct Whirlpool
{
    /*0x00*/
    Vec3s pos;
    /*0x03*/
    short strength;
}

struct Area
{
    /*0x00*/
    byte index;
    /*0x01*/
    byte flags; // Only has 1 flag: 0x01 = Is this the active area?
    /*0x02*/
    ushort terrainType; // default terrain of the level (set from level script cmd 0x31)
    /*0x04*/
    GraphNodeRoot* unk04; // geometry layout data
    /*0x08*/
    short* terrainData; // collision data (set from level script cmd 0x2E)
    /*0x0C*/
    byte* surfaceRooms; // (set from level script cmd 0x2F)
    /*0x10*/
    short* macroObjects; // Macro Objects Ptr (set from level script cmd 0x39)
    /*0x14*/
    ObjectWarpNode* warpNodes;
    /*0x18*/
    WarpNode* paintingWarpNodes;
    /*0x1C*/
    InstantWarp* instantWarps;
    /*0x20*/
    SpawnInfo* objectSpawnInfos;
    /*0x24*/
    Camera* camera;
    /*0x28*/
    UnusedArea28* unused28; // Filled by level script 0x3A, but is unused.
    /*0x2C*/
    Whirlpool*[2] whirlpools;
    /*0x34*/
    ubyte[2] dialog; // Level start dialog number (set by level script cmd 0x30)
    /*0x36*/
    ushort musicParam;
    /*0x38*/
    ushort musicParam2;
}

// All the transition data to be used in screen_transition.c
struct WarpTransitionData
{
    /*0x00*/
    ubyte red;
    /*0x01*/
    ubyte green;
    /*0x02*/
    ubyte blue;

    /*0x04*/
    short startTexRadius;
    /*0x06*/
    short endTexRadius;
    /*0x08*/
    short startTexX;
    /*0x0A*/
    short startTexY;
    /*0x0C*/
    short endTexX;
    /*0x0E*/
    short endTexY;

    /*0x10*/
    short texTimer; // always 0, does seems to affect transition when disabled
}

enum WARP_TRANSITION_FADE_FROM_COLOR = 0x00;
enum WARP_TRANSITION_FADE_INTO_COLOR = 0x01;
enum WARP_TRANSITION_FADE_FROM_STAR = 0x08;
enum WARP_TRANSITION_FADE_INTO_STAR = 0x09;
enum WARP_TRANSITION_FADE_FROM_CIRCLE = 0x0A;
enum WARP_TRANSITION_FADE_INTO_CIRCLE = 0x0B;
enum WARP_TRANSITION_FADE_FROM_MARIO = 0x10;
enum WARP_TRANSITION_FADE_INTO_MARIO = 0x11;
enum WARP_TRANSITION_FADE_FROM_BOWSER = 0x12;
enum WARP_TRANSITION_FADE_INTO_BOWSER = 0x13;

struct WarpTransition
{
    /*0x00*/
    ubyte isActive; // Is the transition active. (either TRUE or FALSE)
    /*0x01*/
    ubyte type; // Determines the type of transition to use (circle, star, etc.)
    /*0x02*/
    ubyte time; // Amount of time to complete the transition (in frames)
    /*0x03*/
    ubyte pauseRendering; // Should the game stop rendering. (either TRUE or FALSE)
    /*0x04*/
    WarpTransitionData data;
}

extern __gshared GraphNode** gLoadedGraphNodes;
extern __gshared SpawnInfo[] gPlayerSpawnInfos;
extern __gshared GraphNode*[] D_8033A160;
extern __gshared Area[] gAreaData;
extern __gshared WarpTransition gWarpTransition;
extern __gshared short gCurrCourseNum;
extern __gshared short gCurrActNum;
extern __gshared short gCurrAreaIndex;
extern __gshared short gSavedCourseNum;
extern __gshared short gPauseScreenMode;
extern __gshared short gSaveOptSelectIndex;

extern __gshared SpawnInfo* gMarioSpawnInfo;

extern __gshared Area* gAreas;
extern __gshared Area* gCurrentArea;

extern __gshared short gCurrSaveFileNum;
extern __gshared short gCurrLevelNum;

void override_viewport_and_clip (Vp* a, Vp* b, ubyte c, ubyte d, ubyte e);
void print_intro_text ();
uint get_mario_spawn_type (Object_* o);
ObjectWarpNode* area_get_warp_node (ubyte id);
void clear_areas ();
void clear_area_graph_nodes ();
void load_area (int index);
void unload_area ();
void load_mario_area ();
void unload_mario_area ();
void change_area (int index);
void area_update_objects ();
void play_transition (short transType, short time, ubyte red, ubyte green, ubyte blue);
void play_transition_after_delay (short transType, short time, ubyte red, ubyte green, ubyte blue, short delay);
void render_game ();

// AREA_H
