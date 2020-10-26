module engine.math_util;

import ultra64, types, gbi, util;

extern (C):

/*
 * The sine and cosine tables overlap, but "#define gCosineTable (gSineTable +
 * 0x400)" doesn't give expected codegen; gSineTable and gCosineTable need to
 * be different symbols for code to match. Most likely the tables were placed
 * adjacent to each other, and gSineTable cut s16, such that reads overflow
 * into gCosineTable.
 *
 * These kinds of out of bounds reads are undefined behavior, and break on
 * e.g. GCC (which doesn't place the tables next to each other, and probably
 * exploits array sizes for range analysis-based optimizations as well).
 * Thus, for non-IDO compilers we use the standard-compliant version.
 */
mixin externCArray!(f32, "gSineTable");

version (SM64_Avoid_UB) {
    extern(D) @property f32* gCosineTable() { return gSineTable + 0x400; }
}
else {
    mixin externCArray!(f32, "gCosineTable");
}

//can't seem to get these working by using the cosine tables...
extern (D) f32 sins(s32 x) {
    return gSineTable[cast(ushort) (x) >> 4];
}

extern (D) f32 coss(s32 x) {
    return gCosineTable[cast(ushort) (x) >> 4];
}

extern (D) auto min(T0, T1)(auto ref T0 a, auto ref T1 b) {
    return a <= b ? a : b;
}

extern (D) auto max(T0, T1)(auto ref T0 a, auto ref T1 b) {
    return a > b ? a : b;
}

extern (D) auto sqr(T)(auto ref T x) {
    return x * x;
}

void* vec3f_copy (ref Vec3f dest, ref Vec3f src);
void* vec3f_set (ref Vec3f dest, f32 x, f32 y, f32 z);
void* vec3f_add (ref Vec3f dest, ref Vec3f a);
void* vec3f_sum (ref Vec3f dest, ref Vec3f a, ref Vec3f b);
void* vec3s_copy (ref Vec3s dest, ref Vec3s src);
void* vec3s_set (ref Vec3s dest, s16 x, s16 y, s16 z);
void* vec3s_add (ref Vec3s dest, ref Vec3s a);
void* vec3s_sum (ref Vec3s dest, ref Vec3s a, ref Vec3s b);
void* vec3s_sub (ref Vec3s dest, ref Vec3s a);
void* vec3s_to_vec3f (ref Vec3f dest, ref Vec3s a);
void* vec3f_to_vec3s (ref Vec3s dest, ref Vec3f a);
void* find_vector_perpendicular_to_plane (ref Vec3f dest, ref Vec3f a, ref Vec3f b, ref Vec3f c);
void* vec3f_cross (ref Vec3f dest, ref Vec3f a, ref Vec3f b);
void* vec3f_normalize (ref Vec3f dest);
void mtxf_copy (ref Mat4 dest, ref Mat4 src);
void mtxf_identity (ref Mat4 mtx);
void mtxf_translate (ref Mat4 dest, ref Vec3f b);
void mtxf_lookat (ref Mat4 mtx, ref Vec3f from, ref Vec3f to, s16 roll);
void mtxf_rotate_zxy_and_translate (ref Mat4 dest, ref Vec3f translate, ref Vec3s rotate);
void mtxf_rotate_xyz_and_translate (ref Mat4 dest, ref Vec3f b, ref Vec3s c);
void mtxf_billboard (ref Mat4 dest, ref Mat4 mtx, ref Vec3f position, s16 angle);
void mtxf_align_terrain_normal (ref Mat4 dest, ref Vec3f upDir, ref Vec3f pos, s16 yaw);
void mtxf_align_terrain_triangle (ref Mat4 mtx, ref Vec3f pos, s16 yaw, f32 radius);
void mtxf_mul (ref Mat4 dest, ref Mat4 a, ref Mat4 b);
void mtxf_scale_vec3f (ref Mat4 dest, ref Mat4 mtx, ref Vec3f s);
void mtxf_mul_vec3s (ref Mat4 mtx, ref Vec3s b);
void mtxf_to_mtx (Mtx* dest, ref Mat4 src);
void mtxf_rotate_xy (Mtx* mtx, s16 angle);
void get_pos_from_transform_mtx (ref Vec3f dest, ref Mat4 objMtx, ref Mat4 camMtx);
void vec3f_get_dist_and_angle (ref Vec3f from, ref Vec3f to, f32* dist, s16* pitch, s16* yaw);
void vec3f_set_dist_and_angle (ref Vec3f from, ref Vec3f to, f32 dist, s16 pitch, s16 yaw);
s32 approach_s32 (s32 current, s32 target, s32 inc, s32 dec);
f32 approach_f32 (f32 current, f32 target, f32 inc, f32 dec);
s16 atan2s (f32 y, f32 x);
float atan2f (f32 a, f32 b);
void spline_get_weights (ref Vec4f result, f32 t, s32 c);
void anim_spline_init (Vec4s* keyFrames);
s32 anim_spline_poll (ref Vec3f result);

// MATH_UTIL_H
