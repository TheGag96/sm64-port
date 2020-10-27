module gfx_dimensions;

import config;

extern (C):

/*

This file is for ports that want to enable widescreen.
Change the definitions to the following:

#include <math.h>
#define GFX_DIMENSIONS_FROM_LEFT_EDGE(v) (SCREEN_WIDTH / 2 - SCREEN_HEIGHT / 2 * [current_aspect_ratio] + (v))
#define GFX_DIMENSIONS_FROM_RIGHT_EDGE(v) (SCREEN_WIDTH / 2 + SCREEN_HEIGHT / 2 * [current_aspect_ratio] - (v))
#define GFX_DIMENSIONS_RECT_FROM_LEFT_EDGE(v) ((int)floorf(GFX_DIMENSIONS_FROM_LEFT_EDGE(v)))
#define GFX_DIMENSIONS_RECT_FROM_RIGHT_EDGE(v) ((int)ceilf(GFX_DIMENSIONS_FROM_RIGHT_EDGE(v)))
#define GFX_DIMENSIONS_ASPECT_RATIO [current_aspect_ratio]

The idea is that SCREEN_WIDTH and SCREEN_HEIGHT are still hardcoded to 320 and 240, and that
x=0 lies at where a 4:3 left edge would be. On 16:9 widescreen, the left edge is hence at -53.33.

To get better accuracy, consider using floats instead of shorts for coordinates in Vertex and Matrix structures.

The conversion to integers above is for RECT commands which naturally only accept integer values.
Note that RECT commands must be enhanced to support negative coordinates with this modification.

*/

version (SM64_Widescreen) {
    import pc.gfx.gfx_pc;

    extern (D) auto GFX_DIMENSIONS_FROM_LEFT_EDGE(T)(auto ref T v) {
        return SCREEN_WIDTH / 2 - SCREEN_HEIGHT / 2 * gfx_current_dimensions.aspect_ratio + v;
    }
    extern (D) auto GFX_DIMENSIONS_FROM_RIGHT_EDGE(T)(auto ref T v) {
        return SCREEN_WIDTH / 2 + SCREEN_HEIGHT / 2 * gfx_current_dimensions.aspect_ratio - v;
    }
    extern (D) auto GFX_DIMENSIONS_RECT_FROM_LEFT_EDGE(T)(auto ref T v) {
        import std.math : floor;
        return cast(int) floor(GFX_DIMENSIONS_FROM_LEFT_EDGE(v));
    }
    extern (D) auto GFX_DIMENSIONS_RECT_FROM_RIGHT_EDGE(T)(auto ref T v) {
        import std.math : ceil;
        return cast(int) ceil(GFX_DIMENSIONS_FROM_RIGHT_EDGE(v));
    }
    extern (D) auto GFX_DIMENSIONS_ASPECT_RATIO() {
        return gfx_current_dimensions.aspect_ratio;
    }
} else {
    extern (D) auto GFX_DIMENSIONS_FROM_LEFT_EDGE(T)(auto ref T v) {
        return v;
    }
    extern (D) auto GFX_DIMENSIONS_FROM_RIGHT_EDGE(T)(auto ref T v) {
        return SCREEN_WIDTH - v;
    }
    extern (D) auto GFX_DIMENSIONS_RECT_FROM_LEFT_EDGE(T)(auto ref T v) {
        return v;
    }
    extern (D) auto GFX_DIMENSIONS_RECT_FROM_RIGHT_EDGE(T)(auto ref T v) {
        return SCREEN_WIDTH - v;
    }
    enum GFX_DIMENSIONS_ASPECT_RATIO = 4.0f / 3.0f;
}

// If screen is taller than it is wide, radius should be equal to SCREEN_HEIGHT since we scale horizontally
extern (D) auto GFX_DIMENSIONS_FULL_RADIUS() {
    return SCREEN_HEIGHT * (GFX_DIMENSIONS_ASPECT_RATIO > 1 ? GFX_DIMENSIONS_ASPECT_RATIO : 1);
};

// GFX_DIMENSIONS_H
