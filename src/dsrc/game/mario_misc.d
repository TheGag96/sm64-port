module game.mario_misc;

import ultra64, types, gbi;

extern (C):

extern __gshared GraphNodeObject gMirrorMario;
extern __gshared MarioBodyState[2] gBodyStates;

Gfx* geo_draw_mario_head_goddard (s32 callContext, GraphNode* node, Mat4* c);
void bhv_toad_message_loop ();
void bhv_toad_message_init ();
void bhv_unlock_door_star_init ();
void bhv_unlock_door_star_loop ();
Gfx* geo_mirror_mario_set_alpha (s32 callContext, GraphNode* node, Mat4* c);
Gfx* geo_switch_mario_stand_run (s32 callContext, GraphNode* node, Mat4* mtx);
Gfx* geo_switch_mario_eyes (s32 callContext, GraphNode* node, Mat4* c);
Gfx* geo_mario_tilt_torso (s32 callContext, GraphNode* node, Mat4* c);
Gfx* geo_mario_head_rotation (s32 callContext, GraphNode* node, Mat4* c);
Gfx* geo_switch_mario_hand (s32 callContext, GraphNode* node, Mat4* c);
Gfx* geo_mario_hand_foot_scaler (s32 callContext, GraphNode* node, Mat4* c);
Gfx* geo_switch_mario_cap_effect (s32 callContext, GraphNode* node, Mat4* c);
Gfx* geo_switch_mario_cap_on_off (s32 callContext, GraphNode* node, Mat4* c);
Gfx* geo_mario_rotate_wing_cap_wings (s32 callContext, GraphNode* node, Mat4* c);
Gfx* geo_switch_mario_hand_grab_pos (s32 callContext, GraphNode* b, Mat4* mtx);
Gfx* geo_render_mirror_mario (s32 callContext, GraphNode* node, Mat4* c);
Gfx* geo_mirror_mario_backface_culling (s32 callContext, GraphNode* node, Mat4* c);

// MARIO_MISC_H
