module game.save_file;

import ultra64, types, course_table, game.area;

extern (C):

enum EEPROM_SIZE    = 0x200;
enum NUM_SAVE_FILES = 4;

struct SaveBlockSignature
{
    ushort magic;
    ushort chksum;
}

struct SaveFile
{
    // Location of lost cap.
    // Note: the coordinates get set, but are never actually used, since the
    // cap can always be found in a fixed spot within the course
    ubyte capLevel;
    ubyte capArea;
    Vec3s capPos;

    uint flags;

    // Star flags for each course.
    // The most significant bit of the byte *following* each course is set if the
    // cannon is oaspen.
    ubyte[COURSE_COUNT] courseStars;

    ubyte[COURSE_STAGES_COUNT] courseCoinScores;

    SaveBlockSignature signature;
}

enum SaveFileIndex
{
    SAVE_FILE_A = 0,
    SAVE_FILE_B = 1,
    SAVE_FILE_C = 2,
    SAVE_FILE_D = 3
}

struct MainMenuSaveData
{
    // Each save file has a 2 bit "age" for each course. The higher this value,
    // the older the high score is. This is used for tie-breaking when displaying
    // on the high score screen.
    uint[NUM_SAVE_FILES] coinScoreAges;
    ushort soundMode;

    // Pad to match the EEPROM size of 0x200 (10 bytes on JP/US, 8 bytes on EU)
    ubyte[10] filler;

    SaveBlockSignature signature;
}

enum SUBTRAHEND = 6;

struct SaveBuffer
{
    // Each of the four save files has two copies. If one is bad, the other is used as a backup.
    SaveFile[2][NUM_SAVE_FILES] files;
    // The main menu data has two copies. If one is bad, the other is used as a backup.
    MainMenuSaveData[2] menuData;
}

extern __gshared ubyte gLastCompletedCourseNum;
extern __gshared ubyte gLastCompletedStarNum;
extern __gshared byte sUnusedGotGlobalCoinHiScore;
extern __gshared ubyte gGotFileCoinHiScore;
extern __gshared ubyte gCurrCourseStarFlags;
extern __gshared ubyte gSpecialTripleJump;
extern __gshared byte[] gLevelToCourseNumTable;

// game progress flags
enum SAVE_FLAG_FILE_EXISTS            = /* 0x00000001 */ (1 << 0);
enum SAVE_FLAG_HAVE_WING_CAP          = /* 0x00000002 */ (1 << 1);
enum SAVE_FLAG_HAVE_METAL_CAP         = /* 0x00000004 */ (1 << 2);
enum SAVE_FLAG_HAVE_VANISH_CAP        = /* 0x00000008 */ (1 << 3);
enum SAVE_FLAG_HAVE_KEY_1             = /* 0x00000010 */ (1 << 4);
enum SAVE_FLAG_HAVE_KEY_2             = /* 0x00000020 */ (1 << 5);
enum SAVE_FLAG_UNLOCKED_BASEMENT_DOOR = /* 0x00000040 */ (1 << 6);
enum SAVE_FLAG_UNLOCKED_UPSTAIRS_DOOR = /* 0x00000080 */ (1 << 7);
enum SAVE_FLAG_DDD_MOVED_BACK         = /* 0x00000100 */ (1 << 8);
enum SAVE_FLAG_MOAT_DRAINED           = /* 0x00000200 */ (1 << 9);
enum SAVE_FLAG_UNLOCKED_PSS_DOOR      = /* 0x00000400 */ (1 << 10);
enum SAVE_FLAG_UNLOCKED_WF_DOOR       = /* 0x00000800 */ (1 << 11);
enum SAVE_FLAG_UNLOCKED_CCM_DOOR      = /* 0x00001000 */ (1 << 12);
enum SAVE_FLAG_UNLOCKED_JRB_DOOR      = /* 0x00002000 */ (1 << 13);
enum SAVE_FLAG_UNLOCKED_BITDW_DOOR    = /* 0x00004000 */ (1 << 14);
enum SAVE_FLAG_UNLOCKED_BITFS_DOOR    = /* 0x00008000 */ (1 << 15);
enum SAVE_FLAG_CAP_ON_GROUND          = /* 0x00010000 */ (1 << 16);
enum SAVE_FLAG_CAP_ON_KLEPTO          = /* 0x00020000 */ (1 << 17);
enum SAVE_FLAG_CAP_ON_UKIKI           = /* 0x00040000 */ (1 << 18);
enum SAVE_FLAG_CAP_ON_MR_BLIZZARD     = /* 0x00080000 */ (1 << 19);
enum SAVE_FLAG_UNLOCKED_50_STAR_DOOR  = /* 0x00100000 */ (1 << 20);
enum SAVE_FLAG_COLLECTED_TOAD_STAR_1  = /* 0x01000000 */ (1 << 24);
enum SAVE_FLAG_COLLECTED_TOAD_STAR_2  = /* 0x02000000 */ (1 << 25);
enum SAVE_FLAG_COLLECTED_TOAD_STAR_3  = /* 0x04000000 */ (1 << 26);
enum SAVE_FLAG_COLLECTED_MIPS_STAR_1  = /* 0x08000000 */ (1 << 27);
enum SAVE_FLAG_COLLECTED_MIPS_STAR_2  = /* 0x10000000 */ (1 << 28);

extern (D) auto SAVE_FLAG_TO_STAR_FLAG(T)(auto ref T cmd)
{
    return (cmd >> 24) & 0x7F;
}

extern (D) auto STAR_FLAG_TO_SAVE_FLAG(T)(auto ref T cmd)
{
    return cmd << 24;
}

// Variable for setting a warp checkpoint.

// possibly a WarpDest struct where arg is a union. TODO: Check?
struct WarpCheckpoint
{
    /*0x00*/ ubyte actNum;
    /*0x01*/ ubyte courseNum;
    /*0x02*/ ubyte levelID;
    /*0x03*/ ubyte areaNum;
    /*0x04*/ ubyte warpNode;
}

extern __gshared WarpCheckpoint gWarpCheckpoint;

extern __gshared byte gMainMenuDataModified;
extern __gshared byte gSaveFileModified;

void save_file_do_save (int fileIndex);
void save_file_erase (int fileIndex);
int save_file_copy (int srcFileIndex, int destFileIndex);
void save_file_load_all ();
void save_file_reload ();
void save_file_collect_star_or_key (short coinScore, short starIndex);
int save_file_exists (int fileIndex);
uint save_file_get_max_coin_score (int courseIndex);
int save_file_get_course_star_count (int fileIndex, int courseIndex);
int save_file_get_total_star_count (int fileIndex, int minCourse, int maxCourse);
void save_file_set_flags (uint flags);
void save_file_clear_flags (uint flags);
uint save_file_get_flags ();
uint save_file_get_star_flags (int fileIndex, int courseIndex);
void save_file_set_star_flags (int fileIndex, int courseIndex, uint starFlags);
int save_file_get_course_coin_score (int fileIndex, int courseIndex);
int save_file_is_cannon_unlocked ();
void save_file_set_cannon_unlocked ();
void save_file_set_cap_pos (short x, short y, short z);
int save_file_get_cap_pos (ref Vec3s capPos);
void save_file_set_sound_mode (ushort mode);
ushort save_file_get_sound_mode ();
void save_file_move_cap_to_default_location ();

void disable_warp_checkpoint ();
void check_if_should_set_warp_checkpoint (WarpNode* warpNode);
int check_warp_checkpoint (WarpNode* warpNode);

// SAVE_FILE_H
