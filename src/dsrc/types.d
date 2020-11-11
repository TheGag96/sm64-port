module types;

import ultra64, game.area, game.camera, game.object_helpers, mario_geo_switch_case_ids;

// This file contains various data types used in Super Mario 64 that don't yet
// have an appropriate header.

//#include <ultra64.h>
//#include "macros.h"

// Certain functions are marked as having return values, but do not
// actually return a value. This causes undefined behavior, which we'd rather
// avoid on modern GCC. This only impacts -O2 and can matter for both the function
// itself and functions that call it.
//#ifdef AVOID_UB
//    #define BAD_RETURN(cmd) void
//#else
//    #define BAD_RETURN(cmd) cmd
//#endif

struct Controller
{
  /*0x00*/ s16 rawStickX;       //
  /*0x02*/ s16 rawStickY;       //
  /*0x04*/ float stickX;        // [-64, 64] positive is right
  /*0x08*/ float stickY;        // [-64, 64] positive is up
  /*0x0C*/ float stickMag;      // distance from center [0, 64]
  /*0x10*/ u16 buttonDown;
  /*0x12*/ u16 buttonPressed;
  /*0x14*/ OSContStatus* statusData;
  /*0x18*/ OSContPad* controllerData;
  version (SM64_SH) {
    /*0x1C*/ int port;
  }
}

alias Vec2f = f32[2];
alias Vec3f = f32[3]; // X, Y, Z, where Y is up
alias Vec3s = s16[3];
alias Vec3i = s32[3];
alias Vec4f = f32[4];
alias Vec4s = s16[4];

alias Mat4 = f32[4][4];

alias GeoLayout      = uintptr_t;
alias LevelScript    = uintptr_t;
alias Movtex         = s16;
alias MacroObject    = s16;
alias Collision      = s16;
alias Trajectory     = s16;
alias PaintingData   = s16;
alias BehaviorScript = uintptr_t;

enum SpTaskState {
    SPTASK_STATE_NOT_STARTED,
    SPTASK_STATE_RUNNING,
    SPTASK_STATE_INTERRUPTED,
    SPTASK_STATE_FINISHED,
    SPTASK_STATE_FINISHED_DP
}

struct SPTask
{
    /*0x00*/ OSTask task;
    /*0x40*/ OSMesgQueue *msgqueue;
    /*0x44*/ OSMesg msg;
    /*0x48*/ SpTaskState state;
} // size = 0x4C, align = 0x8

struct VblankHandler
{
    OSMesgQueue *queue;
    OSMesg msg;
}

enum ANIM_FLAG_NOLOOP     = (1 << 0); // 0x01
enum ANIM_FLAG_FORWARD    = (1 << 1); // 0x02
enum ANIM_FLAG_2          = (1 << 2); // 0x04
enum ANIM_FLAG_HOR_TRANS  = (1 << 3); // 0x08
enum ANIM_FLAG_VERT_TRANS = (1 << 4); // 0x10
enum ANIM_FLAG_5          = (1 << 5); // 0x20
enum ANIM_FLAG_6          = (1 << 6); // 0x40
enum ANIM_FLAG_7          = (1 << 7); // 0x80

struct Animation {
    /*0x00*/ s16 flags;
    /*0x02*/ s16 animYTransDivisor;
    /*0x04*/ s16 startFrame;
    /*0x06*/ s16 loopStart;
    /*0x08*/ s16 loopEnd;
    /*0x0A*/ s16 unusedBoneCount;
    /*0x0C*/ const(s16)* values;
    /*0x10*/ const(u16)* index;
    /*0x14*/ u32 length; // only used with Mario animations to determine how much to load. 0 otherwise.
}

pragma(inline, true)
auto ANIMINDEX_NUMPARTS(T)(T animindex) { return (sizeof(animindex) / sizeof(u16) / 6 - 1); }

struct GraphNode
{
    /*0x00*/ s16 type; // structure type
    /*0x02*/ s16 flags; // hi = drawing layer, lo = rendering modes
    /*0x04*/ GraphNode* prev;
    /*0x08*/ GraphNode* next;
    /*0x0C*/ GraphNode* parent;
    /*0x10*/ GraphNode* children;
}

struct AnimInfo
{
    /*0x00 0x38*/ s16 animID;
    /*0x02 0x3A*/ s16 animYTrans;
    /*0x04 0x3C*/ Animation* curAnim;
    /*0x08 0x40*/ s16 animFrame;
    /*0x0A 0x42*/ u16 animTimer;
    /*0x0C 0x44*/ s32 animFrameAccelAssist;
    /*0x10 0x48*/ s32 animAccel;
}

struct GraphNodeObject
{
    /*0x00*/ GraphNode node;
    /*0x14*/ GraphNode* sharedChild;
    /*0x18*/ s8 areaIndex;
    /*0x19*/ s8 activeAreaIndex;
    /*0x1A*/ Vec3s angle;
    /*0x20*/ Vec3f pos;
    /*0x2C*/ Vec3f scale;
    /*0x38*/ AnimInfo animInfo;
    /*0x4C*/ SpawnInfo* unk4C;
    /*0x50*/ Mat4 *throwMatrix; // matrix ptr
    /*0x54*/ Vec3f cameraToObject;
}

struct ObjectNode
{
    GraphNodeObject gfx;
    ObjectNode* next;
    ObjectNode* prev;
}

// NOTE: Since ObjectNode is the first member of Object_, it is difficult to determine
// whether some of these pointers point to ObjectNode or Object_.

struct Object_
{
    /*0x000*/ ObjectNode header;
    /*0x068*/ Object_* parentObj;
    /*0x06C*/ Object_* prevObj;
    /*0x070*/ u32 collidedObjInteractTypes;
    /*0x074*/ s16 activeFlags;
    /*0x076*/ s16 numCollidedObjs;
    /*0x078*/ Object_*[4] collidedObjs;
    /*0x088*/
    union _anon_1
    {
        // Object_ fields. See object_fields.h.
        u32[0x50] asU32;
        s32[0x50] asS32;
        s16[2][0x50] asS16;
        f32[0x50] asF32;
        static if (size_t.sizeof != 8) {
            s16*[0x50] asS16P;
            s32*[0x50] asS32P;
            Animation**[0x50] asAnims;
            Waypoint*[0x50] asWaypoint;
            ChainSegment*[0x50] asChainSegment;
            Object_*[0x50] asObject;
            Surface*[0x50] asSurface;
            void*[0x50] asVoidPtr;
            const(void)*[0x50] asConstVoidPtr;
        }
    } 
    _anon_1 rawData;
static if (size_t.sizeof == 8) {
    union _anon_2 {
        s16[0x50]* asS16P;
        s32[0x50]* asS32P;
        Animation**[0x50] asAnims;
        Waypoint*[0x50] asWaypoint;
        ChainSegment*[0x50] asChainSegment;
        Object_*[0x50] asObject;
        Surface*[0x50] asSurface;
        void*[0x50] asVoidPtr;
        const(void)*[0x50] asConstVoidPtr;
    } 
    _anon_2 ptrData;
}
    /*0x1C8*/ u32 unused1;
    /*0x1CC*/ const(BehaviorScript)* curBhvCommand;
    /*0x1D0*/ u32 bhvStackIndex;
    /*0x1D4*/ uintptr_t[8] bhvStack;
    /*0x1F4*/ s16 bhvDelayTimer;
    /*0x1F6*/ s16 respawnInfoType;
    /*0x1F8*/ f32 hitboxRadius;
    /*0x1FC*/ f32 hitboxHeight;
    /*0x200*/ f32 hurtboxRadius;
    /*0x204*/ f32 hurtboxHeight;
    /*0x208*/ f32 hitboxDownOffset;
    /*0x20C*/ const(BehaviorScript)* behavior;
    /*0x210*/ u32 unused2;
    /*0x214*/ Object_* platform;
    /*0x218*/ void* collisionData;
    /*0x21C*/ Mat4 transform;
    /*0x25C*/ void* respawnInfo;
}

struct ObjectHitbox
{
    /*0x00*/ u32 interactType;
    /*0x04*/ u8 downOffset;
    /*0x05*/ s8 damageOrCoinValue;
    /*0x06*/ s8 health;
    /*0x07*/ s8 numLootCoins;
    /*0x08*/ s16 radius;
    /*0x0A*/ s16 height;
    /*0x0C*/ s16 hurtboxRadius;
    /*0x0E*/ s16 hurtboxHeight;
}

struct Waypoint
{
    s16 flags;
    Vec3s pos;
}

struct Surface
{
    /*0x00*/ s16 type;
    /*0x02*/ s16 force;
    /*0x04*/ s8 flags;
    /*0x05*/ s8 room;
    /*0x06*/ s16 lowerY;
    /*0x08*/ s16 upperY;
    /*0x0A*/ Vec3s vertex1;
    /*0x10*/ Vec3s vertex2;
    /*0x16*/ Vec3s vertex3;
    /*0x1C*/ struct _anon_1 {
        f32 x;
        f32 y;
        f32 z;
    };
    _anon_1 normal;
    /*0x28*/ f32 originOffset;
    /*0x2C*/ Object_* object;
}

struct MarioBodyState
{
    /*0x00*/ u32 action;
    /*0x04*/ MarioCapGSCId capState;
    /*0x05*/ MarioEyesGSCId eyeState;
    /*0x06*/ MarioHandGSCId handState;
    /*0x07*/ s8 wingFlutter; /// whether Mario's wing cap wings are fluttering
    /*0x08*/ s16 modelState;
    /*0x0A*/ MarioGrabPosGSCId grabPos;
    /*0x0B*/ u8 punchState; /// 2 bits for type of punch, 6 bits for punch animation timer
    /*0x0C*/ Vec3s torsoAngle;
    /*0x12*/ Vec3s headAngle;
    /*0x18*/ Vec3f heldObjLastPosition; /// also known as HOLP
    u8[4] padding;
}

struct OffsetSizePair
{
    u32 offset;
    u32 size;
}

struct MarioAnimDmaRelatedThing
{
    u32 count;
    u8* srcAddr;
    OffsetSizePair[1] anim; // dynamic size
}

struct MarioAnimation
{
    MarioAnimDmaRelatedThing* animDmaTable;
    u8* currentAnimAddr;
    Animation* targetAnim;
    u8[4] padding;
};

struct MarioState
{
    /*0x00*/ u16 unk00;
    /*0x02*/ u16 input;
    /*0x04*/ u32 flags;
    /*0x08*/ u32 particleFlags;
    /*0x0C*/ u32 action;
    /*0x10*/ u32 prevAction;
    /*0x14*/ u32 terrainSoundAddend;
    /*0x18*/ u16 actionState;
    /*0x1A*/ u16 actionTimer;
    /*0x1C*/ u32 actionArg;
    /*0x20*/ f32 intendedMag;
    /*0x24*/ s16 intendedYaw;
    /*0x26*/ s16 invincTimer;
    /*0x28*/ u8 framesSinceA;
    /*0x29*/ u8 framesSinceB;
    /*0x2A*/ u8 wallKickTimer;
    /*0x2B*/ u8 doubleJumpTimer;
    /*0x2C*/ Vec3s faceAngle;
    /*0x32*/ Vec3s angleVel;
    /*0x38*/ s16 slideYaw;
    /*0x3A*/ s16 twirlYaw;
    /*0x3C*/ Vec3f pos;
    /*0x48*/ Vec3f vel;
    /*0x54*/ f32 forwardVel;
    /*0x58*/ f32 slideVelX;
    /*0x5C*/ f32 slideVelZ;
    /*0x60*/ Surface* wall;
    /*0x64*/ Surface* ceil;
    /*0x68*/ Surface* floor;
    /*0x6C*/ f32 ceilHeight;
    /*0x70*/ f32 floorHeight;
    /*0x74*/ s16 floorAngle;
    /*0x76*/ s16 waterLevel;
    /*0x78*/ Object_* interactObj;
    /*0x7C*/ Object_* heldObj;
    /*0x80*/ Object_* usedObj;
    /*0x84*/ Object_* riddenObj;
    /*0x88*/ Object_* marioObj;
    /*0x8C*/ SpawnInfo* spawnInfo;
    /*0x90*/ Area* area;
    /*0x94*/ PlayerCameraState* statusForCamera;
    /*0x98*/ MarioBodyState* marioBodyState;
    /*0x9C*/ Controller* controller;
    /*0xA0*/ MarioAnimation* animation;
    /*0xA4*/ u32 collidedObjInteractTypes;
    /*0xA8*/ s16 numCoins;
    /*0xAA*/ s16 numStars;
    /*0xAC*/ s8 numKeys; // Unused key mechanic
    /*0xAD*/ s8 numLives;
    /*0xAE*/ s16 health;
    /*0xB0*/ s16 unkB0;
    /*0xB2*/ u8 hurtCounter;
    /*0xB3*/ u8 healCounter;
    /*0xB4*/ u8 squishTimer;
    /*0xB5*/ u8 fadeWarpOpacity;
    /*0xB6*/ u16 capTimer;
    /*0xB8*/ s16 prevNumStarsForDialog;
    /*0xBC*/ f32 peakHeight;
    /*0xC0*/ f32 quicksandDepth;
    /*0xC4*/ f32 unkC4;
};

public import object_fields;