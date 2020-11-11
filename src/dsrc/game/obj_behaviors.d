module game.obj_behaviors;

import ultra64, types, engine.surface_collision;

extern (C):

void set_yoshi_as_not_dead ();
s32 coin_step (s16* collisionFlagsPtr);
void moving_coin_flicker ();
void coin_collected ();
void bhv_moving_yellow_coin_init ();
void bhv_moving_yellow_coin_loop ();
void bhv_moving_blue_coin_init ();
void bhv_moving_blue_coin_loop ();
void bhv_blue_coin_sliding_jumping_init ();
void blue_coin_sliding_away_from_mario (); /* likely unused */
void blue_coin_sliding_slow_down (); /* likely unused */
void bhv_blue_coin_sliding_loop (); /* likely unused */
void bhv_blue_coin_jumping_loop (); /* likely unused */
void bhv_seaweed_init ();
void bhv_seaweed_bundle_init ();
void bhv_bobomb_init ();
void bobomb_spawn_coin ();
void bobomb_act_explode ();
void bobomb_check_interactions ();
void bobomb_act_patrol ();
void bobomb_act_chase_mario ();
void bobomb_act_launched ();
void generic_bobomb_free_loop ();
void stationary_bobomb_free_loop ();
void bobomb_free_loop ();
void bobomb_held_loop ();
void bobomb_dropped_loop ();
void bobomb_thrown_loop ();
void curr_obj_random_blink (s32* blinkTimer);
void bhv_bobomb_loop ();
void bhv_bobomb_fuse_smoke_init ();
void bhv_bobomb_buddy_init ();
void bobomb_buddy_act_idle ();
void bobomb_buddy_cannon_dialog (s16 dialogFirstText, s16 dialogSecondText);
void bobomb_buddy_act_talk ();
void bobomb_buddy_act_turn_to_talk ();
void bobomb_buddy_actions ();
void bhv_bobomb_buddy_loop ();
void bhv_cannon_closed_init ();
void cannon_door_act_opening ();
void bhv_cannon_closed_loop ();
void bhv_whirlpool_init ();
void whirlpool_set_hitbox ();
void bhv_whirlpool_loop ();
void bhv_jet_stream_loop ();
void bhv_homing_amp_init ();
void bhv_homing_amp_loop ();
void bhv_circling_amp_init ();
void bhv_circling_amp_loop ();
void bhv_butterfly_init ();
void butterfly_step (s32 speed);
void butterfly_calculate_angle ();
void butterfly_act_rest ();
void butterfly_act_follow_mario ();
void butterfly_act_return_home ();
void bhv_butterfly_loop ();
void bhv_hoot_init ();
f32 hoot_find_next_floor (FloorGeometry** arg0, f32 arg1);
void hoot_floor_bounce ();
void hoot_free_step (s16 fastOscY, s32 speed);
void hoot_player_set_yaw ();
void hoot_carry_step (s32 speed, f32 xPrev, f32 zPrev);
void hoot_surface_collision (f32 xPrev, f32 yPrev, f32 zPrev);
void hoot_act_ascent (f32 xPrev, f32 zPrev);
void hoot_action_loop ();
void hoot_turn_to_home ();
void hoot_awake_loop ();
void bhv_hoot_loop ();
void bhv_beta_holdable_object_init (); /* unused */
void bhv_beta_holdable_object_loop (); /* unused */
void bhv_object_bubble_init ();
void bhv_object_bubble_loop ();
void bhv_object_water_wave_init ();
void bhv_object_water_wave_loop ();
void bhv_explosion_init ();
void bhv_explosion_loop ();
void bhv_bobomb_bully_death_smoke_init ();
void bhv_bobomb_explosion_bubble_init ();
void bhv_bobomb_explosion_bubble_loop ();
void bhv_respawner_loop ();
void create_respawner (s32 arg0, const(BehaviorScript)* behToSpawn, s32 minSpawnDist);
void bhv_small_bully_init ();
void bhv_big_bully_init ();
void bully_check_mario_collision ();
void bully_act_chase_mario ();
void bully_act_knockback ();
void bully_act_back_up ();
void bully_backup_check (s16 collisionFlags);
void bully_play_stomping_sound ();
void bully_step ();
void bully_spawn_coin ();
void bully_act_level_death ();
void bhv_bully_loop ();
void big_bully_spawn_minion (s32 arg0, s32 arg1, s32 arg2, s16 arg3);
void bhv_big_bully_with_minions_init ();
void big_bully_spawn_star ();
void bhv_big_bully_with_minions_loop ();
f32 water_ring_calc_mario_dist ();
void water_ring_init ();
void bhv_jet_stream_water_ring_init ();
void water_ring_check_collection (f32 avgScale, Object_* ringManager);
void water_ring_set_scale (f32 avgScale);
void water_ring_act_collected ();
void water_ring_act_not_collected ();
void bhv_jet_stream_water_ring_loop ();
void spawn_manta_ray_ring_manager (); /* unused */
void water_ring_spawner_act_inactive ();
void bhv_jet_stream_ring_spawner_loop ();
void bhv_manta_ray_water_ring_init ();
void manta_water_ring_act_not_collected ();
void bhv_manta_ray_water_ring_loop ();
void bhv_bowser_bomb_loop ();
void bhv_bowser_bomb_explosion_loop ();
void bhv_bowser_bomb_smoke_loop ();
void bhv_celebration_star_init ();
void celeb_star_act_spin_around_mario ();
void celeb_star_act_face_camera ();
void bhv_celebration_star_loop ();
void bhv_celebration_star_sparkle_loop ();
void bhv_star_key_collection_puff_spawner_loop ();
void bhv_lll_drawbridge_spawner_loop ();
void bhv_lll_drawbridge_loop ();
void bhv_small_bomp_init ();
void bhv_small_bomp_loop ();
void bhv_large_bomp_init ();
void bhv_large_bomp_loop ();
void bhv_wf_sliding_platform_init ();
void bhv_wf_sliding_platform_loop ();
void bhv_moneybag_init ();
void moneybag_check_mario_collision ();
void moneybag_jump (byte collisionFlags);
void moneybag_act_move_around ();
void moneybag_act_return_home ();
void moneybag_act_disappear ();
void moneybag_act_death ();
void bhv_moneybag_loop ();
void bhv_moneybag_hidden_loop ();
void bhv_bowling_ball_init ();
void bowling_ball_set_hitbox ();
void bowling_ball_set_waypoints ();
void bhv_bowling_ball_roll_loop ();
void bhv_bowling_ball_initializeLoop ();
void bhv_bowling_ball_loop ();
void bhv_generic_bowling_ball_spawner_init ();
void bhv_generic_bowling_ball_spawner_loop ();
void bhv_thi_bowling_ball_spawner_loop ();
void bhv_bob_pit_bowling_ball_init ();
void bhv_bob_pit_bowling_ball_loop ();
void bhv_free_bowling_ball_init (); /* likely unused */
void bhv_free_bowling_ball_roll_loop (); /* likely unused */
void bhv_free_bowling_ball_loop (); /* likely unused */
void bhv_rr_cruiser_wing_init ();
void bhv_rr_cruiser_wing_loop ();
void spawn_default_star (f32 sp20, f32 sp24, f32 sp28);

// OBJ_BEHAVIORS_H
