module game.moving_texture;

import ultra64, types, util, gbi;

extern (C):

enum ROTATE_CLOCKWISE         = 0;
enum ROTATE_COUNTER_CLOCKWISE = 1;

/// Ids for textures used for moving textures
enum MovtexRectTextureId {
    TEXTURE_WATER        = 0,
    TEXTURE_MIST         = 1,
    TEXTURE_JRB_WATER    = 2,
    TEXTURE_UNK_WATER    = 3,
    TEXTURE_LAVA         = 4,
    TEX_QUICKSAND_SSL    = 5,
    TEX_PYRAMID_SAND_SSL = 6,
    TEX_YELLOW_TRI_TTC   = 7
}
mixin importEnumMembers!MovtexRectTextureId;

/**
 * Contains an id and an array of MovtexQuad structs.
 */
struct MovtexQuadCollection {
    /// identifier for geo nodes to refer to this MovtexQuad collection
    s16 id;
    /// points to a s16 'n' followed by an array of n MovtexQuad structs
    Movtex* quadArraySegmented;
}

extern __gshared f32 gPaintingMarioYEntry;

// Moving texture mesh ids have for bits 8-16 a course identifier.
// This corresponds to the numbers used in debug level select, except they are
// re-interpreted as hexadecimal numbers. TTM is course 36, so the id is 0x36
// and the first water quad collection in TTM has id 0x3601.
enum MOVTEX_AREA_BBH              = 0x04 << 8;
enum MOVTEX_AREA_CCM              = 0x05 << 8;
enum MOVTEX_AREA_INSIDE_CASTLE    = 0x06 << 8;
enum MOVTEX_AREA_HMC              = 0x07 << 8;
enum MOVTEX_AREA_SSL              = 0x08 << 8;
enum MOVTEX_AREA_SL               = 0x10 << 8;
enum MOVTEX_AREA_WDW              = 0x11 << 8;
enum MOVTEX_AREA_JRB              = 0x12 << 8;
enum MOVTEX_AREA_THI              = 0x13 << 8;
enum MOVTEX_AREA_TTC              = 0x14 << 8;
enum MOVTEX_AREA_CASTLE_GROUNDS   = 0x16 << 8;
enum MOVTEX_AREA_BITFS            = 0x19 << 8;
enum MOVTEX_AREA_LLL              = 0x22 << 8;
enum MOVTEX_AREA_DDD              = 0x23 << 8;
enum MOVTEX_AREA_WF               = 0x24 << 8;
enum MOVTEX_AREA_CASTLE_COURTYARD = 0x26 << 8;
enum MOVTEX_AREA_COTMC            = 0x28 << 8;
enum MOVTEX_AREA_TTM              = 0x36 << 8;

// Quad collections
enum BBH_MOVTEX_MERRY_GO_ROUND_WATER_ENTRANCE  = 0 | MOVTEX_AREA_BBH;
enum BBH_MOVTEX_MERRY_GO_ROUND_WATER_SIDE      = 1 | MOVTEX_AREA_BBH;
enum CCM_MOVTEX_PENGUIN_PUDDLE_WATER           = 1 | MOVTEX_AREA_CCM;
enum INSIDE_CASTLE_MOVTEX_GREEN_ROOM_WATER     = 0 | MOVTEX_AREA_INSIDE_CASTLE;
enum INSIDE_CASTLE_MOVTEX_MOAT_WATER           = 0x12 | MOVTEX_AREA_INSIDE_CASTLE;
enum HMC_MOVTEX_DORRIE_POOL_WATER              = 1 | MOVTEX_AREA_HMC;
enum HMC_MOVTEX_TOXIC_MAZE_MIST                = 2 | MOVTEX_AREA_HMC;
enum SSL_MOVTEX_PUDDLE_WATER                   = 1 | MOVTEX_AREA_SSL;
enum SSL_MOVTEX_TOXBOX_QUICKSAND_MIST          = 0x51 | MOVTEX_AREA_SSL;
enum SL_MOVTEX_WATER                           = 1 | MOVTEX_AREA_SL;
enum WDW_MOVTEX_AREA1_WATER                    = 1 | MOVTEX_AREA_WDW;
enum WDW_MOVTEX_AREA2_WATER                    = 2 | MOVTEX_AREA_WDW;
enum JRB_MOVTEX_WATER                          = 1 | MOVTEX_AREA_JRB;
enum JRB_MOVTEX_INTIAL_MIST                    = 5 | MOVTEX_AREA_JRB;
enum JRB_MOVTEX_SINKED_BOAT_WATER              = 2 | MOVTEX_AREA_JRB;
enum THI_MOVTEX_AREA1_WATER                    = 1 | MOVTEX_AREA_THI;
enum THI_MOVTEX_AREA2_WATER                    = 2 | MOVTEX_AREA_THI;
enum CASTLE_GROUNDS_MOVTEX_WATER               = 1 | MOVTEX_AREA_CASTLE_GROUNDS;
enum LLL_MOVTEX_VOLCANO_FLOOR_LAVA             = 2 | MOVTEX_AREA_LLL;
enum DDD_MOVTEX_AREA1_WATER                    = 1 | MOVTEX_AREA_DDD;
enum DDD_MOVTEX_AREA2_WATER                    = 2 | MOVTEX_AREA_DDD;
enum WF_MOVTEX_WATER                           = 1 | MOVTEX_AREA_WF;
enum CASTLE_COURTYARD_MOVTEX_STAR_STATUE_WATER = 1 | MOVTEX_AREA_CASTLE_COURTYARD;
enum TTM_MOVTEX_PUDDLE                         = 1 | MOVTEX_AREA_TTM;

// Non-colored, unique movtex meshes (drawn in level geo)
enum MOVTEX_PYRAMID_SAND_PATHWAY_FRONT         = 1 | MOVTEX_AREA_SSL;
enum MOVTEX_PYRAMID_SAND_PATHWAY_FLOOR         = 2 | MOVTEX_AREA_SSL;
enum MOVTEX_PYRAMID_SAND_PATHWAY_SIDE          = 3 | MOVTEX_AREA_SSL;
enum MOVTEX_CASTLE_WATERFALL                   = 1 | MOVTEX_AREA_CASTLE_GROUNDS;
enum MOVTEX_BITFS_LAVA_FIRST                   = 1 | MOVTEX_AREA_BITFS;
enum MOVTEX_BITFS_LAVA_SECOND                  = 2 | MOVTEX_AREA_BITFS;
enum MOVTEX_BITFS_LAVA_FLOOR                   = 3 | MOVTEX_AREA_BITFS;
enum MOVTEX_LLL_LAVA_FLOOR                     = 1 | MOVTEX_AREA_LLL;
enum MOVTEX_VOLCANO_LAVA_FALL                  = 2 | MOVTEX_AREA_LLL;
enum MOVTEX_COTMC_WATER                        = 1 | MOVTEX_AREA_COTMC;
enum MOVTEX_TTM_BEGIN_WATERFALL                = 1 | MOVTEX_AREA_TTM;
enum MOVTEX_TTM_END_WATERFALL                  = 2 | MOVTEX_AREA_TTM;
enum MOVTEX_TTM_BEGIN_PUDDLE_WATERFALL         = 3 | MOVTEX_AREA_TTM;
enum MOVTEX_TTM_END_PUDDLE_WATERFALL           = 4 | MOVTEX_AREA_TTM;
enum MOVTEX_TTM_PUDDLE_WATERFALL               = 5 | MOVTEX_AREA_TTM;

// Colored, unique movtex meshes (drawn in level geo)
enum MOVTEX_SSL_PYRAMID_SIDE                   = 1 | MOVTEX_AREA_SSL;
enum MOVTEX_SSL_PYRAMID_CORNER                 = 2 | MOVTEX_AREA_SSL;
enum MOVTEX_SSL_COURSE_EDGE                    = 3 | MOVTEX_AREA_SSL;

// Shared movtex meshes (drawn in object geo)
enum MOVTEX_SSL_SAND_PIT_OUTSIDE               = 1 | MOVTEX_AREA_SSL;
enum MOVTEX_SSL_SAND_PIT_PYRAMID               = 2 | MOVTEX_AREA_SSL;
enum MOVTEX_TREADMILL_BIG                      = 0 | MOVTEX_AREA_TTC;
enum MOVTEX_TREADMILL_SMALL                    = 1 | MOVTEX_AREA_TTC;

Gfx* geo_wdw_set_initial_water_level (s32 callContext, GraphNode* node, ref Mat4 mtx);
Gfx* geo_movtex_pause_control (s32 callContext, GraphNode* node, ref Mat4 mtx);
Gfx* geo_movtex_draw_water_regions (s32 callContext, GraphNode* node, ref Mat4 mtx);
Gfx* geo_movtex_draw_nocolor (s32 callContext, GraphNode* node, ref Mat4 mtx);
Gfx* geo_movtex_draw_colored (s32 callContext, GraphNode* node, ref Mat4 mtx);
Gfx* geo_movtex_draw_colored_no_update (s32 callContext, GraphNode* node, ref Mat4 mtx);
Gfx* geo_movtex_draw_colored_2_no_update (s32 callContext, GraphNode* node, ref Mat4 mtx);
Gfx* geo_movtex_update_horizontal (s32 callContext, GraphNode* node, ref Mat4 mtx);
Gfx* geo_movtex_draw_colored_no_update (s32 callContext, GraphNode* node, ref Mat4 mtx);

// MOVING_TEXTURE_H
