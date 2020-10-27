module util;

version(linux) extern(C) __gshared void _d_dso_registry() {}

mixin template importEnumMembers(T) {
    static foreach (member; __traits(allMembers, T)) {
        mixin("enum T " ~ member ~ " = T. " ~ member ~ ";");
    }
}

mixin template externCArray(T, string name) {
    mixin("pragma(mangle, name) extern(C) extern __gshared T " ~ name ~ "_base;");
    mixin("extern(D) T* " ~ name ~ " = &" ~ name ~ "_base;");
}

struct Version {
    template opDispatch(string name) {
        mixin("version ("~ name ~") enum opDispatch = true; else enum opDispatch = false;");
    }
}