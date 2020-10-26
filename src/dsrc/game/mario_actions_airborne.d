module game.mario_actions_airborne;

import sm64, audio.external, engine.math_util, surface_terrains, game.mario, game.camera, game.mario_step,
       game.interaction, game.level_update, game.save_file, game.game_init;

extern (C):

void play_flip_sounds(MarioState* m, s16 frame1, s16 frame2, s16 frame3) {
    s32 animFrame = m.marioObj.header.gfx.animInfo.animFrame;
    if (animFrame == frame1 || animFrame == frame2 || animFrame == frame3) {
        play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject.ptr);
    }
}

void play_far_fall_sound(MarioState* m) {
    u32 action = m.action;
    if (!(action & ACT_FLAG_INVULNERABLE) && action != ACT_TWIRLING && action != ACT_FLYING
        && !(m.flags & MARIO_UNKNOWN_18)) {
        if (m.peakHeight - m.pos[1] > 1150.0f) {
            play_sound(SOUND_MARIO_WAAAOOOW, m.marioObj.header.gfx.cameraToObject.ptr);
            m.flags |= MARIO_UNKNOWN_18;
        }
    }
}

version (SM64_JP) {
    void play_knockback_sound(MarioState* m) {
        if (m.actionArg == 0 && (m.forwardVel <= -28.0f || m.forwardVel >= 28.0f)) {
            play_sound_if_no_flag(m, SOUND_MARIO_DOH, MARIO_MARIO_SOUND_PLAYED);
        } else {
            play_sound_if_no_flag(m, SOUND_MARIO_UH, MARIO_MARIO_SOUND_PLAYED);
        }
    }
}

s32 lava_boost_on_wall(MarioState* m) {
    m.faceAngle[1] = atan2s(m.wall.normal.z, m.wall.normal.x);

    if (m.forwardVel < 24.0f) {
        m.forwardVel = 24.0f;
    }

    if (!(m.flags & MARIO_METAL_CAP)) {
        m.hurtCounter += (m.flags & MARIO_CAP_ON_HEAD) ? 12 : 18;
    }

    play_sound(SOUND_MARIO_ON_FIRE, m.marioObj.header.gfx.cameraToObject.ptr);
    update_mario_sound_and_camera(m);
    return drop_and_set_mario_action(m, ACT_LAVA_BOOST, 1);
}

s32 check_fall_damage(MarioState* m, u32 hardFallAction) {
    f32 fallHeight;
    f32 damageHeight;

    fallHeight = m.peakHeight - m.pos[1];

//#pragma GCC diagnostic push
//#pragma GCC diagnostic ignored "-Wtype-limits"

    //! Never true
    if (m.actionState == ACT_GROUND_POUND) {
        damageHeight = 600.0f;
    } else {
        damageHeight = 1150.0f;
    }

//#pragma GCC diagnostic pop

    if (m.action != ACT_TWIRLING && m.floor.type != SURFACE_BURNING) {
        if (m.vel[1] < -55.0f) {
            if (fallHeight > 3000.0f) {
                m.hurtCounter += (m.flags & MARIO_CAP_ON_HEAD) ? 16 : 24;
                version (SM64_SH) {
                    queue_rumble_data(5, 80);
                }
                set_camera_shake_from_hit(SHAKE_FALL_DAMAGE);
                play_sound(SOUND_MARIO_ATTACKED, m.marioObj.header.gfx.cameraToObject.ptr);
                return drop_and_set_mario_action(m, hardFallAction, 4);
            } else if (fallHeight > damageHeight && !mario_floor_is_slippery(m)) {
                m.hurtCounter += (m.flags & MARIO_CAP_ON_HEAD) ? 8 : 12;
                m.squishTimer = 30;
                version (SM64_SH) {
                    queue_rumble_data(5, 80);
                }
                set_camera_shake_from_hit(SHAKE_FALL_DAMAGE);
                play_sound(SOUND_MARIO_ATTACKED, m.marioObj.header.gfx.cameraToObject.ptr);
            }
        }
    }

    return false;
}

s32 check_kick_or_dive_in_air(MarioState* m) {
    if (m.input & INPUT_B_PRESSED) {
        return set_mario_action(m, m.forwardVel > 28.0f ? ACT_DIVE : ACT_JUMP_KICK, 0);
    }
    return false;
}

s32 should_get_stuck_in_ground(MarioState* m) {
    u32 terrainType = m.area.terrainType & TERRAIN_MASK;
    Surface* floor = m.floor;
    s32 flags = floor.flags;
    s32 type = floor.type;

    if (floor != null && (terrainType == TERRAIN_SNOW || terrainType == TERRAIN_SAND)
        && type != SURFACE_BURNING && SURFACE_IS_NOT_HARD(type)) {
        if (!(flags & 0x01) && m.peakHeight - m.pos[1] > 1000.0f && floor.normal.y >= 0.8660254f) {
            return true;
        }
    }

    return false;
}

s32 check_fall_damage_or_get_stuck(MarioState* m, u32 hardFallAction) {
    if (should_get_stuck_in_ground(m)) {
        version (SM64_JP) {
            play_sound(SOUND_MARIO_OOOF, m.marioObj.header.gfx.cameraToObject.ptr);
        } else {
            play_sound(SOUND_MARIO_OOOF2, m.marioObj.header.gfx.cameraToObject.ptr);
        }
        m.particleFlags |= PARTICLE_MIST_CIRCLE;
        drop_and_set_mario_action(m, ACT_FEET_STUCK_IN_GROUND, 0);
        version (SM64_SH) {
            queue_rumble_data(5, 80);
        }
        return true;
    }

    return check_fall_damage(m, hardFallAction);
}

s32 check_horizontal_wind(MarioState* m) {
    import std.math : sqrt;

    Surface* floor;
    f32 speed;
    s16 pushAngle;

    floor = m.floor;

    if (floor.type == SURFACE_HORIZONTAL_WIND) {
        pushAngle = cast(s16) (floor.force << 8);

        m.slideVelX += 1.2f * sins(pushAngle);
        m.slideVelZ += 1.2f * coss(pushAngle);

        speed = sqrt(m.slideVelX * m.slideVelX + m.slideVelZ * m.slideVelZ);

        if (speed > 48.0f) {
            m.slideVelX = m.slideVelX * 48.0f / speed;
            m.slideVelZ = m.slideVelZ * 48.0f / speed;
            speed = 32.0f; //! This was meant to be 48?
        } else if (speed > 32.0f) {
            speed = 32.0f;
        }

        m.vel[0] = m.slideVelX;
        m.vel[2] = m.slideVelZ;
        m.slideYaw = atan2s(m.slideVelZ, m.slideVelX);
        m.forwardVel = speed * coss(m.faceAngle[1] - m.slideYaw);

        version (SM64_JP) {
            play_sound(SOUND_ENV_WIND2, m.marioObj.header.gfx.cameraToObject.ptr);
        }
        return true;
    }

    return false;
}

void update_air_with_turn(MarioState* m) {
    f32 dragThreshold;
    s16 intendedDYaw;
    f32 intendedMag;

    if (!check_horizontal_wind(m)) {
        dragThreshold = m.action == ACT_LONG_JUMP ? 48.0f : 32.0f;
        m.forwardVel = approach_f32(m.forwardVel, 0.0f, 0.35f, 0.35f);

        if (m.input & INPUT_NONZERO_ANALOG) {
            intendedDYaw = cast(s16) (m.intendedYaw - m.faceAngle[1]);
            intendedMag = m.intendedMag / 32.0f;

            m.forwardVel += 1.5f * coss(intendedDYaw) * intendedMag;
            m.faceAngle[1] += 512.0f * sins(intendedDYaw) * intendedMag;
        }

        //! Uncapped air speed. Net positive when moving forward.
        if (m.forwardVel > dragThreshold) {
            m.forwardVel -= 1.0f;
        }
        if (m.forwardVel < -16.0f) {
            m.forwardVel += 2.0f;
        }

        m.vel[0] = m.slideVelX = m.forwardVel * sins(m.faceAngle[1]);
        m.vel[2] = m.slideVelZ = m.forwardVel * coss(m.faceAngle[1]);
    }
}

void update_air_without_turn(MarioState* m) {
    f32 sidewaysSpeed = 0.0f;
    f32 dragThreshold;
    s16 intendedDYaw;
    f32 intendedMag;

    if (!check_horizontal_wind(m)) {
        dragThreshold = m.action == ACT_LONG_JUMP ? 48.0f : 32.0f;
        m.forwardVel = approach_f32(m.forwardVel, 0.0f, 0.35f, 0.35f);

        if (m.input & INPUT_NONZERO_ANALOG) {
            intendedDYaw = cast(s16) (m.intendedYaw - m.faceAngle[1]);
            intendedMag = m.intendedMag / 32.0f;

            m.forwardVel += intendedMag * coss(intendedDYaw) * 1.5f;
            if (m.action != ACT_ROLL_AIR) {
                sidewaysSpeed = intendedMag * sins(intendedDYaw) * 10.0f;
            }
        }

        //! Uncapped air speed. Net positive when moving forward.
        if (m.forwardVel > dragThreshold) {
            m.forwardVel -= 1.0f;
        }
        if (m.forwardVel < -16.0f) {
            m.forwardVel += 2.0f;
        }

        m.slideVelX = m.forwardVel * sins(m.faceAngle[1]);
        m.slideVelZ = m.forwardVel * coss(m.faceAngle[1]);

        m.slideVelX += sidewaysSpeed * sins(m.faceAngle[1] + 0x4000);
        m.slideVelZ += sidewaysSpeed * coss(m.faceAngle[1] + 0x4000);

        m.vel[0] = m.slideVelX;
        m.vel[2] = m.slideVelZ;
    }
}

void update_lava_boost_or_twirling(MarioState* m) {
    s16 intendedDYaw;
    f32 intendedMag;

    if (m.input & INPUT_NONZERO_ANALOG) {
        intendedDYaw = cast(s16) (m.intendedYaw - m.faceAngle[1]);
        intendedMag = m.intendedMag / 32.0f;

        m.forwardVel += coss(intendedDYaw) * intendedMag;
        m.faceAngle[1] += sins(intendedDYaw) * intendedMag * 1024.0f;

        if (m.forwardVel < 0.0f) {
            m.faceAngle[1] += 0x8000;
            m.forwardVel *= -1.0f;
        }

        if (m.forwardVel > 32.0f) {
            m.forwardVel -= 2.0f;
        }
    }

    m.vel[0] = m.slideVelX = m.forwardVel * sins(m.faceAngle[1]);
    m.vel[2] = m.slideVelZ = m.forwardVel * coss(m.faceAngle[1]);
}

void update_flying_yaw(MarioState* m) {
    s16 targetYawVel = cast(s16)( -(m.controller.stickX * (m.forwardVel / 4.0f)));

    if (targetYawVel > 0) {
        if (m.angleVel[1] < 0) {
            m.angleVel[1] += 0x40;
            if (m.angleVel[1] > 0x10) {
                m.angleVel[1] = 0x10;
            }
        } else {
            m.angleVel[1] = cast(s16) (approach_s32(m.angleVel[1], targetYawVel, 0x10, 0x20));
        }
    } else if (targetYawVel < 0) {
        if (m.angleVel[1] > 0) {
            m.angleVel[1] -= 0x40;
            if (m.angleVel[1] < -0x10) {
                m.angleVel[1] = -0x10;
            }
        } else {
            m.angleVel[1] = cast(s16) (approach_s32(m.angleVel[1], targetYawVel, 0x20, 0x10));
        }
    } else {
        m.angleVel[1] = cast(s16) (approach_s32(m.angleVel[1], 0, 0x40, 0x40));
    }

    m.faceAngle[1] += m.angleVel[1];
    m.faceAngle[2] = cast(s16) (20 * -cast(s32) m.angleVel[1]);
}

void update_flying_pitch(MarioState* m) {
    s16 targetPitchVel = cast(s16) (-(m.controller.stickY * (m.forwardVel / 5.0f)));

    if (targetPitchVel > 0) {
        if (m.angleVel[0] < 0) {
            m.angleVel[0] += 0x40;
            if (m.angleVel[0] > 0x20) {
                m.angleVel[0] = 0x20;
            }
        } else {
            m.angleVel[0] = cast(s16) (approach_s32(m.angleVel[0], targetPitchVel, 0x20, 0x40));
        }
    } else if (targetPitchVel < 0) {
        if (m.angleVel[0] > 0) {
            m.angleVel[0] -= 0x40;
            if (m.angleVel[0] < -0x20) {
                m.angleVel[0] = -0x20;
            }
        } else {
            m.angleVel[0] = cast(s16) (approach_s32(m.angleVel[0], targetPitchVel, 0x40, 0x20));
        }
    } else {
        m.angleVel[0] = cast(s16) (approach_s32(m.angleVel[0], 0, 0x40, 0x40));
    }
}

void update_flying(MarioState* m) {
    u32 unused;

    update_flying_pitch(m);
    update_flying_yaw(m);

    m.forwardVel -= 2.0f * (cast(f32) m.faceAngle[0] / 0x4000) + 0.1f;
    m.forwardVel -= 0.5f * (1.0f - coss(m.angleVel[1]));

    if (m.forwardVel < 0.0f) {
        m.forwardVel = 0.0f;
    }

    if (m.forwardVel > 16.0f) {
        m.faceAngle[0] += (m.forwardVel - 32.0f) * 6.0f;
    } else if (m.forwardVel > 4.0f) {
        m.faceAngle[0] += (m.forwardVel - 32.0f) * 10.0f;
    } else {
        m.faceAngle[0] -= 0x400;
    }

    m.faceAngle[0] += m.angleVel[0];

    if (m.faceAngle[0] > 0x2AAA) {
        m.faceAngle[0] = 0x2AAA;
    }
    if (m.faceAngle[0] < -0x2AAA) {
        m.faceAngle[0] = -0x2AAA;
    }

    m.vel[0] = m.forwardVel * coss(m.faceAngle[0]) * sins(m.faceAngle[1]);
    m.vel[1] = m.forwardVel * sins(m.faceAngle[0]);
    m.vel[2] = m.forwardVel * coss(m.faceAngle[0]) * coss(m.faceAngle[1]);

    m.slideVelX = m.vel[0];
    m.slideVelZ = m.vel[2];
}

u32 common_air_action_step(MarioState* m, u32 landAction, s32 animation, u32 stepArg) {
    u32 stepResult;

    update_air_without_turn(m);

    stepResult = perform_air_step(m, stepArg);
    switch (stepResult) {
        case AIR_STEP_NONE:
            set_mario_animation(m, animation);
            break;

        case AIR_STEP_LANDED:
            if (!check_fall_damage_or_get_stuck(m, ACT_HARD_BACKWARD_GROUND_KB)) {
                set_mario_action(m, landAction, 0);
            }
            break;

        case AIR_STEP_HIT_WALL:
            set_mario_animation(m, animation);

            if (m.forwardVel > 16.0f) {
                version (SM64_SH) {
                    queue_rumble_data(5, 40);
                }
                mario_bonk_reflection(m, false);
                m.faceAngle[1] += 0x8000;

                if (m.wall != null) {
                    set_mario_action(m, ACT_AIR_HIT_WALL, 0);
                } else {
                    if (m.vel[1] > 0.0f) {
                        m.vel[1] = 0.0f;
                    }

                    //! Hands-free holding. Bonking while no wall is referenced
                    // sets Mario's action to a non-holding action without
                    // dropping the object, causing the hands-free holding
                    // glitch. This can be achieved using an exposed ceiling,
                    // out of bounds, grazing the bottom of a wall while
                    // falling such that the final quarter step does not find a
                    // wall collision, or by rising into the top of a wall such
                    // that the final quarter step detects a ledge, but you are
                    // not able to ledge grab it.
                    if (m.forwardVel >= 38.0f) {
                        m.particleFlags |= PARTICLE_VERTICAL_STAR;
                        set_mario_action(m, ACT_BACKWARD_AIR_KB, 0);
                    } else {
                        if (m.forwardVel > 8.0f) {
                            mario_set_forward_vel(m, -8.0f);
                        }
                        return set_mario_action(m, ACT_SOFT_BONK, 0);
                    }
                }
            } else {
                mario_set_forward_vel(m, 0.0f);
            }
            break;

        case AIR_STEP_GRABBED_LEDGE:
            set_mario_animation(m, MARIO_ANIM_IDLE_ON_LEDGE);
            drop_and_set_mario_action(m, ACT_LEDGE_GRAB, 0);
            break;

        case AIR_STEP_GRABBED_CEILING:
            set_mario_action(m, ACT_START_HANGING, 0);
            break;

        case AIR_STEP_HIT_LAVA_WALL:
            lava_boost_on_wall(m);
            break;

        default: break;
    }

    return stepResult;
}

s32 act_jump(MarioState* m) {
    if (check_kick_or_dive_in_air(m)) {
        return true;
    }

    if (m.input & INPUT_Z_PRESSED) {
        return set_mario_action(m, ACT_GROUND_POUND, 0);
    }

    if (m.input & INPUT_ANALOG_SPIN) {
        return set_mario_action(m, ACT_SPIN_JUMP, 1);
    }

    play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, 0);
    common_air_action_step(m, ACT_JUMP_LAND, MARIO_ANIM_SINGLE_JUMP,
                           AIR_STEP_CHECK_LEDGE_GRAB | AIR_STEP_CHECK_HANG);
    return false;
}

s32 act_double_jump(MarioState* m) {
    s32 animation = (m.vel[1] >= 0.0f)
        ? MARIO_ANIM_DOUBLE_JUMP_RISE
        : MARIO_ANIM_DOUBLE_JUMP_FALL;

    if (check_kick_or_dive_in_air(m)) {
        return true;
    }

    if (m.input & INPUT_Z_PRESSED) {
        return set_mario_action(m, ACT_GROUND_POUND, 0);
    }

    if (m.input & INPUT_ANALOG_SPIN) {
        return set_mario_action(m, ACT_SPIN_JUMP, 1);
    }

    play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, SOUND_MARIO_HOOHOO);
    common_air_action_step(m, ACT_DOUBLE_JUMP_LAND, animation,
                           AIR_STEP_CHECK_LEDGE_GRAB | AIR_STEP_CHECK_HANG);
    return false;
}

s32 act_triple_jump(MarioState* m) {
    if (gSpecialTripleJump) {
        return set_mario_action(m, ACT_SPECIAL_TRIPLE_JUMP, 0);
    }

    if (m.input & INPUT_B_PRESSED) {
        return set_mario_action(m, ACT_DIVE, 0);
    }

    if (m.input & INPUT_Z_PRESSED) {
        return set_mario_action(m, ACT_GROUND_POUND, 0);
    }

version (SM64_JP) {
    play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, 0);
}
else {
    play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, SOUND_MARIO_YAHOO);
}

    common_air_action_step(m, ACT_TRIPLE_JUMP_LAND, MARIO_ANIM_TRIPLE_JUMP, 0);
    version (SM64_SH) {
        if (m.action == ACT_TRIPLE_JUMP_LAND) {
            queue_rumble_data(5, 40);
        }
    }
    play_flip_sounds(m, 2, 8, 20);
    return false;
}

s32 act_backflip(MarioState* m) {
    if (m.input & INPUT_Z_PRESSED) {
        return set_mario_action(m, ACT_GROUND_POUND, 0);
    }

    if (m.input & INPUT_ANALOG_SPIN) {
        return set_mario_action(m, ACT_SPIN_JUMP, 1);
    }

    play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, SOUND_MARIO_YAH_WAH_HOO);
    common_air_action_step(m, ACT_BACKFLIP_LAND, MARIO_ANIM_BACKFLIP, 0);
    version (SM64_SH) {
        if (m.action == ACT_BACKFLIP_LAND) {
            queue_rumble_data(5, 40);
        }
    }
    play_flip_sounds(m, 2, 3, 17);
    return false;
}

s32 act_freefall(MarioState* m) {
    s32 animation;

    if (m.input & INPUT_B_PRESSED) {
        return set_mario_action(m, ACT_DIVE, 0);
    }

    if (m.input & INPUT_Z_PRESSED) {
        return set_mario_action(m, ACT_GROUND_POUND, 0);
    }

    switch (m.actionArg) {
        case 0:
            animation = MARIO_ANIM_GENERAL_FALL;
            break;
        case 1:
            animation = MARIO_ANIM_FALL_FROM_SLIDE;
            break;
        case 2:
            animation = MARIO_ANIM_FALL_FROM_SLIDE_KICK;
            break;
        default: break;
    }

    common_air_action_step(m, ACT_FREEFALL_LAND, animation, AIR_STEP_CHECK_LEDGE_GRAB);
    return false;
}

s32 act_hold_jump(MarioState* m) {
    if (m.marioObj.oInteractStatus & INT_STATUS_MARIO_DROP_OBJECT) {
        return drop_and_set_mario_action(m, ACT_FREEFALL, 0);
    }

    if ((m.input & INPUT_B_PRESSED) && !(m.heldObj.oInteractionSubtype & INT_SUBTYPE_HOLDABLE_NPC)) {
        return set_mario_action(m, ACT_AIR_THROW, 0);
    }

    if (m.input & INPUT_Z_PRESSED) {
        return drop_and_set_mario_action(m, ACT_GROUND_POUND, 0);
    }

    play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, 0);
    common_air_action_step(m, ACT_HOLD_JUMP_LAND, MARIO_ANIM_JUMP_WITH_LIGHT_OBJ,
                           AIR_STEP_CHECK_LEDGE_GRAB);
    return false;
}

s32 act_hold_freefall(MarioState* m) {
    s32 animation;
    if (m.actionArg == 0) {
        animation = MARIO_ANIM_FALL_WITH_LIGHT_OBJ;
    } else {
        animation = MARIO_ANIM_FALL_FROM_SLIDING_WITH_LIGHT_OBJ;
    }

    if (m.marioObj.oInteractStatus & INT_STATUS_MARIO_DROP_OBJECT) {
        return drop_and_set_mario_action(m, ACT_FREEFALL, 0);
    }

    if ((m.input & INPUT_B_PRESSED) && !(m.heldObj.oInteractionSubtype & INT_SUBTYPE_HOLDABLE_NPC)) {
        return set_mario_action(m, ACT_AIR_THROW, 0);
    }

    if (m.input & INPUT_Z_PRESSED) {
        return drop_and_set_mario_action(m, ACT_GROUND_POUND, 0);
    }

    common_air_action_step(m, ACT_HOLD_FREEFALL_LAND, animation, AIR_STEP_CHECK_LEDGE_GRAB);
    return false;
}

s32 act_side_flip(MarioState* m) {
    if (m.input & INPUT_B_PRESSED) {
        return set_mario_action(m, ACT_DIVE, 0);
    }

    if (m.input & INPUT_Z_PRESSED) {
        m.marioObj.header.gfx.angle[1] -= 0x8000;
        return set_mario_action(m, ACT_GROUND_POUND, 0);
    }

    if (m.input & INPUT_ANALOG_SPIN) {
        return set_mario_action(m, ACT_SPIN_JUMP, 1);
    }

    play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, 0);

    if (common_air_action_step(m, ACT_SIDE_FLIP_LAND, MARIO_ANIM_SLIDEFLIP, AIR_STEP_CHECK_LEDGE_GRAB)
        != AIR_STEP_GRABBED_LEDGE) {
        m.marioObj.header.gfx.angle[1] += 0x8000;
    }

    // This must be one line to match on -O2
    // clang-format off
    if (m.marioObj.header.gfx.animInfo.animFrame == 6) play_sound(SOUND_ACTION_SIDE_FLIP_UNK, m.marioObj.header.gfx.cameraToObject.ptr);
    // clang-format on
    return false;
}

s32 act_wall_kick_air(MarioState* m) {
    if (m.input & INPUT_B_PRESSED) {
        return set_mario_action(m, ACT_DIVE, 0);
    }

    if (m.input & INPUT_Z_PRESSED) {
        return set_mario_action(m, ACT_GROUND_POUND, 0);
    }

    if (m.input & INPUT_ANALOG_SPIN) {
        return set_mario_action(m, ACT_SPIN_JUMP, 1);
    }

    play_mario_jump_sound(m);
    common_air_action_step(m, ACT_JUMP_LAND, MARIO_ANIM_SLIDEJUMP, AIR_STEP_CHECK_LEDGE_GRAB);
    return false;
}

s32 act_long_jump(MarioState* m) {
    s32 animation;
    if (!m.marioObj.oMarioLongJumpIsSlow) {
        animation = MARIO_ANIM_FAST_LONGJUMP;
    } else {
        animation = MARIO_ANIM_SLOW_LONGJUMP;
    }

    play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, SOUND_MARIO_YAHOO);

    if (m.floor.type == SURFACE_VERTICAL_WIND && m.actionState == 0) {
        play_sound(SOUND_MARIO_HERE_WE_GO, m.marioObj.header.gfx.cameraToObject.ptr);
        m.actionState = 1;
    }

    common_air_action_step(m, ACT_LONG_JUMP_LAND, animation, AIR_STEP_CHECK_LEDGE_GRAB);
    version (SM64_SH) {
        if (m.action == ACT_LONG_JUMP_LAND) {
            queue_rumble_data(5, 40);
        }
    }
    return false;
}

s32 act_riding_shell_air(MarioState* m) {
    play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, 0);
    set_mario_animation(m, MARIO_ANIM_JUMP_RIDING_SHELL);

    update_air_without_turn(m);

    switch (perform_air_step(m, 0)) {
        case AIR_STEP_LANDED:
            set_mario_action(m, ACT_RIDING_SHELL_GROUND, 1);
            break;

        case AIR_STEP_HIT_WALL:
            mario_set_forward_vel(m, 0.0f);
            break;

        case AIR_STEP_HIT_LAVA_WALL:
            lava_boost_on_wall(m);
            break;

        default: break;
    }

    m.marioObj.header.gfx.pos[1] += 42.0f;
    return false;
}

s32 act_twirling(MarioState* m) {
    s16 startTwirlYaw = m.twirlYaw;
    s16 yawVelTarget;

    if (m.input & INPUT_A_DOWN) {
        yawVelTarget = 0x2000;
    } else {
        yawVelTarget = 0x1800;
    }

    if (m.vel[1] < 0.0f && m.input & INPUT_Z_PRESSED) {
        return set_mario_action(m, ACT_SPIN_POUND, 0);
    }

    m.angleVel[1] = cast(s16) (approach_s32(m.angleVel[1], yawVelTarget, 0x200, 0x200));
    m.twirlYaw += m.angleVel[1];

    set_mario_animation(m, m.actionArg == 0 ? MARIO_ANIM_START_TWIRL : MARIO_ANIM_TWIRL);
    if (is_anim_past_end(m)) {
        m.actionArg = 1;
    }

    if (startTwirlYaw > m.twirlYaw) {
        play_sound(SOUND_ACTION_TWIRL, m.marioObj.header.gfx.cameraToObject.ptr);
    }

    update_lava_boost_or_twirling(m);

    switch (perform_air_step(m, 0)) {
        case AIR_STEP_LANDED:
            set_mario_action(m, ACT_TWIRL_LAND, 0);
            break;

        case AIR_STEP_HIT_WALL:
            mario_bonk_reflection(m, false);
            break;

        case AIR_STEP_HIT_LAVA_WALL:
            lava_boost_on_wall(m);
            break;

        default: break;
    }

    m.marioObj.header.gfx.angle[1] += m.twirlYaw;
    return false;
}

s32 act_dive(MarioState* m) {
    if (m.actionArg == 0) {
        play_mario_sound(m, SOUND_ACTION_THROW, SOUND_MARIO_HOOHOO);
    } else {
        play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, 0);
    }

    set_mario_animation(m, MARIO_ANIM_DIVE);
    if (mario_check_object_grab(m)) {
        mario_grab_used_object(m);
        m.marioBodyState.grabPos = GRAB_POS_LIGHT_OBJ;
        if (m.action != ACT_DIVE) {
            return true;
        }
    }

    update_air_without_turn(m);

    switch (perform_air_step(m, 0)) {
        case AIR_STEP_NONE:
            if (m.vel[1] < 0.0f && m.faceAngle[0] > -0x2AAA) {
                m.faceAngle[0] -= 0x200;
                if (m.faceAngle[0] < -0x2AAA) {
                    m.faceAngle[0] = -0x2AAA;
                }
            }
            m.marioObj.header.gfx.angle[0] = -m.faceAngle[0];
            break;

        case AIR_STEP_LANDED:
            if (should_get_stuck_in_ground(m) && m.faceAngle[0] == -0x2AAA) {
                version (SM64_SH) {
                    queue_rumble_data(5, 80);
                }
                version (SM64_JP) {
                    play_sound(SOUND_MARIO_OOOF, m.marioObj.header.gfx.cameraToObject.ptr);
                } else {
                    play_sound(SOUND_MARIO_OOOF2, m.marioObj.header.gfx.cameraToObject.ptr);
                }
                m.particleFlags |= PARTICLE_MIST_CIRCLE;
                drop_and_set_mario_action(m, ACT_HEAD_STUCK_IN_GROUND, 0);
            } else if (!check_fall_damage(m, ACT_HARD_FORWARD_GROUND_KB)) {
                if (m.heldObj == null) {
                    set_mario_action(m, ACT_DIVE_SLIDE, 0);
                } else {
                    set_mario_action(m, ACT_DIVE_PICKING_UP, 0);
                }
            }
            m.faceAngle[0] = 0;
            break;

        case AIR_STEP_HIT_WALL:
            mario_bonk_reflection(m, true);
            m.faceAngle[0] = 0;

            if (m.vel[1] > 0.0f) {
                m.vel[1] = 0.0f;
            }

            m.particleFlags |= PARTICLE_VERTICAL_STAR;
            drop_and_set_mario_action(m, ACT_BACKWARD_AIR_KB, 0);
            break;

        case AIR_STEP_HIT_LAVA_WALL:
            lava_boost_on_wall(m);
            break;

        default: break;
    }

    return false;
}

s32 act_air_throw(MarioState* m) {
    if (++(m.actionTimer) == 4) {
        mario_throw_held_object(m);
    }

    play_sound_if_no_flag(m, SOUND_MARIO_WAH2, MARIO_MARIO_SOUND_PLAYED);
    set_mario_animation(m, MARIO_ANIM_THROW_LIGHT_OBJECT);
    update_air_without_turn(m);

    switch (perform_air_step(m, 0)) {
        case AIR_STEP_LANDED:
            if (!check_fall_damage_or_get_stuck(m, ACT_HARD_BACKWARD_GROUND_KB)) {
                m.action = ACT_AIR_THROW_LAND;
            }
            break;

        case AIR_STEP_HIT_WALL:
            mario_set_forward_vel(m, 0.0f);
            break;

        case AIR_STEP_HIT_LAVA_WALL:
            lava_boost_on_wall(m);
            break;

        default: break;
    }

    return false;
}

s32 act_water_jump(MarioState* m) {
    if (m.forwardVel < 15.0f) {
        mario_set_forward_vel(m, 15.0f);
    }

    play_mario_sound(m, SOUND_ACTION_UNKNOWN432, 0);
    set_mario_animation(m, MARIO_ANIM_SINGLE_JUMP);

    switch (perform_air_step(m, AIR_STEP_CHECK_LEDGE_GRAB)) {
        case AIR_STEP_LANDED:
            set_mario_action(m, ACT_JUMP_LAND, 0);
            set_camera_mode(m.area.camera, m.area.camera.defMode, 1);
            break;

        case AIR_STEP_HIT_WALL:
            mario_set_forward_vel(m, 15.0f);
            break;

        case AIR_STEP_GRABBED_LEDGE:
            version (SM64_JP) {
                set_mario_animation(m, MARIO_ANIM_IDLE_ON_LEDGE);
            }
            set_mario_action(m, ACT_LEDGE_GRAB, 0);
            set_camera_mode(m.area.camera, m.area.camera.defMode, 1);
            break;

        case AIR_STEP_HIT_LAVA_WALL:
            lava_boost_on_wall(m);
            break;

        default: break;
    }

    if (m.prevAction == ACT_WATER_GROUND_POUND_JUMP) {
        // maintain spinning from water ground pound jump anim
        m.spareFloat += (0x10000*1.0f - m.spareFloat) / 5.0f;
        m.marioObj.header.gfx.angle[1] -= cast(s16) m.spareFloat;
    }

    return false;
}

s32 act_hold_water_jump(MarioState* m) {
    if (m.marioObj.oInteractStatus & INT_STATUS_MARIO_DROP_OBJECT) {
        return drop_and_set_mario_action(m, ACT_FREEFALL, 0);
    }

    if (m.forwardVel < 15.0f) {
        mario_set_forward_vel(m, 15.0f);
    }

    play_mario_sound(m, SOUND_ACTION_UNKNOWN432, 0);
    set_mario_animation(m, MARIO_ANIM_JUMP_WITH_LIGHT_OBJ);

    switch (perform_air_step(m, 0)) {
        case AIR_STEP_LANDED:
            set_mario_action(m, ACT_HOLD_JUMP_LAND, 0);
            set_camera_mode(m.area.camera, m.area.camera.defMode, 1);
            break;

        case AIR_STEP_HIT_WALL:
            mario_set_forward_vel(m, 15.0f);
            break;

        case AIR_STEP_HIT_LAVA_WALL:
            lava_boost_on_wall(m);
            break;

        default: break;
    }

    return false;
}

s32 act_steep_jump(MarioState* m) {
    if (m.input & INPUT_B_PRESSED) {
        return set_mario_action(m, ACT_DIVE, 0);
    }

    play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, 0);
    mario_set_forward_vel(m, 0.98f * m.forwardVel);

    switch (perform_air_step(m, 0)) {
        case AIR_STEP_LANDED:
            if (!check_fall_damage_or_get_stuck(m, ACT_HARD_BACKWARD_GROUND_KB)) {
                m.faceAngle[0] = 0;
                set_mario_action(m, m.forwardVel < 0.0f ? ACT_BEGIN_SLIDING : ACT_JUMP_LAND, 0);
            }
            break;

        case AIR_STEP_HIT_WALL:
            mario_set_forward_vel(m, 0.0f);
            break;

        case AIR_STEP_HIT_LAVA_WALL:
            lava_boost_on_wall(m);
            break;

        default: break;
    }

    set_mario_animation(m, MARIO_ANIM_SINGLE_JUMP);
    m.marioObj.header.gfx.angle[1] = cast(s16) (m.marioObj.oMarioSteepJumpYaw);
    return false;
}

s32 act_ground_pound(MarioState* m) {
    u32 stepResult;
    f32 yOffset;

    play_sound_if_no_flag(m, SOUND_ACTION_THROW, MARIO_ACTION_SOUND_PLAYED);

    if (m.actionState == 0) {
        if (m.actionTimer < 10) {
            yOffset = 20 - 2 * m.actionTimer;
            if (m.pos[1] + yOffset + 160.0f < m.ceilHeight) {
                m.pos[1] += yOffset;
                m.peakHeight = m.pos[1];
                vec3f_copy(m.marioObj.header.gfx.pos, m.pos);
            }
        }

        m.vel[1] = -50.0f;
        mario_set_forward_vel(m, 0.0f);

        set_mario_animation(m, m.actionArg == 0 ? MARIO_ANIM_START_GROUND_POUND
                                                 : MARIO_ANIM_TRIPLE_JUMP_GROUND_POUND);
        if (m.actionTimer == 0) {
            play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject.ptr);
        }

        m.actionTimer++;
        if (m.actionTimer >= m.marioObj.header.gfx.animInfo.curAnim.loopEnd + 4) {
            play_sound(SOUND_MARIO_GROUND_POUND_WAH, m.marioObj.header.gfx.cameraToObject.ptr);
            m.actionState = 1;
        }

        if (m.input & INPUT_B_PRESSED) {
            mario_set_forward_vel(m, 10.0f);
            m.vel[1] = 35;
            set_mario_action(m, ACT_DIVE, 0);
        }
    } else {
        set_mario_animation(m, MARIO_ANIM_GROUND_POUND);

        stepResult = perform_air_step(m, 0);
        if (stepResult == AIR_STEP_LANDED) {
            if (should_get_stuck_in_ground(m)) {
                version (SM64_SH) {
                    queue_rumble_data(5, 80);
                }
                version (SM64_JP) {
                    play_sound(SOUND_MARIO_OOOF, m.marioObj.header.gfx.cameraToObject.ptr);
                } else {
                    play_sound(SOUND_MARIO_OOOF2, m.marioObj.header.gfx.cameraToObject.ptr);
                }
                m.particleFlags |= PARTICLE_MIST_CIRCLE;
                set_mario_action(m, ACT_BUTT_STUCK_IN_GROUND, 0);
            } else {
                play_mario_heavy_landing_sound(m, SOUND_ACTION_TERRAIN_HEAVY_LANDING);
                if (!check_fall_damage(m, ACT_HARD_BACKWARD_GROUND_KB)) {
                    m.particleFlags |= PARTICLE_MIST_CIRCLE | PARTICLE_HORIZONTAL_STAR;
                    set_mario_action(m, ACT_GROUND_POUND_LAND, 0);
                }
            }
            set_camera_shake_from_hit(SHAKE_GROUND_POUND);
        } else if (stepResult == AIR_STEP_HIT_WALL) {
            mario_set_forward_vel(m, -16.0f);
            if (m.vel[1] > 0.0f) {
                m.vel[1] = 0.0f;
            }

            m.particleFlags |= PARTICLE_VERTICAL_STAR;
            set_mario_action(m, ACT_BACKWARD_AIR_KB, 0);
        } else {
            if (m.input & INPUT_B_PRESSED) {
                mario_set_forward_vel(m, 10.0f);
                m.vel[1] = 35;
                set_mario_action(m, ACT_DIVE, 0);
            }
        }
    }

    return false;
}

s32 act_burning_jump(MarioState* m) {
    play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, m.actionArg == 0 ? 0 : -1);
    mario_set_forward_vel(m, m.forwardVel);

    if (perform_air_step(m, 0) == AIR_STEP_LANDED) {
        play_mario_landing_sound(m, SOUND_ACTION_TERRAIN_LANDING);
        set_mario_action(m, ACT_BURNING_GROUND, 0);
    }

    set_mario_animation(m, m.actionArg == 0 ? MARIO_ANIM_SINGLE_JUMP : MARIO_ANIM_FIRE_LAVA_BURN);
    m.particleFlags |= PARTICLE_FIRE;
    play_sound(SOUND_MOVING_LAVA_BURN, m.marioObj.header.gfx.cameraToObject.ptr);

    m.marioObj.oMarioBurnTimer += 3;

    m.health -= 10;
    if (m.health < 0x100) {
        m.health = 0xFF;
    }
    version (SM64_SH) {
        reset_rumble_timers();
    }
    return false;
}

s32 act_burning_fall(MarioState* m) {
    mario_set_forward_vel(m, m.forwardVel);

    if (perform_air_step(m, 0) == AIR_STEP_LANDED) {
        play_mario_landing_sound(m, SOUND_ACTION_TERRAIN_LANDING);
        set_mario_action(m, ACT_BURNING_GROUND, 0);
    }

    set_mario_animation(m, MARIO_ANIM_GENERAL_FALL);
    m.particleFlags |= PARTICLE_FIRE;
    m.marioObj.oMarioBurnTimer += 3;

    m.health -= 10;
    if (m.health < 0x100) {
        m.health = 0xFF;
    }
    version (SM64_SH) {
        reset_rumble_timers();
    }
    return false;
}

s32 act_crazy_box_bounce(MarioState* m) {
    f32 minSpeed;

    if (m.actionTimer == 0) {
        switch (m.actionArg) {
            case 0:
                m.vel[1] = 45.0f;
                minSpeed = 32.0f;
                break;

            case 1:
                m.vel[1] = 60.0f;
                minSpeed = 36.0f;
                break;

            case 2:
                m.vel[1] = 100.0f;
                minSpeed = 48.0f;
                break;

            default: break;
        }

        play_sound(minSpeed < 40.0f ? SOUND_GENERAL_BOING1 : SOUND_GENERAL_BOING2,
                   m.marioObj.header.gfx.cameraToObject.ptr);

        if (m.forwardVel < minSpeed) {
            mario_set_forward_vel(m, minSpeed);
        }

        m.actionTimer = 1;
    }

    play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, 0);
    set_mario_animation(m, MARIO_ANIM_DIVE);

    update_air_without_turn(m);

    switch (perform_air_step(m, 0)) {
        case AIR_STEP_LANDED:
            if (m.actionArg < 2) {
                set_mario_action(m, ACT_CRAZY_BOX_BOUNCE, m.actionArg + 1);
            } else {
                m.heldObj.oInteractStatus = INT_STATUS_STOP_RIDING;
                m.heldObj = null;
                set_mario_action(m, ACT_STOMACH_SLIDE, 0);
            }
            version (SM64_SH) {
                queue_rumble_data(5, 80);
            }
            m.particleFlags |= PARTICLE_MIST_CIRCLE;
            break;

        case AIR_STEP_HIT_WALL:
            mario_bonk_reflection(m, false);
            break;

        case AIR_STEP_HIT_LAVA_WALL:
            lava_boost_on_wall(m);
            break;

        default: break;
    }

    m.marioObj.header.gfx.angle[0] = atan2s(m.forwardVel, -m.vel[1]);
    return false;
}

u32 common_air_knockback_step(MarioState* m, u32 landAction, u32 hardFallAction, s32 animation,
                              f32 speed) {
    u32 stepResult;

    mario_set_forward_vel(m, speed);

    stepResult = perform_air_step(m, 0);
    switch (stepResult) {
        case AIR_STEP_NONE:
            set_mario_animation(m, animation);
            break;

        case AIR_STEP_LANDED:
            version (SM64_SH) {
                if (m.action == ACT_SOFT_BONK) {
                    queue_rumble_data(5, 80);
                }
            }
            if (!check_fall_damage_or_get_stuck(m, hardFallAction)) {
                version (SM64_JP) {
                    if (m.action == ACT_THROWN_FORWARD || m.action == ACT_THROWN_BACKWARD) {
                        set_mario_action(m, landAction, m.hurtCounter);
                    } else {
                        set_mario_action(m, landAction, m.actionArg);
                    }
                } else {
                    set_mario_action(m, landAction, m.actionArg);
                }
            }
            break;

        case AIR_STEP_HIT_WALL:
            set_mario_animation(m, MARIO_ANIM_BACKWARD_AIR_KB);
            mario_bonk_reflection(m, false);

            if (m.vel[1] > 0.0f) {
                m.vel[1] = 0.0f;
            }

            mario_set_forward_vel(m, -speed);
            break;

        case AIR_STEP_HIT_LAVA_WALL:
            lava_boost_on_wall(m);
            break;

        default: break;
    }

    return stepResult;
}

s32 check_wall_kick(MarioState* m) {
    if ((m.input & INPUT_A_PRESSED) && m.wallKickTimer != 0 && m.prevAction == ACT_AIR_HIT_WALL) {
        m.faceAngle[1] += 0x8000;
        return set_mario_action(m, ACT_WALL_KICK_AIR, 0);
    }

    return false;
}

s32 act_backward_air_kb(MarioState* m) {
    if (check_wall_kick(m)) {
        return true;
    }

    version (SM64_JP) {
        play_knockback_sound(m);
    } else {
        play_sound_if_no_flag(m, SOUND_MARIO_UH, MARIO_MARIO_SOUND_PLAYED);
    }
    common_air_knockback_step(m, ACT_BACKWARD_GROUND_KB, ACT_HARD_BACKWARD_GROUND_KB, 0x0002, -16.0f);
    return false;
}

s32 act_forward_air_kb(MarioState* m) {
    if (check_wall_kick(m)) {
        return true;
    }

    version (SM64_JP) {
        play_knockback_sound(m);
    } else {
        play_sound_if_no_flag(m, SOUND_MARIO_UH, MARIO_MARIO_SOUND_PLAYED);
    }
    common_air_knockback_step(m, ACT_FORWARD_GROUND_KB, ACT_HARD_FORWARD_GROUND_KB, 0x002D, 16.0f);
    return false;
}

s32 act_hard_backward_air_kb(MarioState* m) {
    version (SM64_JP) {
        play_knockback_sound(m);
    } else {
        play_sound_if_no_flag(m, SOUND_MARIO_UH, MARIO_MARIO_SOUND_PLAYED);
    }
    common_air_knockback_step(m, ACT_HARD_BACKWARD_GROUND_KB, ACT_HARD_BACKWARD_GROUND_KB, 0x0002,
                              -16.0f);
    return false;
}

s32 act_hard_forward_air_kb(MarioState* m) {
    version (SM64_JP) {
        play_knockback_sound(m);
    } else {
        play_sound_if_no_flag(m, SOUND_MARIO_UH, MARIO_MARIO_SOUND_PLAYED);
    }
    common_air_knockback_step(m, ACT_HARD_FORWARD_GROUND_KB, ACT_HARD_FORWARD_GROUND_KB, 0x002D, 16.0f);
    return false;
}

s32 act_thrown_backward(MarioState* m) {
    u32 landAction;
    if (m.actionArg != 0) {
        landAction = ACT_HARD_BACKWARD_GROUND_KB;
    } else {
        landAction = ACT_BACKWARD_GROUND_KB;
    }

    play_sound_if_no_flag(m, SOUND_MARIO_WAAAOOOW, MARIO_MARIO_SOUND_PLAYED);

    common_air_knockback_step(m, landAction, ACT_HARD_BACKWARD_GROUND_KB, 0x0002, m.forwardVel);

    m.forwardVel *= 0.98f;
    return false;
}

s32 act_thrown_forward(MarioState* m) {
    s16 pitch;

    u32 landAction;
    if (m.actionArg != 0) {
        landAction = ACT_HARD_FORWARD_GROUND_KB;
    } else {
        landAction = ACT_FORWARD_GROUND_KB;
    }

    play_sound_if_no_flag(m, SOUND_MARIO_WAAAOOOW, MARIO_MARIO_SOUND_PLAYED);

    if (common_air_knockback_step(m, landAction, ACT_HARD_FORWARD_GROUND_KB, 0x002D, m.forwardVel)
        == AIR_STEP_NONE) {
        pitch = atan2s(m.forwardVel, -m.vel[1]);
        if (pitch > 0x1800) {
            pitch = 0x1800;
        }

        m.marioObj.header.gfx.angle[0] = cast(s16) (pitch + 0x1800);
    }

    m.forwardVel *= 0.98f;
    return false;
}

s32 act_soft_bonk(MarioState* m) {
    if (check_wall_kick(m)) {
        return true;
    }

    version (SM64) {
        play_knockback_sound(m);
    } else {
        play_sound_if_no_flag(m, SOUND_MARIO_UH, MARIO_MARIO_SOUND_PLAYED);
    }

    common_air_knockback_step(m, ACT_FREEFALL_LAND, ACT_HARD_BACKWARD_GROUND_KB, 0x0056, m.forwardVel);
    return false;
}

s32 act_getting_blown(MarioState* m) {
    if (m.actionState == 0) {
        if (m.forwardVel > -60.0f) {
            m.forwardVel -= 6.0f;
        } else {
            m.actionState = 1;
        }
    } else {
        if (m.forwardVel < -16.0f) {
            m.forwardVel += 0.8f;
        }

        if (m.vel[1] < 0.0f && m.unkC4 < 4.0f) {
            m.unkC4 += 0.05f;
        }
    }

    if (++(m.actionTimer) == 20) {
        mario_blow_off_cap(m, 50.0f);
    }

    mario_set_forward_vel(m, m.forwardVel);
    version (SM64_JP) {
        play_sound_if_no_flag(m, SOUND_MARIO_UH, MARIO_MARIO_SOUND_PLAYED);
    }
    set_mario_animation(m, MARIO_ANIM_BACKWARD_AIR_KB);

    switch (perform_air_step(m, 0)) {
        case AIR_STEP_LANDED:
            set_mario_action(m, ACT_HARD_BACKWARD_AIR_KB, 0);
            break;

        case AIR_STEP_HIT_WALL:
            set_mario_animation(m, MARIO_ANIM_AIR_FORWARD_KB);
            mario_bonk_reflection(m, false);

            if (m.vel[1] > 0.0f) {
                m.vel[1] = 0.0f;
            }

            mario_set_forward_vel(m, -m.forwardVel);
            break;

        default: break;
    }

    return false;
}

s32 act_air_hit_wall(MarioState* m) {
    if (m.heldObj != null) {
        mario_drop_held_object(m);
    }

    if (++(m.actionTimer) <= 1 && m.input & INPUT_A_PRESSED) {
        m.vel[1] = 52.0f;
        m.faceAngle[1] += 0x8000;
        return set_mario_action(m, ACT_WALL_KICK_AIR, 0);
    } else if (m.forwardVel >= 38.0f) {
        m.wallKickTimer = 5;
        if (m.vel[1] > 0.0f) {
            m.vel[1] = 0.0f;
        }

        m.particleFlags |= PARTICLE_VERTICAL_STAR;
        return set_mario_action(m, ACT_BACKWARD_AIR_KB, 0);
    } else {
        m.faceAngle[1] += 0x8000;
        return set_mario_action(m, ACT_WALL_SLIDE, 0);
    }

    return set_mario_animation(m, MARIO_ANIM_START_WALLKICK);

    //! Missing return statement. The returned value is the result of the call
    // to set_mario_animation. In practice, this value is nonzero.
    // This results in this action "cancelling" into itself. It is supposed to
    // execute on two frames, but instead it executes twice on the same frame.
    // This results in firsties only being possible for a single frame, instead
    // of two.
}

s32 act_wall_slide(MarioState* m) {
    if (m.input & INPUT_A_PRESSED) {
        m.vel[1] = 52.0f;
        // m.faceAngle[1] += 0x8000;
        return set_mario_action(m, ACT_WALL_KICK_AIR, 0);
    }

    // attempt to stick to the wall a bit. if it's 0, sometimes you'll get kicked off of slightly sloped walls
    mario_set_forward_vel(m, -1.0f);

    m.particleFlags |= PARTICLE_DUST;

    play_sound(SOUND_MOVING_TERRAIN_SLIDE + m.terrainSoundAddend, m.marioObj.header.gfx.cameraToObject.ptr);
    set_mario_animation(m, MARIO_ANIM_START_WALLKICK);

    switch (perform_air_step(m, 0)) {
        case AIR_STEP_LANDED:
            mario_set_forward_vel(m, 0.0f);
            if (!check_fall_damage_or_get_stuck(m, ACT_HARD_BACKWARD_GROUND_KB)) {
                return set_mario_action(m, ACT_FREEFALL_LAND, 0);
            }
            break;

        default: break;
    }

    if (m.wall == null) {
        mario_set_forward_vel(m, 0.0f);
        return set_mario_action(m, ACT_FREEFALL, 0);
    }

    return false;
}

s32 act_forward_rollout(MarioState* m) {
    if (m.actionState == 0) {
        m.vel[1] = 30.0f;
        m.actionState = 1;
    }

    play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, 0);

    update_air_without_turn(m);

    switch (perform_air_step(m, 0)) {
        case AIR_STEP_NONE:
            if (m.actionState == 1) {
                if (set_mario_animation(m, MARIO_ANIM_FORWARD_SPINNING) == 4) {
                    play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject.ptr);
                }
            } else {
                set_mario_animation(m, MARIO_ANIM_GENERAL_FALL);
            }
            break;

        case AIR_STEP_LANDED:
            set_mario_action(m, ACT_FREEFALL_LAND_STOP, 0);
            play_mario_landing_sound(m, SOUND_ACTION_TERRAIN_LANDING);
            break;

        case AIR_STEP_HIT_WALL:
            mario_set_forward_vel(m, 0.0f);
            break;

        case AIR_STEP_HIT_LAVA_WALL:
            lava_boost_on_wall(m);
            break;

        default: break;
    }

    if (m.actionState == 1 && is_anim_past_end(m)) {
        m.actionState = 2;
    }
    return false;
}

s32 act_backward_rollout(MarioState* m) {
    if (m.actionState == 0) {
        m.vel[1] = 30.0f;
        m.actionState = 1;
    }

    play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, 0);

    update_air_without_turn(m);

    switch (perform_air_step(m, 0)) {
        case AIR_STEP_NONE:
            if (m.actionState == 1) {
                if (set_mario_animation(m, MARIO_ANIM_BACKWARD_SPINNING) == 4) {
                    play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject.ptr);
                }
            } else {
                set_mario_animation(m, MARIO_ANIM_GENERAL_FALL);
            }
            break;

        case AIR_STEP_LANDED:
            set_mario_action(m, ACT_FREEFALL_LAND_STOP, 0);
            play_mario_landing_sound(m, SOUND_ACTION_TERRAIN_LANDING);
            break;

        case AIR_STEP_HIT_WALL:
            mario_set_forward_vel(m, 0.0f);
            break;

        case AIR_STEP_HIT_LAVA_WALL:
            lava_boost_on_wall(m);
            break;

        default: break;
    }

    if (m.actionState == 1 && m.marioObj.header.gfx.animInfo.animFrame == 2) {
        m.actionState = 2;
    }
    return false;
}

s32 act_butt_slide_air(MarioState* m) {
    if (++(m.actionTimer) > 30 && m.pos[1] - m.floorHeight > 500.0f) {
        return set_mario_action(m, ACT_FREEFALL, 1);
    }

    update_air_with_turn(m);

    switch (perform_air_step(m, 0)) {
        case AIR_STEP_LANDED:
            if (m.actionState == 0 && m.vel[1] < 0.0f && m.floor.normal.y >= 0.9848077f) {
                m.vel[1] = -m.vel[1] / 2.0f;
                m.actionState = 1;
            } else {
                set_mario_action(m, ACT_BUTT_SLIDE, 0);
            }
            play_mario_landing_sound(m, SOUND_ACTION_TERRAIN_LANDING);
            break;

        case AIR_STEP_HIT_WALL:
            if (m.vel[1] > 0.0f) {
                m.vel[1] = 0.0f;
            }
            m.particleFlags |= PARTICLE_VERTICAL_STAR;
            set_mario_action(m, ACT_BACKWARD_AIR_KB, 0);
            break;

        case AIR_STEP_HIT_LAVA_WALL:
            lava_boost_on_wall(m);
            break;

        default: break;
    }

    set_mario_animation(m, MARIO_ANIM_SLIDE);
    return false;
}

s32 act_hold_butt_slide_air(MarioState* m) {
    if (m.marioObj.oInteractStatus & INT_STATUS_MARIO_DROP_OBJECT) {
        return drop_and_set_mario_action(m, ACT_HOLD_FREEFALL, 1);
    }

    if (++m.actionTimer > 30 && m.pos[1] - m.floorHeight > 500.0f) {
        return set_mario_action(m, ACT_HOLD_FREEFALL, 1);
    }

    update_air_with_turn(m);

    switch (perform_air_step(m, 0)) {
        case AIR_STEP_LANDED:
            if (m.actionState == 0 && m.vel[1] < 0.0f && m.floor.normal.y >= 0.9848077f) {
                m.vel[1] = -m.vel[1] / 2.0f;
                m.actionState = 1;
            } else {
                set_mario_action(m, ACT_HOLD_BUTT_SLIDE, 0);
            }
            play_mario_landing_sound(m, SOUND_ACTION_TERRAIN_LANDING);
            break;

        case AIR_STEP_HIT_WALL:
            if (m.vel[1] > 0.0f) {
                m.vel[1] = 0.0f;
            }

            mario_drop_held_object(m);
            m.particleFlags |= PARTICLE_VERTICAL_STAR;
            set_mario_action(m, ACT_BACKWARD_AIR_KB, 0);
            break;

        case AIR_STEP_HIT_LAVA_WALL:
            lava_boost_on_wall(m);
            break;

        default: break;
    }

    set_mario_animation(m, MARIO_ANIM_SLIDING_ON_BOTTOM_WITH_LIGHT_OBJ);
    return false;
}

s32 act_lava_boost(MarioState* m) {
    version (SM64_SH) {
        if (!(m.flags & MARIO_MARIO_SOUND_PLAYED)) {
            play_sound_if_no_flag(m, SOUND_MARIO_ON_FIRE, MARIO_MARIO_SOUND_PLAYED);
            queue_rumble_data(5, 80);
        }
    } else {
        play_sound_if_no_flag(m, SOUND_MARIO_ON_FIRE, MARIO_MARIO_SOUND_PLAYED);
    }

    if (!(m.input & INPUT_NONZERO_ANALOG)) {
        m.forwardVel = approach_f32(m.forwardVel, 0.0f, 0.35f, 0.35f);
    }

    update_lava_boost_or_twirling(m);

    switch (perform_air_step(m, 0)) {
        case AIR_STEP_LANDED:
            if (m.floor.type == SURFACE_BURNING) {
                m.actionState = 0;
                if (!(m.flags & MARIO_METAL_CAP)) {
                    m.hurtCounter += (m.flags & MARIO_CAP_ON_HEAD) ? 12 : 18;
                }
                m.vel[1] = 84.0f;
                play_sound(SOUND_MARIO_ON_FIRE, m.marioObj.header.gfx.cameraToObject.ptr);
                version (SM64_SH) {
                    queue_rumble_data(5, 80);
                }
            } else {
                play_mario_heavy_landing_sound(m, SOUND_ACTION_TERRAIN_BODY_HIT_GROUND);
                if (m.actionState < 2 && m.vel[1] < 0.0f) {
                    m.vel[1] = -m.vel[1] * 0.4f;
                    mario_set_forward_vel(m, m.forwardVel * 0.5f);
                    m.actionState += 1;
                } else {
                    set_mario_action(m, ACT_LAVA_BOOST_LAND, 0);
                }
            }
            break;

        case AIR_STEP_HIT_WALL:
            mario_bonk_reflection(m, false);
            break;

        case AIR_STEP_HIT_LAVA_WALL:
            lava_boost_on_wall(m);
            break;

        default: break;
    }

    set_mario_animation(m, MARIO_ANIM_FIRE_LAVA_BURN);
    if ((m.area.terrainType & TERRAIN_MASK) != TERRAIN_SNOW && !(m.flags & MARIO_METAL_CAP)
        && m.vel[1] > 0.0f) {
        m.particleFlags |= PARTICLE_FIRE;
        if (m.actionState == 0) {
            play_sound(SOUND_MOVING_LAVA_BURN, m.marioObj.header.gfx.cameraToObject.ptr);
        }
    }

    if (m.health < 0x100) {
        level_trigger_warp(m, WARP_OP_DEATH);
    }

    m.marioBodyState.eyeState = MARIO_EYES_DEAD;
    version (SM64_SH) {
        reset_rumble_timers();
    }
    return false;
}

s32 act_slide_kick(MarioState* m) {
    if (m.actionState == 0 && m.actionTimer == 0) {
        play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, SOUND_MARIO_HOOHOO);
        set_mario_animation(m, MARIO_ANIM_SLIDE_KICK);
    }

    if (++(m.actionTimer) > 30 && m.pos[1] - m.floorHeight > 500.0f) {
        return set_mario_action(m, ACT_FREEFALL, 2);
    }

    update_air_without_turn(m);

    switch (perform_air_step(m, 0)) {
        case AIR_STEP_NONE:
            if (m.actionState == 0) {
                m.marioObj.header.gfx.angle[0] = atan2s(m.forwardVel, -m.vel[1]);
                if (m.marioObj.header.gfx.angle[0] > 0x1800) {
                    m.marioObj.header.gfx.angle[0] = 0x1800;
                }
            }
            break;

        case AIR_STEP_LANDED:
            if (m.actionState == 0 && m.vel[1] < 0.0f) {
                m.vel[1] = -m.vel[1] / 2.0f;
                m.actionState = 1;
                m.actionTimer = 0;
            } else {
                set_mario_action(m, ACT_SLIDE_KICK_SLIDE, 0);
            }
            play_mario_landing_sound(m, SOUND_ACTION_TERRAIN_LANDING);
            break;

        case AIR_STEP_HIT_WALL:
            if (m.vel[1] > 0.0f) {
                m.vel[1] = 0.0f;
            }

            m.particleFlags |= PARTICLE_VERTICAL_STAR;

            set_mario_action(m, ACT_BACKWARD_AIR_KB, 0);
            break;

        case AIR_STEP_HIT_LAVA_WALL:
            lava_boost_on_wall(m);
            break;

        default: break;
    }

    return false;
}

s32 act_jump_kick(MarioState* m) {
    s32 animFrame;

    if (m.actionState == 0) {
        play_sound_if_no_flag(m, SOUND_MARIO_PUNCH_HOO, MARIO_ACTION_SOUND_PLAYED);
        m.marioObj.header.gfx.animInfo.animID = -1;
        set_mario_animation(m, MARIO_ANIM_AIR_KICK);
        m.actionState = 1;
    }

    animFrame = m.marioObj.header.gfx.animInfo.animFrame;
    if (animFrame == 0) {
        m.marioBodyState.punchState = (2 << 6) | 6;
    }
    if (animFrame >= 0 && animFrame < 8) {
        m.flags |= MARIO_KICKING;
    }

    update_air_without_turn(m);

    switch (perform_air_step(m, 0)) {
        case AIR_STEP_LANDED:
            if (!check_fall_damage_or_get_stuck(m, ACT_HARD_BACKWARD_GROUND_KB)) {
                set_mario_action(m, ACT_FREEFALL_LAND, 0);
            }
            break;

        case AIR_STEP_HIT_WALL:
            mario_set_forward_vel(m, 0.0f);
            break;

        default: break;
    }

    return false;
}

s32 act_shot_from_cannon(MarioState* m) {
    if (m.area.camera.mode != CAMERA_MODE_BEHIND_MARIO) {
        m.statusForCamera.cameraEvent = CAM_EVENT_SHOT_FROM_CANNON;
    }

    mario_set_forward_vel(m, m.forwardVel);

    play_sound_if_no_flag(m, SOUND_MARIO_YAHOO, MARIO_MARIO_SOUND_PLAYED);

    switch (perform_air_step(m, 0)) {
        case AIR_STEP_NONE:
            set_mario_animation(m, MARIO_ANIM_AIRBORNE_ON_STOMACH);
            m.faceAngle[0] = atan2s(m.forwardVel, m.vel[1]);
            m.marioObj.header.gfx.angle[0] = -m.faceAngle[0];
            break;

        case AIR_STEP_LANDED:
            set_mario_action(m, ACT_DIVE_SLIDE, 0);
            m.faceAngle[0] = 0;
            set_camera_mode(m.area.camera, m.area.camera.defMode, 1);
            version (SM64_SH) {
                queue_rumble_data(5, 80);
            }
            break;

        case AIR_STEP_HIT_WALL:
            mario_set_forward_vel(m, -16.0f);

            m.faceAngle[0] = 0;
            if (m.vel[1] > 0.0f) {
                m.vel[1] = 0.0f;
            }

            m.particleFlags |= PARTICLE_VERTICAL_STAR;
            set_mario_action(m, ACT_BACKWARD_AIR_KB, 0);
            set_camera_mode(m.area.camera, m.area.camera.defMode, 1);
            break;

        case AIR_STEP_HIT_LAVA_WALL:
            lava_boost_on_wall(m);
            break;

        default: break;
    }

    if ((m.flags & MARIO_WING_CAP) && m.vel[1] < 0.0f) {
        set_mario_action(m, ACT_FLYING, 0);
    }

    if ((m.forwardVel -= 0.05) < 10.0f) {
        mario_set_forward_vel(m, 10.0f);
    }

    if (m.vel[1] > 0.0f) {
        m.particleFlags |= PARTICLE_DUST;
    }
    version (SM64_SH) {
        reset_rumble_timers();
    }
    return false;
}

s32 act_flying(MarioState* m) {
    s16 startPitch = m.faceAngle[0];

    if (m.input & INPUT_Z_PRESSED) {
        if (m.area.camera.mode == CAMERA_MODE_BEHIND_MARIO) {
            set_camera_mode(m.area.camera, m.area.camera.defMode, 1);
        }
        return set_mario_action(m, ACT_GROUND_POUND, 1);
    }

    if (!(m.flags & MARIO_WING_CAP)) {
        if (m.area.camera.mode == CAMERA_MODE_BEHIND_MARIO) {
            set_camera_mode(m.area.camera, m.area.camera.defMode, 1);
        }
        return set_mario_action(m, ACT_FREEFALL, 0);
    }

    if (m.area.camera.mode != CAMERA_MODE_BEHIND_MARIO) {
        set_camera_mode(m.area.camera, CAMERA_MODE_BEHIND_MARIO, 1);
    }

    if (m.actionState == 0) {
        if (m.actionArg == 0) {
            set_mario_animation(m, MARIO_ANIM_FLY_FROM_CANNON);
        } else {
            set_mario_animation(m, MARIO_ANIM_FORWARD_SPINNING_FLIP);
            if (m.marioObj.header.gfx.animInfo.animFrame == 1) {
                play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject.ptr);
            }
        }

        if (is_anim_at_end(m)) {
            if (m.actionArg == 2) {
                load_level_init_text(0);
                m.actionArg = 1;
            }

            set_mario_animation(m, MARIO_ANIM_WING_CAP_FLY);
            m.actionState = 1;
        }
    }

    update_flying(m);

    switch (perform_air_step(m, 0)) {
        case AIR_STEP_NONE:
            m.marioObj.header.gfx.angle[0] = -m.faceAngle[0];
            m.marioObj.header.gfx.angle[2] = m.faceAngle[2];
            m.actionTimer = 0;
            break;

        case AIR_STEP_LANDED:
            set_mario_action(m, ACT_DIVE_SLIDE, 0);

            set_mario_animation(m, MARIO_ANIM_DIVE);
            set_anim_to_frame(m, 7);

            m.faceAngle[0] = 0;
            set_camera_mode(m.area.camera, m.area.camera.defMode, 1);
            version (SM64_SH) {
                queue_rumble_data(5, 80);
            }
            break;

        case AIR_STEP_HIT_WALL:
            if (m.wall != null) {
                mario_set_forward_vel(m, -16.0f);
                m.faceAngle[0] = 0;

                if (m.vel[1] > 0.0f) {
                    m.vel[1] = 0.0f;
                }

                play_sound((m.flags & MARIO_METAL_CAP) ? SOUND_ACTION_METAL_BONK
                                                        : SOUND_ACTION_BONK,
                           m.marioObj.header.gfx.cameraToObject.ptr);

                m.particleFlags |= PARTICLE_VERTICAL_STAR;
                set_mario_action(m, ACT_BACKWARD_AIR_KB, 0);
                set_camera_mode(m.area.camera, m.area.camera.defMode, 1);
            } else {
                if (m.actionTimer++ == 0) {
                    play_sound(SOUND_ACTION_HIT, m.marioObj.header.gfx.cameraToObject.ptr);
                }

                if (m.actionTimer == 30) {
                    m.actionTimer = 0;
                }

                m.faceAngle[0] -= 0x200;
                if (m.faceAngle[0] < -0x2AAA) {
                    m.faceAngle[0] = -0x2AAA;
                }

                m.marioObj.header.gfx.angle[0] = -m.faceAngle[0];
                m.marioObj.header.gfx.angle[2] = m.faceAngle[2];
            }
            break;

        case AIR_STEP_HIT_LAVA_WALL:
            lava_boost_on_wall(m);
            break;

        default: break;
    }

    if (m.faceAngle[0] > 0x800 && m.forwardVel >= 48.0f) {
        m.particleFlags |= PARTICLE_DUST;
    }

    if (startPitch <= 0 && m.faceAngle[0] > 0 && m.forwardVel >= 48.0f) {
        play_sound(SOUND_ACTION_FLYING_FAST, m.marioObj.header.gfx.cameraToObject.ptr);
        version (SM64_JP) {
            play_sound(SOUND_MARIO_YAHOO_WAHA_YIPPEE + ((gAudioRandom % 5) << 16),
                       m.marioObj.header.gfx.cameraToObject.ptr);
        }
        version (SM64_SH) {
            queue_rumble_data(50, 40);
        }
    }

    play_sound(SOUND_MOVING_FLYING, m.marioObj.header.gfx.cameraToObject.ptr);
    adjust_sound_for_speed(m);
    return false;
}

s32 act_riding_hoot(MarioState* m) {
    if (!(m.input & INPUT_A_DOWN) || (m.marioObj.oInteractStatus & INT_STATUS_MARIO_UNK7)) {
        m.usedObj.oInteractStatus = 0;
        m.usedObj.oHootMarioReleaseTime = gGlobalTimer;

        play_sound_if_no_flag(m, SOUND_MARIO_UH, MARIO_MARIO_SOUND_PLAYED);
        version (SM64_SH) {
            queue_rumble_data(4, 40);
        }
        return set_mario_action(m, ACT_FREEFALL, 0);
    }

    m.pos[0] = m.usedObj.oPosX;
    m.pos[1] = m.usedObj.oPosY - 92.5f;
    m.pos[2] = m.usedObj.oPosZ;

    m.faceAngle[1] = cast(s16) (0x4000 - m.usedObj.oMoveAngleYaw);

    if (m.actionState == 0) {
        set_mario_animation(m, MARIO_ANIM_HANG_ON_CEILING);
        if (is_anim_at_end(m)) {
            set_mario_animation(m, MARIO_ANIM_HANG_ON_OWL);
            m.actionState = 1;
        }
    }

    vec3f_set(m.vel, 0.0f, 0.0f, 0.0f);
    vec3f_set(m.marioObj.header.gfx.pos, m.pos[0], m.pos[1], m.pos[2]);
    vec3s_set(m.marioObj.header.gfx.angle, 0, cast(s16) (0x4000 - m.faceAngle[1]), 0);
    return false;
}

s32 act_flying_triple_jump(MarioState* m) {
    version (SM64_JP) {
        if (m.input & (INPUT_B_PRESSED | INPUT_Z_PRESSED)) {
            if (m.area.camera.mode == CAMERA_MODE_BEHIND_MARIO) {
                set_camera_mode(m.area.camera, m.area.camera.defMode, 1);
            }
            if (m.input & INPUT_B_PRESSED) {
                return set_mario_action(m, ACT_DIVE, 0);
            } else {
                return set_mario_action(m, ACT_GROUND_POUND, 0);
            }
        }
    } else {
        if (m.input & INPUT_B_PRESSED) {
            return set_mario_action(m, ACT_DIVE, 0);
        }

        if (m.input & INPUT_Z_PRESSED) {
            return set_mario_action(m, ACT_GROUND_POUND, 0);
        }
    }

    play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, SOUND_MARIO_YAHOO);
    if (m.actionState == 0) {
        set_mario_animation(m, MARIO_ANIM_TRIPLE_JUMP_FLY);

        if (m.marioObj.header.gfx.animInfo.animFrame == 7) {
            play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject.ptr);
        }

        if (is_anim_past_end(m)) {
            set_mario_animation(m, MARIO_ANIM_FORWARD_SPINNING);
            version (SM64_SH) {
                queue_rumble_data(8, 80);
            }
            m.actionState = 1;
        }
    }

    if (m.actionState == 1 && m.marioObj.header.gfx.animInfo.animFrame == 1) {
        play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject.ptr);
    }

    if (m.vel[1] < 4.0f) {
        if (m.area.camera.mode != CAMERA_MODE_BEHIND_MARIO) {
            set_camera_mode(m.area.camera, CAMERA_MODE_BEHIND_MARIO, 1);
        }

        if (m.forwardVel < 32.0f) {
            mario_set_forward_vel(m, 32.0f);
        }

        set_mario_action(m, ACT_FLYING, 1);
    }

    if (m.actionTimer++ == 10 && m.area.camera.mode != CAMERA_MODE_BEHIND_MARIO) {
        set_camera_mode(m.area.camera, CAMERA_MODE_BEHIND_MARIO, 1);
    }

    update_air_without_turn(m);

    switch (perform_air_step(m, 0)) {
        case AIR_STEP_LANDED:
            if (!check_fall_damage_or_get_stuck(m, ACT_HARD_BACKWARD_GROUND_KB)) {
                set_mario_action(m, ACT_DOUBLE_JUMP_LAND, 0);
            }
            break;

        case AIR_STEP_HIT_WALL:
            mario_bonk_reflection(m, false);
            break;

        case AIR_STEP_HIT_LAVA_WALL:
            lava_boost_on_wall(m);
            break;

        default: break;
    }

    return false;
}

s32 act_top_of_pole_jump(MarioState* m) {
    play_mario_jump_sound(m);
    common_air_action_step(m, ACT_FREEFALL_LAND, MARIO_ANIM_HANDSTAND_JUMP, AIR_STEP_CHECK_LEDGE_GRAB);
    return false;
}

s32 act_vertical_wind(MarioState* m) {
    s16 intendedDYaw = cast(s16) (m.intendedYaw - m.faceAngle[1]);
    f32 intendedMag = m.intendedMag / 32.0f;

    play_sound_if_no_flag(m, SOUND_MARIO_HERE_WE_GO, MARIO_MARIO_SOUND_PLAYED);
    if (m.actionState == 0) {
        set_mario_animation(m, MARIO_ANIM_FORWARD_SPINNING_FLIP);
        if (m.marioObj.header.gfx.animInfo.animFrame == 1) {
            play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject.ptr);
            version (SM64_SH) {
                queue_rumble_data(8, 80);
            }
        }

        if (is_anim_past_end(m)) {
            m.actionState = 1;
        }
    } else {
        set_mario_animation(m, MARIO_ANIM_AIRBORNE_ON_STOMACH);
    }

    update_air_without_turn(m);

    switch (perform_air_step(m, 0)) {
        case AIR_STEP_LANDED:
            set_mario_action(m, ACT_DIVE_SLIDE, 0);
            break;

        case AIR_STEP_HIT_WALL:
            mario_set_forward_vel(m, -16.0f);
            break;

        default: break;
    }

    m.marioObj.header.gfx.angle[0] = cast(s16) ( 6144.0f * intendedMag * coss(intendedDYaw));
    m.marioObj.header.gfx.angle[2] = cast(s16) (-4096.0f * intendedMag * sins(intendedDYaw));
    return false;
}

s32 act_special_triple_jump(MarioState* m) {
    if (m.input & INPUT_B_PRESSED) {
        return set_mario_action(m, ACT_DIVE, 0);
    }

    if (m.input & INPUT_Z_PRESSED) {
        return set_mario_action(m, ACT_GROUND_POUND, 0);
    }

    play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, SOUND_MARIO_YAHOO);

    update_air_without_turn(m);

    switch (perform_air_step(m, 0)) {
        case AIR_STEP_LANDED:
            if (m.actionState++ == 0) {
                m.vel[1] = 42.0f;
            } else {
                set_mario_action(m, ACT_FREEFALL_LAND_STOP, 0);
            }
            play_mario_landing_sound(m, SOUND_ACTION_TERRAIN_LANDING);
            break;

        case AIR_STEP_HIT_WALL:
            mario_bonk_reflection(m, true);
            break;

        default: break;
    }

    if (m.actionState == 0 || m.vel[1] > 0.0f) {
        if (set_mario_animation(m, MARIO_ANIM_FORWARD_SPINNING) == 0) {
            play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject.ptr);
        }
    } else {
        set_mario_animation(m, MARIO_ANIM_GENERAL_FALL);
    }

    m.particleFlags |= PARTICLE_SPARKLES;
    return false;
}

s32 act_ground_pound_jump(MarioState* m) {
    if (check_kick_or_dive_in_air(m)) {
        m.marioObj.header.gfx.angle[1] += cast(s16) m.spareFloat;
        return true;
    }

    if (m.input & INPUT_Z_PRESSED) {
        m.marioObj.header.gfx.angle[1] += cast(s16) m.spareFloat;
        return set_mario_action(m, ACT_GROUND_POUND, 0);
    }

    if (m.input & INPUT_ANALOG_SPIN) {
        return set_mario_action(m, ACT_SPIN_JUMP, 1);
    }

    if (m.actionTimer == 0) {
        m.spareFloat = 0;
    }
    else if (m.actionTimer == 1) {
        play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject.ptr);
    }

    play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, SOUND_MARIO_YAHOO);

    common_air_action_step(m, ACT_JUMP_LAND, MARIO_ANIM_SINGLE_JUMP,
                           AIR_STEP_CHECK_LEDGE_GRAB | AIR_STEP_CHECK_HANG);

    m.spareFloat += (0x10000*1.0f - m.spareFloat) / 5.0f;
    m.marioObj.header.gfx.angle[1] -= cast(s16) m.spareFloat;

    m.actionTimer++;

    return false;
}

s32 act_roll_air(MarioState* m) {
    enum MAX_NORMAL_ROLL_SPEED        = 50.0f;
    enum ROLL_AIR_CANCEL_LOCKOUT_TIME = 15;

    if (m.actionTimer == 0) {
        if (m.prevAction != ACT_ROLL) {
            m.spareFloat = 0;
            m.spareInt   = 0;
        }
    }

    if (!(m.input & INPUT_Z_DOWN) && m.actionTimer >= ROLL_AIR_CANCEL_LOCKOUT_TIME) {
        return set_mario_action(m, ACT_FREEFALL, 0);
    }

    set_mario_animation(m, MARIO_ANIM_FORWARD_SPINNING);

    switch (perform_air_step(m, 0)) {
        case AIR_STEP_LANDED:
            if (!check_fall_damage_or_get_stuck(m, ACT_HARD_BACKWARD_GROUND_KB)) {
                play_sound_and_spawn_particles(m, SOUND_ACTION_TERRAIN_STEP, 0);
                return set_mario_action(m, ACT_ROLL, m.actionArg);
            }
            break;

        case AIR_STEP_HIT_WALL:
            version (SM64_SH) {
                queue_rumble_data(5, 40);
            }
            mario_bonk_reflection(m, false);
            m.faceAngle[1] += 0x8000;

            if (m.vel[1] > 0.0f) {
                m.vel[1] = 0.0f;
            }

            m.particleFlags |= PARTICLE_VERTICAL_STAR;
            return set_mario_action(m, ACT_BACKWARD_AIR_KB, 0);
            break;

        default: break;
    }

    m.spareFloat += 0x80 * m.forwardVel;
    if (m.spareFloat > 0x10000) m.spareFloat -= 0x10000;
    set_anim_to_frame(m, cast(s16) (10 * m.spareFloat / 0x10000));

    m.spareInt++;
    m.actionTimer++;

    return false;
}

s32 act_spin_jump(MarioState* m) {
    f32 spinDirFactor;

    if (m.actionTimer == 0) {
        // determine clockwise/counter-clockwise spin
        if (m.spinDirection < 0) {
            m.actionState = 1;
        }
    }
    else if (m.actionTimer == 1 || m.actionTimer == 4) {
        play_sound(SOUND_ACTION_TWIRL, m.marioObj.header.gfx.cameraToObject.ptr);
    }

    spinDirFactor = (m.actionState == 1 ? -1 : 1);  // negative for clockwise, positive for counter-clockwise

    if (m.input & INPUT_B_PRESSED) {
        return set_mario_action(m, ACT_DIVE, 0);
    }

    if (m.input & INPUT_Z_PRESSED) {
        play_sound(SOUND_ACTION_TWIRL, m.marioObj.header.gfx.cameraToObject.ptr);

        m.vel[1] = -50.0f;
        mario_set_forward_vel(m, 0.0f);

        // choose which direction to be facing on land (practically random if no input)
        if (m.input & INPUT_NONZERO_ANALOG) {
            m.faceAngle[1] = m.intendedYaw;
        }
        else {
            m.faceAngle[1] = cast(s16) m.spareFloat;
        }

        return set_mario_action(m, ACT_SPIN_POUND, m.actionState);
    }

    play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, SOUND_MARIO_YAHOO);

    common_air_action_step(m, ACT_DOUBLE_JUMP_LAND, MARIO_ANIM_TWIRL,
                           AIR_STEP_CHECK_HANG);

    m.spareFloat += 0x2867;
    if (m.spareFloat >  0x10000) m.spareFloat -= 0x10000;
    if (m.spareFloat < -0x10000) m.spareFloat += 0x10000;
    m.marioObj.header.gfx.angle[1] += cast(s16) (m.spareFloat * spinDirFactor);

    m.actionTimer++;

    return false;
}

s32 act_spin_pound(MarioState* m) {
    u32 stepResult;
    f32 spinDirFactor;

    if (m.actionTimer == 0) {
        m.actionState = cast(u16) m.actionArg;
    }

    spinDirFactor = (m.actionState == 1 ? -1 : 1);  // negative for clockwise, positive for counter-clockwise

    set_mario_animation(m, MARIO_ANIM_TWIRL);

    if (m.input & INPUT_B_PRESSED) {
        mario_set_forward_vel(m, 10.0f);
        m.vel[1] = 35;
        set_mario_action(m, ACT_DIVE, 0);
    }

    stepResult = perform_air_step(m, 0);
    if (stepResult == AIR_STEP_LANDED) {
        if (should_get_stuck_in_ground(m)) {
            version (SM64_SH) {
                queue_rumble_data(5, 80);
            }
            version (SM64_JP) {
                play_sound(SOUND_MARIO_OOOF, m.marioObj.header.gfx.cameraToObject.ptr);
            } else {
                play_sound(SOUND_MARIO_OOOF2, m.marioObj.header.gfx.cameraToObject.ptr);
            }
            m.particleFlags |= PARTICLE_MIST_CIRCLE;
            set_mario_action(m, ACT_BUTT_STUCK_IN_GROUND, 0);
        } else {
            play_mario_heavy_landing_sound(m, SOUND_ACTION_TERRAIN_HEAVY_LANDING);
            if (!check_fall_damage(m, ACT_HARD_BACKWARD_GROUND_KB)) {
                m.particleFlags |= PARTICLE_MIST_CIRCLE | PARTICLE_HORIZONTAL_STAR;
                set_mario_action(m, ACT_SPIN_POUND_LAND, 0);
            }
        }
        set_camera_shake_from_hit(SHAKE_GROUND_POUND);
    } else if (stepResult == AIR_STEP_HIT_WALL) {
        mario_set_forward_vel(m, -16.0f);
        if (m.vel[1] > 0.0f) {
            m.vel[1] = 0.0f;
        }

        m.particleFlags |= PARTICLE_VERTICAL_STAR;
        set_mario_action(m, ACT_BACKWARD_AIR_KB, 0);
    }

    m.spareFloat += 0x3053;
    if (m.spareFloat >  0x10000) m.spareFloat -= 0x10000;
    if (m.spareFloat < -0x10000) m.spareFloat += 0x10000;
    m.marioObj.header.gfx.angle[1] += cast(s16) (m.spareFloat * spinDirFactor);

    m.actionTimer++;

    return false;
}


s32 act_ledge_parkour(MarioState* m) {
    s16 animFrame;

    set_mario_animation(m, MARIO_ANIM_SLIDEFLIP);

    animFrame = m.marioObj.header.gfx.animInfo.animFrame;

    if (m.actionTimer == 0)      play_sound(SOUND_MARIO_HAHA_2, m.marioObj.header.gfx.cameraToObject.ptr);
    else if (m.actionTimer == 1) play_sound(SOUND_ACTION_SIDE_FLIP_UNK, m.marioObj.header.gfx.cameraToObject.ptr);

    update_air_without_turn(m);

    switch (perform_air_step(m, AIR_STEP_CHECK_LEDGE_GRAB)) {
        case AIR_STEP_NONE:
            // play the side flip animation at double speed for a portion of it
            if      (animFrame < 15) animFrame += 2;
            else if (animFrame > 23) animFrame = 23;
            else                     animFrame++;

            set_anim_to_frame(m, animFrame);
            m.marioObj.header.gfx.angle[1] += 0x8000;
            break;

        case AIR_STEP_LANDED:
            m.marioObj.header.gfx.angle[1] += 0x8000;
            set_mario_action(m, ACT_FREEFALL_LAND_STOP, 0);
            play_mario_landing_sound(m, SOUND_ACTION_TERRAIN_LANDING);
            break;

        case AIR_STEP_HIT_WALL:
            m.marioObj.header.gfx.angle[1] += 0x8000;
            mario_set_forward_vel(m, 0.0f);
            break;

        case AIR_STEP_HIT_LAVA_WALL:
            m.marioObj.header.gfx.angle[1] += 0x8000;
            lava_boost_on_wall(m);
            break;

        default: break;
    }

    m.actionTimer++;

    return false;
}


s32 check_common_airborne_cancels(MarioState* m) {
    if (m.pos[1] < m.waterLevel - 100) {
        return set_water_plunge_action(m);
    }

    if (m.input & INPUT_SQUISHED) {
        return drop_and_set_mario_action(m, ACT_SQUISHED, 0);
    }

    if (m.floor.type == SURFACE_VERTICAL_WIND && (m.action & ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)) {
        return drop_and_set_mario_action(m, ACT_VERTICAL_WIND, 0);
    }

    m.quicksandDepth = 0.0f;
    return false;
}

s32 mario_execute_airborne_action(MarioState* m) {
    u32 cancel;

    if (check_common_airborne_cancels(m)) {
        return true;
    }

    play_far_fall_sound(m);

    /* clang-format off */
    switch (m.action) {
        case ACT_JUMP:                 cancel = act_jump(m);                 break;
        case ACT_DOUBLE_JUMP:          cancel = act_double_jump(m);          break;
        case ACT_FREEFALL:             cancel = act_freefall(m);             break;
        case ACT_HOLD_JUMP:            cancel = act_hold_jump(m);            break;
        case ACT_HOLD_FREEFALL:        cancel = act_hold_freefall(m);        break;
        case ACT_SIDE_FLIP:            cancel = act_side_flip(m);            break;
        case ACT_WALL_KICK_AIR:        cancel = act_wall_kick_air(m);        break;
        case ACT_TWIRLING:             cancel = act_twirling(m);             break;
        case ACT_WATER_JUMP:           cancel = act_water_jump(m);           break;
        case ACT_HOLD_WATER_JUMP:      cancel = act_hold_water_jump(m);      break;
        case ACT_STEEP_JUMP:           cancel = act_steep_jump(m);           break;
        case ACT_BURNING_JUMP:         cancel = act_burning_jump(m);         break;
        case ACT_BURNING_FALL:         cancel = act_burning_fall(m);         break;
        case ACT_TRIPLE_JUMP:          cancel = act_triple_jump(m);          break;
        case ACT_BACKFLIP:             cancel = act_backflip(m);             break;
        case ACT_LONG_JUMP:            cancel = act_long_jump(m);            break;
        case ACT_RIDING_SHELL_JUMP:
        case ACT_RIDING_SHELL_FALL:    cancel = act_riding_shell_air(m);     break;
        case ACT_DIVE:                 cancel = act_dive(m);                 break;
        case ACT_SPIN_JUMP:            cancel = act_spin_jump(m);            break;
        case ACT_AIR_THROW:            cancel = act_air_throw(m);            break;
        case ACT_BACKWARD_AIR_KB:      cancel = act_backward_air_kb(m);      break;
        case ACT_FORWARD_AIR_KB:       cancel = act_forward_air_kb(m);       break;
        case ACT_HARD_FORWARD_AIR_KB:  cancel = act_hard_forward_air_kb(m);  break;
        case ACT_HARD_BACKWARD_AIR_KB: cancel = act_hard_backward_air_kb(m); break;
        case ACT_SOFT_BONK:            cancel = act_soft_bonk(m);            break;
        case ACT_AIR_HIT_WALL:         cancel = act_air_hit_wall(m);         break;
        case ACT_FORWARD_ROLLOUT:      cancel = act_forward_rollout(m);      break;
        case ACT_SHOT_FROM_CANNON:     cancel = act_shot_from_cannon(m);     break;
        case ACT_BUTT_SLIDE_AIR:       cancel = act_butt_slide_air(m);       break;
        case ACT_SPIN_POUND:           cancel = act_spin_pound(m);           break;
        case ACT_HOLD_BUTT_SLIDE_AIR:  cancel = act_hold_butt_slide_air(m);  break;
        case ACT_LAVA_BOOST:           cancel = act_lava_boost(m);           break;
        case ACT_GETTING_BLOWN:        cancel = act_getting_blown(m);        break;
        case ACT_BACKWARD_ROLLOUT:     cancel = act_backward_rollout(m);     break;
        case ACT_CRAZY_BOX_BOUNCE:     cancel = act_crazy_box_bounce(m);     break;
        case ACT_SPECIAL_TRIPLE_JUMP:  cancel = act_special_triple_jump(m);  break;
        case ACT_GROUND_POUND:         cancel = act_ground_pound(m);         break;
        case ACT_THROWN_FORWARD:       cancel = act_thrown_forward(m);       break;
        case ACT_THROWN_BACKWARD:      cancel = act_thrown_backward(m);      break;
        case ACT_FLYING_TRIPLE_JUMP:   cancel = act_flying_triple_jump(m);   break;
        case ACT_SLIDE_KICK:           cancel = act_slide_kick(m);           break;
        case ACT_JUMP_KICK:            cancel = act_jump_kick(m);            break;
        case ACT_FLYING:               cancel = act_flying(m);               break;
        case ACT_RIDING_HOOT:          cancel = act_riding_hoot(m);          break;
        case ACT_TOP_OF_POLE_JUMP:     cancel = act_top_of_pole_jump(m);     break;
        case ACT_VERTICAL_WIND:        cancel = act_vertical_wind(m);        break;
        case ACT_WALL_SLIDE:           cancel = act_wall_slide(m);           break;
        case ACT_GROUND_POUND_JUMP:    cancel = act_ground_pound_jump(m);    break;
        case ACT_ROLL_AIR:             cancel = act_roll_air(m);             break;
        case ACT_LEDGE_PARKOUR:        cancel = act_ledge_parkour(m);        break;
        default:                                                             break;
    }
    /* clang-format on */

    return cancel;
}