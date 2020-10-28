module mbi;

extern (C):

/**************************************************************************
 *									  *
 *		 Copyright (C) 1994, Silicon Graphics, Inc.		  *
 *									  *
 *  These coded instructions, statements, and computer programs  contain  *
 *  unpublished  proprietary  information of Silicon Graphics, Inc., and  *
 *  are protected by Federal copyright law.  They  may  not be disclosed  *
 *  to  third  parties  or copied or duplicated in any form, in whole or  *
 *  in part, without the prior written consent of Silicon Graphics, Inc.  *
 *									  *
 **************************************************************************/

/**************************************************************************
 *
 *  $Revision: 1.136 $
 *  $Date: 1999/01/05 13:04:00 $
 *  $Source: /hosts/gate3/exdisk2/cvs/N64OS/Master/cvsmdev2/PR/include/mbi.h,v $
 *
 **************************************************************************/

/*
 * Header file for the Media Binary Interface
 *
 * NOTE: This file is included by the RSP microcode, so any C-specific
 * constructs must be bracketed by #ifdef _LANGUAGE_C
 *
 */

/*
 * the SHIFT macros are used to build display list commands, inserting
 * bit-fields into a 32-bit word. They take a value, a shift amount,
 * and a width.
 *
 * For the left shift, the lower bits of the value are masked,
 * then shifted left.
 *
 * For the right shift, the value is shifted right, then the lower bits
 * are masked.
 *
 * (NOTE: _SHIFTL(v, 0, 32) won't work, just use an assignment)
 *
 */
extern (D) auto _SHIFTL(T0, T1, T2)(auto ref T0 v, auto ref T1 s, auto ref T2 w)
{
    return cast(uint) (cast(uint) v & ((0x01 << w) - 1)) << s;
}

extern (D) auto _SHIFTR(T0, T1, T2)(auto ref T0 v, auto ref T1 s, auto ref T2 w)
{
    return cast(uint) (cast(uint) v >> s) & ((0x01 << w) - 1);
}

alias _SHIFT = _SHIFTL; /* old, for compatibility only */

enum G_ON = 1;
enum G_OFF = 0;

/**************************************************************************
 *
 * Graphics Binary Interface
 *
 **************************************************************************/

/**************************************************************************
 *
 * Audio Binary Interface
 *
 **************************************************************************/

/**************************************************************************
 *
 * Task list
 *
 **************************************************************************/

enum M_GFXTASK = 1;
enum M_AUDTASK = 2;
enum M_VIDTASK = 3;
enum M_HVQTASK = 6;
enum M_HVQMTASK = 7;

/**************************************************************************
 *
 * Segment macros and definitions
 *
 **************************************************************************/

enum NUM_SEGMENTS = 16;

extern (D) auto SEGMENT_OFFSET(T)(auto ref T a)
{
    return cast(uint) a & 0x00ffffff;
}

extern (D) auto SEGMENT_NUMBER(T)(auto ref T a)
{
    return (cast(uint) a << 4) >> 28;
}

extern (D) auto SEGMENT_ADDR(T0, T1)(auto ref T0 num, auto ref T1 off)
{
    return (num << 24) + off;
}

/* !_MBI_H_ */
