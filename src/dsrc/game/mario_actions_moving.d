module game.mario_actions_moving;

import sm64, surface_terrains, behavior_data,
       audio.external,
       engine.surface_collision, engine.math_util,
       game.mario, game.camera, game.mario_step, game.interaction, game.level_update, game.save_file, game.game_init,
       game.memory;

extern (C):

struct LandingAction {
    s16 numFrames;
    s16 unk02;
    u32 verySteepAction;
    u32 endAction;
    u32 aPressedAction;
    u32 offFloorAction;
    u32 slideAction;
}

LandingAction sJumpLandAction = {
    4, 5, ACT_FREEFALL, ACT_JUMP_LAND_STOP, ACT_DOUBLE_JUMP, ACT_FREEFALL, ACT_BEGIN_SLIDING,
};

LandingAction sFreefallLandAction = {
    4, 5, ACT_FREEFALL, ACT_FREEFALL_LAND_STOP, ACT_DOUBLE_JUMP, ACT_FREEFALL, ACT_BEGIN_SLIDING,
};

LandingAction sSideFlipLandAction = {
    4, 5, ACT_FREEFALL, ACT_SIDE_FLIP_LAND_STOP, ACT_DOUBLE_JUMP, ACT_FREEFALL, ACT_BEGIN_SLIDING,
};

LandingAction sHoldJumpLandAction = {
    4, 5, ACT_HOLD_FREEFALL, ACT_HOLD_JUMP_LAND_STOP, ACT_HOLD_JUMP, ACT_HOLD_FREEFALL, ACT_HOLD_BEGIN_SLIDING,
};

LandingAction sHoldFreefallLandAction = {
    4, 5, ACT_HOLD_FREEFALL, ACT_HOLD_FREEFALL_LAND_STOP, ACT_HOLD_JUMP, ACT_HOLD_FREEFALL, ACT_HOLD_BEGIN_SLIDING,
};

LandingAction sLongJumpLandAction = {
    6, 5, ACT_FREEFALL, ACT_LONG_JUMP_LAND_STOP, ACT_LONG_JUMP, ACT_FREEFALL, ACT_BEGIN_SLIDING,
};

LandingAction sDoubleJumpLandAction = {
    4, 5, ACT_FREEFALL, ACT_DOUBLE_JUMP_LAND_STOP, ACT_JUMP, ACT_FREEFALL, ACT_BEGIN_SLIDING,
};

LandingAction sTripleJumpLandAction = {
    4, 0, ACT_FREEFALL, ACT_TRIPLE_JUMP_LAND_STOP, ACT_UNINITIALIZED, ACT_FREEFALL, ACT_BEGIN_SLIDING,
};

LandingAction sBackflipLandAction = {
    4, 0, ACT_FREEFALL, ACT_BACKFLIP_LAND_STOP, ACT_BACKFLIP, ACT_FREEFALL, ACT_BEGIN_SLIDING,
};

Mat4[2] sFloorAlignMatrix;

s16 tilt_body_running(MarioState *m) {
    s16 pitch = find_floor_slope(m, 0);
    pitch = cast(s16) (pitch * m.forwardVel / 40.0f);
    return -pitch;
}

void play_step_sound(MarioState* m, s16 frame1, s16 frame2) {
    if (is_anim_past_frame(m, frame1) || is_anim_past_frame(m, frame2)) {
        if (m.flags & MARIO_METAL_CAP) {
            if (m.marioObj.header.gfx.animInfo.animID == MARIO_ANIM_TIPTOE) {
                play_sound_and_spawn_particles(m, SOUND_ACTION_METAL_STEP_TIPTOE, 0);
            } else {
                play_sound_and_spawn_particles(m, SOUND_ACTION_METAL_STEP, 0);
            }
        } else if (m.quicksandDepth > 50.0f) {
            play_sound(SOUND_ACTION_QUICKSAND_STEP, m.marioObj.header.gfx.cameraToObject.ptr);
        } else if (m.marioObj.header.gfx.animInfo.animID == MARIO_ANIM_TIPTOE) {
            play_sound_and_spawn_particles(m, SOUND_ACTION_TERRAIN_STEP_TIPTOE, 0);
        } else {
            play_sound_and_spawn_particles(m, SOUND_ACTION_TERRAIN_STEP, 0);
        }
    }
}

void align_with_floor(MarioState* m) {
    m.pos[1] = m.floorHeight;
    mtxf_align_terrain_triangle(sFloorAlignMatrix[m.unk00], m.pos, m.faceAngle[1], 40.0f);
    m.marioObj.header.gfx.throwMatrix = &sFloorAlignMatrix[m.unk00];
}

s32 begin_walking_action(MarioState* m, f32 forwardVel, u32 action, u32 actionArg) {
    m.faceAngle[1] = m.intendedYaw;
    mario_set_forward_vel(m, forwardVel);
    return set_mario_action(m, action, actionArg);
}

void check_ledge_climb_down(MarioState* m) {
    WallCollisionData wallCols;
    Surface* floor;
    f32 floorHeight;
    Surface* wall;
    s16 wallAngle;
    s16 wallDYaw;

    if (m.forwardVel < 10.0f) {
        wallCols.x = m.pos[0];
        wallCols.y = m.pos[1];
        wallCols.z = m.pos[2];
        wallCols.radius = 10.0f;
        wallCols.offsetY = -10.0f;

        if (find_wall_collisions(&wallCols) != 0) {
            floorHeight = find_floor(wallCols.x, wallCols.y, wallCols.z, &floor);
            if (floor != null && (wallCols.y - floorHeight > 160.0f)) {
                wall = wallCols.walls[wallCols.numWalls - 1];
                wallAngle = atan2s(wall.normal.z, wall.normal.x);
                wallDYaw = cast(s16) (wallAngle - m.faceAngle[1]);

                if (wallDYaw > -0x4000 && wallDYaw < 0x4000) {
                    m.pos[0] = wallCols.x - 20.0f * wall.normal.x;
                    m.pos[2] = wallCols.z - 20.0f * wall.normal.z;

                    m.faceAngle[0] = 0;
                    m.faceAngle[1] = cast(s16) (wallAngle + 0x8000);

                    set_mario_action(m, ACT_LEDGE_CLIMB_DOWN, 0);
                    set_mario_animation(m, MARIO_ANIM_CLIMB_DOWN_LEDGE);
                }
            }
        }
    }
}

void slide_bonk(MarioState* m, u32 fastAction, u32 slowAction) {
    if (m.forwardVel > 16.0f) {
        mario_bonk_reflection(m, true);
        drop_and_set_mario_action(m, fastAction, 0);
    } else {
        mario_set_forward_vel(m, 0.0f);
        set_mario_action(m, slowAction, 0);
    }
}

s32 set_triple_jump_action(MarioState* m, u32 action, u32 actionArg) {
    if (m.flags & MARIO_WING_CAP) {
        return set_mario_action(m, ACT_FLYING_TRIPLE_JUMP, 0);
    } else if (m.forwardVel > 20.0f) {
        return set_mario_action(m, ACT_TRIPLE_JUMP, 0);
    } else {
        if (m.input & INPUT_ANALOG_SPIN) {
            return set_mario_action(m, ACT_SPIN_JUMP, 0);
        }
        else {
            return set_mario_action(m, ACT_JUMP, 0);
        }
    }

    return false;
}

void update_sliding_angle(MarioState* m, f32 accel, f32 lossFactor) {
    import std.math;

    s32 newFacingDYaw;
    s16 facingDYaw;

    Surface* floor = m.floor;
    s16 slopeAngle = atan2s(floor.normal.z, floor.normal.x);
    f32 steepness = sqrt(floor.normal.x * floor.normal.x + floor.normal.z * floor.normal.z);
    f32 normalY = floor.normal.y;

    m.slideVelX += accel * steepness * sins(slopeAngle);
    m.slideVelZ += accel * steepness * coss(slopeAngle);

    m.slideVelX *= lossFactor;
    m.slideVelZ *= lossFactor;

    m.slideYaw = atan2s(m.slideVelZ, m.slideVelX);

    facingDYaw = cast(s16) (m.faceAngle[1] - m.slideYaw);
    newFacingDYaw = facingDYaw;

    //! -0x4000 not handled - can slide down a slope while facing perpendicular to it
    if (newFacingDYaw > 0 && newFacingDYaw <= 0x4000) {
        if ((newFacingDYaw -= 0x200) < 0) {
            newFacingDYaw = 0;
        }
    } else if (newFacingDYaw >= -0x4000 && newFacingDYaw < 0) {
        if ((newFacingDYaw += 0x200) > 0) {
            newFacingDYaw = 0;
        }
    } else if (newFacingDYaw > 0x4000 && newFacingDYaw < 0x8000) {
        if ((newFacingDYaw += 0x200) > 0x8000) {
            newFacingDYaw = 0x8000;
        }
    } else if (newFacingDYaw > -0x8000 && newFacingDYaw < -0x4000) {
        if ((newFacingDYaw -= 0x200) < -0x8000) {
            newFacingDYaw = -0x8000;
        }
    }

    m.faceAngle[1] = cast(s16) (m.slideYaw + newFacingDYaw);

    m.vel[0] = m.slideVelX;
    m.vel[1] = 0.0f;
    m.vel[2] = m.slideVelZ;

    mario_update_moving_sand(m);
    mario_update_windy_ground(m);

    //! Speed is capped a frame late (butt slide HSG)
    m.forwardVel = sqrt(m.slideVelX * m.slideVelX + m.slideVelZ * m.slideVelZ);
    if (m.forwardVel > 100.0f) {
        m.slideVelX = m.slideVelX * 100.0f / m.forwardVel;
        m.slideVelZ = m.slideVelZ * 100.0f / m.forwardVel;
    }

    if (newFacingDYaw < -0x4000 || newFacingDYaw > 0x4000) {
        m.forwardVel *= -1.0f;

        if (m.action == ACT_ROLL) {
            m.faceAngle[1] += 0x4000;
        }
    }
}

s32 update_sliding(MarioState* m, f32 stopSpeed) {
    import std.math;

    f32 lossFactor;
    f32 accel;
    f32 oldSpeed;
    f32 newSpeed;
    f32 angleChange;
    f32 modSlideVelX;
    f32 modSlideVelZ;

    s32 stopped = false;

    s16 intendedDYaw = cast(s16) (m.intendedYaw - m.slideYaw);
    f32 forward = coss(intendedDYaw);
    f32 sideward = sins(intendedDYaw);

    //! 10k glitch
    if (forward < 0.0f && m.forwardVel >= 0.0f) {
        forward *= 0.5f + 0.5f * m.forwardVel / 100.0f;
    }

    if (m.action == ACT_ROLL) {
        accel = 4.0f;
        lossFactor = 0.994f;
    }
    else {
        switch (mario_get_floor_class(m)) {
            case SURFACE_CLASS_VERY_SLIPPERY:
                accel = 10.0f;
                lossFactor = m.intendedMag / 32.0f * forward * 0.02f + 0.98f;
                break;

            case SURFACE_CLASS_SLIPPERY:
                accel = 8.0f;
                lossFactor = m.intendedMag / 32.0f * forward * 0.02f + 0.96f;
                break;

            default:
                accel = 7.0f;
                lossFactor = m.intendedMag / 32.0f * forward * 0.02f + 0.92f;
                break;

            case SURFACE_CLASS_NOT_SLIPPERY:
                accel = 5.0f;
                lossFactor = m.intendedMag / 32.0f * forward * 0.02f + 0.92f;
                break;
        }
    }

    oldSpeed = sqrt(m.slideVelX * m.slideVelX + m.slideVelZ * m.slideVelZ);

    //! This is uses trig derivatives to rotate Mario's speed.
    // In vanilla, it was slightly off/asymmetric since it uses the new X speed, but the old
    // Z speed. I've gone and fixed it here.
    angleChange  = (m.intendedMag / 32.0f) * (m.action == ACT_ROLL ? 0.6f : 1.0f),
    modSlideVelX = m.slideVelZ * angleChange * sideward * 0.05f,
    modSlideVelZ = m.slideVelX * angleChange * sideward * 0.05f;

    m.slideVelX += modSlideVelX;
    m.slideVelZ -= modSlideVelZ;

    newSpeed = sqrt(m.slideVelX * m.slideVelX + m.slideVelZ * m.slideVelZ);

    if (oldSpeed > 0.0f && newSpeed > 0.0f) {
        m.slideVelX = m.slideVelX * oldSpeed / newSpeed;
        m.slideVelZ = m.slideVelZ * oldSpeed / newSpeed;
    }

    update_sliding_angle(m, accel, lossFactor);

    if (!mario_floor_is_slope(m) && m.forwardVel * m.forwardVel < stopSpeed * stopSpeed) {
        mario_set_forward_vel(m, 0.0f);
        stopped = true;
    }

    return stopped;
}

void apply_slope_accel(MarioState* m) {
    import std.math;

    f32 slopeAccel;

    Surface* floor = m.floor;
    f32 steepness = sqrt(floor.normal.x * floor.normal.x + floor.normal.z * floor.normal.z);

    f32 normalY = floor.normal.y;
    s16 floorDYaw = cast(s16) (m.floorAngle - m.faceAngle[1]);

    if (mario_floor_is_slope(m)) {
        s16 slopeClass = 0;

        if (m.action != ACT_SOFT_BACKWARD_GROUND_KB && m.action != ACT_SOFT_FORWARD_GROUND_KB) {
            slopeClass = cast(s16) (mario_get_floor_class(m));
        }

        switch (slopeClass) {
            case SURFACE_CLASS_VERY_SLIPPERY:
                slopeAccel = 5.3f;
                break;
            case SURFACE_CLASS_SLIPPERY:
                slopeAccel = 2.7f;
                break;
            default:
                slopeAccel = 1.7f;
                break;
            case SURFACE_CLASS_NOT_SLIPPERY:
                slopeAccel = 0.0f;
                break;
        }

        if (floorDYaw > -0x4000 && floorDYaw < 0x4000) {
            m.forwardVel += slopeAccel * steepness;
        } else {
            m.forwardVel -= slopeAccel * steepness;
        }
    }

    m.slideYaw = m.faceAngle[1];

    m.slideVelX = m.forwardVel * sins(m.faceAngle[1]);
    m.slideVelZ = m.forwardVel * coss(m.faceAngle[1]);

    m.vel[0] = m.slideVelX;
    m.vel[1] = 0.0f;
    m.vel[2] = m.slideVelZ;

    mario_update_moving_sand(m);
    mario_update_windy_ground(m);
}

s32 apply_landing_accel(MarioState* m, f32 frictionFactor) {
    s32 stopped = false;

    apply_slope_accel(m);

    if (!mario_floor_is_slope(m)) {
        m.forwardVel *= frictionFactor;
        if (m.forwardVel * m.forwardVel < 1.0f) {
            mario_set_forward_vel(m, 0.0f);
            stopped = true;
        }
    }

    return stopped;
}

void update_shell_speed(MarioState* m) {
    f32 maxTargetSpeed;
    f32 targetSpeed;

    if (m.floorHeight < m.waterLevel) {
        m.floorHeight = m.waterLevel;
        m.floor = &gWaterSurfacePseudoFloor;
        m.floor.originOffset = m.waterLevel; //! Negative origin offset
    }

    if (m.floor != null && m.floor.type == SURFACE_SLOW) {
        maxTargetSpeed = 48.0f;
    } else {
        maxTargetSpeed = 64.0f;
    }

    targetSpeed = m.intendedMag * 2.0f;
    if (targetSpeed > maxTargetSpeed) {
        targetSpeed = maxTargetSpeed;
    }
    if (targetSpeed < 24.0f) {
        targetSpeed = 24.0f;
    }

    if (m.forwardVel <= 0.0f) {
        m.forwardVel += 1.1f;
    } else if (m.forwardVel <= targetSpeed) {
        m.forwardVel += 1.1f - m.forwardVel / 58.0f;
    } else if (m.floor.normal.y >= 0.95f) {
        m.forwardVel -= 1.0f;
    }

    //! No backward speed cap (shell hyperspeed)
    if (m.forwardVel > 64.0f) {
        m.forwardVel = 64.0f;
    }

    m.faceAngle[1] =
        cast(s16) (m.intendedYaw - approach_s32(cast(s16)(m.intendedYaw - m.faceAngle[1]), 0, 0x800, 0x800));

    apply_slope_accel(m);
}

s32 apply_slope_decel(MarioState* m, f32 decelCoef) {
    f32 decel;
    s32 stopped = false;

    switch (mario_get_floor_class(m)) {
        case SURFACE_CLASS_VERY_SLIPPERY:
            decel = decelCoef * 0.2f;
            break;
        case SURFACE_CLASS_SLIPPERY:
            decel = decelCoef * 0.7f;
            break;
        default:
            decel = decelCoef * 2.0f;
            break;
        case SURFACE_CLASS_NOT_SLIPPERY:
            decel = decelCoef * 3.0f;
            break;
    }

    if ((m.forwardVel = approach_f32(m.forwardVel, 0.0f, decel, decel)) == 0.0f) {
        stopped = true;
    }

    apply_slope_accel(m);
    return stopped;
}

s32 update_decelerating_speed(MarioState* m) {
    s32 stopped = false;

    if ((m.forwardVel = approach_f32(m.forwardVel, 0.0f, 1.0f, 1.0f)) == 0.0f) {
        stopped = true;
    }

    mario_set_forward_vel(m, m.forwardVel);
    mario_update_moving_sand(m);
    mario_update_windy_ground(m);

    return stopped;
}

void update_walking_speed(MarioState* m) {
    f32 maxTargetSpeed;
    f32 targetSpeed;
    f32 firmSpeedCap = m.prevAction == ACT_ROLL ? 60.0f : 48.0f;
    f32 hardSpeedCap = 105;
    f32 decayFactor;

    if (m.floor != null && m.floor.type == SURFACE_SLOW) {
        maxTargetSpeed = 24.0f;
    } else {
        maxTargetSpeed = 32.0f;
    }

    targetSpeed = m.intendedMag < maxTargetSpeed ? m.intendedMag : maxTargetSpeed;

    if (m.quicksandDepth > 10.0f) {
        targetSpeed *= 6.25 / m.quicksandDepth;
    }

    // instead of a hard walk speed cap, going over this new firm speed cap makes you slow down to it twice as fast
    decayFactor = m.forwardVel > firmSpeedCap ? 2.0f : 1.0f;

    if (m.forwardVel <= 0.0f) {
        m.forwardVel += 1.1f;
    } else if (m.forwardVel <= targetSpeed) {
        m.forwardVel += 1.1f - m.forwardVel / 43.0f;
    } else if (m.floor.normal.y >= 0.95f) {
        m.forwardVel -= decayFactor;
    } else {
        // reintroduce the old hardcap for the weird slopes where you kind of just maintain your speed
        if (m.forwardVel > firmSpeedCap) {
            m.forwardVel = firmSpeedCap;
        }
    }

    // still keep a high hard cap as a failsafe
    if (m.forwardVel > hardSpeedCap) {
        m.forwardVel = hardSpeedCap;
    }

    if (analog_stick_held_back(m)) {
        m.faceAngle[1] = m.intendedYaw;

        if (m.forwardVel < 0) {
            mario_set_forward_vel(m, -m.forwardVel);
        }
    } else {
        m.faceAngle[1] =
            cast(s16) (m.intendedYaw - approach_s32(cast(s16)(m.intendedYaw - m.faceAngle[1]), 0, 0xC00, 0xC00));
    }
    apply_slope_accel(m);
}

s32 should_begin_sliding(MarioState* m) {
    if (m.input & INPUT_ABOVE_SLIDE) {
        s32 slideLevel = (m.area.terrainType & TERRAIN_MASK) == TERRAIN_SLIDE;
        s32 movingBackward = m.forwardVel <= -1.0f;

        if (slideLevel || movingBackward || mario_facing_downhill(m, false)) {
            return true;
        }
    }

    return false;
}

s32 analog_stick_held_back(MarioState* m) {
    s16 intendedDYaw = cast(s16) (m.intendedYaw - m.faceAngle[1]);
    return intendedDYaw < -0x471C || intendedDYaw > 0x471C;
}

s32 check_ground_dive_or_punch(MarioState* m) {
    if (m.input & INPUT_B_PRESSED) {
        //! Speed kick (shoutouts to SimpleFlips)
        if (m.forwardVel >= 29.0f && m.controller.stickMag > 48.0f) {
            m.vel[1] = 20.0f;
            return set_mario_action(m, ACT_DIVE, 1);
        }

        return set_mario_action(m, ACT_MOVE_PUNCHING, 0);
    }

    return false;
}

s32 begin_braking_action(MarioState* m) {
    mario_drop_held_object(m);

    if (m.actionState == 1) {
        m.faceAngle[1] = cast(s16) m.actionArg;
        return set_mario_action(m, ACT_STANDING_AGAINST_WALL, 0);
    }

    if (m.forwardVel >= 16.0f && m.floor.normal.y >= 0.17364818f) {
        return set_mario_action(m, ACT_BRAKING, 0);
    }

    return set_mario_action(m, ACT_DECELERATING, 0);
}

void anim_and_audio_for_walk(MarioState* m) {
    s32 val14;
    Object_* marioObj = m.marioObj;
    s32 val0C = true;
    s16 targetPitch = 0;
    f32 val04;

    val04 = m.intendedMag > m.forwardVel ? m.intendedMag : m.forwardVel;

    if (val04 < 4.0f) {
        val04 = 4.0f;
    }

    if (m.quicksandDepth > 50.0f) {
        val14 = cast(s32) (val04 / 4.0f * 0x10000);
        set_mario_anim_with_accel(m, MARIO_ANIM_MOVE_IN_QUICKSAND, val14);
        play_step_sound(m, 19, 93);
        m.actionTimer = 0;
    } else {
        while (val0C) {
            switch (m.actionTimer) {
                case 0:
                    if (val04 > 8.0f) {
                        m.actionTimer = 2;
                    } else {
                        //! (Speed Crash) If Mario's speed is more than 2^17.
                        if ((val14 = cast(s32) (val04 / 4.0f * 0x10000)) < 0x1000) {
                            val14 = 0x1000;
                        }
                        set_mario_anim_with_accel(m, MARIO_ANIM_START_TIPTOE, val14);
                        play_step_sound(m, 7, 22);
                        if (is_anim_past_frame(m, 23)) {
                            m.actionTimer = 2;
                        }

                        val0C = false;
                    }
                    break;

                case 1:
                    if (val04 > 8.0f) {
                        m.actionTimer = 2;
                    } else {
                        //! (Speed Crash) If Mario's speed is more than 2^17.
                        if ((val14 = cast(s32) (val04 * 0x10000)) < 0x1000) {
                            val14 = 0x1000;
                        }
                        set_mario_anim_with_accel(m, MARIO_ANIM_TIPTOE, val14);
                        play_step_sound(m, 14, 72);

                        val0C = false;
                    }
                    break;

                case 2:
                    if (val04 < 5.0f) {
                        m.actionTimer = 1;
                    } else if (val04 > 22.0f) {
                        m.actionTimer = 3;
                    } else {
                        //! (Speed Crash) If Mario's speed is more than 2^17.
                        val14 = cast(s32) (val04 / 4.0f * 0x10000);
                        set_mario_anim_with_accel(m, MARIO_ANIM_WALKING, val14);
                        play_step_sound(m, 10, 49);

                        val0C = false;
                    }
                    break;

                case 3:
                    if (val04 < 18.0f) {
                        m.actionTimer = 2;
                    } else {
                        //! (Speed Crash) If Mario's speed is more than 2^17.
                        val14 = cast(s32) (val04 / 4.0f * 0x10000);
                        set_mario_anim_with_accel(m, MARIO_ANIM_RUNNING, val14);
                        play_step_sound(m, 9, 45);
                        targetPitch = tilt_body_running(m);

                        val0C = false;
                    }
                    break;

                default: break;
            }
        }
    }

    marioObj.oMarioWalkingPitch =
        cast(s16) approach_s32(marioObj.oMarioWalkingPitch, targetPitch, 0x800, 0x800);
    marioObj.header.gfx.angle[0] = cast(s16) marioObj.oMarioWalkingPitch;
}

void anim_and_audio_for_hold_walk(MarioState* m) {
    s32 val0C;
    s32 val08 = true;
    f32 val04;

    val04 = m.intendedMag > m.forwardVel ? m.intendedMag : m.forwardVel;

    if (val04 < 2.0f) {
        val04 = 2.0f;
    }

    while (val08) {
        switch (m.actionTimer) {
            case 0:
                if (val04 > 6.0f) {
                    m.actionTimer = 1;
                } else {
                    //! (Speed Crash) Crashes if Mario's speed exceeds or equals 2^15.
                    val0C = cast(s32) (val04 * 0x10000);
                    set_mario_anim_with_accel(m, MARIO_ANIM_SLOW_WALK_WITH_LIGHT_OBJ, val0C);
                    play_step_sound(m, 12, 62);

                    val08 = false;
                }
                break;

            case 1:
                if (val04 < 3.0f) {
                    m.actionTimer = 0;
                } else if (val04 > 11.0f) {
                    m.actionTimer = 2;
                } else {
                    //! (Speed Crash) Crashes if Mario's speed exceeds or equals 2^15.
                    val0C = cast(s32) (val04 * 0x10000);
                    set_mario_anim_with_accel(m, MARIO_ANIM_WALK_WITH_LIGHT_OBJ, val0C);
                    play_step_sound(m, 12, 62);

                    val08 = false;
                }
                break;

            case 2:
                if (val04 < 8.0f) {
                    m.actionTimer = 1;
                } else {
                    //! (Speed Crash) Crashes if Mario's speed exceeds or equals 2^16.
                    val0C = cast(s32) (val04 / 2.0f * 0x10000);
                    set_mario_anim_with_accel(m, MARIO_ANIM_RUN_WITH_LIGHT_OBJ, val0C);
                    play_step_sound(m, 10, 49);

                    val08 = false;
                }
                break;

            default: break;
        }
    }
}

void anim_and_audio_for_heavy_walk(MarioState* m) {
    s32 val04 = cast(s32) (m.intendedMag * 0x10000);
    set_mario_anim_with_accel(m, MARIO_ANIM_WALK_WITH_HEAVY_OBJ, val04);
    play_step_sound(m, 26, 79);
}

void push_or_sidle_wall(MarioState* m, Vec3f startPos) {
    import std.math;

    s16 wallAngle;
    s16 dWallAngle;
    f32 dx = m.pos[0] - startPos[0];
    f32 dz = m.pos[2] - startPos[2];
    f32 movedDistance = sqrt(dx * dx + dz * dz);
    //! (Speed Crash) If a wall is after moving 16384 distance, this crashes.
    s32 val04 = cast(s32) (movedDistance * 2.0f * 0x10000);

    if (m.forwardVel > 6.0f) {
        mario_set_forward_vel(m, 6.0f);
    }

    if (m.wall != null) {
        wallAngle = atan2s(m.wall.normal.z, m.wall.normal.x);
        dWallAngle = cast(s16) (wallAngle - m.faceAngle[1]);
    }

    if (m.wall == null || dWallAngle <= -0x71C8 || dWallAngle >= 0x71C8) {
        m.flags |= MARIO_UNKNOWN_31;
        set_mario_animation(m, MARIO_ANIM_PUSHING);
        play_step_sound(m, 6, 18);
    } else {
        if (dWallAngle < 0) {
            set_mario_anim_with_accel(m, MARIO_ANIM_SIDESTEP_RIGHT, val04);
        } else {
            set_mario_anim_with_accel(m, MARIO_ANIM_SIDESTEP_LEFT, val04);
        }

        if (m.marioObj.header.gfx.animInfo.animFrame < 20) {
            play_sound(SOUND_MOVING_TERRAIN_SLIDE + m.terrainSoundAddend, m.marioObj.header.gfx.cameraToObject.ptr);
            m.particleFlags |= PARTICLE_DUST;
        }

        m.actionState = 1;
        m.actionArg = wallAngle + 0x8000;
        m.marioObj.header.gfx.angle[1] = cast(s16) (wallAngle + 0x8000);
        m.marioObj.header.gfx.angle[2] = find_floor_slope(m, 0x4000);
    }
}

void tilt_body_walking(MarioState* m, s16 startYaw) {
    MarioBodyState* val0C = m.marioBodyState;
    Object_* marioObj = m.marioObj;
    s16 animID = m.marioObj.header.gfx.animInfo.animID;
    s16 dYaw;
    s16 val02;
    s16 val00;

    if (animID == MARIO_ANIM_WALKING || animID == MARIO_ANIM_RUNNING) {
        dYaw = cast(s16) (m.faceAngle[1] - startYaw);
        //! (Speed Crash) These casts can cause a crash if (dYaw * forwardVel / 12) or
        //! (forwardVel * 170) exceed or equal 2^31.
        val02 = -cast(s16)(dYaw * m.forwardVel / 12.0f);
        val00 = cast(s16)(m.forwardVel * 170.0f);

        if (val02 > 0x1555) {
            val02 = 0x1555;
        }
        if (val02 < -0x1555) {
            val02 = -0x1555;
        }

        if (val00 > 0x1555) {
            val00 = 0x1555;
        }
        if (val00 < 0) {
            val00 = 0;
        }

        val0C.torsoAngle[2] = cast(s16) approach_s32(val0C.torsoAngle[2], val02, 0x400, 0x400);
        val0C.torsoAngle[0] = cast(s16) approach_s32(val0C.torsoAngle[0], val00, 0x400, 0x400);
    } else {
        val0C.torsoAngle[2] = 0;
        val0C.torsoAngle[0] = 0;
    }
}

void tilt_body_ground_shell(MarioState* m, s16 startYaw) {
    MarioBodyState* val0C = m.marioBodyState;
    Object_* marioObj = m.marioObj;
    s16 dYaw = cast(s16) (m.faceAngle[1] - startYaw);
    //! (Speed Crash) These casts can cause a crash if (dYaw * forwardVel / 12) or
    //! (forwardVel * 170) exceed or equal 2^31. Harder (if not impossible to do)
    //! while on a Koopa Shell making this less of an issue.
    s16 val04 = -cast(s16)(dYaw * m.forwardVel / 12.0f);
    s16 val02 = cast(s16)(m.forwardVel * 170.0f);

    if (val04 > 0x1800) {
        val04 = 0x1800;
    }
    if (val04 < -0x1800) {
        val04 = -0x1800;
    }

    if (val02 > 0x1000) {
        val02 = 0x1000;
    }
    if (val02 < 0) {
        val02 = 0;
    }

    val0C.torsoAngle[2] = cast(s16) approach_s32(val0C.torsoAngle[2], val04, 0x200, 0x200);
    val0C.torsoAngle[0] = cast(s16) approach_s32(val0C.torsoAngle[0], val02, 0x200, 0x200);
    val0C.headAngle[2] = -val0C.torsoAngle[2];

    marioObj.header.gfx.angle[2] = val0C.torsoAngle[2];
    marioObj.header.gfx.pos[1] += 45.0f;
}

s32 act_walking(MarioState* m) {
    Vec3f startPos;
    s16 startYaw = m.faceAngle[1];

    mario_drop_held_object(m);

    if (should_begin_sliding(m)) {
        return set_mario_action(m, ACT_BEGIN_SLIDING, 0);
    }

    if (m.input & INPUT_FIRST_PERSON) {
        return begin_braking_action(m);
    }

    if (m.input & INPUT_A_PRESSED) {
        return set_jump_from_landing(m);
    }

    if (check_ground_dive_or_punch(m)) {
        return true;
    }

    if (m.input & INPUT_UNKNOWN_5) {
        return begin_braking_action(m);
    }

    if (analog_stick_held_back(m) && m.forwardVel >= 12.0f) {
        return set_mario_action(m, ACT_TURNING_AROUND, 0);
    }

    if (m.input & INPUT_Z_PRESSED) {
        return set_mario_action(m, ACT_CROUCH_SLIDE, 0);
    }

    m.actionState = 0;

    vec3f_copy(startPos, m.pos);
    update_walking_speed(m);

    switch (perform_ground_step(m)) {
        case GROUND_STEP_LEFT_GROUND:
            set_mario_action(m, ACT_FREEFALL, 0);
            set_mario_animation(m, MARIO_ANIM_GENERAL_FALL);
            break;

        case GROUND_STEP_NONE:
            anim_and_audio_for_walk(m);
            if (m.intendedMag - m.forwardVel > 16.0f) {
                m.particleFlags |= PARTICLE_DUST;
            }
            break;

        case GROUND_STEP_HIT_WALL:
            push_or_sidle_wall(m, startPos);
            m.actionTimer = 0;
            break;

        default: break;
    }

    check_ledge_climb_down(m);
    tilt_body_walking(m, startYaw);
    return false;
}

s32 act_move_punching(MarioState* m) {
    if (should_begin_sliding(m)) {
        return set_mario_action(m, ACT_BEGIN_SLIDING, 0);
    }

    if (m.actionState == 0 && (m.input & INPUT_A_DOWN)) {
        return set_mario_action(m, ACT_JUMP_KICK, 0);
    }

    m.actionState = 1;

    mario_update_punch_sequence(m);

    if (m.forwardVel >= 0.0f) {
        apply_slope_decel(m, 0.5f);
    } else {
        if ((m.forwardVel += 8.0f) >= 0.0f) {
            m.forwardVel = 0.0f;
        }
        apply_slope_accel(m);
    }

    switch (perform_ground_step(m)) {
        case GROUND_STEP_LEFT_GROUND:
            set_mario_action(m, ACT_FREEFALL, 0);
            break;

        case GROUND_STEP_NONE:
            m.particleFlags |= PARTICLE_DUST;
            break;

        default: break;
    }

    return false;
}

s32 act_hold_walking(MarioState* m) {
    if (m.heldObj.behavior == segmented_to_virtual(bhvJumpingBox)) {
        return set_mario_action(m, ACT_CRAZY_BOX_BOUNCE, 0);
    }

    if (m.marioObj.oInteractStatus & INT_STATUS_MARIO_DROP_OBJECT) {
        return drop_and_set_mario_action(m, ACT_WALKING, 0);
    }

    if (should_begin_sliding(m)) {
        return set_mario_action(m, ACT_HOLD_BEGIN_SLIDING, 0);
    }

    if (m.input & INPUT_B_PRESSED) {
        return set_mario_action(m, ACT_THROWING, 0);
    }

    if (m.input & INPUT_A_PRESSED) {
        return set_jumping_action(m, ACT_HOLD_JUMP, 0);
    }

    if (m.input & INPUT_UNKNOWN_5) {
        return set_mario_action(m, ACT_HOLD_DECELERATING, 0);
    }

    if (m.input & INPUT_Z_PRESSED) {
        return drop_and_set_mario_action(m, ACT_CROUCH_SLIDE, 0);
    }

    m.intendedMag *= 0.4f;

    update_walking_speed(m);

    switch (perform_ground_step(m)) {
        case GROUND_STEP_LEFT_GROUND:
            set_mario_action(m, ACT_HOLD_FREEFALL, 0);
            break;

        case GROUND_STEP_HIT_WALL:
            if (m.forwardVel > 16.0f) {
                mario_set_forward_vel(m, 16.0f);
            }
            break;

        default: break;
    }

    anim_and_audio_for_hold_walk(m);

    if (0.4f * m.intendedMag - m.forwardVel > 10.0f) {
        m.particleFlags |= PARTICLE_DUST;
    }

    return false;
}

s32 act_hold_heavy_walking(MarioState* m) {
    if (m.input & INPUT_B_PRESSED) {
        return set_mario_action(m, ACT_HEAVY_THROW, 0);
    }

    if (should_begin_sliding(m)) {
        return drop_and_set_mario_action(m, ACT_BEGIN_SLIDING, 0);
    }

    if (m.input & INPUT_UNKNOWN_5) {
        return set_mario_action(m, ACT_HOLD_HEAVY_IDLE, 0);
    }

    m.intendedMag *= 0.1f;

    update_walking_speed(m);

    switch (perform_ground_step(m)) {
        case GROUND_STEP_LEFT_GROUND:
            drop_and_set_mario_action(m, ACT_FREEFALL, 0);
            break;

        case GROUND_STEP_HIT_WALL:
            if (m.forwardVel > 10.0f) {
                mario_set_forward_vel(m, 10.0f);
            }
            break;

        default: break;
    }

    anim_and_audio_for_heavy_walk(m);
    return false;
}

s32 act_turning_around(MarioState* m) {
    if (m.input & INPUT_ABOVE_SLIDE) {
        return set_mario_action(m, ACT_BEGIN_SLIDING, 0);
    }

    if (m.input & INPUT_A_PRESSED) {
        if (m.input & INPUT_ANALOG_SPIN) {
            return set_jumping_action(m, ACT_SPIN_JUMP, 0);
        }
        else {
            return set_jumping_action(m, ACT_SIDE_FLIP, 0);
        }
    }

    if (m.input & INPUT_UNKNOWN_5) {
        return set_mario_action(m, ACT_BRAKING, 0);
    }

    if (!analog_stick_held_back(m)) {
        return set_mario_action(m, ACT_WALKING, 0);
    }

    if (apply_slope_decel(m, 2.0f)) {
        return begin_walking_action(m, 8.0f, ACT_FINISH_TURNING_AROUND, 0);
    }

    play_sound(SOUND_MOVING_TERRAIN_SLIDE + m.terrainSoundAddend, m.marioObj.header.gfx.cameraToObject.ptr);

    adjust_sound_for_speed(m);

    switch (perform_ground_step(m)) {
        case GROUND_STEP_LEFT_GROUND:
            set_mario_action(m, ACT_FREEFALL, 0);
            break;

        case GROUND_STEP_NONE:
            m.particleFlags |= PARTICLE_DUST;
            break;

        default: break;
    }

    if (m.forwardVel >= 18.0f) {
        set_mario_animation(m, MARIO_ANIM_TURNING_PART1);
    } else {
        set_mario_animation(m, MARIO_ANIM_TURNING_PART2);
        if (is_anim_at_end(m)) {
            if (m.forwardVel > 0.0f) {
                begin_walking_action(m, -m.forwardVel, ACT_WALKING, 0);
            } else {
                begin_walking_action(m, 8.0f, ACT_WALKING, 0);
            }
        }
    }

    return false;
}

s32 act_finish_turning_around(MarioState* m) {
    if (m.input & INPUT_ABOVE_SLIDE) {
        return set_mario_action(m, ACT_BEGIN_SLIDING, 0);
    }

    if (m.input & INPUT_A_PRESSED) {
        if (m.input & INPUT_ANALOG_SPIN) {
            return set_jumping_action(m, ACT_SPIN_JUMP, 0);
        }
        else {
            return set_jumping_action(m, ACT_SIDE_FLIP, 0);
        }
    }

    update_walking_speed(m);
    set_mario_animation(m, MARIO_ANIM_TURNING_PART2);

    if (perform_ground_step(m) == GROUND_STEP_LEFT_GROUND) {
        set_mario_action(m, ACT_FREEFALL, 0);
    }

    if (is_anim_at_end(m)) {
        set_mario_action(m, ACT_WALKING, 0);
    }

    m.marioObj.header.gfx.angle[1] += 0x8000;
    return false;
}

s32 act_braking(MarioState* m) {
    if (!(m.input & INPUT_FIRST_PERSON)
        && (m.input
            & (INPUT_NONZERO_ANALOG | INPUT_A_PRESSED | INPUT_OFF_FLOOR | INPUT_ABOVE_SLIDE))) {
        return check_common_action_exits(m);
    }

    if (apply_slope_decel(m, 2.0f)) {
        return set_mario_action(m, ACT_BRAKING_STOP, 0);
    }

    if (m.input & INPUT_B_PRESSED) {
        return set_mario_action(m, ACT_MOVE_PUNCHING, 0);
    }

    switch (perform_ground_step(m)) {
        case GROUND_STEP_LEFT_GROUND:
            set_mario_action(m, ACT_FREEFALL, 0);
            break;

        case GROUND_STEP_NONE:
            m.particleFlags |= PARTICLE_DUST;
            break;

        case GROUND_STEP_HIT_WALL:
            slide_bonk(m, ACT_BACKWARD_GROUND_KB, ACT_BRAKING_STOP);
            break;

        default: break;
    }

    play_sound(SOUND_MOVING_TERRAIN_SLIDE + m.terrainSoundAddend, m.marioObj.header.gfx.cameraToObject.ptr);
    adjust_sound_for_speed(m);
    set_mario_animation(m, MARIO_ANIM_SKID_ON_GROUND);
    return false;
}

s32 act_decelerating(MarioState* m) {
    s32 val0C;
    s16 slopeClass = cast(s16) mario_get_floor_class(m);

    if (!(m.input & INPUT_FIRST_PERSON)) {
        if (should_begin_sliding(m)) {
            return set_mario_action(m, ACT_BEGIN_SLIDING, 0);
        }

        if (m.input & INPUT_A_PRESSED) {
            return set_jump_from_landing(m);
        }

        if (check_ground_dive_or_punch(m)) {
            return true;
        }

        if (m.input & INPUT_NONZERO_ANALOG) {
            return set_mario_action(m, ACT_WALKING, 0);
        }

        if (m.input & INPUT_Z_PRESSED) {
            return set_mario_action(m, ACT_CROUCH_SLIDE, 0);
        }
    }

    if (update_decelerating_speed(m)) {
        return set_mario_action(m, ACT_IDLE, 0);
    }

    switch (perform_ground_step(m)) {
        case GROUND_STEP_LEFT_GROUND:
            set_mario_action(m, ACT_FREEFALL, 0);
            break;

        case GROUND_STEP_HIT_WALL:
            if (slopeClass == SURFACE_CLASS_VERY_SLIPPERY) {
                mario_bonk_reflection(m, true);
            } else {
                mario_set_forward_vel(m, 0.0f);
            }
            break;

        default: break;
    }

    if (slopeClass == SURFACE_CLASS_VERY_SLIPPERY) {
        set_mario_animation(m, MARIO_ANIM_IDLE_HEAD_LEFT);
        play_sound(SOUND_MOVING_TERRAIN_SLIDE + m.terrainSoundAddend, m.marioObj.header.gfx.cameraToObject.ptr);
        adjust_sound_for_speed(m);
        m.particleFlags |= PARTICLE_DUST;
    } else {
        // (Speed Crash) Crashes if speed exceeds 2^17.
        if ((val0C = cast(s32) (m.forwardVel / 4.0f * 0x10000)) < 0x1000) {
            val0C = 0x1000;
        }

        set_mario_anim_with_accel(m, MARIO_ANIM_WALKING, val0C);
        play_step_sound(m, 10, 49);
    }

    return false;
}

s32 act_hold_decelerating(MarioState* m) {
    s32 val0C;
    s16 slopeClass = cast(s16) mario_get_floor_class(m);

    if (m.marioObj.oInteractStatus & INT_STATUS_MARIO_DROP_OBJECT) {
        return drop_and_set_mario_action(m, ACT_WALKING, 0);
    }

    if (should_begin_sliding(m)) {
        return set_mario_action(m, ACT_HOLD_BEGIN_SLIDING, 0);
    }

    if (m.input & INPUT_B_PRESSED) {
        return set_mario_action(m, ACT_THROWING, 0);
    }

    if (m.input & INPUT_A_PRESSED) {
        return set_jumping_action(m, ACT_HOLD_JUMP, 0);
    }

    if (m.input & INPUT_Z_PRESSED) {
        return drop_and_set_mario_action(m, ACT_CROUCH_SLIDE, 0);
    }

    if (m.input & INPUT_NONZERO_ANALOG) {
        return set_mario_action(m, ACT_HOLD_WALKING, 0);
    }

    if (update_decelerating_speed(m)) {
        return set_mario_action(m, ACT_HOLD_IDLE, 0);
    }

    m.intendedMag *= 0.4f;

    switch (perform_ground_step(m)) {
        case GROUND_STEP_LEFT_GROUND:
            set_mario_action(m, ACT_HOLD_FREEFALL, 0);
            break;

        case GROUND_STEP_HIT_WALL:
            if (slopeClass == SURFACE_CLASS_VERY_SLIPPERY) {
                mario_bonk_reflection(m, true);
            } else {
                mario_set_forward_vel(m, 0.0f);
            }
            break;

        default: break;
    }

    if (slopeClass == SURFACE_CLASS_VERY_SLIPPERY) {
        set_mario_animation(m, MARIO_ANIM_IDLE_WITH_LIGHT_OBJ);
        play_sound(SOUND_MOVING_TERRAIN_SLIDE + m.terrainSoundAddend, m.marioObj.header.gfx.cameraToObject.ptr);
        adjust_sound_for_speed(m);
        m.particleFlags |= PARTICLE_DUST;
    } else {
        //! (Speed Crash) This crashes if Mario has more speed than 2^15 speed.
        if ((val0C = cast(s32) (m.forwardVel * 0x10000)) < 0x1000) {
            val0C = 0x1000;
        }

        set_mario_anim_with_accel(m, MARIO_ANIM_WALK_WITH_LIGHT_OBJ, val0C);
        play_step_sound(m, 12, 62);
    }

    return false;
}

s32 act_riding_shell_ground(MarioState* m) {
    s16 startYaw = m.faceAngle[1];

    if (m.input & INPUT_A_PRESSED) {
        return set_mario_action(m, ACT_RIDING_SHELL_JUMP, 0);
    }

    if (m.input & INPUT_Z_PRESSED) {
        mario_stop_riding_object(m);
        if (m.forwardVel < 24.0f) {
            mario_set_forward_vel(m, 24.0f);
        }
        return set_mario_action(m, ACT_CROUCH_SLIDE, 0);
    }

    update_shell_speed(m);
    set_mario_animation(m, m.actionArg == 0 ? MARIO_ANIM_START_RIDING_SHELL : MARIO_ANIM_RIDING_SHELL);

    switch (perform_ground_step(m)) {
        case GROUND_STEP_LEFT_GROUND:
            set_mario_action(m, ACT_RIDING_SHELL_FALL, 0);
            break;

        case GROUND_STEP_HIT_WALL:
            mario_stop_riding_object(m);
            play_sound(m.flags & MARIO_METAL_CAP ? SOUND_ACTION_METAL_BONK : SOUND_ACTION_BONK,
                       m.marioObj.header.gfx.cameraToObject.ptr);
            m.particleFlags |= PARTICLE_VERTICAL_STAR;
            set_mario_action(m, ACT_BACKWARD_GROUND_KB, 0);
            break;

        default: break;
    }

    tilt_body_ground_shell(m, startYaw);
    if (m.floor.type == SURFACE_BURNING) {
        play_sound(SOUND_MOVING_RIDING_SHELL_LAVA, m.marioObj.header.gfx.cameraToObject.ptr);
    } else {
        play_sound(SOUND_MOVING_TERRAIN_RIDING_SHELL + m.terrainSoundAddend,
                   m.marioObj.header.gfx.cameraToObject.ptr);
    }

    adjust_sound_for_speed(m);

    version (SM64_SH) {
        reset_rumble_timers();
    }
    return false;
}

s32 act_crawling(MarioState* m) {
    s32 val04;

    if (should_begin_sliding(m)) {
        return set_mario_action(m, ACT_BEGIN_SLIDING, 0);
    }

    if (m.input & INPUT_FIRST_PERSON) {
        return set_mario_action(m, ACT_STOP_CRAWLING, 0);
    }

    if (m.input & INPUT_A_PRESSED) {
        return set_jumping_action(m, ACT_JUMP, 0);
    }

    if (check_ground_dive_or_punch(m)) {
        return true;
    }

    if (m.input & INPUT_UNKNOWN_5) {
        return set_mario_action(m, ACT_STOP_CRAWLING, 0);
    }

    if (!(m.input & INPUT_Z_DOWN)) {
        return set_mario_action(m, ACT_STOP_CRAWLING, 0);
    }

    m.intendedMag *= 0.1f;

    update_walking_speed(m);

    switch (perform_ground_step(m)) {
        case GROUND_STEP_LEFT_GROUND:
            set_mario_action(m, ACT_FREEFALL, 0);
            break;

        case GROUND_STEP_HIT_WALL:
            if (m.forwardVel > 10.0f) {
                mario_set_forward_vel(m, 10.0f);
            }
            //! Possibly unintended missing break

        case GROUND_STEP_NONE:
            align_with_floor(m);
            break;

        default: break;
    }

    val04 = cast(s32) (m.intendedMag * 2.0f * 0x10000);
    set_mario_anim_with_accel(m, MARIO_ANIM_CRAWLING, val04);
    play_step_sound(m, 26, 79);
    return false;
}

s32 act_burning_ground(MarioState* m) {
    if (m.input & INPUT_A_PRESSED) {
        return set_mario_action(m, ACT_BURNING_JUMP, 0);
    }

    m.marioObj.oMarioBurnTimer += 2;
    if (m.marioObj.oMarioBurnTimer > 160) {
        return set_mario_action(m, ACT_WALKING, 0);
    }

    if (m.waterLevel - m.floorHeight > 50.0f) {
        play_sound(SOUND_GENERAL_FLAME_OUT, m.marioObj.header.gfx.cameraToObject.ptr);
        return set_mario_action(m, ACT_WALKING, 0);
    }

    if (m.forwardVel < 8.0f) {
        m.forwardVel = 8.0f;
    }
    if (m.forwardVel > 48.0f) {
        m.forwardVel = 48.0f;
    }

    m.forwardVel = approach_f32(m.forwardVel, 32.0f, 4.0f, 1.0f);

    if (m.input & INPUT_NONZERO_ANALOG) {
        m.faceAngle[1] =
            cast(s16) (m.intendedYaw - approach_s32(cast(s16)(m.intendedYaw - m.faceAngle[1]), 0, 0x600, 0x600));
    }

    apply_slope_accel(m);

    if (perform_ground_step(m) == GROUND_STEP_LEFT_GROUND) {
        set_mario_action(m, ACT_BURNING_FALL, 0);
    }

    set_mario_anim_with_accel(m, MARIO_ANIM_RUNNING, cast(s32) (m.forwardVel / 2.0f * 0x10000));
    play_step_sound(m, 9, 45);

    m.particleFlags |= PARTICLE_FIRE;
    play_sound(SOUND_MOVING_LAVA_BURN, m.marioObj.header.gfx.cameraToObject.ptr);

    m.health -= 10;
    if (m.health < 0x100) {
        set_mario_action(m, ACT_STANDING_DEATH, 0);
    }

    m.marioBodyState.eyeState = MARIO_EYES_DEAD;
    version (SM64_SH) {
        reset_rumble_timers();
    }
    return false;
}

void tilt_body_butt_slide(MarioState* m) {
    s16 intendedDYaw = cast(s16) (m.intendedYaw - m.faceAngle[1]);
    m.marioBodyState.torsoAngle[0] = cast(s16) (5461.3335f * m.intendedMag / 32.0f * coss(intendedDYaw));
    m.marioBodyState.torsoAngle[2] = cast(s16) (-(5461.3335f * m.intendedMag / 32.0f * sins(intendedDYaw)));
}

void common_slide_action(MarioState* m, u32 endAction, u32 airAction, s32 animation) {
    import std.math;

    Vec3f pos;

    vec3f_copy(pos, m.pos);
    play_sound(SOUND_MOVING_TERRAIN_SLIDE + m.terrainSoundAddend, m.marioObj.header.gfx.cameraToObject.ptr);

    version (SM64_SH) {
        reset_rumble_timers();
    }

    adjust_sound_for_speed(m);

    switch (perform_ground_step(m)) {
        case GROUND_STEP_LEFT_GROUND:
            set_mario_action(m, airAction, 0);
            if (m.forwardVel < -50.0f || 50.0f < m.forwardVel) {
                play_sound(SOUND_MARIO_HOOHOO, m.marioObj.header.gfx.cameraToObject.ptr);
            }
            break;

        case GROUND_STEP_NONE:
            set_mario_animation(m, animation);
            align_with_floor(m);
            m.particleFlags |= PARTICLE_DUST;
            break;

        case GROUND_STEP_HIT_WALL:
            if (!mario_floor_is_slippery(m)) {
                version (SM64_JP) {
                    m.particleFlags |= PARTICLE_VERTICAL_STAR;
                } else {
                    if (m.forwardVel > 16.0f) {
                        m.particleFlags |= PARTICLE_VERTICAL_STAR;
                    }
                }
                slide_bonk(m, ACT_GROUND_BONK, endAction);
            } else if (m.wall != null) {
                s16 wallAngle = atan2s(m.wall.normal.z, m.wall.normal.x);
                f32 slideSpeed = sqrt(m.slideVelX * m.slideVelX + m.slideVelZ * m.slideVelZ);

                if ((slideSpeed *= 0.9) < 4.0f) {
                    slideSpeed = 4.0f;
                }

                m.slideYaw = cast(s16) (wallAngle - cast(s16)(m.slideYaw - wallAngle) + 0x8000);

                m.vel[0] = m.slideVelX = slideSpeed * sins(m.slideYaw);
                m.vel[2] = m.slideVelZ = slideSpeed * coss(m.slideYaw);
            }

            align_with_floor(m);
            break;

        default: break;
    }
}

s32 common_slide_action_with_jump(MarioState* m, u32 stopAction, u32 jumpAction, u32 airAction,
                                  s32 animation) {
    if (m.actionTimer == 5) {
        if (m.input & INPUT_A_PRESSED) {
            return set_jumping_action(m, jumpAction, 0);
        }
    } else {
        m.actionTimer++;
    }

    if (update_sliding(m, 4.0f)) {
        return set_mario_action(m, stopAction, 0);
    }

    common_slide_action(m, stopAction, airAction, animation);
    return false;
}

s32 act_butt_slide(MarioState* m) {
    s32 cancel = common_slide_action_with_jump(m, ACT_BUTT_SLIDE_STOP, ACT_JUMP, ACT_BUTT_SLIDE_AIR,
                                               MARIO_ANIM_SLIDE);
    tilt_body_butt_slide(m);
    return cancel;
}

s32 act_hold_butt_slide(MarioState* m) {
    s32 cancel;

    if (m.marioObj.oInteractStatus & INT_STATUS_MARIO_DROP_OBJECT) {
        return drop_and_set_mario_action(m, ACT_BUTT_SLIDE, 0);
    }

    cancel = common_slide_action_with_jump(m, ACT_HOLD_BUTT_SLIDE_STOP, ACT_HOLD_JUMP, ACT_HOLD_BUTT_SLIDE_AIR,
                                           MARIO_ANIM_SLIDING_ON_BOTTOM_WITH_LIGHT_OBJ);
    tilt_body_butt_slide(m);
    return cancel;
}

s32 act_crouch_slide(MarioState* m) {
    s32 cancel;

    if (m.input & INPUT_ABOVE_SLIDE) {
        return set_mario_action(m, ACT_BUTT_SLIDE, 0);
    }

    if (m.actionTimer < 30) {
        m.actionTimer++;
        if (m.input & INPUT_A_PRESSED) {
            if (m.forwardVel > 10.0f) {
                return set_jumping_action(m, ACT_LONG_JUMP, 0);
            }
        }
    }

    if (m.input & INPUT_B_PRESSED) {
        if (m.forwardVel >= 10.0f) {
            return set_mario_action(m, ACT_SLIDE_KICK, 0);
        } else {
            return set_mario_action(m, ACT_MOVE_PUNCHING, 0x0009);
        }
    }

    if (m.input & INPUT_A_PRESSED) {
        return set_jumping_action(m, ACT_JUMP, 0);
    }

    if (m.input & INPUT_FIRST_PERSON) {
        return set_mario_action(m, ACT_BRAKING, 0);
    }

    if (m.controller.buttonPressed & R_TRIG) {
        m.vel[1] = 19.0f;
        mario_set_forward_vel(m, max(32, m.forwardVel));
        play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, 0);
        play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject.ptr);
        return set_mario_action(m, ACT_ROLL_AIR, 0);
    }

    cancel = common_slide_action_with_jump(m, ACT_CROUCHING, ACT_JUMP, ACT_FREEFALL,
                                           MARIO_ANIM_START_CROUCHING);
    return cancel;
}

s32 act_slide_kick_slide(MarioState* m) {
    if (m.input & INPUT_A_PRESSED) {
        version (SM64_SH) {
            queue_rumble_data(5, 80);
        }
        return set_jumping_action(m, ACT_FORWARD_ROLLOUT, 0);
    }

    set_mario_animation(m, MARIO_ANIM_SLIDE_KICK);
    if (is_anim_at_end(m) && m.forwardVel < 1.0f) {
        return set_mario_action(m, ACT_SLIDE_KICK_SLIDE_STOP, 0);
    }

    update_sliding(m, 1.0f);
    switch (perform_ground_step(m)) {
        case GROUND_STEP_LEFT_GROUND:
            set_mario_action(m, ACT_FREEFALL, 2);
            break;

        case GROUND_STEP_HIT_WALL:
            mario_bonk_reflection(m, true);
            m.particleFlags |= PARTICLE_VERTICAL_STAR;
            set_mario_action(m, ACT_BACKWARD_GROUND_KB, 0);
            break;

        default: break;
    }

    play_sound(SOUND_MOVING_TERRAIN_SLIDE + m.terrainSoundAddend, m.marioObj.header.gfx.cameraToObject.ptr);
    m.particleFlags |= PARTICLE_DUST;
    return false;
}

s32 act_roll(MarioState* m) {
    enum MAX_NORMAL_ROLL_SPEED    = 50.0f;
    enum ROLL_BOOST_GAIN          = 10.0f;
    enum ROLL_CANCEL_LOCKOUT_TIME = 10;
    enum BOOST_LOCKOUT_TIME       = 20;

    //m.spareFloat  is used for Mario's rotation angle during the roll (persists when going into ACT_ROLL_AIR and back)
    //m.spareInt    is used for the boost lockout timer (persists when going into ACT_ROLL_AIR and back)
    //m.actionTimer is used to lockout walk canceling out of rollout (reset each action switch)

    if (m.actionTimer == 0) {
        if (m.prevAction != ACT_ROLL_AIR) {
            m.spareFloat = 0;
            m.spareInt   = 0;
        }
    }
    else if (m.actionTimer >= ROLL_CANCEL_LOCKOUT_TIME || m.actionArg == 1) {
        if (!(m.input & INPUT_Z_DOWN))
            return set_mario_action(m, ACT_WALKING, 0);
    }

    if (m.input & INPUT_B_PRESSED){
        version (SM64_SH) {
            queue_rumble_data(5, 80);
        }
        return set_jumping_action(m, ACT_FORWARD_ROLLOUT, 0);
    }

    if (m.input & INPUT_A_PRESSED)
        return set_jumping_action(m, ACT_LONG_JUMP, 0);

    if (m.controller.buttonPressed & R_TRIG && m.actionTimer > 0) {
        m.vel[1] = 19.0f;
        play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, 0);

        if (m.spareInt >= BOOST_LOCKOUT_TIME) {
            m.spareInt = 0;

            if (m.forwardVel < MAX_NORMAL_ROLL_SPEED) {
                mario_set_forward_vel(m, min(m.forwardVel + ROLL_BOOST_GAIN, MAX_NORMAL_ROLL_SPEED));
            }

            m.particleFlags |= PARTICLE_HORIZONTAL_STAR;

            //! playing this after the call to play_mario_sound seems to matter in making this sound play
            play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject.ptr);
        }

        return set_mario_action(m, ACT_ROLL_AIR, m.actionArg);
    }

    set_mario_animation(m, MARIO_ANIM_FORWARD_SPINNING);

    if (update_sliding(m, 10.0f))
        return set_mario_action(m, ACT_CROUCH_SLIDE, 0);

    common_slide_action(m, ACT_CROUCH_SLIDE, ACT_ROLL_AIR, MARIO_ANIM_FORWARD_SPINNING);

    m.spareFloat += 0x80 * m.forwardVel;
    if (m.spareFloat > 0x10000) m.spareFloat -= 0x10000;
    set_anim_to_frame(m, cast(s16) (10 * m.spareFloat / 0x10000));

    m.spareInt++;

    // if (m.forwardVel > MAX_NORMAL_ROLL_SPEED) {
    //     mario_set_forward_vel(m, MAX_NORMAL_ROLL_SPEED);
    // }

    m.actionTimer++;

    return false;
}

s32 stomach_slide_action(MarioState* m, u32 stopAction, u32 airAction, s32 animation) {
    if (m.actionTimer == 5) {
        if (!(m.input & INPUT_ABOVE_SLIDE) && (m.input & (INPUT_A_PRESSED | INPUT_B_PRESSED))) {
            version (SM64_SH) {
                queue_rumble_data(5, 80);
            }
            return drop_and_set_mario_action(
                m, m.forwardVel >= 0.0f ? ACT_FORWARD_ROLLOUT : ACT_BACKWARD_ROLLOUT, 0);
        }
    } else {
        m.actionTimer++;
    }

    if (update_sliding(m, 4.0f)) {
        return set_mario_action(m, stopAction, 0);
    }

    common_slide_action(m, stopAction, airAction, animation);
    return false;
}

s32 act_stomach_slide(MarioState* m) {
    s32 cancel = stomach_slide_action(m, ACT_STOMACH_SLIDE_STOP, ACT_FREEFALL, MARIO_ANIM_SLIDE_DIVE);
    return cancel;
}

s32 act_hold_stomach_slide(MarioState* m) {
    s32 cancel;

    if (m.marioObj.oInteractStatus & INT_STATUS_MARIO_DROP_OBJECT) {
        return drop_and_set_mario_action(m, ACT_STOMACH_SLIDE, 0);
    }

    cancel = stomach_slide_action(m, ACT_DIVE_PICKING_UP, ACT_HOLD_FREEFALL, MARIO_ANIM_SLIDE_DIVE);
    return cancel;
}

s32 act_dive_slide(MarioState* m) {
    if (!(m.input & INPUT_ABOVE_SLIDE) && (m.input & INPUT_A_PRESSED)) {
        version (SM64_SH) {
            queue_rumble_data(5, 80);
        }
        return set_mario_action(m, m.forwardVel > 0.0f ? ACT_FORWARD_ROLLOUT : ACT_BACKWARD_ROLLOUT,
                                0);
    }

    play_mario_landing_sound_once(m, SOUND_ACTION_TERRAIN_BODY_HIT_GROUND);

    if (!(m.input & INPUT_ABOVE_SLIDE)) {
        if (m.input & INPUT_Z_DOWN && m.actionTimer == 0) {
            return set_mario_action(m, ACT_ROLL, 1);
        }
        else if (m.input & INPUT_B_PRESSED) {
            //dive hop
            m.vel[1] = 21.0f;
            return set_mario_action(m, ACT_DIVE, 1);
        }
    }

    //! If the dive slide ends on the same frame that we pick up on object,
    // Mario will not be in the dive slide action for the call to
    // mario_check_object_grab, and so will end up in the regular picking action,
    // rather than the picking up after dive action.

    if (update_sliding(m, 8.0f) && is_anim_at_end(m)) {
        mario_set_forward_vel(m, 0.0f);
        set_mario_action(m, ACT_STOMACH_SLIDE_STOP, 0);
    }

    if (mario_check_object_grab(m)) {
        mario_grab_used_object(m);
        m.marioBodyState.grabPos = GRAB_POS_LIGHT_OBJ;
        return true;
    }

    common_slide_action(m, ACT_STOMACH_SLIDE_STOP, ACT_FREEFALL, MARIO_ANIM_DIVE);

    m.actionTimer++;

    return false;
}

s32 common_ground_knockback_action(MarioState* m, s32 animation, s32 arg2, s32 arg3, s32 arg4) {
    s32 animFrame;

    if (arg3) {
        play_mario_heavy_landing_sound_once(m, SOUND_ACTION_TERRAIN_BODY_HIT_GROUND);
    }

    if (arg4 > 0) {
        play_sound_if_no_flag(m, SOUND_MARIO_ATTACKED, MARIO_MARIO_SOUND_PLAYED);
    } else {
        version (SM64_JP) {
            play_sound_if_no_flag(m, SOUND_MARIO_OOOF, MARIO_MARIO_SOUND_PLAYED);
        } else {
            play_sound_if_no_flag(m, SOUND_MARIO_OOOF2, MARIO_MARIO_SOUND_PLAYED);
        }
    }

    if (m.forwardVel > 32.0f) {
        m.forwardVel = 32.0f;
    }
    if (m.forwardVel < -32.0f) {
        m.forwardVel = -32.0f;
    }

    animFrame = set_mario_animation(m, animation);
    if (animFrame < arg2) {
        apply_landing_accel(m, 0.9f);
    } else if (m.forwardVel >= 0.0f) {
        mario_set_forward_vel(m, 0.1f);
    } else {
        mario_set_forward_vel(m, -0.1f);
    }

    if (perform_ground_step(m) == GROUND_STEP_LEFT_GROUND) {
        if (m.forwardVel >= 0.0f) {
            set_mario_action(m, ACT_FORWARD_AIR_KB, arg4);
        } else {
            set_mario_action(m, ACT_BACKWARD_AIR_KB, arg4);
        }
    } else if (is_anim_at_end(m)) {
        if (m.health < 0x100) {
            set_mario_action(m, ACT_STANDING_DEATH, 0);
        } else {
            if (arg4 > 0) {
                m.invincTimer = 30;
            }
            set_mario_action(m, ACT_IDLE, 0);
        }
    }

    return animFrame;
}

s32 act_hard_backward_ground_kb(MarioState* m) {
    s32 animFrame =
        common_ground_knockback_action(m, MARIO_ANIM_FALL_OVER_BACKWARDS, 43, true, m.actionArg);
    if (animFrame == 43 && m.health < 0x100) {
        set_mario_action(m, ACT_DEATH_ON_BACK, 0);
    }

    version (SM64_SH) { } else {
        if (animFrame == 54 && m.prevAction == ACT_SPECIAL_DEATH_EXIT) {
            play_sound(SOUND_MARIO_MAMA_MIA, m.marioObj.header.gfx.cameraToObject.ptr);
        }
    }

    if (animFrame == 69) {
        play_mario_landing_sound_once(m, SOUND_ACTION_TERRAIN_LANDING);
    }

    return false;
}

s32 act_hard_forward_ground_kb(MarioState* m) {
    s32 animFrame =
        common_ground_knockback_action(m, MARIO_ANIM_LAND_ON_STOMACH, 21, true, m.actionArg);
    if (animFrame == 23 && m.health < 0x100) {
        set_mario_action(m, ACT_DEATH_ON_STOMACH, 0);
    }

    return false;
}

s32 act_backward_ground_kb(MarioState* m) {
    common_ground_knockback_action(m, MARIO_ANIM_BACKWARD_KB, 22, true, m.actionArg);
    return false;
}

s32 act_forward_ground_kb(MarioState* m) {
    common_ground_knockback_action(m, MARIO_ANIM_FORWARD_KB, 20, true, m.actionArg);
    return false;
}

s32 act_soft_backward_ground_kb(MarioState* m) {
    common_ground_knockback_action(m, MARIO_ANIM_SOFT_BACK_KB, 100, false, m.actionArg);
    return false;
}

s32 act_soft_forward_ground_kb(MarioState* m) {
    common_ground_knockback_action(m, MARIO_ANIM_SOFT_FRONT_KB, 100, false, m.actionArg);
    return false;
}

s32 act_ground_bonk(MarioState* m) {
    s32 animFrame =
        common_ground_knockback_action(m, MARIO_ANIM_GROUND_BONK, 32, true, m.actionArg);
    if (animFrame == 32) {
        play_mario_landing_sound(m, SOUND_ACTION_TERRAIN_LANDING);
    }
    return false;
}

s32 act_death_exit_land(MarioState* m) {
    s32 animFrame;

    apply_landing_accel(m, 0.9f);
    play_mario_heavy_landing_sound_once(m, SOUND_ACTION_TERRAIN_BODY_HIT_GROUND);

    animFrame = set_mario_animation(m, MARIO_ANIM_FALL_OVER_BACKWARDS);

    if (animFrame == 54) {
        play_sound(SOUND_MARIO_MAMA_MIA, m.marioObj.header.gfx.cameraToObject.ptr);
    }
    if (animFrame == 68) {
        play_mario_landing_sound(m, SOUND_ACTION_TERRAIN_LANDING);
    }

    if (is_anim_at_end(m)) {
        set_mario_action(m, ACT_IDLE, 0);
    }

    return false;
}

u32 common_landing_action(MarioState* m, s16 animation, u32 airAction) {
    u32 stepResult;

    if (m.input & INPUT_NONZERO_ANALOG) {
        apply_landing_accel(m, 0.98f);
    } else if (m.forwardVel >= 16.0f) {
        apply_slope_decel(m, 2.0f);
    } else {
        m.vel[1] = 0.0f;
    }

    stepResult = perform_ground_step(m);
    switch (stepResult) {
        case GROUND_STEP_LEFT_GROUND:
            set_mario_action(m, airAction, 0);
            break;

        case GROUND_STEP_HIT_WALL:
            set_mario_animation(m, MARIO_ANIM_PUSHING);
            break;

        default: break;
    }

    if (m.forwardVel > 16.0f) {
        m.particleFlags |= PARTICLE_DUST;
    }

    set_mario_animation(m, animation);
    play_mario_landing_sound_once(m, SOUND_ACTION_TERRAIN_LANDING);

    if (m.floor.type >= SURFACE_SHALLOW_QUICKSAND && m.floor.type <= SURFACE_MOVING_QUICKSAND) {
        m.quicksandDepth += (4 - m.actionTimer) * 3.5f - 0.5f;
    }

    return stepResult;
}

s32 common_landing_cancels(MarioState* m, LandingAction* landingAction,
                           s32 function(MarioState*, u32, u32) setAPressAction) {
    //! Everything here, including floor steepness, is checked before checking
    // if Mario is actually on the floor. This leads to e.g. remote sliding.

    if (m.floor.normal.y < 0.2923717f) {
        return mario_push_off_steep_floor(m, landingAction.verySteepAction, 0);
    }

    m.doubleJumpTimer = cast(u8) landingAction.unk02;

    if (should_begin_sliding(m)) {
        return set_mario_action(m, landingAction.slideAction, 0);
    }

    if (m.input & INPUT_FIRST_PERSON) {
        return set_mario_action(m, landingAction.endAction, 0);
    }

    if (++m.actionTimer >= landingAction.numFrames) {
        return set_mario_action(m, landingAction.endAction, 0);
    }

    if (m.input & INPUT_A_PRESSED) {
        return setAPressAction(m, landingAction.aPressedAction, 0);
    }

    if (m.input & INPUT_OFF_FLOOR) {
        return set_mario_action(m, landingAction.offFloorAction, 0);
    }

    return false;
}

s32 act_jump_land(MarioState* m) {
    if (common_landing_cancels(m, &sJumpLandAction, &set_jumping_action)) {
        return true;
    }

    common_landing_action(m, MARIO_ANIM_LAND_FROM_SINGLE_JUMP, ACT_FREEFALL);
    return false;
}

s32 act_freefall_land(MarioState* m) {
    if (common_landing_cancels(m, &sFreefallLandAction, &set_jumping_action)) {
        return true;
    }

    common_landing_action(m, MARIO_ANIM_GENERAL_LAND, ACT_FREEFALL);
    return false;
}

s32 act_side_flip_land(MarioState* m) {
    if (common_landing_cancels(m, &sSideFlipLandAction, &set_jumping_action)) {
        return true;
    }

    if (common_landing_action(m, MARIO_ANIM_SLIDEFLIP_LAND, ACT_FREEFALL) != GROUND_STEP_HIT_WALL) {
        m.marioObj.header.gfx.angle[1] += 0x8000;
    }
    return false;
}

s32 act_hold_jump_land(MarioState* m) {
    if (m.marioObj.oInteractStatus & INT_STATUS_MARIO_DROP_OBJECT) {
        return drop_and_set_mario_action(m, ACT_JUMP_LAND_STOP, 0);
    }

    if (common_landing_cancels(m, &sHoldJumpLandAction, &set_jumping_action)) {
        return true;
    }

    common_landing_action(m, MARIO_ANIM_JUMP_LAND_WITH_LIGHT_OBJ, ACT_HOLD_FREEFALL);
    return false;
}

s32 act_hold_freefall_land(MarioState* m) {
    if (m.marioObj.oInteractStatus & INT_STATUS_MARIO_DROP_OBJECT) {
        return drop_and_set_mario_action(m, ACT_FREEFALL_LAND_STOP, 0);
    }

    if (common_landing_cancels(m, &sHoldFreefallLandAction, &set_jumping_action)) {
        return true;
    }

    common_landing_action(m, MARIO_ANIM_FALL_LAND_WITH_LIGHT_OBJ, ACT_HOLD_FREEFALL);
    return false;
}

s32 act_long_jump_land(MarioState* m) {
    version (SM64_SH) {
        // BLJ (Backwards Long Jump) speed build up fix, crushing SimpleFlips's dreams since July 1997
        if (m.forwardVel < 0.0f) {
            m.forwardVel = 0.0f;
        }
    }

    if (!(m.input & INPUT_Z_DOWN)) {
        m.input &= ~INPUT_A_PRESSED;
    }
    else if (m.forwardVel > 15.0f && m.actionTimer == 0) {
        play_mario_landing_sound_once(m, SOUND_ACTION_TERRAIN_LANDING);
        return set_mario_action(m, ACT_ROLL, 1);
    }

    if (common_landing_cancels(m, &sLongJumpLandAction, &set_jumping_action)) {
        return true;
    }

    if (!(m.input & INPUT_NONZERO_ANALOG)) {
        play_sound_if_no_flag(m, SOUND_MARIO_UH2_2, MARIO_MARIO_SOUND_PLAYED);
    }

    common_landing_action(m,
                          !m.marioObj.oMarioLongJumpIsSlow ? MARIO_ANIM_CROUCH_FROM_FAST_LONGJUMP
                                                             : MARIO_ANIM_CROUCH_FROM_SLOW_LONGJUMP,
                          ACT_FREEFALL);

    return false;
}

s32 act_double_jump_land(MarioState* m) {
    if (common_landing_cancels(m, &sDoubleJumpLandAction, &set_triple_jump_action)) {
        return true;
    }
    common_landing_action(m, MARIO_ANIM_LAND_FROM_DOUBLE_JUMP, ACT_FREEFALL);
    return false;
}

s32 act_triple_jump_land(MarioState* m) {
    m.input &= ~INPUT_A_PRESSED;

    if (common_landing_cancels(m, &sTripleJumpLandAction, &set_jumping_action)) {
        return true;
    }

    if (!(m.input & INPUT_NONZERO_ANALOG)) {
        play_sound_if_no_flag(m, SOUND_MARIO_HAHA, MARIO_MARIO_SOUND_PLAYED);
    }

    common_landing_action(m, MARIO_ANIM_TRIPLE_JUMP_LAND, ACT_FREEFALL);
    return false;
}

s32 act_backflip_land(MarioState* m) {
    if (!(m.input & INPUT_Z_DOWN)) {
        m.input &= ~INPUT_A_PRESSED;
    }

    if (common_landing_cancels(m, &sBackflipLandAction, &set_jumping_action)) {
        return true;
    }

    if (!(m.input & INPUT_NONZERO_ANALOG)) {
        play_sound_if_no_flag(m, SOUND_MARIO_HAHA, MARIO_MARIO_SOUND_PLAYED);
    }

    common_landing_action(m, MARIO_ANIM_TRIPLE_JUMP_LAND, ACT_FREEFALL);
    return false;
}

s32 quicksand_jump_land_action(MarioState* m, s32 animation1, s32 animation2, u32 endAction,
                               u32 airAction) {
    if (m.actionTimer++ < 6) {
        m.quicksandDepth -= (7 - m.actionTimer) * 0.8f;
        if (m.quicksandDepth < 1.0f) {
            m.quicksandDepth = 1.1f;
        }

        play_mario_jump_sound(m);
        set_mario_animation(m, animation1);
    } else {
        if (m.actionTimer >= 13) {
            return set_mario_action(m, endAction, 0);
        }

        set_mario_animation(m, animation2);
    }

    apply_landing_accel(m, 0.95f);
    if (perform_ground_step(m) == GROUND_STEP_LEFT_GROUND) {
        set_mario_action(m, airAction, 0);
    }

    return false;
}

s32 act_quicksand_jump_land(MarioState* m) {
    s32 cancel = quicksand_jump_land_action(m, MARIO_ANIM_SINGLE_JUMP, MARIO_ANIM_LAND_FROM_SINGLE_JUMP,
                                            ACT_JUMP_LAND_STOP, ACT_FREEFALL);
    return cancel;
}

s32 act_hold_quicksand_jump_land(MarioState* m) {
    s32 cancel = quicksand_jump_land_action(m, MARIO_ANIM_JUMP_WITH_LIGHT_OBJ,
                                            MARIO_ANIM_JUMP_LAND_WITH_LIGHT_OBJ, ACT_HOLD_JUMP_LAND_STOP,
                                            ACT_HOLD_FREEFALL);
    return cancel;
}

s32 check_common_moving_cancels(MarioState* m) {
    if (m.pos[1] < m.waterLevel - 100) {
        return set_water_plunge_action(m);
    }

    if (!(m.action & ACT_FLAG_INVULNERABLE) && (m.input & INPUT_UNKNOWN_10)) {
        return drop_and_set_mario_action(m, ACT_SHOCKWAVE_BOUNCE, 0);
    }

    if (m.input & INPUT_SQUISHED) {
        return drop_and_set_mario_action(m, ACT_SQUISHED, 0);
    }

    if (!(m.action & ACT_FLAG_INVULNERABLE)) {
        if (m.health < 0x100) {
            return drop_and_set_mario_action(m, ACT_STANDING_DEATH, 0);
        }
    }

    return false;
}

s32 mario_execute_moving_action(MarioState* m) {
    s32 cancel;

    if (check_common_moving_cancels(m)) {
        return true;
    }

    if (mario_update_quicksand(m, 0.25f)) {
        return true;
    }

    /* clang-format off */
    switch (m.action) {
        case ACT_WALKING:                  cancel = act_walking(m);                  break;
        case ACT_HOLD_WALKING:             cancel = act_hold_walking(m);             break;
        case ACT_HOLD_HEAVY_WALKING:       cancel = act_hold_heavy_walking(m);       break;
        case ACT_TURNING_AROUND:           cancel = act_turning_around(m);           break;
        case ACT_FINISH_TURNING_AROUND:    cancel = act_finish_turning_around(m);    break;
        case ACT_BRAKING:                  cancel = act_braking(m);                  break;
        case ACT_RIDING_SHELL_GROUND:      cancel = act_riding_shell_ground(m);      break;
        case ACT_CRAWLING:                 cancel = act_crawling(m);                 break;
        case ACT_BURNING_GROUND:           cancel = act_burning_ground(m);           break;
        case ACT_DECELERATING:             cancel = act_decelerating(m);             break;
        case ACT_HOLD_DECELERATING:        cancel = act_hold_decelerating(m);        break;
        case ACT_BUTT_SLIDE:               cancel = act_butt_slide(m);               break;
        case ACT_STOMACH_SLIDE:            cancel = act_stomach_slide(m);            break;
        case ACT_HOLD_BUTT_SLIDE:          cancel = act_hold_butt_slide(m);          break;
        case ACT_HOLD_STOMACH_SLIDE:       cancel = act_hold_stomach_slide(m);       break;
        case ACT_DIVE_SLIDE:               cancel = act_dive_slide(m);               break;
        case ACT_MOVE_PUNCHING:            cancel = act_move_punching(m);            break;
        case ACT_CROUCH_SLIDE:             cancel = act_crouch_slide(m);             break;
        case ACT_SLIDE_KICK_SLIDE:         cancel = act_slide_kick_slide(m);         break;
        case ACT_ROLL:                     cancel = act_roll(m);                     break;
        case ACT_HARD_BACKWARD_GROUND_KB:  cancel = act_hard_backward_ground_kb(m);  break;
        case ACT_HARD_FORWARD_GROUND_KB:   cancel = act_hard_forward_ground_kb(m);   break;
        case ACT_BACKWARD_GROUND_KB:       cancel = act_backward_ground_kb(m);       break;
        case ACT_FORWARD_GROUND_KB:        cancel = act_forward_ground_kb(m);        break;
        case ACT_SOFT_BACKWARD_GROUND_KB:  cancel = act_soft_backward_ground_kb(m);  break;
        case ACT_SOFT_FORWARD_GROUND_KB:   cancel = act_soft_forward_ground_kb(m);   break;
        case ACT_GROUND_BONK:              cancel = act_ground_bonk(m);              break;
        case ACT_DEATH_EXIT_LAND:          cancel = act_death_exit_land(m);          break;
        case ACT_JUMP_LAND:                cancel = act_jump_land(m);                break;
        case ACT_FREEFALL_LAND:            cancel = act_freefall_land(m);            break;
        case ACT_DOUBLE_JUMP_LAND:         cancel = act_double_jump_land(m);         break;
        case ACT_SIDE_FLIP_LAND:           cancel = act_side_flip_land(m);           break;
        case ACT_HOLD_JUMP_LAND:           cancel = act_hold_jump_land(m);           break;
        case ACT_HOLD_FREEFALL_LAND:       cancel = act_hold_freefall_land(m);       break;
        case ACT_TRIPLE_JUMP_LAND:         cancel = act_triple_jump_land(m);         break;
        case ACT_BACKFLIP_LAND:            cancel = act_backflip_land(m);            break;
        case ACT_QUICKSAND_JUMP_LAND:      cancel = act_quicksand_jump_land(m);      break;
        case ACT_HOLD_QUICKSAND_JUMP_LAND: cancel = act_hold_quicksand_jump_land(m); break;
        case ACT_LONG_JUMP_LAND:           cancel = act_long_jump_land(m);           break;
        default:                                                                     break;
    }
    /* clang-format on */

    if (!cancel && (m.input & INPUT_IN_WATER)) {
        m.particleFlags |= PARTICLE_WAVE_TRAIL;
        m.particleFlags &= ~PARTICLE_DUST;
    }

    return cancel;
}
