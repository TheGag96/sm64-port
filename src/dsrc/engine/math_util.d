module engine.math_util;

import ultra64, types, gbi;

extern (C):

/*
 * The sine and cosine tables overlap, but "#define gCosineTable (gSineTable +
 * 0x400)" doesn't give expected codegen; gSineTable and gCosineTable need to
 * be different symbols for code to match. Most likely the tables were placed
 * adjacent to each other, and gSineTable cut short, such that reads overflow
 * into gCosineTable.
 *
 * These kinds of out of bounds reads are undefined behavior, and break on
 * e.g. GCC (which doesn't place the tables next to each other, and probably
 * exploits array sizes for range analysis-based optimizations as well).
 * Thus, for non-IDO compilers we use the standard-compliant version.
 */
extern __gshared f32[] gSineTable;

extern __gshared f32[] gCosineTable;

extern (D) auto sins(T)(auto ref T x)
{
    return gSineTable[cast(ushort) x >> 4];
}

extern (D) auto coss(T)(auto ref T x)
{
    return gCosineTable[cast(ushort) x >> 4];
}

extern (D) auto min(T0, T1)(auto ref T0 a, auto ref T1 b)
{
    return a <= b ? a : b;
}

extern (D) auto max(T0, T1)(auto ref T0 a, auto ref T1 b)
{
    return a > b ? a : b;
}

extern (D) auto sqr(T)(auto ref T x)
{
    return x * x;
}

void* vec3f_copy (Vec3f dest, Vec3f src);
void* vec3f_set (Vec3f dest, f32 x, f32 y, f32 z);
void* vec3f_add (Vec3f dest, Vec3f a);
void* vec3f_sum (Vec3f dest, Vec3f a, Vec3f b);
void* vec3s_copy (Vec3s dest, Vec3s src);
void* vec3s_set (Vec3s dest, short x, short y, short z);
void* vec3s_add (Vec3s dest, Vec3s a);
void* vec3s_sum (Vec3s dest, Vec3s a, Vec3s b);
void* vec3s_sub (Vec3s dest, Vec3s a);
void* vec3s_to_vec3f (Vec3f dest, Vec3s a);
void* vec3f_to_vec3s (Vec3s dest, Vec3f a);
void* find_vector_perpendicular_to_plane (Vec3f dest, Vec3f a, Vec3f b, Vec3f c);
void* vec3f_cross (Vec3f dest, Vec3f a, Vec3f b);
void* vec3f_normalize (Vec3f dest);
void mtxf_copy (Mat4 dest, Mat4 src);
void mtxf_identity (Mat4 mtx);
void mtxf_translate (Mat4 dest, Vec3f b);
void mtxf_lookat (Mat4 mtx, Vec3f from, Vec3f to, short roll);
void mtxf_rotate_zxy_and_translate (Mat4 dest, Vec3f translate, Vec3s rotate);
void mtxf_rotate_xyz_and_translate (Mat4 dest, Vec3f b, Vec3s c);
void mtxf_billboard (Mat4 dest, Mat4 mtx, Vec3f position, short angle);
void mtxf_align_terrain_normal (Mat4 dest, Vec3f upDir, Vec3f pos, short yaw);
void mtxf_align_terrain_triangle (Mat4 mtx, Vec3f pos, short yaw, f32 radius);
void mtxf_mul (Mat4 dest, Mat4 a, Mat4 b);
void mtxf_scale_vec3f (Mat4 dest, Mat4 mtx, Vec3f s);
void mtxf_mul_vec3s (Mat4 mtx, Vec3s b);
void mtxf_to_mtx (Mtx* dest, Mat4 src);
void mtxf_rotate_xy (Mtx* mtx, short angle);
void get_pos_from_transform_mtx (Vec3f dest, Mat4 objMtx, Mat4 camMtx);
void vec3f_get_dist_and_angle (Vec3f from, Vec3f to, f32* dist, short* pitch, short* yaw);
void vec3f_set_dist_and_angle (Vec3f from, Vec3f to, f32 dist, short pitch, short yaw);
int approach_s32 (int current, int target, int inc, int dec);
f32 approach_f32 (f32 current, f32 target, f32 inc, f32 dec);
short atan2s (f32 y, f32 x);
float atan2f (f32 a, f32 b);
void spline_get_weights (Vec4f result, f32 t, int c);
void anim_spline_init (Vec4s* keyFrames);
int anim_spline_poll (Vec3f result);

// MATH_UTIL_H
