module game.sound_init;

import ultra64;

extern (C):

enum SOUND_MENU_FLAG_HANDAPPEAR      = 0x01;
enum SOUND_MENU_FLAG_HANDISAPPEAR    = 0x02;
enum SOUND_MENU_FLAG_UNKNOWN1        = 0x04;
enum SOUND_MENU_FLAG_PINCHMARIOFACE  = 0x08;
enum SOUND_MENU_FLAG_PINCHMARIOFACE2 = 0x10;
enum SOUND_MENU_FLAG_LETGOMARIOFACE  = 0x20;
enum SOUND_MENU_FLAG_CAMERAZOOMIN    = 0x40;
enum SOUND_MENU_FLAG_CAMERAZOOMOUT   = 0x80;

enum SOUND_MENU_MODE_STEREO  = 0;
enum SOUND_MENU_MODE_MONO    = 1;
enum SOUND_MENU_MODE_HEADSET = 2;

void reset_volume ();
void raise_background_noise (s32 a);
void lower_background_noise (s32 a);
void disable_background_sound ();
void enable_background_sound ();
void set_sound_mode (u16 soundMode);
void play_menu_sounds (s16 soundMenuFlags);
void play_painting_eject_sound ();
void play_infinite_stairs_music ();
void set_background_music (u16 a, u16 seqArgs, s16 fadeTimer);
void fadeout_music (s16 fadeOutTime);
void fadeout_level_music (s16 fadeTimer);
void play_cutscene_music (u16 seqArgs);
void play_shell_music ();
void stop_shell_music ();
void play_cap_music (u16 seqArgs);
void fadeout_cap_music ();
void stop_cap_music ();
void audio_game_loop_tick ();
void thread4_sound (void* arg);

// SOUND_INIT_H
