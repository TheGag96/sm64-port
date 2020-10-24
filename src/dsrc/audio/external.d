module audio.external;

import ultra64, types;

extern (C):

// Sequence arguments, passed to play_sequence. seqId may be bit-OR'ed with
// SEQ_VARIATION; this will load the same sequence, but set a variation
// bit which may be read by the sequence script.
extern (D) auto SEQUENCE_ARGS(T0, T1)(auto ref T0 priority, auto ref T1 seqId)
{
    return (priority << 8) | seqId;
}

enum SOUND_MODE_STEREO = 0;
enum SOUND_MODE_MONO = 3;
enum SOUND_MODE_HEADSET = 1;

enum SEQ_PLAYER_LEVEL = 0;
enum SEQ_PLAYER_ENV = 1;
enum SEQ_PLAYER_SFX = 2;

extern __gshared int gAudioErrorFlags;
extern __gshared f32[3] gDefaultSoundArgs;

// defined in data.c, used by the game
extern __gshared uint gAudioRandom;

extern __gshared ubyte[] gAudioSPTaskYieldBuffer; // ucode yield data ptr; only used in JP

SPTask* create_next_audio_frame_task ();
void play_sound (int soundBits, f32* pos);
void audio_signal_game_loop_tick ();
void sequence_player_fade_out (ubyte player, ushort fadeTimer);
void fade_volume_scale (ubyte player, ubyte targetScale, ushort fadeTimer);
void func_8031FFB4 (ubyte player, ushort fadeTimer, ubyte arg2);
void sequence_player_unlower (ubyte player, ushort fadeTimer);
void set_sound_disabled (ubyte disabled);
void sound_init ();
void func_803205E8 (uint soundBits, f32* vec);
void func_803206F8 (f32* arg0);
void func_80320890 ();
void sound_banks_disable (ubyte player, ushort bankMask);
void sound_banks_enable (ubyte player, ushort bankMask);
void func_80320A4C (ubyte bankIndex, ubyte arg1);
void play_dialog_sound (ubyte dialogID);
void play_music (ubyte player, ushort seqArgs, ushort fadeTimer);
void stop_background_music (ushort seqId);
void fadeout_background_music (ushort arg0, ushort fadeOut);
void drop_queued_background_music ();
ushort get_current_background_music ();
void play_secondary_music (ubyte seqId, ubyte bgMusicVolume, ubyte volume, ushort fadeTimer);
void func_80321080 (ushort fadeTimer);
void func_803210D4 (ushort fadeOutTime);
void play_course_clear ();
void play_peachs_jingle ();
void play_puzzle_jingle ();
void play_star_fanfare ();
void play_power_star_jingle (ubyte arg0);
void play_race_fanfare ();
void play_toads_jingle ();
void sound_reset (ubyte presetId);
void audio_set_sound_mode (ubyte arg0);

void audio_init (); // in load.c

// AUDIO_EXTERNAL_H
