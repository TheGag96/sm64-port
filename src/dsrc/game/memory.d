module game.memory;

import ultra64, types;

import core.stdc.stdint;

extern (C):

enum MEMORY_POOL_LEFT = 0;
enum MEMORY_POOL_RIGHT = 1;

struct AllocOnlyPool
{
    int totalSpace;
    int usedSpace;
    ubyte* startPtr;
    ubyte* freePtr;
}

struct MemoryPool;

// Declaring this variable extern puts it in the wrong place in the bss order
// when this file is included from memory.c (first instead of last). Hence,
// ifdef hack. It was very likely subject to bss reordering originally.
extern __gshared MemoryPool* gEffectsMemoryPool;

uintptr_t set_segment_base_addr (int segment, void* addr);
void* get_segment_base_addr (int segment);
void* segmented_to_virtual (const(void)* addr);
void* virtual_to_segmented (uint segment, const(void)* addr);
void move_segment_table_to_dmem ();

void main_pool_init (void* start, void* end);
void* main_pool_alloc (uint size, uint side);

uint main_pool_free (void* addr);
void* main_pool_realloc (void* addr, uint size);
uint main_pool_available ();
uint main_pool_push_state ();
uint main_pool_pop_state ();

void* load_segment (int segment, ubyte* srcStart, ubyte* srcEnd, uint side);
void* load_to_fixed_pool_addr (ubyte* destAddr, ubyte* srcStart, ubyte* srcEnd);
void* load_segment_decompress (int segment, ubyte* srcStart, ubyte* srcEnd);
void* load_segment_decompress_heap (uint segment, ubyte* srcStart, ubyte* srcEnd);
void load_engine_code_segment ();

AllocOnlyPool* alloc_only_pool_init (uint size, uint side);
void* alloc_only_pool_alloc (AllocOnlyPool* pool, int size);
AllocOnlyPool* alloc_only_pool_resize (AllocOnlyPool* pool, uint size);

MemoryPool* mem_pool_init (uint size, uint side);
void* mem_pool_alloc (MemoryPool* pool, uint size);
void mem_pool_free (MemoryPool* pool, void* addr);

void* alloc_display_list (uint size);
void func_80278A78 (MarioAnimation* a, void* b, Animation* target);
int load_patchable_table (MarioAnimation* a, uint b);

// MEMORY_H
