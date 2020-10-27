module pc.gfx.gfx_pc;

import ultra64, gbi;
import core.stdc.stdint;

extern (C):

struct GfxRenderingAPI;
struct GfxWindowManagerAPI;

struct GfxDimensions
{
    uint width;
    uint height;
    float aspect_ratio;
}

extern __gshared GfxDimensions gfx_current_dimensions;

void gfx_init (GfxWindowManagerAPI* wapi, GfxRenderingAPI* rapi, const(char)* game_name, bool start_in_fullscreen);
GfxRenderingAPI* gfx_get_current_rendering_api ();
void gfx_start_frame ();
void gfx_run (Gfx* commands);
void gfx_end_frame ();

