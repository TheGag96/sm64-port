module goddard.gd_types;

import ultra64, util, gbi;

extern (C):

/* Vector Types */
struct GdVec3f
{
    f32 x;
    f32 y;
    f32 z;
}

struct GdPlaneF
{
    GdVec3f p0;
    GdVec3f p1;
}

struct GdTriangleF
{
    GdVec3f p0;
    GdVec3f p1;
    GdVec3f p2;
}

alias Mat4f = float[4][4];

struct GdColour
{
    f32 r;
    f32 g;
    f32 b;
}

/* dynlist entries and types */
union DynUnion
{
    void* ptr;
    char* str;
    s32 word;
}

struct DynList
{
    s32 cmd;
    DynUnion w1;
    DynUnion w2;
    GdVec3f vec;
}

/* Goddard Code Object Structs */
/* Object Type Flags */
enum ObjTypeFlag
{
    OBJ_TYPE_GROUPS    = 0x00000001,
    OBJ_TYPE_BONES     = 0x00000002,
    OBJ_TYPE_JOINTS    = 0x00000004,
    OBJ_TYPE_PARTICLES = 0x00000008,
    OBJ_TYPE_SHAPES    = 0x00000010,
    OBJ_TYPE_NETS      = 0x00000020,
    OBJ_TYPE_PLANES    = 0x00000040,
    OBJ_TYPE_FACES     = 0x00000080,
    OBJ_TYPE_VERTICES  = 0x00000100,
    OBJ_TYPE_CAMERAS   = 0x00000200,
    // 0x400 was not used
    OBJ_TYPE_MATERIALS = 0x00000800,
    OBJ_TYPE_WEIGHTS   = 0x00001000,
    OBJ_TYPE_GADGETS   = 0x00002000,
    OBJ_TYPE_VIEWS     = 0x00004000,
    OBJ_TYPE_LABELS    = 0x00008000,
    OBJ_TYPE_ANIMATORS = 0x00010000,
    OBJ_TYPE_VALPTRS   = 0x00020000,
    // 0x40000 was not used
    OBJ_TYPE_LIGHTS    = 0x00080000,
    OBJ_TYPE_ZONES     = 0x00100000,
    OBJ_TYPE_UNK200000 = 0x00200000
}
mixin importEnumMembers!ObjTypeFlag;

/* This constant seems to be used to indicate the type of any or all objects */
enum OBJ_TYPE_ALL = 0x00FFFFFF;

/// Function pointer for a `GdObj`'s drawing routine
alias drawmethod_t = void function (void*);
/// Flags for the drawFlags field of an GdObj
enum ObjDrawingFlags
{
    OBJ_DRAW_UNK01     = 0x01,
    OBJ_NOT_DRAWABLE   = 0x02, ///< This `GdObj` shouldn't be drawn when updating a scene
    OBJ_PICKED         = 0x04, ///< This `GdObj` is held by the cursor
    OBJ_IS_GRABBALE    = 0x08, ///< This `GdObj` can be grabbed/picked by the cursor
    OBJ_USE_ENV_COLOUR = 0x10
}
mixin importEnumMembers!ObjDrawingFlags;

/**
 * The base of structure of all of Goddard's objects. It is present as a "header"
 * at the beginning of all `ObjX` structures, and as such, this type is used
 * when he need to generalize code to take different `ObjX`es.
 * It is also a linked list node structure with `prev` and `next` pointers.
 */
struct GdObj
{
    /* 0x00 */ GdObj* prev;
    /* 0x04 */ GdObj* next;
    /* 0x08 */ drawmethod_t objDrawFn;
    /* 0x0C */ ObjTypeFlag type;
    /* 0x10 */ s16 number; ///< the index of this `GdObj` in the linked list
    /* 0x12 */ u16 drawFlags; ///< enumerated in `::ObjDrawingFlags`
    /* 0x14 Specific object data starts here */ 
}

/* Used to create a linked list of objects (or data)
** within an ObjGroup */
struct Links
{
    /* 0x00 */ Links* prev;
    /* 0x04 */ Links* next;
    /* 0x08 */ GdObj* obj;
}

/* These are the compressed versions of ObjFace or ObjVertex that are
** pointed to by Links in the faceGroup and vtxGroup, if Group.linkType
** is set to 0x01. See `chk_shapegen` */
struct GdFaceData
{
    u32 count;
    s32 type;
    u16[4]* data; ///< (mtl id, vtx ids[3])
}

struct GdVtxData
{
    u32 count;
    s32 type;
    s16[3]* data; ///< [x, y, z]
}

/**
 * This is test documentation comment for ObjGroup
 */
struct ObjGroup
{
    /* 0x00 */ GdObj header;
    /* 0x14 */ ObjGroup* prev;
    /* 0x18 */ ObjGroup* next;
    /* 0x1C */ Links* link1C; ///< Head of a linked list for objects contained in this group
    /* 0x20 */ Links* link20; // what is this second one used for?
    /* 0x24 */ s32 groupObjTypes; ///< OR'd collection of type flags for all objects in this group
    /* 0x28 */ s32 objCount;
    /* 0x2C */ s32 debugPrint; // might also be a type?
    /* 0x30 */ s32 linkType;
    /* 0x34 */ char[0x40] name; ///< possibly, only referenced in old code
    /* 0x74 */ s32 id;
} /* sizeof = 0x78 */

/* Known linkTypes
 * 0x00 : Normal (link to GdObj)
 * 0x01 : Compressed (vtx or face data)
 */

struct ObjBone
{
    /* 0x000 */ GdObj header;
    /* 0x014 */ GdVec3f unk14; // "position"?? from dead code in draw_bone
    /* 0x020 */ ObjBone* prev; // maybe, based on make_bone
    /* 0x024 */ ObjBone* next; // maybe, based on make_bone
    /* 0x028 */ GdVec3f unk28; // "rotation"?? from dead code in draw_bone
    /* 0x034 */ u8[12] pad34;
    /* 0x040 */ GdVec3f unk40;
    /* 0x04C */ u8[12] pad4C;
    /* 0x058 */ GdVec3f unk58;
    /* 0x064 */ GdVec3f unk64;
    /* 0x070 */ Mat4f mat70;
    /* 0x0B0 */ Mat4f matB0;
    /* 0x0F0 */ ObjShape* unkF0; // from dead code in draw_bone
    /* 0x0F4 */ f32 unkF4;
    /* 0x0F8 */ f32 unkF8; // from dead code in draw_bone
    /* 0x0FC */ f32 unkFC;
    /* 0x100 */ s32 unk100; // "colour"
    /* 0x104 */ s32 unk104; // "flags"
    /* 0x108 */ s32 id;
    /* 0x10C */ ObjGroup* unk10C; // group of joints?
    /* 0x110 */ f32 unk110; // "spring"
    /* 0x114 */ f32 unk114;
    /* 0x118 */ f32 unk118;
    /* 0x11C */ u8[8] pad11C;
} /* sizeof = 0x124 */

struct ObjJoint
{
    /* 0x000 */ GdObj header;
    /* 0x014 */ GdVec3f unk14; //position? based on d_set_initpos
    /* 0x020 */ ObjShape* unk20;
    /* 0x024 */ ObjJoint* prevjoint; // prev joint? linked joint?
    /* 0x028 */ ObjJoint* nextjoint;
    /* 0x02C */ void function (ObjJoint*) fn2C;
    /* 0x030 */ GdVec3f unk30; // huge array of vecs? another matrix?
    /* 0x03C */ GdVec3f unk3C; // relative position?
    /* 0x048 */ GdVec3f unk48;
    /* 0x054 */ GdVec3f unk54; // attached offset (with +200 as well)
    /* 0x060 */ u8[12] pad60;
    /* 0x06C */ GdVec3f unk6C; // initial rotation vec
    /* 0x078 */ GdVec3f unk78;
    /* 0x084 */ GdVec3f unk84;
    /* 0x090 */ GdVec3f unk90;
    /* 0x09C */ GdVec3f unk9C; // scale vec?
    /* 0x0A8 */ GdVec3f unkA8;
    /* 0x0B4 */ GdVec3f unkB4;
    /* 0x0C0 */ GdVec3f unkC0; // "shape offset"
    /* 0x0CC */ GdVec3f unkCC;
    /* 0x0D8 */ u8[4] padD8;
    /* 0x0DC */ GdVec3f unkDC; // "friction"
    /* 0x0E8 */ Mat4f matE8; //matrix4x4
    /* 0x128 */ Mat4f mat128; // "rot matrix"
    /* 0x168 */ Mat4f mat168; // "id matrix"
    /* 0x1A8 */ GdVec3f unk1A8;
    /* 0x1B4 */ s32 id;
    /* 0x1B8 */ u8[4] pad1B8;
    /* 0x1BC */ s32 unk1BC; // "flags"
    /* 0x1C0 */ s32 unk1C0;
    /* 0x1C4 */ ObjGroup* unk1C4; // bone group?
    /* 0x1C8 */ s32 unk1C8; // "colour"
    /* 0x1CC */ s32 unk1CC; // "type"
    /* 0x1D0 */ ObjAnimator* unk1D0;
    /* 0x1D4 */ u8[32] pad1D4;
    /* 0x1F4 */ ObjGroup* unk1F4; //Group of ObjWeights, only? skin weights?
    /* 0x1F8 */ ObjGroup* unk1F8; //attach object group
    /* 0x1FC */ s32 unk1FC; //d_attach_to arg 0; "AttFlag"
    /* 0x200 */ GdVec3f unk200; //attached offset?
    /* 0x20C */ GdObj* unk20C; //attached object?
    /* 0x210 */ u8[24] pad210;
    /* 0x228 */ f32 unk228;
} /* sizeof = 0x22C */

/* Particle Types (+60)
   3 = Has groups of other particles in 6C?
*/

struct ObjParticle
{
    /* 0x00 */ GdObj header;
    /* 0x14 */ u8[8] pad14;
    /* 0x1C */ ObjShape* unk1C; // looks like a shape...
    /* 0x20 */ GdVec3f unk20; // position vec?
    /* 0x2C */ u8[4] pad2C;
    /* 0x30 */ f32 unk30;
    /* 0x34 */ u8[4] pad34;
    /* 0x38 */ GdVec3f unk38;
    /* 0x44 */ f32 unk44; //not vec?
    /* 0x48 */ f32 unk48; //not vec?
    /* 0x4C */ u8[4] pad4C;
    /* 0x50 */ s32 id;
    /* 0x54 */ u32 unk54; // "dflags"?
    /* 0x58 */ s32 unk58; // "colour"
    /* 0x5C */ s32 unk5C; // gd dl dlptr offset?
    /* 0x60 */ s32 unk60; //flag? type?
    /* 0x64 */ s32 unk64; //flag?
    /* 0x68 */ u8[4] pad68;
    /* 0x6C */ ObjGroup* unk6C; // group of other Particles ?
    /* 0x70 */ u8[4] pad70;
    /* 0x74 */ s32 unk74;
    /* 0x78 */ u8[4] unk78;
    /* 0x7C */ ObjAnimator* unk7C; // guessing on type; doesn't seem to be used in final code
    /* 0x80 */ ObjLight* unk80; // could be a Net or Light; not seen as non-null in running code
    /* 0x84 */ u8[44] pad84;
    /* 0xB0 */ s32 unkB0; //state?
    /* 0xB4 */ ObjGroup* unkB4; // attach group? unused group of particles
    /* 0xB8 */ s32 unkB8; //attached arg0; "AttFlag"
    /* 0xBC */ GdObj* unkBC; //attached obj? looks like can be a Light or Camera
} /* sizeof = 0xC0 */

struct ObjShape
{
    /* 0x00 */ GdObj header;
    /* 0x14 */ ObjShape* prevShape;
    /* 0x18 */ ObjShape* nextShape;
    /* 0x1C */ ObjGroup* faceGroup; /* face group; based on get_3DG1_shape */
    /* 0x20 */ ObjGroup* vtxGroup; /* vtx group; based on get_3DG1_shape */
    /* 0x24 */ ObjGroup* unk24; /* group for type 2 shapenets only ? */
    /* 0x28 */ u8[4] pad28;
    /* 0x2C */ ObjGroup* mtlGroup; /* what does this group do? materials? */
    /* 0x30 */ s32 unk30;
    /* 0x34 */ s32 faceCount; /* face count? based on get_3DG1_shape */
    /* 0x38 */ s32 vtxCount; /* vtx count? based on get_3DG1_shape */
    /* 0x3C */ s32 unk3C; // bool? if FALSE, then draw_shape_faces(shape)
    /* 0x40 */ u32 id;
    /* 0x44 */ s32 flag; // what are the flag values? only from dynlists?
    /* 0x48 */ s32[3] gdDls; // gd dl number for each frame buffer (??) [0, 1]; and an offset for GdDl->dlptr [2]
    /* 0x54 */ u8[4] pad54; // part of above array??
    /* 0x58 */ f32 unk58; // paramF? opacitiy? something with rendertype
    /* 0x5C */ char[0x40] name;
} /* sizeof = 0x9C */

/* 0x44 Flag Values  0x01 -
 * 0x10 - Use vtx position as vtx normal? (`chk_shapegen`)
 */

/* netTypes
 * 0 - default?
 * 1 - shape net
 * 2 - something about the shape unk24 group having vertices too?
 * 3 - joints?
 * 4 - dynamic net? bone net?
 * 5 - particle net?
 * 6 - stub
 * 7 -
 */

struct ObjNet
{
    /* 0x000 */ GdObj header;
    /* 0x014 */ GdVec3f unk14; // position? d_set_initpos + d_set_world_pos; print_net says world
    /* 0x020 */ GdVec3f unk20; // position? d_set_initpos? attached offset? dynamic? scratch?
    /* 0x02C */ u8[8] pad2c;
    /* 0x034 */ s32 unk34; // "dflags"?
    /* 0x038 */ u32 unk38; // some sort of id? from move_net
    /* 0x03C */ s32 unk3C; // state flags? vertex info flags?
    /* 0x040 */ s32 unk40; // gd "colour"
    /* 0x044 */ GdVec3f unk44; // "force"
    /* 0x050 */ GdVec3f unk50; // velocity
    /* 0x05C */ GdVec3f unk5C; // rotation
    /* 0x068 */ GdVec3f unk68; //initial rotation?
    /* 0x074 */ GdVec3f unk74; // "collDisp"
    /* 0x080 */ GdVec3f unk80; // "collTorque"
    /* 0x08C */ GdVec3f unk8C; // "CollTorqueL"
    /* 0x098 */ GdVec3f unk98; // "CollTorqueD"
    /* 0x0A4 */ GdVec3f unkA4; // torque
    /* 0x0B0 */ GdVec3f unkB0; // "CofG" center of gravity?
    /* 0x0BC */ GdPlaneF unkBC; // bounding box
    /* 0x0D4 */ GdVec3f unkD4; // "CollDispOff"
    /* 0x0E0 */ f32 unkE0; // "CollMaxD"
    /* 0x0E4 */ f32 unkE4; // "MaxRadius"
    /* 0x0E8 */ Mat4f matE8;
    /* 0x128 */ Mat4f mat128;
    /* 0x168 */ Mat4f mat168; // "rotation matrix"
    /* 0x1A8 */ ObjShape* unk1A8; // "ShapePtr"
    /* 0x1AC */ GdVec3f unk1AC; // scale
    /* 0x1B8 */ f32 unk1B8; // "Mass"
    /* 0x1BC */ s32 unk1BC; // "NumModes"
    /* 0x1C0 */ ObjGroup* unk1C0;
    /* 0x1C4 */ ObjGroup* skinGrp; // SkinGroup (from reset_weight) (joints and bones)
    /* 0x1C8 */ ObjGroup* unk1C8; // "node group" (joints, weights?)
    /* 0x1CC */ ObjGroup* unk1CC; // plane group (only type 1?)
    /* 0x1D0 */ ObjGroup* unk1D0; // vertex group
    /* 0x1D4 */ ObjGroup* unk1D4; // attached objects group?
    /* 0x1D8 */ GdVec3f unk1D8; // attached offset
    /* 0x1E4 */ s32 unk1E4; // d_attach_to arg 0; "AttFlag"
    /* 0x1E8 */ GdObj* unk1E8; // attached obj?
    /* 0x1EC */ s32 netType; // from move_net
    /* 0x1F0 */ ObjNet* unk1F0; // or joint. guess from Unknown80192AD0
    /* 0x1F4 */ GdVec3f unk1F4;
    /* 0x200 */ GdVec3f unk200;
    /* 0x20C */ ObjGroup* unk20C;
    /* 0x210 */ s32 unk210; // "control type"
    /* 0x214 */ u8[8] pad214;
    /* 0x21C */ ObjGroup* unk21C;
} /* sizeof = 0x220 */

struct ObjPlane
{
    /* 0x00 */ GdObj header;
    /* 0x14 */ u32 id;
    /* 0x18 */ s32 unk18; //bool;  contained within zone? (from its parent Net?)
    /* 0x1C */ f32 unk1C;
    /* 0x20 */ s32 unk20;
    /* 0x24 */ s32 unk24;
    /* 0x28 */ GdPlaneF plane28; //position plane?
    /* 0x40 */ ObjFace* unk40;
} /* sizeof = 0x44*/

struct ObjVertex
{
    /* 0x00 */ GdObj header;
    /* 0x14 */ GdVec3f initPos;
    /* 0x20 */ GdVec3f pos; // rel position? world pos? both are set with the same value..
    /* 0x2C */ GdVec3f normal; // normal? also color (like gbi?)
    /* 0x38 */ s16 id;
    /* 0x3A */ u8[2] pad3A;
    /* 0x3C */ f32 scaleFactor;
    /* 0x40 */ f32 alpha;
    /* 0x44 */ VtxLink* gbiVerts;
} /* sizeof = 0x48 */

struct VtxLink
{
    VtxLink* prev;
    VtxLink* next;
    Vtx* data;
}

struct ObjFace
{
    /* 0x00 */ GdObj header;
    /* 0x14 */ GdColour colour;
    /* 0x20 */ s32 colNum; // "colour" index
    /* 0x24 */ GdVec3f normal;
    /* 0x30 */ s32 vtxCount;
    /* 0x34 */ ObjVertex*[4] vertices; // these can also be s32 indices? which are then replaced by `find_thisface_verts`
    /* 0x44 */ s32 mtlId; // from compressed GdFaceData; -1 == coloured face?
    /* 0x48 */ ObjMaterial* mtl; // initialize to NULL; set by `map_face_materials` from mtlId
} /* sizeof = 0x4C */

struct ObjCamera
{
    /* 0x000 */ GdObj header;
    /* 0x014 */ GdVec3f unk14; // position vec? from d_set_initpos
    /* 0x020 */ ObjCamera* prev;
    /* 0x024 */ ObjCamera* next;
    /* 0x028 */ s32 id;
    /* 0x02C */ s32 unk2C; // flag of some sort
    /* 0x030 */ GdObj* unk30; // pointer to some type of object
    /* 0x034 */ GdVec3f unk34;
    /* 0x040 */ GdVec3f unk40; // relative position related?
    /* 0x04C */ GdVec3f unk4C;
    /* 0x058 */ f32 unk58; // GdVec3f ?
    /* 0x05C */ u8[0x4] pad5C;
    /* 0x060 */ f32 unk60;
    /* 0x064 */ Mat4f unk64; //matrix4x4
    /* 0x0A4 */ f32 unkA4;
    /* 0x0A8 */ Mat4f unkA8; //matrix4x4
    /* 0x0E8 */ Mat4f unkE8;
    /* 0x128 */ GdVec3f unk128; //possibly
    /* 0x134 */ GdVec3f unk134;
    /* 0x140 */ GdVec3f[4] positions; // zoom positions (*1, *1.5, *2, empty fourth)
    /* 0x170 */ s32 zoomLevels; // max number of zoom positions
    /* 0x174 */ s32 zoom; // index into position vec array
    /* 0x178 */ f32 unk178;
    /* 0x17C */ f32 unk17C;
    /* 0x180 */ GdVec3f unk180;
    /* 0x18C */ ObjView* unk18C; // view that has/is using this camera?
} /* sizeof = 0x190 */

enum GdMtlTypes
{
    GD_MTL_STUB_DL  = 0x01,
    GD_MTL_BREAK    = 0x04,
    GD_MTL_SHINE_DL = 0x10,
    GD_MTL_TEX_OFF  = 0x20,
    GD_MTL_LIGHTS   = 0x40 // uses default case
}
mixin importEnumMembers!GdMtlTypes;

struct ObjMaterial
{
    /* 0x00 */ GdObj header;
    /* 0x14 */ u8[8] pad14;
    /* 0x1C */ s32 id;
    /* 0x20 */ char[8] name;
    /* 0x28 */ s32 type;
    /* 0x2C */ u8[4] pad2C;
    /* 0x30 */ GdColour Ka; // ambient color
    /* 0x3C */ GdColour Kd; // diffuse color
    /* 0x48 */ u8[16] pad48;
    /* 0x58 */ void* texture; //set by d_usetexture; never seems to be non-null though.
    /* 0x5C */ s32 gddlNumber;
} /* sizeof = 0x60 */

struct ObjWeight
{
    /* 0x00 */ GdObj header;
    /* 0x14 */ u8[0x8] pad14;
    /* 0x1C */ s32 id; //id
    /* 0x20 */ GdVec3f vec20; //based on func_80181894? maybe a GdPlaneF?
    /* 0x2C */ u8[12] pad2C;
    /* 0x38 */ f32 unk38; // weight (unit?)
    /* 0x3C */ ObjVertex* unk3C;
} /* sizeof = 0x40 */

/* This union is used in ObjGadget for a variable typed field.
** The type can be found by checking group unk4C */
union ObjVarVal
{
    s32 i;
    f32 f;
    u64 l;
}

struct ObjGadget
{
    /* 0x00 */ GdObj header;
    /* 0x14 */ GdVec3f unk14; // "world" position vec?
    /* 0x20 */ s32 unk20;
    /* 0x24 */ s32 unk24; // type?
    /* 0x28 */ f32 unk28;
    /* 0x2C */ u8[4] pad2C;
    /* 0x30 */ ObjVarVal varval; //retype and rename varval30
    /* 0x38 */ f32 unk38; //range left?
    /* 0x3C */ f32 unk3C; //range right?
    /* 0x40 */ GdVec3f unk40; // scale?
    /* 0x4C */ ObjGroup* unk4C; //gfroup->link->obj = valptr for var30 ?
    /* 0x50 */ ObjShape* unk50;
    /* 0x54 */ ObjGroup* unk54; //node group?
    /* 0x58 */ u8[4] pad58;
    /* 0x5C */ s32 unk5C; // gd colour id (enum eventually)
} /* sizeof = 0x60 */

enum GdViewFlags
{
    VIEW_2_COL_BUF      = 0x000008,
    VIEW_ALLOC_ZBUF     = 0x000010,
    VIEW_SAVE_TO_GLOBAL = 0x000040,
    VIEW_DEFAULT_PARENT = 0x000100,
    VIEW_BORDERED       = 0x000400,
    VIEW_UPDATE         = 0x000800,
    VIEW_UNK_1000       = 0x001000, // used in setup_view_buffers
    VIEW_UNK_2000       = 0x002000, // only see together with 0x4000
    VIEW_UNK_4000       = 0x004000,
    VIEW_COLOUR_BUF     = 0x008000,
    VIEW_Z_BUF          = 0x010000,
    VIEW_1_CYCLE        = 0x020000,
    VIEW_MOVEMENT       = 0x040000,
    VIEW_DRAW           = 0x080000,
    VIEW_WAS_UPDATED    = 0x100000,
    VIEW_LIGHT          = 0x200000
}
mixin importEnumMembers!GdViewFlags;

struct ObjView
{
    /* 0x00 */ GdObj header;
    /* 0x14 */ u8[0x8] pad14;
    /* 0x1C */ s32 unk1C; // set as nonexistent return of `setup_view_buffers`
    /* 0x20 */ s32 id;
    /* 0x24 */ ObjCamera* activeCam; // is this really active?
    /* 0x28 */ ObjGroup* components; // camera + joints + nets, etc..?
    /* 0x2C */ ObjGroup* lights; // only lights?
    /* 0x30 */ GdObj* pickedObj; // selected with cursor (`update_view`)
    /* 0x34 */ GdViewFlags flags;
    /* 0x38 */ s32 unk38; // enum? if 1 use guPerspective (see `drawscene`)
    /* 0x3C */ GdVec3f upperLeft; // position vec?
    /* 0x48 */ f32 unk48; // what are these? are they another vec?
    /* 0x4C */ f32 unk4C;
    /* 0x50 */ u8[0x4] pad50;
    /* 0x54 */ GdVec3f lowerRight;
    /* 0x60 */ GdVec3f clipping; // z-coordinate of (x: near, y: far) clipping plane?
    /* 0x6C */ const(char)* namePtr;
    /* 0x70 */ s32 gdDlNum; // gd dl number
    /* 0x74 */ s32 unk74;
    /* 0x78 */ s32 unk78;
    /* 0x7C */ GdColour colour;
    /* 0x88 */ ObjView* parent; // maybe not a true parent, but link to buffers in parent?
    /* 0x8C */ void* zbuf;
    /* 0x90 */ void*[2] colourBufs; // frame buffers?
    /* 0x98 */ void function (ObjView*) proc; // Never non-null in game...?
    /* 0x9C */ s32 unk9C;
} /* sizeof = 0xA0 */

alias valptrproc_t = ObjVarVal* function (ObjVarVal*, ObjVarVal);

struct ObjLabel
{
    /* 0x00 */ GdObj header;
    /* 0x14 */ GdVec3f vec14;
    /* 0x20 */ char* fmtstr;
    /* 0x24 */ s32 unk24;
    /* 0x28 */ ObjValPtrs* valptr;
    /* 0x2C */ valptrproc_t valfn;
    /* 0x30 */ s32 unk30; // state or type?
} /* sizeof = 0x34 */

/* unk30 types:
 * 3 = f32? f32 pointer?
**/

struct ObjAnimator
{
    /* 0x00 */ GdObj header;
    /* 0x14 */ ObjGroup* unk14; // joint?
    /* 0x18 */ ObjGroup* animdata; //animation data? a group, but the link points to something weird..
    /* 0x1C */ u8[0x4] pad1C;
    /* 0x20 */ s32 unk20;
    /* 0x24 */ f32 unk24;
    /* 0x28 */ f32 unk28;
    /* 0x2C */ u8[4] pad2C;
    /* 0x30 */ ObjGroup* unk30; //attached group?
    /* 0x34 */ s32 unk34; //attach arg0
    /* 0x38 */ u8[12] pad38;
    /* 0x44 */ GdObj* unk44; //attached object? Normally another Objanimator?
    /* 0x48 */ void function (ObjAnimator*) fn48;
    /* 0x4C */ s32 unk4C; //state enum?
    /* 0x50 */ s32 unk50;
    /* 0x54 */ s32 unk54;
} /* sizeof = 0x58 */

/* Animation Data Types */
enum GdAnimations
{
    GD_ANIM_EMPTY     = 0, // Listed types are how the data are arranged in memory; maybe not be exact type
    GD_ANIM_MATRIX    = 1, // f32[4][4]
    GD_ANIM_TRI_F_2   = 2, // f32[3][3]
    GD_ANIM_9H        = 3, // s16[9]
    GD_ANIM_TRI_F_4   = 4, // f32[3][3]
    GD_ANIM_STUB      = 5,
    GD_ANIM_3H_SCALED = 6, // s16[3]
    GD_ANIM_3H        = 7, // s16[3]
    GD_ANIM_6H_SCALED = 8, // s16[6]
    GD_ANIM_MTX_VEC   = 9, // {f32 mtx[4][4]; f32 vec[3];}
    GD_ANIM_CAMERA    = 11 // s16[6]
}
mixin importEnumMembers!GdAnimations;

/* This struct is pointed to by the `obj` field in Links struct in the `animdata` ObjGroup */
struct AnimDataInfo
{
    s32 count; // count or -1 for end of array of AnimDataInfo structures
    GdAnimations type; // types are used in "move_animator"
    void* data; // points to an array of `type` data
}

/* GD_ANIM_MTX_VEC (9) type */
struct AnimMtxVec
{
    /* 0x00 */ Mat4f matrix;
    /* 0x40 */ GdVec3f vec; // seems to be a scale vec
}

enum ValPtrType
{
    OBJ_VALUE_INT   = 1,
    OBJ_VALUE_FLOAT = 2
}
mixin importEnumMembers!ValPtrType;

struct ObjValPtrs
{
    /* 0x00 */ GdObj header;
    /* 0x14 */ GdObj* obj; // maybe just a void *?
    /* 0x18 */ size_t offset;
    /* 0x1C */ ValPtrType datatype;
    /* 0x20 */ s32 unk20; // obj type ptr enum? Might be OBJ_TYPES flags?
} /* sizeof = 0x24 */

enum GdLightFlags
{
    LIGHT_UNK02         = 0x02, // old type of light?
    LIGHT_NEW_UNCOUNTED = 0x10,
    LIGHT_UNK20         = 0x20 // new, actually used type of light? used for phong shading?
}
mixin importEnumMembers!GdLightFlags;

struct ObjLight
{
    /* 0x00 */ GdObj header;
    /* 0x14 */ u8[0x8] pad0;
    /* 0x1C */ s32 id;
    /* 0x20 */ char[8] name;
    /* 0x28 */ u8[4] pad28;
    /* 0x2C */ s32 flags;
    /* 0x30 */ f32 unk30; // color (5C) = Kd (50) * 30
    /* 0x34 */ u8[4] pad34;
    /* 0x38 */ f32 unk38; // calculated diffuse theta (in degrees?)
    /* 0x3C */ s32 unk3C;
    /* 0x40 */ s32 unk40;
    /* 0x44 */ u8[0x8] pad3;
    /* 0x4C */ s32 unk4C;
    /* 0x50 */ GdColour diffuse;
    /* 0x5C */ GdColour colour;
    /* 0x68 */ GdVec3f unk68;
    /* 0x74 */ GdVec3f position;
    /* 0x80 */ GdVec3f unk80;
    /* 0x8C */ GdVec3f unk8C;
    /* 0x98 */ s32 unk98;
    /* 0x9C */ ObjShape* unk9C;
} /* sizeof = 0xA0 */

struct ObjZone
{
    /* 0x00 */ GdObj header;
    /* 0x14 */ GdPlaneF unk14;
    /* 0x2C */ ObjGroup* unk2C; // plane group?
    /* 0x30 */ ObjGroup* unk30; // guess based on Unknown801781DC; might have to change later
    /* 0x34 */ u8[4] pad;
} /* sizeof = 0x38*/

struct ObjUnk200000
{
    /* 0x00 */ GdObj header;
    /* 0x14 */ u8[28] pad14;
    /* 0x30 */ ObjVertex* unk30; //not sure; guessing for Unknown801781DC; 30 and 34 could switch with ObjZone
    /* 0x34 */ ObjFace* unk34; //not sure; guessing for Unknown801781DC
} /* sizeof = 0x38*/

// GD_TYPES_H
