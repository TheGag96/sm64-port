module util;

version(linux) extern(C) __gshared void _d_dso_registry() {}

mixin template importEnumMembers(T) {
  static foreach (member; __traits(allMembers, T)) {
    mixin("T " ~ member ~ " = T. " ~ member ~ ";");
  }
}