module game.mario_step;

import ultra64, types;

extern (C):

struct BullyCollisionData
{
    /*0x00*/
    f32 conversionRatio;
    /*0x04*/
    f32 radius;
    /*0x08*/
    f32 posX;
    /*0x0C*/
    f32 posZ;
    /*0x10*/
    f32 velX;
    /*0x14*/
    f32 velZ;
}

extern __gshared Surface gWaterSurfacePseudoFloor;

f32 get_additive_y_vel_for_jumps ();
void stub_mario_step_1 (MarioState*);
void stub_mario_step_2 ();

void mario_bonk_reflection (MarioState*, u32);
void transfer_bully_speed (BullyCollisionData* obj1, BullyCollisionData* obj2);
int init_bully_collision_data (
    BullyCollisionData* data,
    f32 posX,
    f32 posZ,
    f32 forwardVel,
    s16 yaw,
    f32 conversionRatio,
    f32 radius);
u32 mario_update_quicksand (MarioState*, f32);
u32 mario_push_off_steep_floor (MarioState*, u32, u32);
u32 mario_update_moving_sand (MarioState*);
u32 mario_update_windy_ground (MarioState*);
void stop_and_set_height_to_floor (MarioState*);
int stationary_ground_step (MarioState*);
int perform_ground_step (MarioState*);
int perform_air_step (MarioState*, u32);

// MARIO_STEP_H
