module game.game_init;

import ultra64, types, gbi, game.memory;

import core.stdc.stdint;

extern (C):

enum GFX_POOL_SIZE = 6400;

struct GfxPool
{
    Gfx[GFX_POOL_SIZE] buffer;
    SPTask spTask;
}

struct DemoInput
{
    ubyte timer; // time until next input. if this value is 0, it means the demo is over
    byte rawStickX;
    byte rawStickY;
    ubyte buttonMask;
}

extern __gshared Controller[3] gControllers;
extern __gshared OSContStatus[4] gControllerStatuses;
extern __gshared OSContPad[4] gControllerPads;
extern __gshared OSMesgQueue gGameVblankQueue;
extern __gshared OSMesgQueue D_80339CB8;
extern __gshared OSMesg D_80339CD0;
extern __gshared OSMesg D_80339CD4;
extern __gshared VblankHandler gGameVblankHandler;
extern __gshared uintptr_t[3] gPhysicalFrameBuffers;
extern __gshared uintptr_t gPhysicalZBuffer;
extern __gshared void* D_80339CF0;
extern __gshared void* D_80339CF4;
extern __gshared SPTask* gGfxSPTask;

extern __gshared Gfx* gDisplayListHead;
extern __gshared ubyte* gGfxPoolEnd;

extern __gshared GfxPool* gGfxPool;
extern __gshared ubyte gControllerBits;
extern __gshared byte gEepromProbe;

extern __gshared void function () D_8032C6A0;
extern __gshared Controller* gPlayer1Controller;
extern __gshared Controller* gPlayer2Controller;
extern __gshared Controller* gPlayer3Controller;
extern __gshared DemoInput* gCurrDemoInput;
extern __gshared ushort gDemoInputListID;
extern __gshared DemoInput gRecordedDemoInput;

// this area is the demo input + the header. when the demo is loaded in, there is a header the size
// of a single word next to the input list. this word is the current ID count.
extern __gshared MarioAnimation D_80339D10;
extern __gshared MarioAnimation gDemo;

extern __gshared ubyte[] gMarioAnims;
extern __gshared ubyte[] gDemoInputs;

extern __gshared ushort frameBufferIndex;
extern __gshared uint gGlobalTimer;

void setup_game_memory ();
void thread5_game_loop (void* arg);
void clear_frame_buffer (int color);
void clear_viewport (Vp* viewport, int color);
void make_viewport_clip_rect (Vp* viewport);
void init_render_image ();
void end_master_display_list ();
void rendering_init ();
void config_gfx_pool ();
void display_and_vsync ();

// GAME_INIT_H
