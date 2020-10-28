module macros;

import ultra64;

extern (C):

version (SM64_No_Segmented_Memory) {

    extern (D) uintptr_t* VIRTUAL_TO_PHYSICAL(T)(auto ref T addr) { return cast(uintptr_t*) addr; }
    extern (D) uintptr_t* PHYSICAL_TO_VIRTUAL(T)(auto ref T addr) { return cast(uintptr_t*) addr; }
    extern (D) u8* VIRTUAL_TO_PHYSICAL2(T)(auto ref T addr) { return cast(u8*) addr; }
}
else {
    // convert a virtual address to physical.
    extern (D) uintptr_t VIRTUAL_TO_PHYSICAL(T)(auto ref T addr) { return (cast(uintptr_t) addr) & 0x1FFFFFFF; }

    // convert a physical address to virtual.
    extern (D) uintptr_t PHYSICAL_TO_VIRTUAL(T)(auto ref T addr) { return (cast(uintptr_t) addr) | 0x80000000; }
    extern (D) u8* VIRTUAL_TO_PHYSICAL2(T)(auto ref T addr) { return (cast(u8*) addr) - 0x80000000U; }
}

// MACROS_H
