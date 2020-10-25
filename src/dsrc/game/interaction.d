module game.interaction;

import ultra64, types;

extern (C):

/* 0x00000001 */
/* 0x00000002 */
/* 0x00000004 */
/* 0x00000008 */
/* 0x00000010 */
/* 0x00000020 */
/* 0x00000040 */
/* 0x00000080 */
/* 0x00000100 */
/* 0x00000200 */
/* 0x00000400 */
/* 0x00000800 */
/* 0x00001000 */
/* 0x00002000 */
/* 0x00004000 */
/* 0x00008000 */
/* 0x00010000 */
/* 0x00020000 */
/* 0x00040000 */
/* 0x00080000 */
/* 0x00100000 */
/* 0x00200000 */
/* 0x00400000 */
/* 0x00800000 */
/* 0x01000000 */
/* 0x02000000 */
/* 0x04000000 */
/* 0x08000000 */
/* 0x10000000 */
/* 0x20000000 */
/* 0x40000000 */
/* 0x80000000 */

// INTERACT_WARP
enum INT_SUBTYPE_FADING_WARP = 0x00000001;

// Damaging interactions
enum INT_SUBTYPE_DELAY_INVINCIBILITY = 0x00000002;
enum INT_SUBTYPE_BIG_KNOCKBACK       = 0x00000008; /* Used by Bowser, sets Mario's forward velocity to 40 on hit */

// INTERACT_GRABBABLE
enum INT_SUBTYPE_GRABS_MARIO      = 0x00000004; /* Also makes the object heavy */
enum INT_SUBTYPE_HOLDABLE_NPC     = 0x00000010; /* Allows the object to be gently dropped, and sets vertical speed to 0 when dropped with no forwards velocity */
enum INT_SUBTYPE_DROP_IMMEDIATELY = 0x00000040; /* This gets set by grabbable NPCs that talk to Mario to make him drop them after the dialog is finished */
enum INT_SUBTYPE_KICKABLE         = 0x00000100;
enum INT_SUBTYPE_NOT_GRABBABLE    = 0x00000200; /* Used by Heavy-Ho to allow it to throw Mario, without Mario being able to pick it up */

// INTERACT_DOOR
enum INT_SUBTYPE_STAR_DOOR = 0x00000020;

//INTERACT_BOUNCE_TOP
enum INT_SUBTYPE_TWIRL_BOUNCE = 0x00000080;

// INTERACT_STAR_OR_KEY
enum INT_SUBTYPE_NO_EXIT    = 0x00000400;
enum INT_SUBTYPE_GRAND_STAR = 0x00000800;

// INTERACT_TEXT
enum INT_SUBTYPE_SIGN = 0x00001000;
enum INT_SUBTYPE_NPC  = 0x00004000;

// INTERACT_CLAM_OR_BUBBA
enum INT_SUBTYPE_EATS_MARIO = 0x00002000;

enum ATTACK_PUNCH                 = 1;
enum ATTACK_KICK_OR_TRIP          = 2;
enum ATTACK_FROM_ABOVE            = 3;
enum ATTACK_GROUND_POUND_OR_TWIRL = 4;
enum ATTACK_FAST_ATTACK           = 5;
enum ATTACK_FROM_BELOW            = 6;

enum INT_STATUS_ATTACK_MASK = 0x000000FF;

enum INT_STATUS_HOOT_GRABBED_BY_MARIO = 1 << 0; /* 0x00000001 */
enum INT_STATUS_MARIO_UNK1            = 1 << 1; /* 0x00000002 */
enum INT_STATUS_MARIO_UNK2            = 1 << 2; /* 0x00000004 */
enum INT_STATUS_MARIO_DROP_OBJECT     = 1 << 3; /* 0x00000008 */
enum INT_STATUS_HIT_BY_SHOCKWAVE      = 1 << 4; /* 0x00000010 */
enum INT_STATUS_MARIO_UNK5            = 1 << 5; /* 0x00000020 */
enum INT_STATUS_MARIO_UNK6            = 1 << 6; /* 0x00000040 */
enum INT_STATUS_MARIO_UNK7            = 1 << 7; /* 0x00000080 */
enum INT_STATUS_GRABBED_MARIO         = 1 << 11; /* 0x00000800 */
enum INT_STATUS_ATTACKED_MARIO        = 1 << 13; /* 0x00002000 */
enum INT_STATUS_WAS_ATTACKED          = 1 << 14; /* 0x00004000 */
enum INT_STATUS_INTERACTED            = 1 << 15; /* 0x00008000 */
enum INT_STATUS_TRAP_TURN             = 1 << 20; /* 0x00100000 */
enum INT_STATUS_HIT_MINE              = 1 << 21; /* 0x00200000 */
enum INT_STATUS_STOP_RIDING           = 1 << 22; /* 0x00400000 */
enum INT_STATUS_TOUCHED_BOB_OMB       = 1 << 23; /* 0x00800000 */

short mario_obj_angle_to_object (MarioState* m, Object* o);
void mario_stop_riding_object (MarioState* m);
void mario_grab_used_object (MarioState* m);
void mario_drop_held_object (MarioState* m);
void mario_throw_held_object (MarioState* m);
void mario_stop_riding_and_holding (MarioState* m);
uint does_mario_have_normal_cap_on_head (MarioState* m);
void mario_blow_off_cap (MarioState* m, f32 capSpeed);
uint mario_lose_cap_to_enemy (uint arg);
void mario_retrieve_cap ();
Object* mario_get_collided_object (MarioState* m, uint interactType);
uint mario_check_object_grab (MarioState* m);
uint get_door_save_file_flag (Object* door);
void mario_process_interactions (MarioState* m);
void mario_handle_special_floors (MarioState* m);

// INTERACTION_H
