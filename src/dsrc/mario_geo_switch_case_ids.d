module mario_geo_switch_case_ids;

import util, ultra64;

extern (C):

/* Mario Geo-Switch-Case IDs */

enum MarioEyesGSCId : s8
{
    /*0x00*/ MARIO_EYES_BLINK       = 0,
    /*0x01*/ MARIO_EYES_OPEN        = 1,
    /*0x02*/ MARIO_EYES_HALF_CLOSED = 2,
    /*0x03*/ MARIO_EYES_CLOSED      = 3,
    /*0x04*/ MARIO_EYES_LOOK_LEFT   = 4, // unused
    /*0x05*/ MARIO_EYES_LOOK_RIGHT  = 5, // unused
    /*0x06*/ MARIO_EYES_LOOK_UP     = 6, // unused
    /*0x07*/ MARIO_EYES_LOOK_DOWN   = 7, // unused
    /*0x08*/ MARIO_EYES_DEAD        = 8
}
mixin importEnumMembers!MarioEyesGSCId;

enum MarioHandGSCId : s8
{
    /*0x00*/ MARIO_HAND_FISTS            = 0,
    /*0x01*/ MARIO_HAND_OPEN             = 1,
    /*0x02*/ MARIO_HAND_PEACE_SIGN       = 2,
    /*0x03*/ MARIO_HAND_HOLDING_CAP      = 3,
    /*0x04*/ MARIO_HAND_HOLDING_WING_CAP = 4,
    /*0x05*/ MARIO_HAND_RIGHT_OPEN       = 5
}
mixin importEnumMembers!MarioHandGSCId;

enum MarioCapGSCId : s8
{
    /*0x00*/ MARIO_HAS_DEFAULT_CAP_ON  = 0,
    /*0x01*/ MARIO_HAS_DEFAULT_CAP_OFF = 1,
    /*0x02*/ MARIO_HAS_WING_CAP_ON     = 2,
    /*0x03*/ MARIO_HAS_WING_CAP_OFF    = 3 // unused
}
mixin importEnumMembers!MarioCapGSCId;

enum MarioGrabPosGSCId : s8
{
    /*0x00*/ GRAB_POS_NULL      = 0,
    /*0x01*/ GRAB_POS_LIGHT_OBJ = 1,
    /*0x02*/ GRAB_POS_HEAVY_OBJ = 2,
    /*0x03*/ GRAB_POS_BOWSER    = 3
}
mixin importEnumMembers!MarioGrabPosGSCId;

// MARIO_GEO_SWITCH_CASE_IDS_H
