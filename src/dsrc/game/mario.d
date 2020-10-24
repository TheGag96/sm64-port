module game.mario;

import ultra64, types;

public import mario_animation_ids;

extern (C):

int is_anim_at_end (MarioState* m);
int is_anim_past_end (MarioState* m);
short set_mario_animation (MarioState* m, int targetAnimID);
short set_mario_anim_with_accel (MarioState* m, int targetAnimID, int accel);
void set_anim_to_frame (MarioState* m, short animFrame);
int is_anim_past_frame (MarioState* m, short animFrame);
short find_mario_anim_flags_and_translation (Object* o, int yaw, Vec3s translation);
void update_mario_pos_for_anim (MarioState* m);
short return_mario_anim_y_translation (MarioState* m);
void play_sound_if_no_flag (MarioState* m, uint soundBits, uint flags);
void play_mario_jump_sound (MarioState* m);
void adjust_sound_for_speed (MarioState* m);
void play_sound_and_spawn_particles (MarioState* m, uint soundBits, uint waveParticleType);
void play_mario_action_sound (MarioState* m, uint soundBits, uint waveParticleType);
void play_mario_landing_sound (MarioState* m, uint soundBits);
void play_mario_landing_sound_once (MarioState* m, uint soundBits);
void play_mario_heavy_landing_sound (MarioState* m, uint soundBits);
void play_mario_heavy_landing_sound_once (MarioState* m, uint soundBits);
void play_mario_sound (MarioState* m, int primarySoundBits, int scondarySoundBits);
void mario_set_forward_vel (MarioState* m, f32 speed);
int mario_get_floor_class (MarioState* m);
uint mario_get_terrain_sound_addend (MarioState* m);
Surface* resolve_and_return_wall_collisions (Vec3f pos, f32 offset, f32 radius);
f32 vec3f_find_ceil (Vec3f pos, f32 height, Surface** ceil);
int mario_facing_downhill (MarioState* m, int turnYaw);
uint mario_floor_is_slippery (MarioState* m);
int mario_floor_is_slope (MarioState* m);
int mario_floor_is_steep (MarioState* m);
f32 find_floor_height_relative_polar (MarioState* m, short angleFromMario, f32 distFromMario);
short find_floor_slope (MarioState* m, short yawOffset);
void update_mario_sound_and_camera (MarioState* m);
void set_steep_jump_action (MarioState* m);
uint set_mario_action (MarioState*, uint action, uint actionArg);
int set_jump_from_landing (MarioState* m);
int set_jumping_action (MarioState* m, uint action, uint actionArg);
int drop_and_set_mario_action (MarioState* m, uint action, uint actionArg);
int hurt_and_set_mario_action (MarioState* m, uint action, uint actionArg, short hurtCounter);
int check_common_action_exits (MarioState* m);
int check_common_hold_action_exits (MarioState* m);
int transition_submerged_to_walking (MarioState* m);
int set_water_plunge_action (MarioState* m);
int execute_mario_action (Object* o);
void init_mario ();
void init_mario_from_save_file ();

// MARIO_H
