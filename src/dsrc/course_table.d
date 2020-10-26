module course_table;

extern (C):

import util;

// Start of the 3 cap courses in a row.
enum COURSE_CAP_COURSES = CourseNum.COURSE_COTMC;

enum CourseNum
{
    // To mark end + 1 for marking max and count.
    // TODO: clean this up. This is still bad. Which
    // one is clearer? Need to get rid of one of these.
    COURSE_NONE         = 0,
    COURSE_BOB          = 1,
    COURSE_WF           = 2,
    COURSE_JRB          = 3,

    // COURSE_TABLE_H
    COURSE_CCM          = 4,
    COURSE_BBH          = 5,
    COURSE_HMC          = 6,
    COURSE_LLL          = 7,
    COURSE_SSL          = 8,
    COURSE_DDD          = 9,
    COURSE_SL           = 10,
    COURSE_WDW          = 11,
    COURSE_TTM          = 12,
    COURSE_THI          = 13,
    COURSE_TTC          = 14,
    COURSE_RR           = 15,
    COURSE_BONUS_STAGES = 16,
    COURSE_STAGES_MAX   = 15,
    COURSE_STAGES_COUNT = 15,
    COURSE_BITDW        = 16,
    COURSE_BITFS        = 17,
    COURSE_BITS         = 18,
    COURSE_PSS          = 19,
    COURSE_COTMC        = 20,
    COURSE_TOTWC        = 21,
    COURSE_VCUTM        = 22,
    COURSE_WMOTR        = 23,
    COURSE_SA           = 24,
    COURSE_CAKE_END     = 25,
    COURSE_END          = 26,
    COURSE_MAX          = COURSE_END - 1,
    COURSE_COUNT        = COURSE_MAX,
    COURSE_MIN          = COURSE_NONE + 1
}
mixin importEnumMembers!CourseNum;

extern (D) auto COURSE_IS_MAIN_COURSE(T)(auto ref T cmd)
{
    return cmd >= CourseNum.COURSE_MIN && cmd <= CourseNum.COURSE_STAGES_MAX;
}
