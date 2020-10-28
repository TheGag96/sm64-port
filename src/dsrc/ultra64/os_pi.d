module ultra64.os_pi;

import ultra64.ultratypes, ultra64.os_message, ultra64.os_thread;
import core.stdc.stdint;

extern (C):

/* Ultra64 Parallel Interface */

/* Types */

struct __OSBlockInfo
{
    uint errStatus;

    void* dramAddr;
    void* C2Addr;
    uint sectorSize;
    uint C1ErrNum;
    uint[4] C1ErrSector;
}

struct __OSTranxInfo
{
    uint cmdType; // 0
    ushort transferMode; // 4
    ushort blockNum; // 6
    int sectorNum; // 8
    uintptr_t devAddr; // c

    //error status added moved to blockinfo

    uint bmCtlShadow; // 10
    uint seqCtlShadow; // 14
    __OSBlockInfo[2] block; // 18
}

struct OSPiHandle_s
{
    OSPiHandle_s* next;
    ubyte type;
    ubyte latency;
    ubyte pageSize;
    ubyte relDuration;
    ubyte pulse;
    ubyte domain;
    uint baseAddress;
    uint speed;
    __OSTranxInfo transferInfo;
}

alias OSPiHandle = OSPiHandle_s;

struct OSPiInfo
{
    ubyte type;
    uintptr_t address;
}

struct OSIoMesgHdr
{
    ushort type;
    ubyte pri;
    ubyte status;
    OSMesgQueue* retQueue;
}

struct OSIoMesg
{
    /*0x00*/
    OSIoMesgHdr hdr;
    /*0x08*/
    void* dramAddr;
    /*0x0C*/
    uintptr_t devAddr;
    /*0x10*/
    size_t size;

    // from the official definition
}

/* Definitions */

enum OS_READ = 0; // device -> RDRAM
enum OS_WRITE = 1; // device <- RDRAM

enum OS_MESG_PRI_NORMAL = 0;
enum OS_MESG_PRI_HIGH = 1;

/* Functions */

int osPiStartDma (
    OSIoMesg* mb,
    int priority,
    int direction,
    uintptr_t devAddr,
    void* vAddr,
    size_t nbytes,
    OSMesgQueue* mq);
void osCreatePiManager (OSPri pri, OSMesgQueue* cmdQ, OSMesg* cmdBuf, int cmdMsgCnt);
OSMesgQueue* osPiGetCmdQueue ();
int osPiWriteIo (uintptr_t devAddr, uint data);
int osPiReadIo (uintptr_t devAddr, uint* data);

int osPiRawStartDma (int dir, uint cart_addr, void* dram_addr, size_t size);
int osEPiRawStartDma (OSPiHandle* piHandle, int dir, uint cart_addr, void* dram_addr, size_t size);
