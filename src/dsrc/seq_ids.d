module seq_ids;

import util;

extern (C):

enum SEQ_VARIATION = 0x80;

enum SeqId {
    SEQ_SOUND_PLAYER                = 0,  // 0x00
    SEQ_EVENT_CUTSCENE_COLLECT_STAR = 1,  // 0x01
    SEQ_MENU_TITLE_SCREEN           = 2,  // 0x02
    SEQ_LEVEL_GRASS                 = 3,  // 0x03
    SEQ_LEVEL_INSIDE_CASTLE         = 4,  // 0x04
    SEQ_LEVEL_WATER                 = 5,  // 0x05
    SEQ_LEVEL_HOT                   = 6,  // 0x06
    SEQ_LEVEL_BOSS_KOOPA            = 7,  // 0x07
    SEQ_LEVEL_SNOW                  = 8,  // 0x08
    SEQ_LEVEL_SLIDE                 = 9,  // 0x09
    SEQ_LEVEL_SPOOKY                = 10, // 0x0A
    SEQ_EVENT_PIRANHA_PLANT         = 11, // 0x0B
    SEQ_LEVEL_UNDERGROUND           = 12, // 0x0C
    SEQ_MENU_STAR_SELECT            = 13, // 0x0D
    SEQ_EVENT_POWERUP               = 14, // 0x0E
    SEQ_EVENT_METAL_CAP             = 15, // 0x0F
    SEQ_EVENT_KOOPA_MESSAGE         = 16, // 0x10
    SEQ_LEVEL_KOOPA_ROAD            = 17, // 0x11
    SEQ_EVENT_HIGH_SCORE            = 18, // 0x12
    SEQ_EVENT_MERRY_GO_ROUND        = 19, // 0x13
    SEQ_EVENT_RACE                  = 20, // 0x14
    SEQ_EVENT_CUTSCENE_STAR_SPAWN   = 21, // 0x15
    SEQ_EVENT_BOSS                  = 22, // 0x16
    SEQ_EVENT_CUTSCENE_COLLECT_KEY  = 23, // 0x17
    SEQ_EVENT_ENDLESS_STAIRS        = 24, // 0x18
    SEQ_LEVEL_BOSS_KOOPA_FINAL      = 25, // 0x19
    SEQ_EVENT_CUTSCENE_CREDITS      = 26, // 0x1A
    SEQ_EVENT_SOLVE_PUZZLE          = 27, // 0x1B
    SEQ_EVENT_TOAD_MESSAGE          = 28, // 0x1C
    SEQ_EVENT_PEACH_MESSAGE         = 29, // 0x1D
    SEQ_EVENT_CUTSCENE_INTRO        = 30, // 0x1E
    SEQ_EVENT_CUTSCENE_VICTORY      = 31, // 0x1F
    SEQ_EVENT_CUTSCENE_ENDING       = 32, // 0x20
    SEQ_MENU_FILE_SELECT            = 33, // 0x21
    SEQ_EVENT_CUTSCENE_LAKITU       = 34, // 0x22 (not in JP)
    SEQ_COUNT                       = 35
}
mixin importEnumMembers!SeqId;

// SEQ_IDS_H
