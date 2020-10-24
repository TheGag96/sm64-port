module ultra64.os_cont;

/*====================================================================
 * os_cont.h
 *
 * Copyright 1995, Silicon Graphics, Inc.
 * All Rights Reserved.
 *
 * This is UNPUBLISHED PROPRIETARY SOURCE CODE of Silicon Graphics,
 * Inc.; the contents of this file may not be disclosed to third
 * parties, copied or duplicated in any form, in whole or in part,
 * without the prior written permission of Silicon Graphics, Inc.
 *
 * RESTRICTED RIGHTS LEGEND:
 * Use, duplication or disclosure by the Government is subject to
 * restrictions as set forth in subdivision (c)(1)(ii) of the Rights
 * in Technical Data and Computer Software clause at DFARS
 * 252.227-7013, and/or in similar or successor clauses in the FAR,
 * DOD or NASA FAR Supplement. Unpublished - rights reserved under the
 * Copyright Laws of the United States.
 *====================================================================*/

import ultra64.ultratypes, ultra64.os_message;

/*---------------------------------------------------------------------*
        Copyright (C) 1998 Nintendo. (Originated by SGI)

        $RCSfile: os_cont.h,v $
        $Revision: 1.1 $
        $Date: 1998/10/09 08:01:05 $
 *---------------------------------------------------------------------*/

extern (C):

/**************************************************************************
 *
 * Type definitions
 *
 */

/*
 * Structure for controllers
 */

struct OSContStatus {
        u16     type;                   /* Controller Type */
        u8      status;                 /* Controller status */
        u8      errnum;
}

struct OSContPad {
        u16     button;
        s8      stick_x;                /* -80 <= stick_x <= 80 */
        s8      stick_y;                /* -80 <= stick_y <= 80 */
        u8      errnum;
};

struct OSContRamIo {
        void*   address;                /* Ram pad Address:  11 bits */
        u8[32]  databuffer;             /* address of the data buffer */
        u8      addressCrc;             /* CRC code for address */
        u8      dataCrc;                /* CRC code for data */
        u8      errnum;
};

/* Controller Type */
/* Controller status */

/* -80 <= stick_x <= 80 */
/* -80 <= stick_y <= 80 */

/* Ram pad Address:  11 bits */
/* address of the data buffer */
/* CRC code for address */
/* CRC code for data */

/* defined(_LANGUAGE_C) || defined(_LANGUAGE_C_PLUS_PLUS) */

/**************************************************************************
 *
 * Global definitions
 *
 */

/*
 *  Controllers  number
 */

enum MAXCONTROLLERS = 4;

/* controller errors */
enum CONT_NO_RESPONSE_ERROR = 0x8;
enum CONT_OVERRUN_ERROR = 0x4;

/* Controller type */

enum CONT_ABSOLUTE = 0x0001;
enum CONT_RELATIVE = 0x0002;
enum CONT_JOYPORT = 0x0004;
enum CONT_EEPROM = 0x8000;
enum CONT_EEP16K = 0x4000;
enum CONT_TYPE_MASK = 0x1f07;
enum CONT_TYPE_NORMAL = 0x0005;
enum CONT_TYPE_MOUSE = 0x0002;
enum CONT_TYPE_VOICE = 0x0100;

/* Controller status */

enum CONT_CARD_ON = 0x01;
enum CONT_CARD_PULL = 0x02;
enum CONT_ADDR_CRC_ER = 0x04;
enum CONT_EEPROM_BUSY = 0x80;

/* Buttons */

enum CONT_A = 0x8000;
enum CONT_B = 0x4000;
enum CONT_G = 0x2000;
enum CONT_START = 0x1000;
enum CONT_UP = 0x0800;
enum CONT_DOWN = 0x0400;
enum CONT_LEFT = 0x0200;
enum CONT_RIGHT = 0x0100;
enum CONT_L = 0x0020;
enum CONT_R = 0x0010;
enum CONT_E = 0x0008;
enum CONT_D = 0x0004;
enum CONT_C = 0x0002;
enum CONT_F = 0x0001;

/* Nintendo's official button names */

enum A_BUTTON = CONT_A;
enum B_BUTTON = CONT_B;
enum L_TRIG = CONT_L;
enum R_TRIG = CONT_R;
enum Z_TRIG = CONT_G;
enum START_BUTTON = CONT_START;
enum U_JPAD = CONT_UP;
enum L_JPAD = CONT_LEFT;
enum R_JPAD = CONT_RIGHT;
enum D_JPAD = CONT_DOWN;
enum U_CBUTTONS = CONT_E;
enum L_CBUTTONS = CONT_C;
enum R_CBUTTONS = CONT_F;
enum D_CBUTTONS = CONT_D;

/* Controller error number */

enum PFS_ERR_NOPACK = 1;
enum PFS_ERR_INVALID = 5;
enum PFS_ERR_DEVICE = 11;

enum CONT_ERR_NO_CONTROLLER = PFS_ERR_NOPACK; /* 1 */
enum CONT_ERR_CONTRFAIL = CONT_OVERRUN_ERROR; /* 4 */
enum CONT_ERR_INVALID = PFS_ERR_INVALID; /* 5 */
enum CONT_ERR_DEVICE = PFS_ERR_DEVICE; /* 11 */
enum CONT_ERR_NOT_READY = 12;
enum CONT_ERR_VOICE_MEMORY = 13;
enum CONT_ERR_VOICE_WORD = 14;
enum CONT_ERR_VOICE_NO_RESPONSE = 15;

/**************************************************************************
 *
 * Macro definitions
 *
 */

/**************************************************************************
 *
 * Extern variables
 *
 */

/**************************************************************************
 *
 * Function prototypes
 *
 */

/* Controller interface */

extern s32              osContInit(OSMesgQueue *, u8 *, OSContStatus *);
extern s32              osContReset(OSMesgQueue *, OSContStatus *);
extern s32              osContStartQuery(OSMesgQueue *);
extern s32              osContStartReadData(OSMesgQueue *);
//#ifndef _HW_VERSION_1
extern s32              osContSetCh(u8);
//#endif
extern void             osContGetQuery(OSContStatus *);
extern void             osContGetReadData(OSContPad *);