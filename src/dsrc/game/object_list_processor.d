module game.object_list_processor;

import ultra64, types, util, game.area, game.memory;

extern (C):

/**
 * Flags for gTimeStopState. These control which objects are processed each frame
 * and also track some miscellaneous info.
 */
enum TIME_STOP_UNKNOWN_0         = 1 << 0;
enum TIME_STOP_ENABLED           = 1 << 1;
enum TIME_STOP_DIALOG            = 1 << 2;
enum TIME_STOP_MARIO_AND_DOORS   = 1 << 3;
enum TIME_STOP_ALL_OBJECTS       = 1 << 4;
enum TIME_STOP_MARIO_OPENED_DOOR = 1 << 5;
enum TIME_STOP_ACTIVE            = 1 << 6;

/**
 * The maximum number of objects that can be loaded at once.
 */
enum OBJECT_POOL_CAPACITY = 240;

/**
 * Every object is categorized into an object list, which controls the order
 * they are processed and which objects they can collide with.
 */
enum ObjectList
{
    OBJ_LIST_PLAYER      = 0,  // (0) Mario
    OBJ_LIST_UNUSED_1    = 1,  // (1) (unused)
    OBJ_LIST_DESTRUCTIVE = 2,  // (2) things that can be used to destroy other objects, like
                               // bob-ombs and corkboxes
    OBJ_LIST_UNUSED_3    = 3,  // (3) (unused)
    OBJ_LIST_GENACTOR    = 4,  // (4) general actors. most normal 'enemies' or actors are
                               // on this list. (MIPS, bullet bill, bully, etc)
    OBJ_LIST_PUSHABLE    = 5,  // (5) pushable actors. This is a group of objects which
                               // can push each other around as well as their parent
                               // objects. (goombas, koopas, spinies)
    OBJ_LIST_LEVEL       = 6,  // (6) level objects. general level objects such as heart, star
    OBJ_LIST_UNUSED_7    = 7,  // (7) (unused)
    OBJ_LIST_DEFAULT     = 8,  // (8) default objects. objects that didnt start with a 00
                               // command are put here, so this is treated as a default.
    OBJ_LIST_SURFACE     = 9,  // (9) surface objects. objects that specifically have surface
                               // collision and not object collision. (thwomp, whomp, etc)
    OBJ_LIST_POLELIKE    = 10, // (10) polelike objects. objects that attract or otherwise
                               // "cling" Mario similar to a pole action. (hoot,
                               // whirlpool, trees/poles, etc)
    OBJ_LIST_SPAWNER     = 11, // (11) spawners
    OBJ_LIST_UNIMPORTANT = 12, // (12) unimportant objects. objects that will not load
                               // if there are not enough object slots: they will also
                               // be manually unloaded to make room for slots if the list
                               // gets exhausted.
    NUM_OBJ_LISTS        = 13
}

mixin externCArray!(ObjectNode, "gObjectListArray");

extern __gshared s32 gDebugInfoFlags;
extern __gshared s32 gNumFindFloorMisses;
extern __gshared s32 unused_8033BEF8;
extern __gshared s32 gUnknownWallCount;
extern __gshared uint gObjectCounter;

struct NumTimesCalled
{
    /*0x00*/ s16 floor;
    /*0x02*/ s16 ceil;
    /*0x04*/ s16 wall;
}

extern __gshared NumTimesCalled gNumCalls;

mixin externCArray!(s16[8], "gDebugInfo");
mixin externCArray!(s16[8], "gDebugInfoOverwrite");

extern __gshared uint gTimeStopState;
//mixin externCArray!(Object_, "gObjectPool");
extern __gshared Object_ gMacroObjectDefaultParent;
extern __gshared ObjectNode* gObjectLists;
extern __gshared ObjectNode gFreeObjectList;

extern __gshared Object_* gMarioObject;
extern __gshared Object_* gLuigiObject;
extern __gshared Object_* gCurrentObject;

extern __gshared const(BehaviorScript)* gCurBhvCommand;
extern __gshared s16 gPrevFrameObjectCount;

extern __gshared s32 gSurfaceNodesAllocated;
extern __gshared s32 gSurfacesAllocated;
extern __gshared s32 gNumStaticSurfaceNodes;
extern __gshared s32 gNumStaticSurfaces;

extern __gshared MemoryPool* gObjectMemoryPool;

extern __gshared s16 gCheckingSurfaceCollisionsForCamera;
extern __gshared s16 gFindFloorIncludeSurfaceIntangible;
extern __gshared s16* gEnvironmentRegions;
extern __gshared s32[20] gEnvironmentLevels;
extern __gshared s8[2][60] gDoorAdjacentRooms;
extern __gshared s16 gMarioCurrentRoom;
extern __gshared s16 D_8035FEE2;
extern __gshared s16 D_8035FEE4;
extern __gshared s16 gTHIWaterDrained;
extern __gshared s16 gTTCSpeedSetting;
extern __gshared s16 gMarioShotFromCannon;
extern __gshared s16 gCCMEnteredSlide;
extern __gshared s16 gNumRoomedObjectsInMarioRoom;
extern __gshared s16 gNumRoomedObjectsNotInMarioRoom;
extern __gshared s16 gWDWWaterLevelChanging;
extern __gshared s16 gMarioOnMerryGoRound;

void bhv_mario_update ();
void set_object_respawn_info_bits (Object_* obj, u8 bits);
void unload_objects_from_area (s32 unused, s32 areaIndex);
void spawn_objects_from_info (s32 unused, SpawnInfo* spawnInfo);
void clear_objects ();
void update_objects (s32 unused);

// OBJECT_LIST_PROCESSOR_H
