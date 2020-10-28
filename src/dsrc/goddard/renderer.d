module goddard.renderer;

import ultra64, util, goddard.gd_types, gbi;

extern (C):

// types
/// Properties types used in [gd_setproperty](@ref gd_setproperty); most are stubbed out.
enum GdProperty
{
    GD_PROP_OVERLAY       = 4,
    GD_PROP_LIGHTING      = 11,
    GD_PROP_AMB_COLOUR    = 12,
    GD_PROP_DIFUSE_COLOUR = 13,
    GD_PROP_LIGHT_DIR     = 15,
    GD_PROP_CULLING       = 16,
    GD_PROP_STUB17        = 17,
    GD_PROP_STUB18        = 18,
    GD_PROP_STUB19        = 19,
    GD_PROP_STUB20        = 20,
    GD_PROP_STUB21        = 21,
    GD_PROP_ZBUF_FN       = 22
}
mixin importEnumMembers!GdProperty;

// data
extern __gshared s32 gGdFrameBuf;

// functions
u32 get_alloc_mem_amt ();
s32 gd_get_ostime ();
f32 get_time_scale ();
f64 gd_sin_d (f64 x);
f64 gd_cos_d (f64 x);
f64 gd_sqrt_d (f64 x);
void gd_printf (const(char)* format, ...);
void gd_exit (s32 code);
void gd_free (void* ptr);
void* gd_allocblock (u32 size);
void* gd_malloc (u32 size, u8 perm);
void* gd_malloc_perm (u32 size);
void* gd_malloc_temp (u32 size);
void func_8019BD0C (s32 dlNum, s32 gfxIdx);

void gd_add_to_heap (void* addr, u32 size);
void gdm_init (void* blockpool, u32 size);

void gdm_setup ();
void gdm_maketestdl (s32 id);
void gd_vblank ();
void gd_copy_p1_contpad (OSContPad* p1cont);
s32 gd_sfx_to_play ();
void* gdm_gettestdl (s32 id);
void gd_draw_rect (f32 ulx, f32 uly, f32 lrx, f32 lry);
void gd_draw_border_rect (f32 ulx, f32 uly, f32 lrx, f32 lry);
void gd_set_fill (GdColour* colour);
void stash_current_gddl ();
void pop_gddl_stash ();
s32 gd_startdisplist (s32 memarea);
s32 gd_enddlsplist_parent ();
void add_mat4_load_to_dl (Mat4f* mtx);
void idn_mtx_push_gddl ();
void pop_mtx_gddl ();
void translate_mtx_gddl (f32 x, f32 y, f32 z);
void translate_load_mtx_gddl (f32 x, f32 y, f32 z);
void func_8019F258 (f32 x, f32 y, f32 z);
void func_8019F2C4 (f32 arg0, s8 arg1);
void func_8019F318 (ObjCamera* cam, f32 arg1, f32 arg2, f32 arg3, f32 arg4, f32 arg5, f32 arg6, f32 arg7);
void check_tri_display (s32 vtxcount);
Vtx* make_vtx_if_new (f32 x, f32 y, f32 z, f32 alpha);
void func_8019FEF0 ();
void add_tri_to_dl (f32 x1, f32 y1, f32 z1, f32 x2, f32 y2, f32 z2, f32 x3, f32 y3, f32 z3);
void func_801A0038 ();
void func_801A0070 ();
void func_801A02B8 (f32 arg0);
void set_light_id (s32 index);
void set_light_num (s32 n);
s32 create_mtl_gddl (s32 mtlType);
void branch_to_gddl (s32 dlNum);
void func_801A0478 (s32, ObjCamera*, GdVec3f*, GdVec3f*, GdVec3f*, GdColour*);
void func_801A0478 (
    s32 idx,
    ObjCamera* cam,
    GdVec3f* arg2,
    GdVec3f* arg3,
    GdVec3f* arg4,
    GdColour* colour);
s32 func_801A086C (s32 id, GdColour* colour, s32 material);
void set_Vtx_norm_buf_1 (GdVec3f* norm);
void set_Vtx_norm_buf_2 (GdVec3f* norm);
void set_gd_mtx_parameters (s32 params);
void gd_set_one_cycle ();
void gddl_is_loading_stub_dl (s32 dlLoad);
void start_view_dl (ObjView* view);
void border_active_view ();
void gd_shading (s32 model);
s32 gd_getproperty (s32 prop, void* arg1);
void gd_setproperty (GdProperty prop, f32 f1, f32 f2, f32 f3);
void gd_create_ortho_matrix (f32 l, f32 r, f32 b, f32 t, f32 n, f32 f);
void gd_create_perspective_matrix (f32 fovy, f32 aspect, f32 near, f32 far);
s32 setup_view_buffers (
    const(char)* name,
    ObjView* view,
    s32 ulx,
    s32 uly,
    s32 lrx,
    s32 lry);
void gd_init_controllers ();
void func_801A43DC (GdObj* obj); //apply to OBJ_TYPE_VIEWS
void* func_801A43F0 (const(char)* menufmt, ...); // TUI code..? query_user? doesn't actually return anything... maybe it returned a "menu *"?
void func_801A4410 (void* arg0); // function looks like it got various controller/input attributes..?
void func_801A4424 (void* arg0); // TUI stuff?
void func_801A4438 (f32 x, f32 y, f32 z);
void func_801A48C4 (u32 arg0);
void func_801A48D8 (char* s);
void set_active_view (ObjView* v);
void func_801A520C ();
void gd_init ();
void func_801A5998 (s8* arg0); /* convert LE bytes to BE word? */
void func_801A59AC (void* arg0);
void func_801A59C0 (s8* arg0); /* convert LE bytes to BE f32? */
void init_pick_buf (s16* buf, s32 len);
void store_in_pickbuf (s16 data);
s32 get_cur_pickbuf_offset (s16* arg0);
void set_vtx_tc_buf (f32 tcS, f32 tcT);
GdObj* load_dynlist (DynList* dynlist);

// GD_RENDERER_H
