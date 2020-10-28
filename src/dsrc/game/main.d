extern (C):

import ultra64, types;

struct RumbleData {
    u8 unk00;
    u8 unk01;
    s16 unk02;
    s16 unk04;
}

struct StructSH8031D9B0 {
    s16 unk00;
    s16 unk02;
    s16 unk04;
    s16 unk06;
    s16 unk08;
    s16 unk0A;
    s16 unk0C;
    s16 unk0E;
}

extern __gshared OSThread D_80339210;
extern __gshared OSThread gIdleThread;
extern __gshared OSThread gMainThread;
extern __gshared OSThread gGameLoopThread;
extern __gshared OSThread gSoundThread;

// Actually an OSPfs but we don't have that header yet

extern __gshared OSMesgQueue gPIMesgQueue;
extern __gshared OSMesgQueue gIntrMesgQueue;
extern __gshared OSMesgQueue gSPTaskMesgQueue;

extern __gshared OSMesg[1] gDmaMesgBuf;
extern __gshared OSMesg[32] gPIMesgBuf;
extern __gshared OSMesg[1] gSIEventMesgBuf;
extern __gshared OSMesg[16] gIntrMesgBuf;
extern __gshared OSMesg[16] gUnknownMesgBuf;
extern __gshared OSIoMesg gDmaIoMesg;
extern __gshared OSMesg D_80339BEC;
extern __gshared OSMesgQueue gDmaMesgQueue;
extern __gshared OSMesgQueue gSIEventMesgQueue;

extern __gshared VblankHandler* gVblankHandler1;
extern __gshared VblankHandler* gVblankHandler2;
extern __gshared SPTask* gActiveSPTask;
extern __gshared u32 sNumVblanks;
extern __gshared s8 gResetTimer;
extern __gshared s8 D_8032C648;
extern __gshared s8 gDebugLevelSelect;
extern __gshared s8 D_8032C650;
extern __gshared s8 gShowProfiler;
extern __gshared s8 gShowDebugText;

void set_vblank_handler (s32 index, VblankHandler* handler, OSMesgQueue* queue, OSMesg* msg);
void dispatch_audio_sptask (SPTask* spTask);
void send_display_list (SPTask* spTask);

// MAIN_H
