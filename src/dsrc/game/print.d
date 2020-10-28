module game.print;

import ultra64, types;

extern (C):

enum TEXRECT_MIN_X = 10;
enum TEXRECT_MAX_X = 300;
enum TEXRECT_MIN_Y = 5;
enum TEXRECT_MAX_Y = 220;

enum GLYPH_SPACE           = -1;
enum GLYPH_U               = 30;
enum GLYPH_EXCLAMATION_PNT = 36;
enum GLYPH_TWO_EXCLAMATION = 37;
enum GLYPH_QUESTION_MARK   = 38;
enum GLYPH_AMPERSAND       = 39;
enum GLYPH_PERCENT         = 40;
enum GLYPH_MULTIPLY        = 50;
enum GLYPH_COIN            = 51;
enum GLYPH_MARIO_HEAD      = 52;
enum GLYPH_STAR            = 53;
enum GLYPH_PERIOD          = 54;
enum GLYPH_BETA_KEY        = 55;
enum GLYPH_APOSTROPHE      = 56;
enum GLYPH_DOUBLE_QUOTE    = 57;
enum GLYPH_UMLAUT          = 58;

void print_text_fmt_int (s32 x, s32 y, const(char)* str, s32 n);
void print_text (s32 x, s32 y, const(char)* str);
void print_text_centered (s32 x, s32 y, const(char)* str);
void render_text_labels ();

// PRINT_H
