module game.mario_actions_airborne;

import sm64, audio.external;

extern (C):

void play_flip_sounds(MarioState* m, s16 frame1, s16 frame2, s16 frame3) {
    s32 animFrame = m.marioObj.header.gfx.animInfo.animFrame;
    if (animFrame == frame1 || animFrame == frame2 || animFrame == frame3) {
        play_sound(SOUND_ACTION_SPIN, m.marioObj.header.gfx.cameraToObject.ptr);
    }
}