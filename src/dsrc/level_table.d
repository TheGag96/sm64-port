module level_table;

import util;

extern (C):

// For LEVEL_NAME defines, see level_defines.h.
// Please include this file if you want to use them.

enum LevelNum
{
    LEVEL_NONE = 0,

    // LEVEL_TABLE_H
    LEVEL_UNKNOWN_1 = 1,
    LEVEL_UNKNOWN_2 = 2,
    LEVEL_UNKNOWN_3 = 3,
    LEVEL_BBH = 4,
    LEVEL_CCM = 5,
    LEVEL_CASTLE = 6,
    LEVEL_HMC = 7,
    LEVEL_SSL = 8,
    LEVEL_BOB = 9,
    LEVEL_SL = 10,
    LEVEL_WDW = 11,
    LEVEL_JRB = 12,
    LEVEL_THI = 13,
    LEVEL_TTC = 14,
    LEVEL_RR = 15,
    LEVEL_CASTLE_GROUNDS = 16,
    LEVEL_BITDW = 17,
    LEVEL_VCUTM = 18,
    LEVEL_BITFS = 19,
    LEVEL_SA = 20,
    LEVEL_BITS = 21,
    LEVEL_LLL = 22,
    LEVEL_DDD = 23,
    LEVEL_WF = 24,
    LEVEL_ENDING = 25,
    LEVEL_CASTLE_COURTYARD = 26,
    LEVEL_PSS = 27,
    LEVEL_COTMC = 28,
    LEVEL_TOTWC = 29,
    LEVEL_BOWSER_1 = 30,
    LEVEL_WMOTR = 31,
    LEVEL_UNKNOWN_32 = 32,
    LEVEL_BOWSER_2 = 33,
    LEVEL_BOWSER_3 = 34,
    LEVEL_UNKNOWN_35 = 35,
    LEVEL_TTM = 36,
    LEVEL_UNKNOWN_37 = 37,
    LEVEL_UNKNOWN_38 = 38,
    LEVEL_COUNT = 39,
    LEVEL_MAX = LEVEL_COUNT - 1,
    LEVEL_MIN = LEVEL_NONE + 1
}
mixin importEnumMembers!LevelNum;
