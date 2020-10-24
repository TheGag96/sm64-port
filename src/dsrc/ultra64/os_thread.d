module ultra64.os_thread;

import ultra64.ultratypes;

extern (C):

/* Recommended priorities for system threads */
enum OS_PRIORITY_MAX = 255;
enum OS_PRIORITY_VIMGR = 254;
enum OS_PRIORITY_RMON = 250;
enum OS_PRIORITY_RMONSPIN = 200;
enum OS_PRIORITY_PIMGR = 150;
enum OS_PRIORITY_SIMGR = 140;
enum OS_PRIORITY_APPMAX = 127;
enum OS_PRIORITY_IDLE = 0;

enum OS_STATE_STOPPED = 1;
enum OS_STATE_RUNNABLE = 2;
enum OS_STATE_RUNNING = 4;
enum OS_STATE_WAITING = 8;

/* Types */

alias OSPri = int;
alias OSId = int;

union __OSfp
{
    struct _Anonymous_0
    {
        f32 f_odd;
        f32 f_even;
    }

    _Anonymous_0 f;
}

struct __OSThreadContext
{
    /* registers */
    /*0x20*/
    ulong at;
    ulong v0;
    ulong v1;
    ulong a0;
    ulong a1;
    ulong a2;
    ulong a3;
    /*0x58*/
    ulong t0;
    ulong t1;
    ulong t2;
    ulong t3;
    ulong t4;
    ulong t5;
    ulong t6;
    ulong t7;
    /*0x98*/
    ulong s0;
    ulong s1;
    ulong s2;
    ulong s3;
    ulong s4;
    ulong s5;
    ulong s6;
    ulong s7;
    /*0xD8*/
    ulong t8;
    ulong t9;
    ulong gp;
    ulong sp;
    ulong s8;
    ulong ra;
    /*0x108*/
    ulong lo;
    ulong hi;
    /*0x118*/
    uint sr;
    uint pc;
    uint cause;
    uint badvaddr;
    uint rcp;
    /*0x12C*/
    uint fpcsr;
    __OSfp fp0;
    __OSfp fp2;
    __OSfp fp4;
    __OSfp fp6;
    __OSfp fp8;
    __OSfp fp10;
    __OSfp fp12;
    __OSfp fp14;
    __OSfp fp16;
    __OSfp fp18;
    __OSfp fp20;
    __OSfp fp22;
    __OSfp fp24;
    __OSfp fp26;
    __OSfp fp28;
    __OSfp fp30;
}

struct __OSThreadprofile_s
{
    uint flag;
    uint count;
    ulong time;
}

struct OSThread_s
{
    /*0x00*/
    OSThread_s* next;
    /*0x04*/
    OSPri priority;
    /*0x08*/
    OSThread_s** queue;
    /*0x0C*/
    OSThread_s* tlnext;
    /*0x10*/
    ushort state;
    /*0x12*/
    ushort flags;
    /*0x14*/
    OSId id;
    /*0x18*/
    int fp;
    /*0x1C*/
    __OSThreadprofile_s* thprof;
    /*0x20*/
    __OSThreadContext context;
}

alias OSThread = OSThread_s;

/* Functions */

void osCreateThread (
    OSThread* thread,
    OSId id,
    void function (void*) entry,
    void* arg,
    void* sp,
    OSPri pri);
OSId osGetThreadId (OSThread* thread);
OSPri osGetThreadPri (OSThread* thread);
void osSetThreadPri (OSThread* thread, OSPri pri);
void osStartThread (OSThread* thread);
void osStopThread (OSThread* thread);

