module ultra64.os_message;

/*====================================================================
 * os_message.h
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

import ultra64.ultratypes, ultra64.os_thread;

/*---------------------------------------------------------------------*
        Copyright (C) 1998 Nintendo. (Originated by SGI)

        $RCSfile: os_message.h,v $
        $Revision: 1.1 $
        $Date: 1998/10/09 08:01:15 $
 *---------------------------------------------------------------------*/

extern (C):

/**************************************************************************
 *
 * Type definitions
 *
 */

/*
 * Structure for message
 */
alias OSMesg = void*;

/*
 * Structure for message queue
 */
struct OSMesgQueue {
        OSThread*       mtqueue;        /* Queue to store threads blocked
                                           on empty mailboxes (receive) */
        OSThread*       fullqueue;      /* Queue to store threads blocked
                                           on full mailboxes (send) */
        s32             validCount;     /* Contains number of valid message */
        s32             first;          /* Points to first valid message */
        s32             msgCount;       /* Contains total # of messages */
        OSMesg*         msg;            /* Points to message buffer array */
};

/* Queue to store threads blocked
					   on empty mailboxes (receive) */
/* Queue to store threads blocked
					   on full mailboxes (send) */
/* Contains number of valid message */
/* Points to first valid message */
/* Contains total # of messages */
/* Points to message buffer array */

/* defined(_LANGUAGE_C) || defined(_LANGUAGE_C_PLUS_PLUS) */

/**************************************************************************
 *
 * Global definitions
 *
 */

/* Events */

enum OS_NUM_EVENTS = 23;

enum OS_EVENT_SW1 = 0; /* CPU SW1 interrupt */
enum OS_EVENT_SW2 = 1; /* CPU SW2 interrupt */
enum OS_EVENT_CART = 2; /* Cartridge interrupt: used by rmon */
enum OS_EVENT_COUNTER = 3; /* Counter int: used by VI/Timer Mgr */
enum OS_EVENT_SP = 4; /* SP task done interrupt */
enum OS_EVENT_SI = 5; /* SI (controller) interrupt */
enum OS_EVENT_AI = 6; /* AI interrupt */
enum OS_EVENT_VI = 7; /* VI interrupt: used by VI/Timer Mgr */
enum OS_EVENT_PI = 8; /* PI interrupt: used by PI Manager */
enum OS_EVENT_DP = 9; /* DP full sync interrupt */
enum OS_EVENT_CPU_BREAK = 10; /* CPU breakpoint: used by rmon */
enum OS_EVENT_SP_BREAK = 11; /* SP breakpoint:  used by rmon */
enum OS_EVENT_FAULT = 12; /* CPU fault event: used by rmon */
enum OS_EVENT_THREADSTATUS = 13; /* CPU thread status: used by rmon */
enum OS_EVENT_PRENMI = 14; /* Pre NMI interrupt */

enum OS_EVENT_RDB_READ_DONE = 15; /* RDB read ok event: used by rmon */
enum OS_EVENT_RDB_LOG_DONE = 16; /* read of log data complete */
enum OS_EVENT_RDB_DATA_DONE = 17; /* read of hostio data complete */
enum OS_EVENT_RDB_REQ_RAMROM = 18; /* host needs ramrom access */
enum OS_EVENT_RDB_FREE_RAMROM = 19; /* host is done with ramrom access */
enum OS_EVENT_RDB_DBG_DONE = 20;
enum OS_EVENT_RDB_FLUSH_PROF = 21;
enum OS_EVENT_RDB_ACK_PROF = 22;

/* Flags to turn blocking on/off when sending/receiving message */

enum OS_MESG_NOBLOCK = 0;
enum OS_MESG_BLOCK = 1;

/**************************************************************************
 *
 * Macro definitions
 *
 */

/* Get count of valid messages in queue */

/* Figure out if message queue is empty or full */

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

/* Message operations */

/* Event operations */

/* defined(_LANGUAGE_C) || defined(_LANGUAGE_C_PLUS_PLUS) */

/* !_OS_MESSAGE_H_ */
