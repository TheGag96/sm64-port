module ultra64.sptask;

extern (C):

/* Task Types */
enum M_GFXTASK = 1;
enum M_AUDTASK = 2;
enum M_VIDTASK = 3;
enum M_HVQTASK = 6;
enum M_HVQMTASK = 7;

enum OS_YIELD_DATA_SIZE = 0x900;

enum OS_YIELD_AUDIO_SIZE = 0x400;

/* Flags  */
enum M_TASK_FLAG0 = 1;
enum M_TASK_FLAG1 = 2;

/* SpStatus */
enum SPSTATUS_CLEAR_HALT = 0x00000001;
enum SPSTATUS_SET_HALT = 0x00000002;
enum SPSTATUS_CLEAR_BROKE = 0x00000004;
enum SPSTATUS_CLEAR_INTR = 0x00000008;
enum SPSTATUS_SET_INTR = 0x00000010;
enum SPSTATUS_CLEAR_SSTEP = 0x00000020;
enum SPSTATUS_SET_SSTEP = 0x00000040;
enum SPSTATUS_CLEAR_INTR_ON_BREAK = 0x00000080;
enum SPSTATUS_SET_INTR_ON_BREAK = 0x00000100;
enum SPSTATUS_CLEAR_SIGNAL0 = 0x00000200;
enum SPSTATUS_SET_SIGNAL0 = 0x00000400;
enum SPSTATUS_CLEAR_SIGNAL1 = 0x00000800;
enum SPSTATUS_SET_SIGNAL1 = 0x00001000;
enum SPSTATUS_CLEAR_SIGNAL2 = 0x00002000;
enum SPSTATUS_SET_SIGNAL2 = 0x00004000;
enum SPSTATUS_CLEAR_SIGNAL3 = 0x00008000;
enum SPSTATUS_SET_SIGNAL3 = 0x00010000;
enum SPSTATUS_CLEAR_SIGNAL4 = 0x00020000;
enum SPSTATUS_SET_SIGNAL4 = 0x00040000;
enum SPSTATUS_CLEAR_SIGNAL5 = 0x00080000;
enum SPSTATUS_SET_SIGNAL5 = 0x00100000;
enum SPSTATUS_CLEAR_SIGNAL6 = 0x00200000;
enum SPSTATUS_SET_SIGNAL6 = 0x00800000;
enum SPSTATUS_CLEAR_SIGNAL7 = 0x01000000;
enum SPSTATUS_SET_SIGNAL7 = 0x02000000;

enum SPSTATUS_HALT = 0x0001;
enum SPSTATUS_BROKE = 0x0002;
enum SPSTATUS_DMA_BUSY = 0x0004;
enum SPSTATUS_DMA_FULL = 0x0008;
enum SPSTATUS_IO_FULL = 0x0010;
enum SPSTATUS_SINGLE_STEP = 0x0020;
enum SPSTATUS_INTERRUPT_ON_BREAK = 0x0040;
enum SPSTATUS_SIGNAL0_SET = 0x0080;
enum SPSTATUS_SIGNAL1_SET = 0x0100;
enum SPSTATUS_SIGNAL2_SET = 0x0200;
enum SPSTATUS_SIGNAL3_SET = 0x0400;
enum SPSTATUS_SIGNAL4_SET = 0x0800;
enum SPSTATUS_SIGNAL5_SET = 0x1000;
enum SPSTATUS_SIGNAL6_SET = 0x2000;
enum SPSTATUS_SIGNAL7_SET = 0x4000;

/* Types */
/* Types */

struct OSTask_t
{
    /*0x00*/
    uint type;
    /*0x04*/
    uint flags;

    /*0x08*/
    ulong* ucode_boot;
    /*0x0C*/
    uint ucode_boot_size;

    /*0x10*/
    ulong* ucode;
    /*0x14*/
    uint ucode_size;

    /*0x18*/
    ulong* ucode_data;
    /*0x1C*/
    uint ucode_data_size;

    /*0x20*/
    ulong* dram_stack;
    /*0x24*/
    uint dram_stack_size;

    /*0x28*/
    ulong* output_buff;
    /*0x2C*/
    ulong* output_buff_size;

    /*0x30*/
    ulong* data_ptr;
    /*0x34*/
    uint data_size;

    /*0x38*/
    ulong* yield_data_ptr;
    /*0x3C*/
    uint yield_data_size;
} // size = 0x40

union OSTask
{
    OSTask_t t;
    long force_structure_alignment;
}

alias OSYieldResult = uint;

/* Functions */

void osSpTaskLoad (OSTask* task);
void osSpTaskStartGo (OSTask* task);
void osSpTaskYield ();
OSYieldResult osSpTaskYielded (OSTask* task);

