module game.camera;

import ultra64, types, engine.graph_node, level_table, gbi;

//#include "../engine/geo_layout.h"
//#include "../../include/level_table.h"


extern (C):

/**
 * @file camera.h
 * Constants, defines, and structs used by the camera system.
 * @see camera.c
 */

extern (D) auto ABS(T)(auto ref T x)
{
    return x > 0.f ? x : -x;
}

extern (D) auto ABS2(T)(auto ref T x)
{
    return x >= 0.f ? x : -x;
}

/**
 * Converts an angle in degrees to sm64's s16 angle units. For example, DEGREES(90) == 0x4000
 * This should be used mainly to make camera code clearer at first glance.
 */
extern (D) auto DEGREES(T)(auto ref T x)
{
    return x * 0x10000 / 360;
}

extern (D) auto LEVEL_AREA_INDEX(T0, T1)(auto ref T0 levelNum, auto ref T1 areaNum)
{
    return (levelNum << 4) + areaNum;
}

/**
 * Helper macro for defining which areas of a level should zoom out the camera when the game is paused.
 * Because a mask is used by two levels, the pattern will repeat when more than 4 areas are used by a level.
 */
extern (D) auto ZOOMOUT_AREA_MASK(T0, T1, T2, T3, T4, T5, T6, T7)(auto ref T0 level1Area1, auto ref T1 level1Area2, auto ref T2 level1Area3, auto ref T3 level1Area4, auto ref T4 level2Area1, auto ref T5 level2Area2, auto ref T6 level2Area3, auto ref T7 level2Area4)
{
    return level2Area4 << 7 | level2Area3 << 6 | level2Area2 << 5 | level2Area1 << 4 | level1Area4 << 3 | level1Area3 << 2 | level1Area2 << 1 | level1Area1 << 0;
}

enum AREA_BBH = LEVEL_AREA_INDEX(LevelNum.LEVEL_BBH, 1);
enum AREA_CCM_OUTSIDE = LEVEL_AREA_INDEX(LevelNum.LEVEL_CCM, 1);
enum AREA_CCM_SLIDE = LEVEL_AREA_INDEX(LevelNum.LEVEL_CCM, 2);
enum AREA_CASTLE_LOBBY = LEVEL_AREA_INDEX(LevelNum.LEVEL_CASTLE, 1);
enum AREA_CASTLE_TIPPY = LEVEL_AREA_INDEX(LevelNum.LEVEL_CASTLE, 2);
enum AREA_CASTLE_BASEMENT = LEVEL_AREA_INDEX(LevelNum.LEVEL_CASTLE, 3);
enum AREA_HMC = LEVEL_AREA_INDEX(LevelNum.LEVEL_HMC, 1);
enum AREA_SSL_OUTSIDE = LEVEL_AREA_INDEX(LevelNum.LEVEL_SSL, 1);
enum AREA_SSL_PYRAMID = LEVEL_AREA_INDEX(LevelNum.LEVEL_SSL, 2);
enum AREA_SSL_EYEROK = LEVEL_AREA_INDEX(LevelNum.LEVEL_SSL, 3);
enum AREA_BOB = LEVEL_AREA_INDEX(LevelNum.LEVEL_BOB, 1);
enum AREA_SL_OUTSIDE = LEVEL_AREA_INDEX(LevelNum.LEVEL_SL, 1);
enum AREA_SL_IGLOO = LEVEL_AREA_INDEX(LevelNum.LEVEL_SL, 2);
enum AREA_WDW_MAIN = LEVEL_AREA_INDEX(LevelNum.LEVEL_WDW, 1);
enum AREA_WDW_TOWN = LEVEL_AREA_INDEX(LevelNum.LEVEL_WDW, 2);
enum AREA_JRB_MAIN = LEVEL_AREA_INDEX(LevelNum.LEVEL_JRB, 1);
enum AREA_JRB_SHIP = LEVEL_AREA_INDEX(LevelNum.LEVEL_JRB, 2);
enum AREA_THI_HUGE = LEVEL_AREA_INDEX(LevelNum.LEVEL_THI, 1);
enum AREA_THI_TINY = LEVEL_AREA_INDEX(LevelNum.LEVEL_THI, 2);
enum AREA_THI_WIGGLER = LEVEL_AREA_INDEX(LevelNum.LEVEL_THI, 3);
enum AREA_TTC = LEVEL_AREA_INDEX(LevelNum.LEVEL_TTC, 1);
enum AREA_RR = LEVEL_AREA_INDEX(LevelNum.LEVEL_RR, 1);
enum AREA_CASTLE_GROUNDS = LEVEL_AREA_INDEX(LevelNum.LEVEL_CASTLE_GROUNDS, 1);
enum AREA_BITDW = LEVEL_AREA_INDEX(LevelNum.LEVEL_BITDW, 1);
enum AREA_VCUTM = LEVEL_AREA_INDEX(LevelNum.LEVEL_VCUTM, 1);
enum AREA_BITFS = LEVEL_AREA_INDEX(LevelNum.LEVEL_BITFS, 1);
enum AREA_SA = LEVEL_AREA_INDEX(LevelNum.LEVEL_SA, 1);
enum AREA_BITS = LEVEL_AREA_INDEX(LevelNum.LEVEL_BITS, 1);
enum AREA_LLL_OUTSIDE = LEVEL_AREA_INDEX(LevelNum.LEVEL_LLL, 1);
enum AREA_LLL_VOLCANO = LEVEL_AREA_INDEX(LevelNum.LEVEL_LLL, 2);
enum AREA_DDD_WHIRLPOOL = LEVEL_AREA_INDEX(LevelNum.LEVEL_DDD, 1);
enum AREA_DDD_SUB = LEVEL_AREA_INDEX(LevelNum.LEVEL_DDD, 2);
enum AREA_WF = LEVEL_AREA_INDEX(LevelNum.LEVEL_WF, 1);
enum AREA_ENDING = LEVEL_AREA_INDEX(LevelNum.LEVEL_ENDING, 1);
enum AREA_COURTYARD = LEVEL_AREA_INDEX(LevelNum.LEVEL_CASTLE_COURTYARD, 1);
enum AREA_PSS = LEVEL_AREA_INDEX(LevelNum.LEVEL_PSS, 1);
enum AREA_COTMC = LEVEL_AREA_INDEX(LevelNum.LEVEL_COTMC, 1);
enum AREA_TOTWC = LEVEL_AREA_INDEX(LevelNum.LEVEL_TOTWC, 1);
enum AREA_BOWSER_1 = LEVEL_AREA_INDEX(LevelNum.LEVEL_BOWSER_1, 1);
enum AREA_WMOTR = LEVEL_AREA_INDEX(LevelNum.LEVEL_WMOTR, 1);
enum AREA_BOWSER_2 = LEVEL_AREA_INDEX(LevelNum.LEVEL_BOWSER_2, 1);
enum AREA_BOWSER_3 = LEVEL_AREA_INDEX(LevelNum.LEVEL_BOWSER_3, 1);
enum AREA_TTM_OUTSIDE = LEVEL_AREA_INDEX(LevelNum.LEVEL_TTM, 1);

enum CAM_MODE_MARIO_ACTIVE = 0x01;
enum CAM_MODE_LAKITU_WAS_ZOOMED_OUT = 0x02;
enum CAM_MODE_MARIO_SELECTED = 0x04;

enum CAM_SELECTION_MARIO = 1;
enum CAM_SELECTION_FIXED = 2;

enum CAM_ANGLE_MARIO = 1;
enum CAM_ANGLE_LAKITU = 2;

enum CAMERA_MODE_NONE = 0x00;
enum CAMERA_MODE_RADIAL = 0x01;
enum CAMERA_MODE_OUTWARD_RADIAL = 0x02;
enum CAMERA_MODE_BEHIND_MARIO = 0x03;
enum CAMERA_MODE_CLOSE = 0x04; // Inside Castle / Big Boo's Haunt
enum CAMERA_MODE_C_UP = 0x06;
enum CAMERA_MODE_WATER_SURFACE = 0x08;
enum CAMERA_MODE_SLIDE_HOOT = 0x09;
enum CAMERA_MODE_INSIDE_CANNON = 0x0A;
enum CAMERA_MODE_BOSS_FIGHT = 0x0B;
enum CAMERA_MODE_PARALLEL_TRACKING = 0x0C;
enum CAMERA_MODE_FIXED = 0x0D;
enum CAMERA_MODE_8_DIRECTIONS = 0x0E; // AKA Parallel Camera, Bowser Courses & Rainbow Ride
enum CAMERA_MODE_FREE_ROAM = 0x10;
enum CAMERA_MODE_SPIRAL_STAIRS = 0x11;

enum CAM_MOVE_RETURN_TO_MIDDLE = 0x0001;
enum CAM_MOVE_ZOOMED_OUT = 0x0002;
enum CAM_MOVE_ROTATE_RIGHT = 0x0004;
enum CAM_MOVE_ROTATE_LEFT = 0x0008;
enum CAM_MOVE_ENTERED_ROTATE_SURFACE = 0x0010;
enum CAM_MOVE_METAL_BELOW_WATER = 0x0020;
enum CAM_MOVE_FIX_IN_PLACE = 0x0040;
enum CAM_MOVE_UNKNOWN_8 = 0x0080;
enum CAM_MOVING_INTO_MODE = 0x0100;
enum CAM_MOVE_STARTED_EXITING_C_UP = 0x0200;
enum CAM_MOVE_UNKNOWN_11 = 0x0400;
enum CAM_MOVE_INIT_CAMERA = 0x0800;
enum CAM_MOVE_ALREADY_ZOOMED_OUT = 0x1000;
enum CAM_MOVE_C_UP_MODE = 0x2000;
enum CAM_MOVE_SUBMERGED = 0x4000;
enum CAM_MOVE_PAUSE_SCREEN = 0x8000;

/**/
/// These flags force the camera to move a certain way
/**/

enum CAM_SOUND_C_UP_PLAYED = 0x01;
enum CAM_SOUND_MARIO_ACTIVE = 0x02;
enum CAM_SOUND_NORMAL_ACTIVE = 0x04;
enum CAM_SOUND_UNUSED_SELECT_MARIO = 0x08;
enum CAM_SOUND_UNUSED_SELECT_FIXED = 0x10;
enum CAM_SOUND_FIXED_ACTIVE = 0x20;

enum CAM_FLAG_SMOOTH_MOVEMENT = 0x0001;
enum CAM_FLAG_BLOCK_SMOOTH_MOVEMENT = 0x0002;
enum CAM_FLAG_FRAME_AFTER_CAM_INIT = 0x0004;
enum CAM_FLAG_CHANGED_PARTRACK_INDEX = 0x0008;
enum CAM_FLAG_CCM_SLIDE_SHORTCUT = 0x0010;
enum CAM_FLAG_CAM_NEAR_WALL = 0x0020;
enum CAM_FLAG_SLEEPING = 0x0040;
enum CAM_FLAG_UNUSED_7 = 0x0080;
enum CAM_FLAG_UNUSED_8 = 0x0100;
enum CAM_FLAG_COLLIDED_WITH_WALL = 0x0200;
enum CAM_FLAG_START_TRANSITION = 0x0400;
enum CAM_FLAG_TRANSITION_OUT_OF_C_UP = 0x0800;
enum CAM_FLAG_BLOCK_AREA_PROCESSING = 0x1000;
enum CAM_FLAG_UNUSED_13 = 0x2000;
enum CAM_FLAG_UNUSED_CUTSCENE_ACTIVE = 0x4000;
enum CAM_FLAG_BEHIND_MARIO_POST_DOOR = 0x8000;

enum CAM_STATUS_NONE = 0;
enum CAM_STATUS_MARIO = 1 << 0;
enum CAM_STATUS_LAKITU = 1 << 1;
enum CAM_STATUS_FIXED = 1 << 2;
enum CAM_STATUS_C_DOWN = 1 << 3;
enum CAM_STATUS_C_UP = 1 << 4;

enum CAM_STATUS_MODE_GROUP = CAM_STATUS_MARIO | CAM_STATUS_LAKITU | CAM_STATUS_FIXED;
enum CAM_STATUS_C_MODE_GROUP = CAM_STATUS_C_DOWN | CAM_STATUS_C_UP;

enum SHAKE_ATTACK = 1;
enum SHAKE_GROUND_POUND = 2;
enum SHAKE_SMALL_DAMAGE = 3;
enum SHAKE_MED_DAMAGE = 4;
enum SHAKE_LARGE_DAMAGE = 5;
enum SHAKE_HIT_FROM_BELOW = 8;
enum SHAKE_FALL_DAMAGE = 9;
enum SHAKE_SHOCK = 10;

enum SHAKE_ENV_EXPLOSION = 1;
enum SHAKE_ENV_BOWSER_THROW_BOUNCE = 2;
enum SHAKE_ENV_BOWSER_JUMP = 3;
enum SHAKE_ENV_UNUSED_5 = 5;
enum SHAKE_ENV_UNUSED_6 = 6;
enum SHAKE_ENV_UNUSED_7 = 7;
enum SHAKE_ENV_PYRAMID_EXPLODE = 8;
enum SHAKE_ENV_JRB_SHIP_DRAIN = 9;
enum SHAKE_ENV_FALLING_BITS_PLAT = 10;

enum SHAKE_FOV_SMALL = 1;
enum SHAKE_FOV_UNUSED = 2;
enum SHAKE_FOV_MEDIUM = 3;
enum SHAKE_FOV_LARGE = 4;

enum SHAKE_POS_SMALL = 1;
enum SHAKE_POS_MEDIUM = 2;
enum SHAKE_POS_LARGE = 3;
enum SHAKE_POS_BOWLING_BALL = 4;

enum CUTSCENE_DOOR_PULL = 130;
enum CUTSCENE_DOOR_PUSH = 131;
enum CUTSCENE_ENTER_CANNON = 133;
enum CUTSCENE_ENTER_PAINTING = 134;
enum CUTSCENE_DEATH_EXIT = 135;
enum CUTSCENE_DOOR_WARP = 139;
enum CUTSCENE_DOOR_PULL_MODE = 140;
enum CUTSCENE_DOOR_PUSH_MODE = 141;
enum CUTSCENE_INTRO_PEACH = 142;
enum CUTSCENE_DANCE_ROTATE = 143;
enum CUTSCENE_ENTER_BOWSER_ARENA = 144;
enum CUTSCENE_0F_UNUSED = 145; // Never activated, stub cutscene functions
enum CUTSCENE_UNUSED_EXIT = 147; // Never activated
enum CUTSCENE_SLIDING_DOORS_OPEN = 149;
enum CUTSCENE_PREPARE_CANNON = 150;
enum CUTSCENE_UNLOCK_KEY_DOOR = 151;
enum CUTSCENE_STANDING_DEATH = 152;
enum CUTSCENE_DEATH_ON_STOMACH = 153;
enum CUTSCENE_DEATH_ON_BACK = 154;
enum CUTSCENE_QUICKSAND_DEATH = 155;
enum CUTSCENE_SUFFOCATION_DEATH = 156;
enum CUTSCENE_EXIT_BOWSER_SUCC = 157;
enum CUTSCENE_EXIT_BOWSER_DEATH = 158; // Never activated
enum CUTSCENE_WATER_DEATH = 159; // Not in cutscene switch
enum CUTSCENE_EXIT_PAINTING_SUCC = 160;
enum CUTSCENE_CAP_SWITCH_PRESS = 161;
enum CUTSCENE_DIALOG = 162;
enum CUTSCENE_RACE_DIALOG = 163;
enum CUTSCENE_ENTER_PYRAMID_TOP = 164;
enum CUTSCENE_DANCE_FLY_AWAY = 165;
enum CUTSCENE_DANCE_CLOSEUP = 166;
enum CUTSCENE_KEY_DANCE = 167;
enum CUTSCENE_SSL_PYRAMID_EXPLODE = 168; // Never activated
enum CUTSCENE_EXIT_SPECIAL_SUCC = 169;
enum CUTSCENE_NONPAINTING_DEATH = 170;
enum CUTSCENE_READ_MESSAGE = 171;
enum CUTSCENE_ENDING = 172;
enum CUTSCENE_STAR_SPAWN = 173;
enum CUTSCENE_GRAND_STAR = 174;
enum CUTSCENE_DANCE_DEFAULT = 175;
enum CUTSCENE_RED_COIN_STAR_SPAWN = 176;
enum CUTSCENE_END_WAVING = 177;
enum CUTSCENE_CREDITS = 178;
enum CUTSCENE_EXIT_WATERFALL = 179;
enum CUTSCENE_EXIT_FALL_WMOTR = 180;
enum CUTSCENE_ENTER_POOL = 181;

/**
 * Stop the cutscene.
 */
enum CUTSCENE_STOP = 0x8000;
/**
 * Play the current cutscene shot indefinitely (until canceled).
 */
enum CUTSCENE_LOOP = 0x7FFF;

enum HAND_CAM_SHAKE_OFF = 0;
enum HAND_CAM_SHAKE_CUTSCENE = 1;
enum HAND_CAM_SHAKE_UNUSED = 2;
enum HAND_CAM_SHAKE_HANG_OWL = 3;
enum HAND_CAM_SHAKE_HIGH = 4;
enum HAND_CAM_SHAKE_STAR_DANCE = 5;
enum HAND_CAM_SHAKE_LOW = 6;

enum DOOR_DEFAULT = 0;
enum DOOR_LEAVING_SPECIAL = 1;
enum DOOR_ENTER_LOBBY = 2;

// Might rename these to reflect what they are used for instead "SET_45" etc.
enum CAM_FOV_SET_45 = 1;
enum CAM_FOV_DEFAULT = 2;
enum CAM_FOV_APP_45 = 4;
enum CAM_FOV_SET_30 = 5;
enum CAM_FOV_APP_20 = 6;
enum CAM_FOV_BBH = 7;
enum CAM_FOV_APP_80 = 9;
enum CAM_FOV_APP_30 = 10;
enum CAM_FOV_APP_60 = 11;
enum CAM_FOV_ZOOM_30 = 12;
enum CAM_FOV_SET_29 = 13;

enum CAM_EVENT_CANNON = 1;
enum CAM_EVENT_SHOT_FROM_CANNON = 2;
enum CAM_EVENT_UNUSED_3 = 3;
enum CAM_EVENT_BOWSER_INIT = 4;
enum CAM_EVENT_DOOR_WARP = 5;
enum CAM_EVENT_DOOR = 6;
enum CAM_EVENT_BOWSER_JUMP = 7;
enum CAM_EVENT_BOWSER_THROW_BOUNCE = 8;
enum CAM_EVENT_START_INTRO = 9;
enum CAM_EVENT_START_GRAND_STAR = 10;
enum CAM_EVENT_START_ENDING = 11;
enum CAM_EVENT_START_END_WAVING = 12;
enum CAM_EVENT_START_CREDITS = 13;

/**
 * A copy of player information that is relevant to the camera.
 */
struct PlayerCameraState
{
    /**
     * Mario's action on this frame.
     */
    /*0x00*/ uint action;
    /*0x04*/ Vec3f pos;
    /*0x10*/ Vec3s faceAngle;
    /*0x16*/ Vec3s headRotation;
    /*0x1C*/ s16 unused;
    /**
     * Set to nonzero when an event, such as entering a door, starting the credits, or throwing bowser,
     * has happened on this frame.
     */
    /*0x1E*/ s16 cameraEvent;
    /*0x20*/ Object_* usedObj;
}

/**
 * Struct containing info that is used when transition_next_state() is called. Stores the intermediate
 * distances and angular displacements from lakitu's goal position and focus.
 */
struct TransitionInfo
{
    /*0x00*/ s16 posPitch;
    /*0x02*/ s16 posYaw;
    /*0x04*/ f32 posDist;
    /*0x08*/ s16 focPitch;
    /*0x0A*/ s16 focYaw;
    /*0x0C*/ f32 focDist;
    /*0x10*/ int framesLeft;
    /*0x14*/ Vec3f marioPos;
    /*0x20*/ u8 pad; // for the structs to align, there has to be an extra unused variable here. type is unknown.
}

/**
 * A point that's used in a spline, controls the direction to move the camera in
 * during the shake effect.
 */
struct HandheldShakePoint
{
    /*0x00*/ byte index; // only set to -1
    /*0x04 (aligned)*/ uint pad;
    /*0x08*/ Vec3s point;
} // size = 0x10

// These are the same type, but the name that is used depends on context.
/**
 * A function that is called by CameraTriggers and cutscene shots.
 * These are concurrent: multiple CameraEvents can occur on the same frame.
 */
alias CameraEvent = int function (Camera* c);
/**
 * The same type as a CameraEvent, but because these are generally longer, and happen in sequential
 * order, they're are called "shots," a term taken from cinematography.
 *
 * To further tell the difference: CutsceneShots usually call multiple CameraEvents at once, but only
 * one CutsceneShot is ever called on a given frame.
 */
alias CutsceneShot = int function ();

/**
 * Defines a bounding box which activates an event while Mario is inside
 */
struct CameraTrigger
{
    /**
     * The area this should be checked in, or -1 if it should run in every area of the level.
     *
     * Triggers with area set to -1 are run by default, they don't care if Mario is inside their bounds.
     * However, they are only active if Mario is not already inside an area-specific trigger's
     * boundaries.
     */
    byte area;
    /// A function that gets called while Mario is in the trigger bounds
    CameraEvent event;
    // The (x,y,z) position of the center of the bounding box
    s16 centerX;
    s16 centerY;
    s16 centerZ;
    // The max displacement in x, y, and z from the center for a point to be considered inside the
    // bounding box
    s16 boundsX;
    s16 boundsY;
    s16 boundsZ;
    /// This angle rotates Mario's offset from the box's origin, before it is checked for being inside.
    s16 boundsYaw;
}

/**
 * A camera shot that is active for a number of frames.
 * Together, a sequence of shots makes up a cutscene.
 */
struct Cutscene
{
    /// The function that gets called.
    CutsceneShot shot;
    /// How long the shot lasts.
    s16 duration;
}

/**
 * Info for the camera's field of view and the FOV shake effect.
 */
struct CameraFOVStatus
{
    /// The current function being used to set the camera's field of view (before any fov shake is applied).
    /*0x00*/ u8 fovFunc;
    /// The current field of view in degrees
    /*0x04*/ f32 fov;

    // Fields used by shake_camera_fov()

    /// The amount to change the current fov by in the fov shake effect.
    /*0x08*/ f32 fovOffset;
    /// A bool set in fov_default() but unused otherwise
    /*0x0C*/ uint unusedIsSleeping;
    /// The range in degrees to shake fov
    /*0x10*/ f32 shakeAmplitude;
    /// Used to calculate fovOffset, the phase through the shake's period.
    /*0x14*/ s16 shakePhase;
    /// How much to progress through the shake period
    /*0x16*/ s16 shakeSpeed;
    /// How much to decrease shakeAmplitude each frame.
    /*0x18*/ s16 decay;
}

/**
 * Information for a control point in a spline segment.
 */
struct CutsceneSplinePoint
{
    /* The index of this point in the spline. Ignored except for -1, which ends the spline.
       An index of -1 should come four points after the start of the last segment. */
    byte index;
    /* Roughly controls the number of frames it takes to progress through the spline segment.
       See move_point_along_spline() in camera.c */
    u8 speed;
    Vec3s point;
}

/**
 * Struct containing the nearest floor and ceiling to the player, as well as the previous floor and
 * ceiling. It also stores their distances from the player's position.
 */
struct PlayerGeometry
{
    /*0x00*/ Surface* currFloor;
    /*0x04*/ f32 currFloorHeight;
    /*0x08*/ s16 currFloorType;
    /*0x0C*/ Surface* currCeil;
    /*0x10*/ s16 currCeilType;
    /*0x14*/ f32 currCeilHeight;
    /*0x18*/ Surface* prevFloor;
    /*0x1C*/ f32 prevFloorHeight;
    /*0x20*/ s16 prevFloorType;
    /*0x24*/ Surface* prevCeil;
    /*0x28*/ f32 prevCeilHeight;
    /*0x2C*/ s16 prevCeilType;
    /// Unused, but recalculated every frame
    /*0x30*/ f32 waterHeight;
}

/**
 * Point used in transitioning between camera modes and C-Up.
 */
struct LinearTransitionPoint
{
    Vec3f focus;
    Vec3f pos;
    f32 dist;
    s16 pitch;
    s16 yaw;
}

/**
 * Info about transitioning between camera modes.
 */
struct ModeTransitionInfo
{
    s16 newMode;
    s16 lastMode;
    s16 max;
    s16 frame;
    LinearTransitionPoint transitionStart;
    LinearTransitionPoint transitionEnd;
}

/**
 * A point in a path used by update_parallel_tracking_camera
 */
struct ParallelTrackingPoint
{
    /// Whether this point is the start of a path
    s16 startOfPath;
    /// Point used to define a line segment to follow
    Vec3f pos;
    /// The distance Mario can move along the line before the camera should move
    f32 distThresh;
    /// The percentage that the camera should move from the line to Mario
    f32 zoom;
}

/**
 * Stores the camera's info
 */
struct CameraStoredInfo
{
    /*0x00*/ Vec3f pos;
    /*0x0C*/ Vec3f focus;
    /*0x18*/ f32 panDist;
    /*0x1C*/ f32 cannonYOffset;
}

/**
 * Struct used to store cutscene info, like the camera's target position/focus.
 *
 * See the sCutsceneVars[] array in camera.c for more details.
 */
struct CutsceneVariable
{
    /// Perhaps an index
    int unused1;
    Vec3f point;
    Vec3f unusedPoint;
    Vec3s angle;
    /// Perhaps a boolean or an extra angle
    s16 unused2;
}

/**
 * The main camera struct. Gets updated by the active camera mode and the current level/area. In
 * update_lakitu, its pos and focus are used to calculate lakitu's next position and focus, which are
 * then used to render the game.
 */
struct Camera
{
    /*0x00*/ u8 mode; // What type of mode the camera uses (see defines above)
    /*0x01*/ u8 defMode;
    /**
     * Determines what direction Mario moves in when the analog stick is moved.
     *
     * @warning This is NOT the camera's xz-rotation in world space. This is the angle calculated from the
     *          camera's focus TO the camera's position, instead of the other way around like it should
     *          be. It's effectively the opposite of the camera's actual yaw. Use
     *          vec3f_get_dist_and_angle() if you need the camera's yaw.
     */
    /*0x02*/ s16 yaw;
    /*0x04*/ Vec3f focus;
    /*0x10*/ Vec3f pos;
    /*0x1C*/ Vec3f unusedVec1;
    /// The x coordinate of the "center" of the area. The camera will rotate around this point.
    /// For example, this is what makes the camera rotate around the hill in BoB
    /*0x28*/ f32 areaCenX;
    /// The z coordinate of the "center" of the area. The camera will rotate around this point.
    /// For example, this is what makes the camera rotate around the hill in BoB
    /*0x2C*/ f32 areaCenZ;
    /*0x30*/ u8 cutscene;
    /*0x31*/ u8[0x8] filler31;
    /*0x3A*/ s16 nextYaw;
    /*0x3C*/ u8[0x28] filler3C;
    /*0x64*/ u8 doorStatus;
    /// The y coordinate of the "center" of the area. Unlike areaCenX and areaCenZ, this is only used
    /// when paused. See zoom_out_if_paused_and_outside
    /*0x68*/ f32 areaCenY;
}

/**
 * A struct containing info pertaining to lakitu, such as his position and focus, and what
 * camera-related effects are happening to him, like camera shakes.
 *
 * This struct's pos and focus are what is actually used to render the game.
 *
 * @see update_lakitu()
 */
struct LakituState
{
    /**
     * Lakitu's position, which (when CAM_FLAG_SMOOTH_MOVEMENT is set), approaches his goalPos every frame.
     */
    /*0x00*/ Vec3f curFocus;
    /**
     * Lakitu's focus, which (when CAM_FLAG_SMOOTH_MOVEMENT is set), approaches his goalFocus every frame.
     */
    /*0x0C*/ Vec3f curPos;
    /**
     * The focus point that lakitu turns towards every frame.
     * If CAM_FLAG_SMOOTH_MOVEMENT is unset, this is the same as curFocus.
     */
    /*0x18*/ Vec3f goalFocus;
    /**
     * The point that lakitu flies towards every frame.
     * If CAM_FLAG_SMOOTH_MOVEMENT is unset, this is the same as curPos.
     */
    /*0x24*/ Vec3f goalPos;

    /*0x30*/ u8[12] filler30; // extra unused Vec3f?

    /// Copy of the active camera mode
    /*0x3C*/ u8 mode;
    /// Copy of the default camera mode
    /*0x3D*/ u8 defMode;

    /*0x3E*/ u8[10] filler3E;

    /*0x48*/ f32 focusDistance; // unused
    /*0x4C*/ s16 oldPitch; // unused
    /*0x4E*/ s16 oldYaw; // unused
    /*0x50*/ s16 oldRoll; // unused

    /// The angular offsets added to lakitu's pitch, yaw, and roll
    /*0x52*/ Vec3s shakeMagnitude;

    // shake pitch, yaw, and roll phase: The progression through the camera shake (a cosine wave).
    // shake pitch, yaw, and roll vel: The speed of the camera shake.
    // shake pitch, yaw, and roll decay: The shake's deceleration.
    /*0x58*/ s16 shakePitchPhase;
    /*0x5A*/ s16 shakePitchVel;
    /*0x5C*/ s16 shakePitchDecay;

    /*0x60*/ Vec3f unusedVec1;
    /*0x6C*/ Vec3s unusedVec2;
    /*0x72*/ u8[8] filler72;

    /// Used to rotate the screen when rendering.
    /*0x7A*/ s16 roll;
    /// Copy of the camera's yaw.
    /*0x7C*/ s16 yaw;
    /// Copy of the camera's next yaw.
    /*0x7E*/ s16 nextYaw;
    /// The actual focus point the game uses to render.
    /*0x80*/ Vec3f focus;
    /// The actual position the game is rendered from.
    /*0x8C*/ Vec3f pos;

    // Shake variables: See above description
    /*0x98*/ s16 shakeRollPhase;
    /*0x9A*/ s16 shakeRollVel;
    /*0x9C*/ s16 shakeRollDecay;
    /*0x9E*/ s16 shakeYawPhase;
    /*0xA0*/ s16 shakeYawVel;
    /*0xA2*/ s16 shakeYawDecay;

    // focH,Vspeed: how fast lakitu turns towards his goalFocus.
    /// By default HSpeed is 0.8, so lakitu turns 80% of the horz distance to his goal each frame.
    /*0xA4*/ f32 focHSpeed;
    /// By default VSpeed is 0.3, so lakitu turns 30% of the vert distance to his goal each frame.
    /*0xA8*/ f32 focVSpeed;

    // posH,Vspeed: How fast lakitu flies towards his goalPos.
    /// By default they are 0.3, so lakitu will fly 30% of the way towards his goal each frame.
    /*0xAC*/ f32 posHSpeed;
    /*0xB0*/ f32 posVSpeed;

    /// The roll offset applied during part of the key dance cutscene
    /*0xB4*/ s16 keyDanceRoll;
    /// Mario's action from the previous frame. Only used to determine if Mario just finished a dive.
    /*0xB8*/ uint lastFrameAction;
    /*0xBC*/ s16 unused;
}

// bss order hack to not affect BSS order. if possible, remove me, but it will be hard to match otherwise

// BSS
extern __gshared s16 sSelectionFlags;
extern __gshared s16 sCameraSoundFlags;
extern __gshared u16 sCButtonsPressed;
extern __gshared PlayerCameraState[2] gPlayerCameraState;
extern __gshared LakituState gLakituState;
extern __gshared s16 gCameraMovementFlags;
extern __gshared int gObjCutsceneDone;
extern __gshared Camera* gCamera;

extern __gshared Object_* gCutsceneFocus;
extern __gshared Object_* gSecondCameraFocus;
extern __gshared u8 gRecentCutscene;

// TODO: sort all of this extremely messy shit out after the split

void set_camera_shake_from_hit (s16 shake);
void set_environmental_camera_shake (s16 shake);
void set_camera_shake_from_point (s16 shake, f32 posX, f32 posY, f32 posZ);
void move_mario_head_c_up (Camera* c);
void transition_next_state (Camera* c, s16 frames);
void set_camera_mode (Camera* c, s16 mode, s16 frames);
void update_camera (Camera* c);
void reset_camera (Camera* c);
void init_camera (Camera* c);
void select_mario_cam_mode ();
Gfx* geo_camera_main (int callContext, GraphNode* g, void* context);
void stub_camera_2 (Camera* c);
void stub_camera_3 (Camera* c);
void vec3f_sub (ref Vec3f dst, ref Vec3f src);
void object_pos_to_vec3f (ref Vec3f dst, Object_* o);
void vec3f_to_object_pos (Object_* o, ref Vec3f src);
int move_point_along_spline (ref Vec3f p, CutsceneSplinePoint* spline, s16* splineSegment, f32* progress);
int cam_select_alt_mode (int angle);
int set_cam_angle (int mode);
void set_handheld_shake (u8 mode);
void shake_camera_handheld (ref Vec3f pos, ref Vec3f focus);
int find_c_buttons_pressed (u16 currentState, u16 buttonsPressed, u16 buttonsDown);
int update_camera_hud_status (Camera* c);
int collide_with_walls (ref Vec3f pos, f32 offsetY, f32 radius);
int clamp_pitch (ref Vec3f from, ref Vec3f to, s16 maxPitch, s16 minPitch);
int is_within_100_units_of_mario (f32 posX, f32 posY, f32 posZ);
int set_or_approach_f32_asymptotic (f32* dst, f32 goal, f32 scale);
int approach_f32_asymptotic_bool (f32* current, f32 target, f32 multiplier);
f32 approach_f32_asymptotic (f32 current, f32 target, f32 multiplier);
int approach_s16_asymptotic_bool (s16* current, s16 target, s16 divisor);
int approach_s16_asymptotic (s16 current, s16 target, s16 divisor);
void approach_vec3f_asymptotic (ref Vec3f current, ref Vec3f target, f32 xMul, f32 yMul, f32 zMul);
void set_or_approach_vec3f_asymptotic (ref Vec3f dst, ref Vec3f goal, f32 xMul, f32 yMul, f32 zMul);
int camera_approach_s16_symmetric_bool (s16* current, s16 target, s16 increment);
int set_or_approach_s16_symmetric (s16* current, s16 target, s16 increment);
int camera_approach_f32_symmetric_bool (f32* current, f32 target, f32 increment);
f32 camera_approach_f32_symmetric (f32 value, f32 target, f32 increment);
void random_vec3s (ref Vec3s dst, s16 xRange, s16 yRange, s16 zRange);
int clamp_positions_and_find_yaw (ref Vec3f pos, ref Vec3f origin, f32 xMax, f32 xMin, f32 zMax, f32 zMin);
int is_range_behind_surface (ref Vec3f from, ref Vec3f to, Surface* surf, s16 range, s16 surfType);
void scale_along_line (ref Vec3f dest, ref Vec3f from, ref Vec3f to, f32 scale);
s16 calculate_pitch (ref Vec3f from, ref Vec3f to);
s16 calculate_yaw (ref Vec3f from, ref Vec3f to);
void calculate_angles (ref Vec3f from, ref Vec3f to, s16* pitch, s16* yaw);
f32 calc_abs_dist (ref Vec3f a, ref Vec3f b);
f32 calc_hor_dist (ref Vec3f a, ref Vec3f b);
void rotate_in_xz (ref Vec3f dst, ref Vec3f src, s16 yaw);
void rotate_in_yz (ref Vec3f dst, ref Vec3f src, s16 pitch);
void set_camera_pitch_shake (s16 mag, s16 decay, s16 inc);
void set_camera_yaw_shake (s16 mag, s16 decay, s16 inc);
void set_camera_roll_shake (s16 mag, s16 decay, s16 inc);
void set_pitch_shake_from_point (s16 mag, s16 decay, s16 inc, f32 maxDist, f32 posX, f32 posY, f32 posZ);
void shake_camera_pitch (ref Vec3f pos, ref Vec3f focus);
void shake_camera_yaw (ref Vec3f pos, ref Vec3f focus);
void shake_camera_roll (s16* roll);
int offset_yaw_outward_radial (Camera* c, s16 areaYaw);
void play_camera_buzz_if_cdown ();
void play_camera_buzz_if_cbutton ();
void play_camera_buzz_if_c_sideways ();
void play_sound_cbutton_up ();
void play_sound_cbutton_down ();
void play_sound_cbutton_side ();
void play_sound_button_change_blocked ();
void play_sound_rbutton_changed ();
void play_sound_if_cam_switched_to_lakitu_or_mario ();
int radial_camera_input (Camera* c, f32 unused);
int trigger_cutscene_dialog (int trigger);
void handle_c_button_movement (Camera* c);
void start_cutscene (Camera* c, u8 cutscene);
u8 get_cutscene_from_mario_status (Camera* c);
void warp_camera (f32 displacementX, f32 displacementY, f32 displacementZ);
void approach_camera_height (Camera* c, f32 goal, f32 inc);
void offset_rotated (ref Vec3f dst, ref Vec3f from, ref Vec3f to, ref Vec3s rotation);
s16 next_lakitu_state (ref Vec3f newPos, ref Vec3f newFoc, ref Vec3f curPos, ref Vec3f curFoc, ref Vec3f oldPos, ref Vec3f oldFoc, s16 yaw);
void set_fixed_cam_axis_sa_lobby (s16 preset);
s16 camera_course_processing (Camera* c);
void resolve_geometry_collisions (ref Vec3f pos, ref Vec3f lastGood);
int rotate_camera_around_walls (Camera* c, ref Vec3f cPos, s16* avoidYaw, s16 yawRange);
void find_mario_floor_and_ceil (PlayerGeometry* pg);
u8 start_object_cutscene_without_focus (u8 cutscene);
s16 cutscene_object_with_dialog (u8 cutscene, Object_* o, s16 dialogID);
s16 cutscene_object_without_dialog (u8 cutscene, Object_* o);
s16 cutscene_object (u8 cutscene, Object_* o);
void play_cutscene (Camera* c);
int cutscene_event (CameraEvent event, Camera* c, s16 start, s16 end);
int cutscene_spawn_obj (uint obj, s16 frame);
void set_fov_shake (s16 amplitude, s16 decay, s16 shakeSpeed);

void set_fov_function (u8 func);
void cutscene_set_fov_shake_preset (u8 preset);
void set_fov_shake_from_point_preset (u8 preset, f32 posX, f32 posY, f32 posZ);
void obj_rotate_towards_point (Object_* o, ref Vec3f point, s16 pitchOff, s16 yawOff, s16 pitchDiv, s16 yawDiv);

Gfx* geo_camera_fov (int callContext, GraphNode* g, void* context);

// CAMERA_H
