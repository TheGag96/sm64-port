module object_fields;

import types;

extern (D):

/**
 * The array [0x88, 0x1C8) in struct Object consists of fields that can vary by
 * object type. These macros provide access to these fields.
 */

ref auto OBJECT_FIELD_U32           (Object_ * obj, size_t index)                  { return obj.rawData.asU32[index]; }
ref auto OBJECT_FIELD_S32           (Object_ * obj, size_t index)                  { return obj.rawData.asS32[index]; }
ref auto OBJECT_FIELD_S16           (Object_ * obj, size_t index, size_t subIndex) { return obj.rawData.asS16[index][subIndex]; }
ref auto OBJECT_FIELD_F32           (Object_ * obj, size_t index)                  { return obj.rawData.asF32[index]; }

static if (size_t.sizeof == 8) {
    ref auto OBJECT_FIELD_S16P          (Object_ * obj, size_t index) { return obj.ptrData.asS16P[index]; }
    ref auto OBJECT_FIELD_S32P          (Object_ * obj, size_t index) { return obj.ptrData.asS32P[index]; }
    ref auto OBJECT_FIELD_ANIMS         (Object_ * obj, size_t index) { return obj.ptrData.asAnims[index]; }
    ref auto OBJECT_FIELD_WAYPOINT      (Object_ * obj, size_t index) { return obj.ptrData.asWaypoint[index]; }
    ref auto OBJECT_FIELD_CHAIN_SEGMENT (Object_ * obj, size_t index) { return obj.ptrData.asChainSegment[index]; }
    ref auto OBJECT_FIELD_OBJ           (Object_ * obj, size_t index) { return obj.ptrData.asObject[index]; }
    ref auto OBJECT_FIELD_SURFACE       (Object_ * obj, size_t index) { return obj.ptrData.asSurface[index]; }
    ref auto OBJECT_FIELD_VPTR          (Object_ * obj, size_t index) { return obj.ptrData.asVoidPtr[index]; }
    ref auto OBJECT_FIELD_CVPTR         (Object_ * obj, size_t index) { return obj.ptrData.asConstVoidPtr[index]; }
}
else {
    ref auto OBJECT_FIELD_S16P          (Object_ * obj, size_t index) { return obj.rawData.asS16P[index]; }
    ref auto OBJECT_FIELD_S32P          (Object_ * obj, size_t index) { return obj.rawData.asS32P[index]; }
    ref auto OBJECT_FIELD_ANIMS         (Object_ * obj, size_t index) { return obj.rawData.asAnims[index]; }
    ref auto OBJECT_FIELD_WAYPOINT      (Object_ * obj, size_t index) { return obj.rawData.asWaypoint[index]; }
    ref auto OBJECT_FIELD_CHAIN_SEGMENT (Object_ * obj, size_t index) { return obj.rawData.asChainSegment[index]; }
    ref auto OBJECT_FIELD_OBJ           (Object_ * obj, size_t index) { return obj.rawData.asObject[index]; }
    ref auto OBJECT_FIELD_SURFACE       (Object_ * obj, size_t index) { return obj.rawData.asSurface[index]; }
    ref auto OBJECT_FIELD_VPTR          (Object_ * obj, size_t index) { return obj.rawData.asVoidPtr[index]; }
    ref auto OBJECT_FIELD_CVPTR         (Object_ * obj, size_t index) { return obj.rawData.asConstVoidPtr[index]; }
}

// 0x088 (0x00), the first field, is object-specific and defined below the common fields.
/* Common fields */
/*0x08C*/
ref auto oFlags(Object_* obj) { return obj.OBJECT_FIELD_U32(0x01); }
/*0x090*/
ref auto oDialogResponse(Object_* obj) { return obj.OBJECT_FIELD_S16(0x02, 0); }
/*0x092*/
ref auto oDialogState(Object_* obj) { return obj.OBJECT_FIELD_S16(0x02, 1); }
/*0x094*/
ref auto oUnk94(Object_* obj) { return obj.OBJECT_FIELD_U32(0x03); }
// 0x98 unused/removed.
/*0x09C*/
ref auto oIntangibleTimer(Object_* obj) { return obj.OBJECT_FIELD_S32(0x05); }
/*0x0A0*/
enum O_POS_INDEX = 0x06;
/*0x0A0*/
ref auto oPosX(Object_* obj) { return obj.OBJECT_FIELD_F32(O_POS_INDEX + 0); }
/*0x0A4*/
ref auto oPosY(Object_* obj) { return obj.OBJECT_FIELD_F32(O_POS_INDEX + 1); }
/*0x0A8*/
ref auto oPosZ(Object_* obj) { return obj.OBJECT_FIELD_F32(O_POS_INDEX + 2); }
/*0x0AC*/
ref auto oVelX(Object_* obj) { return obj.OBJECT_FIELD_F32(0x09); }
/*0x0B0*/
ref auto oVelY(Object_* obj) { return obj.OBJECT_FIELD_F32(0x0A); }
/*0x0B4*/
ref auto oVelZ(Object_* obj) { return obj.OBJECT_FIELD_F32(0x0B); }
/*0x0B8*/
ref auto oForwardVel(Object_* obj) { return obj.OBJECT_FIELD_F32(0x0C); }
/*0x0B8*/
ref auto oForwardVelS32(Object_* obj) { return obj.OBJECT_FIELD_S32(0x0C); }
/*0x0BC*/
ref auto oUnkBC(Object_* obj) { return obj.OBJECT_FIELD_F32(0x0D); }
/*0x0C0*/
ref auto oUnkC0(Object_* obj) { return obj.OBJECT_FIELD_F32(0x0E); }
/*0x0C4*/
enum O_MOVE_ANGLE_INDEX = 0x0F;
/*0x0C4*/
enum O_MOVE_ANGLE_PITCH_INDEX = O_MOVE_ANGLE_INDEX + 0;
/*0x0C4*/
enum O_MOVE_ANGLE_YAW_INDEX = O_MOVE_ANGLE_INDEX + 1;
/*0x0C4*/
enum O_MOVE_ANGLE_ROLL_INDEX = O_MOVE_ANGLE_INDEX + 2;
/*0x0C4*/
ref auto oMoveAnglePitch(Object_* obj) { return obj.OBJECT_FIELD_S32(O_MOVE_ANGLE_PITCH_INDEX); }
/*0x0C8*/
ref auto oMoveAngleYaw(Object_* obj) { return obj.OBJECT_FIELD_S32(O_MOVE_ANGLE_YAW_INDEX); }
/*0x0CC*/
ref auto oMoveAngleRoll(Object_* obj) { return obj.OBJECT_FIELD_S32(O_MOVE_ANGLE_ROLL_INDEX); }
/*0x0D0*/
enum O_FACE_ANGLE_INDEX = 0x12;
/*0x0D0*/
enum O_FACE_ANGLE_PITCH_INDEX = O_FACE_ANGLE_INDEX + 0;
/*0x0D0*/
enum O_FACE_ANGLE_YAW_INDEX = O_FACE_ANGLE_INDEX + 1;
/*0x0D0*/
enum O_FACE_ANGLE_ROLL_INDEX = O_FACE_ANGLE_INDEX + 2;
/*0x0D0*/
ref auto oFaceAnglePitch(Object_* obj) { return obj.OBJECT_FIELD_S32(O_FACE_ANGLE_PITCH_INDEX); }
/*0x0D4*/
ref auto oFaceAngleYaw(Object_* obj) { return obj.OBJECT_FIELD_S32(O_FACE_ANGLE_YAW_INDEX); }
/*0x0D8*/
ref auto oFaceAngleRoll(Object_* obj) { return obj.OBJECT_FIELD_S32(O_FACE_ANGLE_ROLL_INDEX); }
/*0x0DC*/
ref auto oGraphYOffset(Object_* obj) { return obj.OBJECT_FIELD_F32(0x15); }
/*0x0E0*/
ref auto oActiveParticleFlags(Object_* obj) { return obj.OBJECT_FIELD_U32(0x16); }
/*0x0E4*/
ref auto oGravity(Object_* obj) { return obj.OBJECT_FIELD_F32(0x17); }
/*0x0E8*/
ref auto oFloorHeight(Object_* obj) { return obj.OBJECT_FIELD_F32(0x18); }
/*0x0EC*/
ref auto oMoveFlags(Object_* obj) { return obj.OBJECT_FIELD_U32(0x19); }
/*0x0F0*/
ref auto oAnimState(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1A); }
// 0x0F4-0x110 (0x1B-0x22) are object specific and defined below the common fields.
/*0x114*/
ref auto oAngleVelPitch(Object_* obj) { return obj.OBJECT_FIELD_S32(0x23); }
/*0x118*/
ref auto oAngleVelYaw(Object_* obj) { return obj.OBJECT_FIELD_S32(0x24); }
/*0x11C*/
ref auto oAngleVelRoll(Object_* obj) { return obj.OBJECT_FIELD_S32(0x25); }
/*0x120*/
ref auto oAnimations(Object_* obj) { return obj.OBJECT_FIELD_ANIMS(0x26); }
/*0x124*/
ref auto oHeldState(Object_* obj) { return obj.OBJECT_FIELD_U32(0x27); }
/*0x128*/
ref auto oWallHitboxRadius(Object_* obj) { return obj.OBJECT_FIELD_F32(0x28); }
/*0x12C*/
ref auto oDragStrength(Object_* obj) { return obj.OBJECT_FIELD_F32(0x29); }
/*0x130*/
ref auto oInteractType(Object_* obj) { return obj.OBJECT_FIELD_U32(0x2A); }
/*0x134*/
ref auto oInteractStatus(Object_* obj) { return obj.OBJECT_FIELD_S32(0x2B); }
/*0x138*/
enum O_PARENT_RELATIVE_POS_INDEX = 0x2C;
/*0x138*/
ref auto oParentRelativePosX(Object_* obj) { return obj.OBJECT_FIELD_F32(O_PARENT_RELATIVE_POS_INDEX + 0); }
/*0x13C*/
ref auto oParentRelativePosY(Object_* obj) { return obj.OBJECT_FIELD_F32(O_PARENT_RELATIVE_POS_INDEX + 1); }
/*0x140*/
ref auto oParentRelativePosZ(Object_* obj) { return obj.OBJECT_FIELD_F32(O_PARENT_RELATIVE_POS_INDEX + 2); }
/*0x144*/
ref auto oBehParams2ndByte(Object_* obj) { return obj.OBJECT_FIELD_S32(0x2F); }
// 0x148 unused, possibly a third param byte.
/*0x14C*/
ref auto oAction(Object_* obj) { return obj.OBJECT_FIELD_S32(0x31); }
/*0x150*/
ref auto oSubAction(Object_* obj) { return obj.OBJECT_FIELD_S32(0x32); }
/*0x154*/
ref auto oTimer(Object_* obj) { return obj.OBJECT_FIELD_S32(0x33); }
/*0x158*/
ref auto oBounciness(Object_* obj) { return obj.OBJECT_FIELD_F32(0x34); }
/*0x15C*/
ref auto oDistanceToMario(Object_* obj) { return obj.OBJECT_FIELD_F32(0x35); }
/*0x160*/
ref auto oAngleToMario(Object_* obj) { return obj.OBJECT_FIELD_S32(0x36); }
/*0x164*/
ref auto oHomeX(Object_* obj) { return obj.OBJECT_FIELD_F32(0x37); }
/*0x168*/
ref auto oHomeY(Object_* obj) { return obj.OBJECT_FIELD_F32(0x38); }
/*0x16C*/
ref auto oHomeZ(Object_* obj) { return obj.OBJECT_FIELD_F32(0x39); }
/*0x170*/
ref auto oFriction(Object_* obj) { return obj.OBJECT_FIELD_F32(0x3A); }
/*0x174*/
ref auto oBuoyancy(Object_* obj) { return obj.OBJECT_FIELD_F32(0x3B); }
/*0x178*/
ref auto oSoundStateID(Object_* obj) { return obj.OBJECT_FIELD_S32(0x3C); }
/*0x17C*/
ref auto oOpacity(Object_* obj) { return obj.OBJECT_FIELD_S32(0x3D); }
/*0x180*/
ref auto oDamageOrCoinValue(Object_* obj) { return obj.OBJECT_FIELD_S32(0x3E); }
/*0x184*/
ref auto oHealth(Object_* obj) { return obj.OBJECT_FIELD_S32(0x3F); }
/*0x188*/
ref auto oBehParams(Object_* obj) { return obj.OBJECT_FIELD_S32(0x40); }
/*0x18C*/
ref auto oPrevAction(Object_* obj) { return obj.OBJECT_FIELD_S32(0x41); }
/*0x190*/
ref auto oInteractionSubtype(Object_* obj) { return obj.OBJECT_FIELD_U32(0x42); }
/*0x194*/
ref auto oCollisionDistance(Object_* obj) { return obj.OBJECT_FIELD_F32(0x43); }
/*0x198*/
ref auto oNumLootCoins(Object_* obj) { return obj.OBJECT_FIELD_S32(0x44); }
/*0x19C*/
ref auto oDrawingDistance(Object_* obj) { return obj.OBJECT_FIELD_F32(0x45); }
/*0x1A0*/
ref auto oRoom(Object_* obj) { return obj.OBJECT_FIELD_S32(0x46); }
// 0x1A4 is unused, possibly related to 0x1A8 in removed macro purposes.
/*0x1A8*/
ref auto oUnk1A8(Object_* obj) { return obj.OBJECT_FIELD_U32(0x48); }
// 0x1AC-0x1B2 (0x48-0x4A) are object specific and defined below the common fields.
/*0x1B4*/
ref auto oWallAngle(Object_* obj) { return obj.OBJECT_FIELD_S32(0x4B); }
/*0x1B8*/
ref auto oFloorType(Object_* obj) { return obj.OBJECT_FIELD_S16(0x4C, 0); }
/*0x1BA*/
ref auto oFloorRoom(Object_* obj) { return obj.OBJECT_FIELD_S16(0x4C, 1); }
/*0x1BC*/
ref auto oAngleToHome(Object_* obj) { return obj.OBJECT_FIELD_S32(0x4D); }
/*0x1C0*/
ref auto oFloor(Object_* obj) { return obj.OBJECT_FIELD_SURFACE(0x4E); }
/*0x1C4*/
ref auto oDeathSound(Object_* obj) { return obj.OBJECT_FIELD_S32(0x4F); }

/* Pathed (see obj_follow_path) */
/*0x0FC*/
ref auto oPathedStartWaypoint(Object_* obj) { return obj.OBJECT_FIELD_WAYPOINT(0x1D); }
/*0x100*/
ref auto oPathedPrevWaypoint(Object_* obj) { return obj.OBJECT_FIELD_WAYPOINT(0x1E); }
/*0x104*/
ref auto oPathedPrevWaypointFlags(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1F); }
/*0x108*/
ref auto oPathedTargetPitch(Object_* obj) { return obj.OBJECT_FIELD_S32(0x20); }
/*0x10C*/
ref auto oPathedTargetYaw(Object_* obj) { return obj.OBJECT_FIELD_S32(0x21); }

/* Special Object Macro */
/*0x108*/
ref auto oMacroUnk108(Object_* obj) { return obj.OBJECT_FIELD_F32(0x20); }
/*0x10C*/
ref auto oMacroUnk10C(Object_* obj) { return obj.OBJECT_FIELD_F32(0x21); }
/*0x110*/
ref auto oMacroUnk110(Object_* obj) { return obj.OBJECT_FIELD_F32(0x22); }

/* Mario */
/*0x0F4*/
ref auto oMarioParticleFlags(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x108*/
ref auto oMarioPoleUnk108(Object_* obj) { return obj.OBJECT_FIELD_S32(0x20); }
/*0x108*/
ref auto oMarioReadingSignDYaw(Object_* obj) { return obj.OBJECT_FIELD_S32(0x20); }
/*0x10C*/
ref auto oMarioPoleYawVel(Object_* obj) { return obj.OBJECT_FIELD_S32(0x21); }
/*0x10C*/
ref auto oMarioCannonObjectYaw(Object_* obj) { return obj.OBJECT_FIELD_S32(0x21); }
/*0x10C*/
ref auto oMarioTornadoYawVel(Object_* obj) { return obj.OBJECT_FIELD_S32(0x21); }
/*0x10C*/
ref auto oMarioReadingSignDPosX(Object_* obj) { return obj.OBJECT_FIELD_F32(0x21); }
/*0x110*/
ref auto oMarioPolePos(Object_* obj) { return obj.OBJECT_FIELD_F32(0x22); }
/*0x110*/
ref auto oMarioCannonInputYaw(Object_* obj) { return obj.OBJECT_FIELD_S32(0x22); }
/*0x110*/
ref auto oMarioTornadoPosY(Object_* obj) { return obj.OBJECT_FIELD_F32(0x22); }
/*0x110*/
ref auto oMarioReadingSignDPosZ(Object_* obj) { return obj.OBJECT_FIELD_F32(0x22); }
/*0x110*/
ref auto oMarioWhirlpoolPosY(Object_* obj) { return obj.OBJECT_FIELD_F32(0x22); }
/*0x110*/
ref auto oMarioBurnTimer(Object_* obj) { return obj.OBJECT_FIELD_S32(0x22); }
/*0x110*/
ref auto oMarioLongJumpIsSlow(Object_* obj) { return obj.OBJECT_FIELD_S32(0x22); }
/*0x110*/
ref auto oMarioSteepJumpYaw(Object_* obj) { return obj.OBJECT_FIELD_S32(0x22); }
/*0x110*/
ref auto oMarioWalkingPitch(Object_* obj) { return obj.OBJECT_FIELD_S32(0x22); }

/* 1-Up Hidden */
/*0x0F4*/
ref auto o1UpHiddenUnkF4(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }

/* Activated Back and Forth Platform */
/*0x0F4*/
ref auto oActivatedBackAndForthPlatformMaxOffset(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }
/*0x0F8*/
ref auto oActivatedBackAndForthPlatformOffset(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }
/*0x0FC*/
ref auto oActivatedBackAndForthPlatformVel(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1D); }
/*0x100*/
ref auto oActivatedBackAndForthPlatformCountdown(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1E); }
/*0x104*/
ref auto oActivatedBackAndForthPlatformStartYaw(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1F); }
/*0x108*/
ref auto oActivatedBackAndForthPlatformVertical(Object_* obj) { return obj.OBJECT_FIELD_S32(0x20); }
/*0x10C*/
ref auto oActivatedBackAndForthPlatformFlipRotation(Object_* obj) { return obj.OBJECT_FIELD_S32(0x21); }

/* Amp */
/*0x0F4*/
ref auto oAmpRadiusOfRotation(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }
/*0x0F8*/
ref auto oAmpYPhase(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }

/* Homing Amp */
/*0x0F4*/
ref auto oHomingAmpLockedOn(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0FC*/
ref auto oHomingAmpAvgY(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1D); }

/* Arrow Lift */
/*0x0F4*/
ref auto oArrowLiftDisplacement(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }
/*0x100*/
ref auto oArrowLiftUnk100(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1E); }

/* Back-and-Forth Platform */
/*0x0F4*/
ref auto oBackAndForthPlatformUnkF4(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }
/*0x0F8*/
ref auto oBackAndForthPlatformUnkF8(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }
/*0x0FC*/
ref auto oBackAndForthPlatformUnkFC(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1D); }
/*0x100*/
ref auto oBackAndForthPlatformUnk100(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1E); }

/* Bird */
/*0x0F4*/
ref auto oBirdSpeed(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }
/*0x0F8*/
ref auto oBirdTargetPitch(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x0FC*/
ref auto oBirdTargetYaw(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }

/* Bird Chirp Chirp */
/*0x0F4*/
ref auto oBirdChirpChirpUnkF4(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }

/* End Birds */
/*0x104*/
ref auto oEndBirdUnk104(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1F); }

/* Hidden Blue Coin */
/*0x0F8*/
ref auto oHiddenBlueCoinSwitch(Object_* obj) { return obj.OBJECT_FIELD_OBJ(0x1C); }

/* Bob-omb */
/*0x0F4*/
ref auto oBobombBlinkTimer(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oBobombFuseLit(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x0FC*/
ref auto oBobombFuseTimer(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }

/* Bob-omb Buddy */
/*0x0F4*/
ref auto oBobombBuddyBlinkTimer(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oBobombBuddyHasTalkedToMario(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x0FC*/
ref auto oBobombBuddyRole(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }
/*0x100*/
ref auto oBobombBuddyCannonStatus(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1E); }
/*0x108*/
ref auto oBobombBuddyPosXCopy(Object_* obj) { return obj.OBJECT_FIELD_F32(0x20); }
/*0x10C*/
ref auto oBobombBuddyPosYCopy(Object_* obj) { return obj.OBJECT_FIELD_F32(0x21); }
/*0x110*/
ref auto oBobombBuddyPosZCopy(Object_* obj) { return obj.OBJECT_FIELD_F32(0x22); }

/* Bob-omb Explosion Bubble */
/*0x0FC*/
ref auto oBobombExpBubGfxScaleFacX(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }
/*0x100*/
ref auto oBobombExpBubGfxScaleFacY(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1E); }
/*0x104*/
ref auto oBobombExpBubGfxExpRateX(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1F); }
/*0x108*/
ref auto oBobombExpBubGfxExpRateY(Object_* obj) { return obj.OBJECT_FIELD_S32(0x20); }

/* Bomp (Small) */
/*0x100*/
ref auto oSmallBompInitX(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1E); }

/* Boo */
/*0x088*/
ref auto oBooDeathStatus(Object_* obj) { return obj.OBJECT_FIELD_S32(0x00); }
/*0x0F4*/
ref auto oBooTargetOpacity(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oBooBaseScale(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }
/*0x0FC*/
ref auto oBooOscillationTimer(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }
/*0x100*/
ref auto oBooMoveYawDuringHit(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1E); }
/*0x104*/
ref auto oBooMoveYawBeforeHit(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1F); }
/*0x108*/
ref auto oBooParentBigBoo(Object_* obj) { return obj.OBJECT_FIELD_OBJ(0x20); }
/*0x10C*/
ref auto oBooNegatedAggressiveness(Object_* obj) { return obj.OBJECT_FIELD_F32(0x21); }
/*0x110*/
ref auto oBooInitialMoveYaw(Object_* obj) { return obj.OBJECT_FIELD_S32(0x22); }
/*0x1B0*/
ref auto oBooTurningSpeed(Object_* obj) { return obj.OBJECT_FIELD_S16(0x4A, 0); }

/* Big Boo */
/*0x1AC*/
ref auto oBigBooNumMinionBoosKilled(Object_* obj) { return obj.OBJECT_FIELD_S32(0x49); }

/* Bookend */
/*0x0F4*/
ref auto oBookendUnkF4(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oBookendUnkF8(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }

/* Book Switch */
/*0x0F4*/
ref auto oBookSwitchUnkF4(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }

/* Book Switch Manager */
/*0x0F4*/
ref auto oBookSwitchManagerUnkF4(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oBookSwitchManagerUnkF8(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }

/* Haunted Bookshelf */
/*0x088*/
ref auto oHauntedBookshelfShouldOpen(Object_* obj) { return obj.OBJECT_FIELD_S32(0x00); }

/* Bouncing FireBall */
/*0x0F4*/
ref auto oBouncingFireBallUnkF4(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }

/* Bowling Ball */
/*0x0F4*/
ref auto oBowlingBallTargetYaw(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
// 0x1D-0x21 reserved for pathing

/* Bowling Ball Spawner (Generic) */
/*0x0F4*/
ref auto oBBallSpawnerMaxSpawnDist(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }
/*0x0F8*/
ref auto oBBallSpawnerSpawnOdds(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }
/*0x0FC*/
ref auto oBBallSpawnerPeriodMinus1(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }

/* Bowser */
/*0x088*/
ref auto oBowserUnk88(Object_* obj) { return obj.OBJECT_FIELD_S32(0x00); }
/*0x0F4*/
ref auto oBowserUnkF4(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oBowserUnkF8(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x0FC*/
ref auto oBowserDistToCentre(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1D); }
/*0x106*/
ref auto oBowserUnk106(Object_* obj) { return obj.OBJECT_FIELD_S16(0x1F, 1); }
/*0x108*/
ref auto oBowserUnk108(Object_* obj) { return obj.OBJECT_FIELD_S16(0x20, 0); }
/*0x10A*/
ref auto oBowserHeldAnglePitch(Object_* obj) { return obj.OBJECT_FIELD_S16(0x20, 1); }
/*0x10D*/
ref auto oBowserHeldAngleVelYaw(Object_* obj) { return obj.OBJECT_FIELD_S16(0x21, 0); }
/*0x10E*/
ref auto oBowserUnk10E(Object_* obj) { return obj.OBJECT_FIELD_S16(0x21, 1); }
/*0x110*/
ref auto oBowserUnk110(Object_* obj) { return obj.OBJECT_FIELD_S16(0x22, 0); }
/*0x112*/
ref auto oBowserAngleToCentre(Object_* obj) { return obj.OBJECT_FIELD_S16(0x22, 1); }
/*0x1AC*/
ref auto oBowserUnk1AC(Object_* obj) { return obj.OBJECT_FIELD_S16(0x49, 0); }
/*0x1AE*/
ref auto oBowserUnk1AE(Object_* obj) { return obj.OBJECT_FIELD_S16(0x49, 1); }
/*0x1B0*/
ref auto oBowserEyesShut(Object_* obj) { return obj.OBJECT_FIELD_S16(0x4A, 0); }
/*0x1B2*/
ref auto oBowserUnk1B2(Object_* obj) { return obj.OBJECT_FIELD_S16(0x4A, 1); }

/* Bowser Shockwave */
/*0x0F4*/
ref auto oBowserShockWaveUnkF4(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }

/* Black Smoke Bowser */
/*0x0F4*/
ref auto oBlackSmokeBowserUnkF4(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }

/* Bowser Key Cutscene */
/*0x0F4*/
ref auto oBowserKeyScale(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }

/* Bowser Puzzle */
/*0x0F4*/
ref auto oBowserPuzzleCompletionFlags(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }

/* Bowser Puzzle Piece */
/*0x0FC*/
ref auto oBowserPuzzlePieceOffsetX(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1D); }
/*0x100*/
ref auto oBowserPuzzlePieceOffsetY(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1E); }
/*0x104*/
ref auto oBowserPuzzlePieceOffsetZ(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1F); }
/*0x108*/
ref auto oBowserPuzzlePieceContinuePerformingAction(Object_* obj) { return obj.OBJECT_FIELD_S32(0x20); }
/*0x10C*/
ref auto oBowserPuzzlePieceActionList(Object_* obj) { return obj.OBJECT_FIELD_VPTR(0x21); }
/*0x110*/
ref auto oBowserPuzzlePieceNextAction(Object_* obj) { return obj.OBJECT_FIELD_VPTR(0x22); }

/* Bubba */
/*0x0F4*/
ref auto oBubbaUnkF4(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }
/*0x0F8*/
ref auto oBubbaUnkF8(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x0FC*/
ref auto oBubbaUnkFC(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }
/*0x100*/
ref auto oBubbaUnk100(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1E); }
/*0x104*/
ref auto oBubbaUnk104(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1F); }
/*0x108*/
ref auto oBubbaUnk108(Object_* obj) { return obj.OBJECT_FIELD_F32(0x20); }
/*0x10C*/
ref auto oBubbaUnk10C(Object_* obj) { return obj.OBJECT_FIELD_F32(0x21); }
/*0x1AC*/
ref auto oBubbaUnk1AC(Object_* obj) { return obj.OBJECT_FIELD_S16(0x49, 0); }
/*0x1AE*/
ref auto oBubbaUnk1AE(Object_* obj) { return obj.OBJECT_FIELD_S16(0x49, +1); }
/*0x1B0*/
ref auto oBubbaUnk1B0(Object_* obj) { return obj.OBJECT_FIELD_S16(0x4A, 0); }
/*0x1B2*/
ref auto oBubbaUnk1B2(Object_* obj) { return obj.OBJECT_FIELD_S16(0x4A, +1); }

/* Bullet Bill */
/*0x0F8*/
ref auto oBulletBillInitialMoveYaw(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }

/* Bully (all variants) */
/*0x0F4*/
ref auto oBullySubtype(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oBullyPrevX(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }
/*0x0FC*/
ref auto oBullyPrevY(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1D); }
/*0x100*/
ref auto oBullyPrevZ(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1E); }
/*0x104*/
ref auto oBullyKBTimerAndMinionKOCounter(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1F); }
/*0x108*/
ref auto oBullyMarioCollisionAngle(Object_* obj) { return obj.OBJECT_FIELD_S32(0x20); }

/* Butterfly */
/*0x0F4*/
ref auto oButterflyYPhase(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }

/* Triplet Butterfly */
/*0x0F4*/
ref auto oTripletButterflyScale(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }
/*0x0F8*/
ref auto oTripletButterflySpeed(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }
/*0x0FC*/
ref auto oTripletButterflyBaseYaw(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1D); }
/*0x100*/
ref auto oTripletButterflyTargetPitch(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1E); }
/*0x104*/
ref auto oTripletButterflyTargetYaw(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1F); }
/*0x108*/
ref auto oTripletButterflyType(Object_* obj) { return obj.OBJECT_FIELD_S32(0x20); }
/*0x10C*/
ref auto oTripletButterflyModel(Object_* obj) { return obj.OBJECT_FIELD_S32(0x21); }
/*0x110*/
ref auto oTripletButterflySelectedButterfly(Object_* obj) { return obj.OBJECT_FIELD_S32(0x22); }
/*0x1AC*/
ref auto oTripletButterflyScalePhase(Object_* obj) { return obj.OBJECT_FIELD_S32(0x49); }

/* Cannon */
/*0x0F4*/
ref auto oCannonUnkF4(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oCannonUnkF8(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x10C*/
ref auto oCannonUnk10C(Object_* obj) { return obj.OBJECT_FIELD_S32(0x21); }

/* Cap */
/*0x0F4*/
ref auto oCapUnkF4(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oCapUnkF8(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }

/* Chain Chomp */
/*0x0F4*/
ref auto oChainChompSegments(Object_* obj) { return obj.OBJECT_FIELD_CHAIN_SEGMENT(0x1B); }
/*0x0F8*/
ref auto oChainChompMaxDistFromPivotPerChainPart(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }
/*0x0FC*/
ref auto oChainChompMaxDistBetweenChainParts(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1D); }
/*0x100*/
ref auto oChainChompDistToPivot(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1E); }
/*0x104*/
ref auto oChainChompUnk104(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1F); }
/*0x108*/
ref auto oChainChompRestrictedByChain(Object_* obj) { return obj.OBJECT_FIELD_S32(0x20); }
/*0x10C*/
ref auto oChainChompTargetPitch(Object_* obj) { return obj.OBJECT_FIELD_S32(0x21); }
/*0x110*/
ref auto oChainChompNumLunges(Object_* obj) { return obj.OBJECT_FIELD_S32(0x22); }
/*0x1AC*/
ref auto oChainChompReleaseStatus(Object_* obj) { return obj.OBJECT_FIELD_S32(0x49); }
/*0x1B0*/
ref auto oChainChompHitGate(Object_* obj) { return obj.OBJECT_FIELD_S32(0x4A); }

/* Checkerboard Platform */
/*0x0F8*/
ref auto oCheckerBoardPlatformUnkF8(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); } // oAction like
/*0x0FC*/
ref auto oCheckerBoardPlatformUnkFC(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }
/*0x1AC*/
ref auto oCheckerBoardPlatformUnk1AC(Object_* obj) { return obj.OBJECT_FIELD_F32(0x49); }

/* Cheep Cheep */
/*0x0F4*/
ref auto oCheepCheepUnkF4(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }
/*0x0F8*/
ref auto oCheepCheepUnkF8(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }
/*0x0FC*/
ref auto oCheepCheepUnkFC(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1D); }
/*0x104*/
ref auto oCheepCheepUnk104(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1F); }
/*0x108*/
ref auto oCheepCheepUnk108(Object_* obj) { return obj.OBJECT_FIELD_F32(0x20); }

/* Chuckya */
/*0x088*/
ref auto oChuckyaUnk88(Object_* obj) { return obj.OBJECT_FIELD_S32(0x00); }
/*0x0F8*/
ref auto oChuckyaUnkF8(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x0FC*/
ref auto oChuckyaUnkFC(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }
/*0x100*/
ref auto oChuckyaUnk100(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1E); }

/* Clam */
/*0x0F4*/
ref auto oClamUnkF4(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }

/* Cloud */
/*0x0F4*/
ref auto oCloudCenterX(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }
/*0x0F8*/
ref auto oCloudCenterY(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }
/*0x0FC*/
ref auto oCloudBlowing(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }
/*0x100*/
ref auto oCloudGrowSpeed(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1E); }
/*0x1AC*/
ref auto oCloudFwooshMovementRadius(Object_* obj) { return obj.OBJECT_FIELD_S16(0x49, 0); }

/* Coin */
/*0x0F4*/
ref auto oCoinUnkF4(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oCoinUnkF8(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x110*/
ref auto oCoinUnk110(Object_* obj) { return obj.OBJECT_FIELD_F32(0x22); }

/*0x1B0*/
ref auto oCoinUnk1B0(Object_* obj) { return obj.OBJECT_FIELD_S32(0x4A); }

/* Collision Particle */
/*0x0F4*/
ref auto oCollisionParticleUnkF4(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }

/* Controllable Platform */
/*0x0F8*/
ref auto oControllablePlatformUnkF8(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x0FC*/
ref auto oControllablePlatformUnkFC(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1D); }
/*0x100*/
ref auto oControllablePlatformUnk100(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1E); }

/* Breakable Box Small (Small Cork Box) */
/*0x0F4*/
ref auto oBreakableBoxSmallReleased(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0FC*/
ref auto oBreakableBoxSmallFramesSinceReleased(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }

/* Jumping Box (Crazy Box) */
/*0x0F4*/
ref auto oJumpingBoxUnkF4(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oJumpingBoxUnkF8(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }

/* RR Cruiser Wing */
/*0x0F4*/
ref auto oRRCruiserWingUnkF4(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oRRCruiserWingUnkF8(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }

/* Donut Platform Spawner */
/*0x0F4*/
ref auto oDonutPlatformSpawnerSpawnedPlatforms(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }

/* Door */
/*0x088*/
ref auto oDoorUnk88(Object_* obj) { return obj.OBJECT_FIELD_S32(0x00); }
/*0x0F8*/
ref auto oDoorUnkF8(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x0FC*/
ref auto oDoorUnkFC(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }
/*0x100*/
ref auto oDoorUnk100(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1E); }

/* Dorrie */
/*0x0F4*/
ref auto oDorrieDistToHome(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }
/*0x0F8*/
ref auto oDorrieOffsetY(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }
/*0x0FC*/
ref auto oDorrieVelY(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1D); }
/*0x100*/
ref auto oDorrieForwardDistToMario(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1E); }
/*0x104*/
ref auto oDorrieYawVel(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1F); }
/*0x10C*/
ref auto oDorrieLiftingMario(Object_* obj) { return obj.OBJECT_FIELD_S32(0x21); }
/*0x1AC*/
ref auto oDorrieGroundPounded(Object_* obj) { return obj.OBJECT_FIELD_S16(0x49, 0); }
/*0x1AE*/
ref auto oDorrieAngleToHome(Object_* obj) { return obj.OBJECT_FIELD_S16(0x49, +1); }
/*0x1B0*/
ref auto oDorrieNeckAngle(Object_* obj) { return obj.OBJECT_FIELD_S16(0x4A, 0); }
/*0x1B2*/
ref auto oDorrieHeadRaiseSpeed(Object_* obj) { return obj.OBJECT_FIELD_S16(0x4A, +1); }

/* Elevator */
/*0x0F4*/
ref auto oElevatorUnkF4(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }
/*0x0F8*/
ref auto oElevatorUnkF8(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }
/*0x0FC*/
ref auto oElevatorUnkFC(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1D); }
/*0x100*/
ref auto oElevatorUnk100(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1E); }

/* Exclamation Box */
/*0x0F4*/
ref auto oExclamationBoxUnkF4(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); } // scale?
/*0x0F8*/
ref auto oExclamationBoxUnkF8(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); } // scale?
/*0x0FC*/
ref auto oExclamationBoxUnkFC(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); } // angle?

/* Eyerok Boss */
/*0x0F8*/
ref auto oEyerokBossNumHands(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x0FC*/
ref auto oEyerokBossUnkFC(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }
/*0x100*/
ref auto oEyerokBossActiveHand(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1E); }
/*0x104*/
ref auto oEyerokBossUnk104(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1F); }
/*0x108*/
ref auto oEyerokBossUnk108(Object_* obj) { return obj.OBJECT_FIELD_F32(0x20); }
/*0x10C*/
ref auto oEyerokBossUnk10C(Object_* obj) { return obj.OBJECT_FIELD_F32(0x21); }
/*0x110*/
ref auto oEyerokBossUnk110(Object_* obj) { return obj.OBJECT_FIELD_F32(0x22); }
/*0x1AC*/
ref auto oEyerokBossUnk1AC(Object_* obj) { return obj.OBJECT_FIELD_S32(0x49); }

/* Eyerok Hand */
/*0x0F4*/
ref auto oEyerokHandWakeUpTimer(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oEyerokReceivedAttack(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x0FC*/
ref auto oEyerokHandUnkFC(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }
/*0x100*/
ref auto oEyerokHandUnk100(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1E); }

/* Falling Pillar */
/*0x0F4*/
ref auto oFallingPillarPitchAcceleration(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }

/* Fire Spitter */
/*0x0F4*/
ref auto oFireSpitterScaleVel(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }

/* Blue Fish */
/*0x0F4*/
ref auto oBlueFishRandomVel(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }
/*0x0F8*/
ref auto oBlueFishRandomTime(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x100*/
ref auto oBlueFishRandomAngle(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1E); }

/* Fish Group */
/*0x0F4*/
ref auto oFishWaterLevel(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }
/*0x0F8*/
ref auto oFishPosY(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }
/*0x0FC*/
ref auto oFishRandomOffset(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1D); }
/*0x100*/
ref auto oFishRandomSpeed(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1E); }
/*0x104*/
ref auto oFishRespawnDistance(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1F); }
/*0x108*/
ref auto oFishRandomVel(Object_* obj) { return obj.OBJECT_FIELD_F32(0x20); }
/*0x10C*/
ref auto oFishDepthDistance(Object_* obj) { return obj.OBJECT_FIELD_F32(0x21); }
/*0x110*/
ref auto oFishActiveDistance(Object_* obj) { return obj.OBJECT_FIELD_F32(0x22); }

/* Flame */
/*0x0F4*/
ref auto oFlameUnkF4(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }
/*0x0F8*/
ref auto oFlameUnkF8(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x0FC*/
ref auto oFlameUnkFC(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1D); }
/*0x100*/
ref auto oFlameUnk100(Object_* obj) { return obj.OBJECT_FIELD_OBJ(0x1E); }

/* Blue Flame */
/*0x0F8*/
ref auto oBlueFlameUnkF8(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }

/* Small Piranha Flame */
/*0x0F4*/
ref auto oSmallPiranhaFlameStartSpeed(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }
/*0x0F8*/
ref auto oSmallPiranhaFlameEndSpeed(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }
/*0x0FC*/
ref auto oSmallPiranhaFlameModel(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }
/*0x100*/
ref auto oSmallPiranhaFlameUnk100(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1E); }
/*0x104*/
ref auto oSmallPiranhaFlameUnk104(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1F); }

/* Moving Flame */
/*0x0F4*/
ref auto oMovingFlameTimer(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }

/* Flamethrower Flame */
/*0x110*/
ref auto oFlameThowerFlameUnk110(Object_* obj) { return obj.OBJECT_FIELD_S32(0x22); }

/* Flamethrower */
/*0x110*/
ref auto oFlameThowerUnk110(Object_* obj) { return obj.OBJECT_FIELD_S32(0x22); }

/* Floating Platform */
/*0x0F4*/
ref auto oFloatingPlatformUnkF4(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oFloatingPlatformUnkF8(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }
/*0x0FC*/
ref auto oFloatingPlatformUnkFC(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1D); }
/*0x100*/
ref auto oFloatingPlatformUnk100(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1E); }

/* Floor Switch Press Animation */
/*0x0F4*/
ref auto oFloorSwitchPressAnimationUnkF4(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oFloorSwitchPressAnimationUnkF8(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x0FC*/
ref auto oFloorSwitchPressAnimationUnkFC(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }
/*0x100*/
ref auto oFloorSwitchPressAnimationUnk100(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1E); }

/* Fly Guy */
/*0x0F4*/
ref auto oFlyGuyIdleTimer(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oFlyGuyOscTimer(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x0FC*/
ref auto oFlyGuyUnusedJitter(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }
/*0x100*/
ref auto oFlyGuyLungeYDecel(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1E); }
/*0x104*/
ref auto oFlyGuyLungeTargetPitch(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1F); }
/*0x108*/
ref auto oFlyGuyTargetRoll(Object_* obj) { return obj.OBJECT_FIELD_S32(0x20); }
/*0x10C*/
ref auto oFlyGuyScaleVel(Object_* obj) { return obj.OBJECT_FIELD_F32(0x21); }

/* Grand Star */
/*0x108*/
ref auto oGrandStarUnk108(Object_* obj) { return obj.OBJECT_FIELD_S32(0x20); }

/* Horizontal Grindel */
/*0x0F4*/
ref auto oHorizontalGrindelTargetYaw(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oHorizontalGrindelDistToHome(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }
/*0x0FC*/
ref auto oHorizontalGrindelOnGround(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }

/* Goomba */
/*0x0F4*/
ref auto oGoombaSize(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oGoombaScale(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }
/*0x0FC*/
ref auto oGoombaWalkTimer(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }
/*0x100*/
ref auto oGoombaTargetYaw(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1E); }
/*0x104*/
ref auto oGoombaBlinkTimer(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1F); }
/*0x108*/
ref auto oGoombaTurningAwayFromWall(Object_* obj) { return obj.OBJECT_FIELD_S32(0x20); }
/*0x10C*/
ref auto oGoombaRelativeSpeed(Object_* obj) { return obj.OBJECT_FIELD_F32(0x21); }

/* Haunted Chair */
/*0x0F4*/
ref auto oHauntedChairUnkF4(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oHauntedChairUnkF8(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }
/*0x0FC*/
ref auto oHauntedChairUnkFC(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1D); }
/*0x100*/
ref auto oHauntedChairUnk100(Object_* obj) { return obj.OBJECT_FIELD_S32P(0x1E); }
/*0x104*/
ref auto oHauntedChairUnk104(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1F); }

/* Heave-Ho */
/*0x088*/
ref auto oHeaveHoUnk88(Object_* obj) { return obj.OBJECT_FIELD_S32(0x00); }
/*0x0F4*/
ref auto oHeaveHoUnkF4(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }

/* Hidden Object */
/*0x0F4*/
ref auto oHiddenObjectUnkF4(Object_* obj) { return obj.OBJECT_FIELD_OBJ(0x1B); }

/* Hoot */
/*0x0F4*/
ref auto oHootAvailability(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x110*/
ref auto oHootMarioReleaseTime(Object_* obj) { return obj.OBJECT_FIELD_S32(0x22); }

/* Horizontal Movement */
/*0x0F4*/
ref auto oHorizontalMovementUnkF4(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oHorizontalMovementUnkF8(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x100*/
ref auto oHorizontalMovementUnk100(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1E); }
/*0x104*/
ref auto oHorizontalMovementUnk104(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1F); }
/*0x108*/
ref auto oHorizontalMovementUnk108(Object_* obj) { return obj.OBJECT_FIELD_F32(0x20); }

/* Kickable Board */
/*0x0F4*/
ref auto oKickableBoardF4(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oKickableBoardF8(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }

/* King Bob-omb */
/*0x088*/
ref auto oKingBobombUnk88(Object_* obj) { return obj.OBJECT_FIELD_S32(0x00); }
/*0x0F8*/
ref auto oKingBobombUnkF8(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x0FC*/
ref auto oKingBobombUnkFC(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }
/*0x100*/
ref auto oKingBobombUnk100(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1E); }
/*0x104*/
ref auto oKingBobombUnk104(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1F); }
/*0x108*/
ref auto oKingBobombUnk108(Object_* obj) { return obj.OBJECT_FIELD_S32(0x20); }

/* Klepto */
/*0x0F4*/
ref auto oKleptoDistanceToTarget(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }
/*0x0F8*/
ref auto oKleptoUnkF8(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }
/*0x0FC*/
ref auto oKleptoUnkFC(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1D); }
/*0x100*/
ref auto oKleptoSpeed(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1E); }
/*0x104*/
ref auto oKleptoStartPosX(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1F); }
/*0x108*/
ref auto oKleptoStartPosY(Object_* obj) { return obj.OBJECT_FIELD_F32(0x20); }
/*0x10C*/
ref auto oKleptoStartPosZ(Object_* obj) { return obj.OBJECT_FIELD_F32(0x21); }
/*0x110*/
ref auto oKleptoTimeUntilTargetChange(Object_* obj) { return obj.OBJECT_FIELD_S32(0x22); }
/*0x1AC*/
ref auto oKleptoTargetNumber(Object_* obj) { return obj.OBJECT_FIELD_S16(0x49, 0); }
/*0x1AE*/
ref auto oKleptoUnk1AE(Object_* obj) { return obj.OBJECT_FIELD_S16(0x49, +1); }
/*0x1B0*/
ref auto oKleptoUnk1B0(Object_* obj) { return obj.OBJECT_FIELD_S16(0x4A, 0); }
/*0x1B2*/
ref auto oKleptoYawToTarget(Object_* obj) { return obj.OBJECT_FIELD_S16(0x4A, +1); }

/* Koopa */
/*0x0F4*/
ref auto oKoopaAgility(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }
/*0x0F8*/
ref auto oKoopaMovementType(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x0FC*/
ref auto oKoopaTargetYaw(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }
/*0x100*/
ref auto oKoopaUnshelledTimeUntilTurn(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1E); }
/*0x104*/
ref auto oKoopaTurningAwayFromWall(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1F); }
/*0x108*/
ref auto oKoopaDistanceToMario(Object_* obj) { return obj.OBJECT_FIELD_F32(0x20); }
/*0x10C*/
ref auto oKoopaAngleToMario(Object_* obj) { return obj.OBJECT_FIELD_S32(0x21); }
/*0x110*/
ref auto oKoopaBlinkTimer(Object_* obj) { return obj.OBJECT_FIELD_S32(0x22); }
/*0x1AC*/
ref auto oKoopaCountdown(Object_* obj) { return obj.OBJECT_FIELD_S16(0x49, 0); }
/*0x1AE*/
ref auto oKoopaTheQuickRaceIndex(Object_* obj) { return obj.OBJECT_FIELD_S16(0x49, 1); }
/*0x1B0*/
ref auto oKoopaTheQuickInitTextboxCooldown(Object_* obj) { return obj.OBJECT_FIELD_S16(0x4A, 0); }
// 0x1D-0x21 for koopa the quick reserved for pathing

/* Koopa Race Endpoint */
/*0x0F4*/
ref auto oKoopaRaceEndpointRaceBegun(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oKoopaRaceEndpointKoopaFinished(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x0FC*/
ref auto oKoopaRaceEndpointRaceStatus(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }
/*0x100*/
ref auto oKoopaRaceEndpointUnk100(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1E); }
/*0x104*/
ref auto oKoopaRaceEndpointRaceEnded(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1F); }

/* Koopa Shell Flame */
/*0x0F4*/
ref auto oKoopaShellFlameUnkF4(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }
/*0x0F8*/
ref auto oKoopaShellFlameUnkF8(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }

/* Camera Lakitu */
/*0x0F4*/
ref auto oCameraLakituBlinkTimer(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oCameraLakituSpeed(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }
/*0x0FC*/
ref auto oCameraLakituCircleRadius(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1D); }
/*0x100*/
ref auto oCameraLakituFinishedDialog(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1E); }

/*0x104*/
ref auto oCameraLakituUnk104(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1F); }

/*0x1AC*/
ref auto oCameraLakituPitchVel(Object_* obj) { return obj.OBJECT_FIELD_S16(0x49, 0); }
/*0x1AE*/
ref auto oCameraLakituYawVel(Object_* obj) { return obj.OBJECT_FIELD_S16(0x49, +1); }

/* Evil Lakitu */
/*0x0F4*/
ref auto oEnemyLakituNumSpinies(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oEnemyLakituBlinkTimer(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x0FC*/
ref auto oEnemyLakituSpinyCooldown(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }
/*0x100*/
ref auto oEnemyLakituFaceForwardCountdown(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1E); }

/* Intro Cutscene Lakitu */
/*0x0F8*/
ref auto oIntroLakituSplineSegmentProgress(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }
/*0x0FC*/
ref auto oIntroLakituSplineSegment(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1D); }
/*0x100*/
ref auto oIntroLakituUnk100(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1E); }
/*0x104*/
ref auto oIntroLakituUnk104(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1F); }
/*0x108*/
ref auto oIntroLakituUnk108(Object_* obj) { return obj.OBJECT_FIELD_F32(0x20); }
/*0x10C*/
ref auto oIntroLakituUnk10C(Object_* obj) { return obj.OBJECT_FIELD_F32(0x21); }
/*0x110*/
ref auto oIntroLakituUnk110(Object_* obj) { return obj.OBJECT_FIELD_F32(0x22); }
/*0x1AC*/
ref auto oIntroLakituCloud(Object_* obj) { return obj.OBJECT_FIELD_OBJ(0x49); }

/* Main Menu Button */
/*0x0F4*/
ref auto oMenuButtonState(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oMenuButtonTimer(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x0FC*/
ref auto oMenuButtonOrigPosX(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1D); }
/*0x100*/
ref auto oMenuButtonOrigPosY(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1E); }
/*0x104*/
ref auto oMenuButtonOrigPosZ(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1F); }
/*0x108*/
ref auto oMenuButtonScale(Object_* obj) { return obj.OBJECT_FIELD_F32(0x20); }
/*0x10C*/
ref auto oMenuButtonActionPhase(Object_* obj) { return obj.OBJECT_FIELD_S32(0x21); }

/* Manta Ray */
/*0x0F4*/
ref auto oMantaUnkF4(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oMantaUnkF8(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x1AC*/
ref auto oMantaUnk1AC(Object_* obj) { return obj.OBJECT_FIELD_S32(0x49); }

/* Merry-Go-Round */
/*0x088*/
ref auto oMerryGoRoundStopped(Object_* obj) { return obj.OBJECT_FIELD_S32(0x00); }
/*0x0F8*/
ref auto oMerryGoRoundMusicShouldPlay(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x0FC*/
ref auto oMerryGoRoundMarioIsOutside(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }

/* Merry-Go-Round Boo Manager */
/*0x088*/
ref auto oMerryGoRoundBooManagerNumBoosKilled(Object_* obj) { return obj.OBJECT_FIELD_S32(0x00); }
/*0x0FC*/
ref auto oMerryGoRoundBooManagerNumBoosSpawned(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }

/* Mips */
/*0x0F4*/
ref auto oMipsStarStatus(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oMipsStartWaypointIndex(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
// 0x1D-0x21 reserved for pathing
/*0x1AC*/
ref auto oMipsForwardVelocity(Object_* obj) { return obj.OBJECT_FIELD_F32(0x49); }

/* Moneybag */
/*0x0F4*/
ref auto oMoneybagJumpState(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }

/* Monty Mole */
/*0x0F4*/
ref auto oMontyMoleCurrentHole(Object_* obj) { return obj.OBJECT_FIELD_OBJ(0x1B); }
/*0x0F8*/
ref auto oMontyMoleHeightRelativeToFloor(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }

/* Monty Mole Hole */
/*0x0F4*/
ref auto oMontyMoleHoleCooldown(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }

/* Mr. Blizzard */
/*0x0F4*/
ref auto oMrBlizzardScale(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }
/*0x0F8*/
ref auto oMrBlizzardHeldObj(Object_* obj) { return obj.OBJECT_FIELD_OBJ(0x1C); }
/*0x0FC*/
ref auto oMrBlizzardGraphYVel(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1D); }
/*0x100*/
ref auto oMrBlizzardTimer(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1E); }
/*0x104*/
ref auto oMrBlizzardDizziness(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1F); }
/*0x108*/
ref auto oMrBlizzardChangeInDizziness(Object_* obj) { return obj.OBJECT_FIELD_F32(0x20); }
/*0x10C*/
ref auto oMrBlizzardGraphYOffset(Object_* obj) { return obj.OBJECT_FIELD_F32(0x21); }
/*0x110*/
ref auto oMrBlizzardDistFromHome(Object_* obj) { return obj.OBJECT_FIELD_S32(0x22); }
/*0x1AC*/
ref auto oMrBlizzardTargetMoveYaw(Object_* obj) { return obj.OBJECT_FIELD_S32(0x49); }

/* Mr. I */
/*0x0F4*/
ref auto oMrIUnkF4(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0FC*/
ref auto oMrIUnkFC(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }
/*0x100*/
ref auto oMrIUnk100(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1E); }
/*0x104*/
ref auto oMrIUnk104(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1F); }
/*0x108*/
ref auto oMrIUnk108(Object_* obj) { return obj.OBJECT_FIELD_S32(0x20); }
/*0x10C*/
ref auto oMrISize(Object_* obj) { return obj.OBJECT_FIELD_F32(0x21); }
/*0x110*/
ref auto oMrIUnk110(Object_* obj) { return obj.OBJECT_FIELD_S32(0x22); }

/* Object Respawner */
/*0x0F4*/
ref auto oRespawnerModelToRespawn(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oRespawnerMinSpawnDist(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }
/*0x0FC*/
ref auto oRespawnerBehaviorToRespawn(Object_* obj) { return obj.OBJECT_FIELD_CVPTR(0x1D); }

/* Openable Grill */
/*0x088*/
ref auto oOpenableGrillUnk88(Object_* obj) { return obj.OBJECT_FIELD_S32(0x00); }
/*0x0F4*/
ref auto oOpenableGrillUnkF4(Object_* obj) { return obj.OBJECT_FIELD_OBJ(0x1B); }

/* Intro Cutscene Peach */
/*0x108*/
ref auto oIntroPeachYawFromFocus(Object_* obj) { return obj.OBJECT_FIELD_F32(0x20); }
/*0x10C*/
ref auto oIntroPeachPitchFromFocus(Object_* obj) { return obj.OBJECT_FIELD_F32(0x21); }
/*0x110*/
ref auto oIntroPeachDistToCamera(Object_* obj) { return obj.OBJECT_FIELD_F32(0x22); }

/* Racing Penguin */
/*0x0F4*/
ref auto oRacingPenguinInitTextCooldown(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
// 0x1D-0x21 reserved for pathing
/*0x110*/
ref auto oRacingPenguinWeightedNewTargetSpeed(Object_* obj) { return obj.OBJECT_FIELD_F32(0x22); }
/*0x1AC*/
ref auto oRacingPenguinFinalTextbox(Object_* obj) { return obj.OBJECT_FIELD_S16(0x49, 0); }
/*0x1AE*/
ref auto oRacingPenguinMarioWon(Object_* obj) { return obj.OBJECT_FIELD_S16(0x49, +1); }
/*0x1B0*/
ref auto oRacingPenguinReachedBottom(Object_* obj) { return obj.OBJECT_FIELD_S16(0x4A, 0); }
/*0x1B2*/
ref auto oRacingPenguinMarioCheated(Object_* obj) { return obj.OBJECT_FIELD_S16(0x4A, +1); }

/* Small Penguin */
/*0x088*/
ref auto oSmallPenguinUnk88(Object_* obj) { return obj.OBJECT_FIELD_S32(0x00); }
/*0x100*/
ref auto oSmallPenguinUnk100(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1E); } // angle?
/*0x104*/
ref auto oSmallPenguinUnk104(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1F); }
/*0x108*/
ref auto oSmallPenguinUnk108(Object_* obj) { return obj.OBJECT_FIELD_F32(0x20); }
/*0x110*/
ref auto oSmallPenguinUnk110(Object_* obj) { return obj.OBJECT_FIELD_S32(0x22); }

/* SL Walking Penguin */
/*0x100*/
ref auto oSLWalkingPenguinWindCollisionXPos(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1E); }
/*0x104*/
ref auto oSLWalkingPenguinWindCollisionZPos(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1F); }
/*0x10C*/
ref auto oSLWalkingPenguinCurStep(Object_* obj) { return obj.OBJECT_FIELD_S32(0x21); }
/*0x110*/
ref auto oSLWalkingPenguinCurStepTimer(Object_* obj) { return obj.OBJECT_FIELD_S32(0x22); }

/* Piranha Plant */
/*0x0F4*/
ref auto oPiranhaPlantSleepMusicState(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oPiranhaPlantScale(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }

/* Fire Piranha Plant */
/*0x0F4*/
ref auto oFirePiranhaPlantNeutralScale(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }
/*0x0F8*/
ref auto oFirePiranhaPlantScale(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); } //Shared with above obj? Coincidence?
/*0x0FC*/
ref auto oFirePiranhaPlantActive(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }
/*0x100*/
ref auto oFirePiranhaPlantDeathSpinTimer(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1E); }
/*0x104*/
ref auto oFirePiranhaPlantDeathSpinVel(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1F); }

/* Pitoune */
/*0x0F4*/
ref auto oPitouneUnkF4(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }
/*0x0F8*/
ref auto oPitouneUnkF8(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }
/*0x0FC*/
ref auto oPitouneUnkFC(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1D); }

/* Platform */
/*0x0F4*/
ref auto oPlatformTimer(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oPlatformUnkF8(Object_* obj) { return obj.OBJECT_FIELD_OBJ(0x1C); }
/*0x0FC*/
ref auto oPlatformUnkFC(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }
/*0x10C*/
ref auto oPlatformUnk10C(Object_* obj) { return obj.OBJECT_FIELD_F32(0x21); }
/*0x110*/
ref auto oPlatformUnk110(Object_* obj) { return obj.OBJECT_FIELD_F32(0x22); }

/* Platform on Tracks */
/*0x088*/
ref auto oPlatformOnTrackBaseBallIndex(Object_* obj) { return obj.OBJECT_FIELD_S32(0x00); }
/*0x0F4*/
ref auto oPlatformOnTrackDistMovedSinceLastBall(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }
/*0x0F8*/
ref auto oPlatformOnTrackSkiLiftRollVel(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }
/*0x0FC*/
ref auto oPlatformOnTrackStartWaypoint(Object_* obj) { return obj.OBJECT_FIELD_WAYPOINT(0x1D); }
/*0x100*/
ref auto oPlatformOnTrackPrevWaypoint(Object_* obj) { return obj.OBJECT_FIELD_WAYPOINT(0x1E); }
/*0x104*/
ref auto oPlatformOnTrackPrevWaypointFlags(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1F); }
/*0x108*/
ref auto oPlatformOnTrackPitch(Object_* obj) { return obj.OBJECT_FIELD_S32(0x20); }
/*0x10C*/
ref auto oPlatformOnTrackYaw(Object_* obj) { return obj.OBJECT_FIELD_S32(0x21); }
/*0x110*/
ref auto oPlatformOnTrackOffsetY(Object_* obj) { return obj.OBJECT_FIELD_F32(0x22); }
/*0x1AC*/
ref auto oPlatformOnTrackIsNotSkiLift(Object_* obj) { return obj.OBJECT_FIELD_S16(0x49, 0); }
/*0x1AE*/
ref auto oPlatformOnTrackIsNotHMC(Object_* obj) { return obj.OBJECT_FIELD_S16(0x49, +1); }
/*0x1B0*/
ref auto oPlatformOnTrackType(Object_* obj) { return obj.OBJECT_FIELD_S16(0x4A, 0); }
/*0x1B2*/
ref auto oPlatformOnTrackWasStoodOn(Object_* obj) { return obj.OBJECT_FIELD_S16(0x4A, +1); }

/* Platform Spawner */
/*0x0F4*/
ref auto oPlatformSpawnerUnkF4(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oPlatformSpawnerUnkF8(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x0FC*/
ref auto oPlatformSpawnerUnkFC(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }
/*0x100*/
ref auto oPlatformSpawnerUnk100(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1E); }
/*0x104*/
ref auto oPlatformSpawnerUnk104(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1F); }
/*0x108*/
ref auto oPlatformSpawnerUnk108(Object_* obj) { return obj.OBJECT_FIELD_F32(0x20); }

/* Pokey */
/*0x0F4*/
ref auto oPokeyAliveBodyPartFlags(Object_* obj) { return obj.OBJECT_FIELD_U32(0x1B); }
/*0x0F8*/
ref auto oPokeyNumAliveBodyParts(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x0FC*/
ref auto oPokeyBottomBodyPartSize(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1D); }
/*0x100*/
ref auto oPokeyHeadWasKilled(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1E); }
/*0x104*/
ref auto oPokeyTargetYaw(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1F); }
/*0x108*/
ref auto oPokeyChangeTargetTimer(Object_* obj) { return obj.OBJECT_FIELD_S32(0x20); }
/*0x10C*/
ref auto oPokeyTurningAwayFromWall(Object_* obj) { return obj.OBJECT_FIELD_S32(0x21); }

/* Pokey Body Part */
/*0x0F8*/
ref auto oPokeyBodyPartDeathDelayAfterHeadKilled(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x110*/
ref auto oPokeyBodyPartBlinkTimer(Object_* obj) { return obj.OBJECT_FIELD_S32(0x22); }

/* DDD Pole */
/*0x0F4*/
ref auto oDDDPoleVel(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }
/*0x0F8*/
ref auto oDDDPoleMaxOffset(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }
/*0x0FC*/
ref auto oDDDPoleOffset(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1D); }

/* Pyramid Top */
/*0x0F4*/
ref auto oPyramidTopPillarsTouched(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }

/* Pyramid Top Explosion */
/*0x0F4*/
ref auto oPyramidTopFragmentsScale(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }

/* Rolling Log */
/*0x0F4*/
ref auto oRollingLogUnkF4(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }

/* Lll Rotating Hex Flame */
/*0x0F4*/
ref auto oLllRotatingHexFlameUnkF4(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }
/*0x0F8*/
ref auto oLllRotatingHexFlameUnkF8(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }
/*0x0FC*/
ref auto oLllRotatingHexFlameUnkFC(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1D); }

/* Scuttlebug */
/*0x0F4*/
ref auto oScuttlebugUnkF4(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oScuttlebugUnkF8(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x0FC*/
ref auto oScuttlebugUnkFC(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }

/* Scuttlebug Spawner */
/*0x088*/
ref auto oScuttlebugSpawnerUnk88(Object_* obj) { return obj.OBJECT_FIELD_S32(0x00); }
/*0x0F4*/
ref auto oScuttlebugSpawnerUnkF4(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }

/* Seesaw Platform */
/*0x0F4*/
ref auto oSeesawPlatformPitchVel(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }

/* Ship Part 3 */
/*0x0F4*/
ref auto oShipPart3UnkF4(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); } // angle?
/*0x0F8*/
ref auto oShipPart3UnkF8(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); } // angle?

/* Sink When Stepped On */
/*0x104*/
ref auto oSinkWhenSteppedOnUnk104(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1F); }
/*0x108*/
ref auto oSinkWhenSteppedOnUnk108(Object_* obj) { return obj.OBJECT_FIELD_F32(0x20); }

/* Skeeter */
/*0x0F4*/
ref auto oSkeeterTargetAngle(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oSkeeterUnkF8(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x0FC*/
ref auto oSkeeterUnkFC(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1D); }
/*0x100*/
ref auto oSkeeterWaitTime(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1E); }
/*0x1AC*/
ref auto oSkeeterUnk1AC(Object_* obj) { return obj.OBJECT_FIELD_S16(0x49, 0); }

/* Jrb Sliding Box */
/*0x0F4*/
ref auto oJrbSlidingBoxUnkF4(Object_* obj) { return obj.OBJECT_FIELD_OBJ(0x1B); }
/*0x0F8*/
ref auto oJrbSlidingBoxUnkF8(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x0FC*/
ref auto oJrbSlidingBoxUnkFC(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1D); }

/* WF Sliding Brick Platform */
/*0x0F4*/
ref auto oWFSlidBrickPtfmMovVel(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }

/* Smoke */
/*0x0F4*/
ref auto oSmokeTimer(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }

/* Snowman's Bottom */
/*0x0F4*/
ref auto oSnowmansBottomUnkF4(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }
/*0x0F8*/
ref auto oSnowmansBottomUnkF8(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x1AC*/
ref auto oSnowmansBottomUnk1AC(Object_* obj) { return obj.OBJECT_FIELD_S32(0x49); }
// 0x1D-0x21 reserved for pathing

/* Snowman's Head */
/*0x0F4*/
ref auto oSnowmansHeadUnkF4(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }

/* Snowman Wind Blowing */
/*0x0F4*/
ref auto oSLSnowmanWindOriginalYaw(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }

/* Snufit */
/*0x0F4*/
ref auto oSnufitRecoil(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oSnufitScale(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }
/*0x100*/
ref auto oSnufitCircularPeriod(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1E); }
/*0x104*/
ref auto oSnufitBodyScalePeriod(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1F); }
/*0x108*/
ref auto oSnufitBodyBaseScale(Object_* obj) { return obj.OBJECT_FIELD_S32(0x20); }
/*0x10C*/
ref auto oSnufitBullets(Object_* obj) { return obj.OBJECT_FIELD_S32(0x21); }
/*0x1AC*/
ref auto oSnufitXOffset(Object_* obj) { return obj.OBJECT_FIELD_S16(0x49, 0); }
/*0x1AE*/
ref auto oSnufitYOffset(Object_* obj) { return obj.OBJECT_FIELD_S16(0x49, +1); }
/*0x1B0*/
ref auto oSnufitZOffset(Object_* obj) { return obj.OBJECT_FIELD_S16(0x4A, 0); }
/*0x1B2*/
ref auto oSnufitBodyScale(Object_* obj) { return obj.OBJECT_FIELD_S16(0x4A, +1); }

/* Spindel */
/*0x0F4*/
ref auto oSpindelUnkF4(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oSpindelUnkF8(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }

/* Spinning Heart */
/*0x0F4*/
ref auto oSpinningHeartTotalSpin(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oSpinningHeartPlayedSound(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }

/* Spiny */
/*0x0F4*/
ref auto oSpinyTimeUntilTurn(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oSpinyTargetYaw(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x100*/
ref auto oSpinyTurningAwayFromWall(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1E); }

/* Sound Effect */
/*0x0F4*/
ref auto oSoundEffectUnkF4(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }

/* Star Spawn */
/*0x0F4*/
ref auto oStarSpawnDisFromHome(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }
/*0x0FC*/
ref auto oStarSpawnUnkFC(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1D); }

/* Hidden Star */
// Secrets/Red Coins
/*0x0F4*/
ref auto oHiddenStarTriggerCounter(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }

// Overall very difficult to determine usage, mostly stubbed code.
/* Sparkle Spawn Star */
/*0x1B0*/
ref auto oSparkleSpawnUnk1B0(Object_* obj) { return obj.OBJECT_FIELD_S32(0x4A); }

/* Sealed Door Star */
/*0x108*/
ref auto oUnlockDoorStarState(Object_* obj) { return obj.OBJECT_FIELD_U32(0x20); }
/*0x10C*/
ref auto oUnlockDoorStarTimer(Object_* obj) { return obj.OBJECT_FIELD_S32(0x21); }
/*0x110*/
ref auto oUnlockDoorStarYawVel(Object_* obj) { return obj.OBJECT_FIELD_S32(0x22); }

/* Celebration Star */
/*0x0F4*/
ref auto oCelebStarUnkF4(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x108*/
ref auto oCelebStarDiameterOfRotation(Object_* obj) { return obj.OBJECT_FIELD_S32(0x20); }

/* Star Selector */
/*0x0F4*/
ref auto oStarSelectorType(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oStarSelectorTimer(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x108*/
ref auto oStarSelectorSize(Object_* obj) { return obj.OBJECT_FIELD_F32(0x20); }

/* Sushi Shark */
/*0x0F4*/
ref auto oSushiSharkUnkF4(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); } // angle?

/* Swing Platform */
/*0x0F4*/
ref auto oSwingPlatformAngle(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }
/*0x0F8*/
ref auto oSwingPlatformSpeed(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }

/* Swoop */
/*0x0F4*/
ref auto oSwoopBonkCountdown(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oSwoopTargetPitch(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x0FC*/
ref auto oSwoopTargetYaw(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }

/* Thwomp */
/*0x0F4*/
ref auto oThwompRandomTimer(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }

/* Tilting Platform */
/*0x0F4*/
ref auto oTiltingPyramidNormalX(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }
/*0x0F8*/
ref auto oTiltingPyramidNormalY(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }
/*0x0FC*/
ref auto oTiltingPyramidNormalZ(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1D); }
/*0x10C*/
ref auto oTiltingPyramidMarioOnPlatform(Object_* obj) { return obj.OBJECT_FIELD_S32(0x21); }

/* Toad Message */
/*0x108*/
ref auto oToadMessageDialogId(Object_* obj) { return obj.OBJECT_FIELD_U32(0x20); }
/*0x10C*/
ref auto oToadMessageRecentlyTalked(Object_* obj) { return obj.OBJECT_FIELD_S32(0x21); }
/*0x110*/
ref auto oToadMessageState(Object_* obj) { return obj.OBJECT_FIELD_S32(0x22); }

/* Tox Box */
/*0x1AC*/
ref auto oToxBoxMovementPattern(Object_* obj) { return obj.OBJECT_FIELD_VPTR(0x49); }
/*0x1B0*/
ref auto oToxBoxMovementStep(Object_* obj) { return obj.OBJECT_FIELD_S32(0x4A); }

/* TTC Rotating Solid */
/*0x0F4*/
ref auto oTTCRotatingSolidNumTurns(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oTTCRotatingSolidNumSides(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x0FC*/
ref auto oTTCRotatingSolidRotationDelay(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }
/*0x100*/
ref auto oTTCRotatingSolidVelY(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1E); }
/*0x104*/
ref auto oTTCRotatingSolidSoundTimer(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1F); }

/* TTC Pendulum */
/*0x0F4*/
ref auto oTTCPendulumAccelDir(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }
/*0x0F8*/
ref auto oTTCPendulumAngle(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }
/*0x0FC*/
ref auto oTTCPendulumAngleVel(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1D); }
/*0x100*/
ref auto oTTCPendulumAngleAccel(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1E); }
/*0x104*/
ref auto oTTCPendulumDelay(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1F); }
/*0x108*/
ref auto oTTCPendulumSoundTimer(Object_* obj) { return obj.OBJECT_FIELD_S32(0x20); }

/* TTC Treadmill */
/*0x0F4*/
ref auto oTTCTreadmillBigSurface(Object_* obj) { return obj.OBJECT_FIELD_S16P(0x1B); }
/*0x0F8*/
ref auto oTTCTreadmillSmallSurface(Object_* obj) { return obj.OBJECT_FIELD_S16P(0x1C); }
/*0x0FC*/
ref auto oTTCTreadmillSpeed(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1D); }
/*0x100*/
ref auto oTTCTreadmillTargetSpeed(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1E); }
/*0x104*/
ref auto oTTCTreadmillTimeUntilSwitch(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1F); }

/* TTC Moving Bar */
/*0x0F4*/
ref auto oTTCMovingBarDelay(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oTTCMovingBarStoppedTimer(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x0FC*/
ref auto oTTCMovingBarOffset(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1D); }
/*0x100*/
ref auto oTTCMovingBarSpeed(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1E); }
/*0x104*/
ref auto oTTCMovingBarStartOffset(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1F); }

/* TTC Cog */
/*0x0F4*/
ref auto oTTCCogDir(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }
/*0x0F8*/
ref auto oTTCCogSpeed(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }
/*0x0FC*/
ref auto oTTCCogTargetVel(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1D); }

/* TTC Pit Block */
/*0x0F4*/
ref auto oTTCPitBlockPeakY(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }
/*0x0F8*/
ref auto oTTCPitBlockDir(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x0FC*/
ref auto oTTCPitBlockWaitTime(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }

/* TTC Elevator */
/*0x0F4*/
ref auto oTTCElevatorDir(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }
/*0x0F8*/
ref auto oTTCElevatorPeakY(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }
/*0x0FC*/
ref auto oTTCElevatorMoveTime(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }

/* TTC 2D Rotator */
/*0x0F4*/
ref auto oTTC2DRotatorMinTimeUntilNextTurn(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oTTC2DRotatorTargetYaw(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x0FC*/
ref auto oTTC2DRotatorIncrement(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }
/*0x104*/
ref auto oTTC2DRotatorRandomDirTimer(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1F); }
/*0x108*/
ref auto oTTC2DRotatorSpeed(Object_* obj) { return obj.OBJECT_FIELD_S32(0x20); }

/* TTC Spinner */
/*0x0F4*/
ref auto oTTCSpinnerDir(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oTTCChangeDirTimer(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }

/* Beta Trampoline */
/*0x110*/
ref auto oBetaTrampolineMarioOnTrampoline(Object_* obj) { return obj.OBJECT_FIELD_S32(0x22); }

/* Treasure Chest */
/*0x0F4*/
ref auto oTreasureChestUnkF4(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oTreasureChestUnkF8(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x0FC*/
ref auto oTreasureChestUnkFC(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }

/* Tree Snow Or Leaf */
/*0x0F4*/
ref auto oTreeSnowOrLeafUnkF4(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oTreeSnowOrLeafUnkF8(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x0FC*/
ref auto oTreeSnowOrLeafUnkFC(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }

/* Tumbling Bridge */
/*0x0F4*/
ref auto oTumblingBridgeUnkF4(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }

/* Tweester */
/*0x0F4*/
ref auto oTweesterScaleTimer(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oTweesterUnused(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }

/* Ukiki */
/*0x0F4*/
ref auto oUkikiTauntCounter(Object_* obj) { return obj.OBJECT_FIELD_S16(0x1B, 0); }
/*0x0F6*/
ref auto oUkikiTauntsToBeDone(Object_* obj) { return obj.OBJECT_FIELD_S16(0x1B, 1); }
// 0x1D-0x21 reserved for pathing
/*0x110*/
ref auto oUkikiChaseFleeRange(Object_* obj) { return obj.OBJECT_FIELD_F32(0x22); }
/*0x1AC*/
ref auto oUkikiTextState(Object_* obj) { return obj.OBJECT_FIELD_S16(0x49, 0); }
/*0x1AE*/
ref auto oUkikiTextboxTimer(Object_* obj) { return obj.OBJECT_FIELD_S16(0x49, 1); }
/*0x1B0*/
ref auto oUkikiCageSpinTimer(Object_* obj) { return obj.OBJECT_FIELD_S16(0x4A, 0); }
/*0x1B2*/
ref auto oUkikiHasCap(Object_* obj) { return obj.OBJECT_FIELD_S16(0x4A, 1); }

/* Ukiki Cage*/
/*0x088*/
ref auto oUkikiCageNextAction(Object_* obj) { return obj.OBJECT_FIELD_S32(0x00); }

/* Unagi */
/*0x0F4*/
ref auto oUnagiUnkF4(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }
/*0x0F8*/
ref auto oUnagiUnkF8(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }
// 0x1D-0x21 reserved for pathing
/*0x110*/
ref auto oUnagiUnk110(Object_* obj) { return obj.OBJECT_FIELD_F32(0x22); }
/*0x1AC*/
ref auto oUnagiUnk1AC(Object_* obj) { return obj.OBJECT_FIELD_F32(0x49); }
/*0x1B0*/
ref auto oUnagiUnk1B0(Object_* obj) { return obj.OBJECT_FIELD_S16(0x4A, 0); }
/*0x1B2*/
ref auto oUnagiUnk1B2(Object_* obj) { return obj.OBJECT_FIELD_S16(0x4A, +1); }

/* Water Bomb */
/*0x0F8*/
ref auto oWaterBombVerticalStretch(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }
/*0x0FC*/
ref auto oWaterBombStretchSpeed(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1D); }
/*0x100*/
ref auto oWaterBombOnGround(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1E); }
/*0x104*/
ref auto oWaterBombNumBounces(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1F); }

/* Water Bomb Spawner */
/*0x0F4*/
ref auto oWaterBombSpawnerBombActive(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oWaterBombSpawnerTimeToSpawn(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }

/* Water Bomb Cannon */
/*0x0F4*/
ref auto oWaterCannonUnkF4(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oWaterCannonUnkF8(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x0FC*/
ref auto oWaterCannonUnkFC(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }
/*0x100*/
ref auto oWaterCannonUnk100(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1E); }

/* Cannon Barrel Bubbles */
/*0x0F4*/
ref auto oCannonBarrelBubblesUnkF4(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }

/* Water Level Pillar */
/*0x0F8*/
ref auto oWaterLevelPillarDrained(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }

/* Water Level Trigger */
/*0x0F4*/
ref auto oWaterLevelTriggerUnkF4(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oWaterLevelTriggerTargetWaterLevel(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }

/* Water Objects */
/*0x0F4*/
ref auto oWaterObjUnkF4(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oWaterObjUnkF8(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x0FC*/
ref auto oWaterObjUnkFC(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }
/*0x100*/
ref auto oWaterObjUnk100(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1E); }

/* Water Ring (both variants) */
/*0x0F4*/
ref auto oWaterRingScalePhaseX(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oWaterRingScalePhaseY(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x0FC*/
ref auto oWaterRingScalePhaseZ(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }
/*0x100*/
ref auto oWaterRingNormalX(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1E); }
/*0x104*/
ref auto oWaterRingNormalY(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1F); }
/*0x108*/
ref auto oWaterRingNormalZ(Object_* obj) { return obj.OBJECT_FIELD_F32(0x20); }
/*0x10C*/
ref auto oWaterRingMarioDistInFront(Object_* obj) { return obj.OBJECT_FIELD_F32(0x21); }
/*0x110*/
ref auto oWaterRingIndex(Object_* obj) { return obj.OBJECT_FIELD_S32(0x22); }
/*0x1AC*/
ref auto oWaterRingAvgScale(Object_* obj) { return obj.OBJECT_FIELD_F32(0x49); }

/* Water Ring Spawner (Jet Stream Ring Spawner and Manta Ray) */
/*0x1AC*/
ref auto oWaterRingSpawnerRingsCollected(Object_* obj) { return obj.OBJECT_FIELD_S32(0x49); }

/* Water Ring Manager (Jet Stream Ring Spawner and Manta Ray Ring Manager) */
/*0x0F4*/
ref auto oWaterRingMgrNextRingIndex(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oWaterRingMgrLastRingCollected(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }

/* Wave Trail */
/*0x0F8*/
ref auto oWaveTrailSize(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1C); }

/* Whirlpool */
/*0x0F4*/
ref auto oWhirlpoolInitFacePitch(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oWhirlpoolInitFaceRoll(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }

/* White Puff Explode */
/*0x0F4*/
ref auto oWhitePuffUnkF4(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }
/*0x0F8*/
ref auto oWhitePuffUnkF8(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x0FC*/
ref auto oWhitePuffUnkFC(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }

/* White Wind Particle */
/*0x0F4*/
ref auto oStrongWindParticlePenguinObj(Object_* obj) { return obj.OBJECT_FIELD_OBJ(0x1B); }

/* Whomp */
/*0x0F8*/
ref auto oWhompShakeVal(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }

/* Wiggler */
/*0x0F4*/
ref auto oWigglerFallThroughFloorsHeight(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1B); }
/*0x0F8*/
ref auto oWigglerSegments(Object_* obj) { return obj.OBJECT_FIELD_CHAIN_SEGMENT(0x1C); }
/*0x0FC*/
ref auto oWigglerWalkAnimSpeed(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1D); }
/*0x104*/
ref auto oWigglerSquishSpeed(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1F); }
/*0x108*/
ref auto oWigglerTimeUntilRandomTurn(Object_* obj) { return obj.OBJECT_FIELD_S32(0x20); }
/*0x10C*/
ref auto oWigglerTargetYaw(Object_* obj) { return obj.OBJECT_FIELD_S32(0x21); }
/*0x110*/
ref auto oWigglerWalkAwayFromWallTimer(Object_* obj) { return obj.OBJECT_FIELD_S32(0x22); }
/*0x1AC*/
ref auto oWigglerUnused(Object_* obj) { return obj.OBJECT_FIELD_S16(0x49, 0); }
/*0x1AE*/
ref auto oWigglerTextStatus(Object_* obj) { return obj.OBJECT_FIELD_S16(0x49, +1); }

/* Lll Wood Piece */
/*0x0F4*/
ref auto oLllWoodPieceOscillationTimer(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }

/* Wooden Post */
/*0x0F4*/
ref auto oWoodenPostTotalMarioAngle(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0F8*/
ref auto oWoodenPostPrevAngleToMario(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1C); }
/*0x0FC*/
ref auto oWoodenPostSpeedY(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1D); }
/*0x100*/
ref auto oWoodenPostMarioPounding(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1E); }
/*0x104*/
ref auto oWoodenPostOffsetY(Object_* obj) { return obj.OBJECT_FIELD_F32(0x1F); }

/* Yoshi */
/*0x0F4*/
ref auto oYoshiBlinkTimer(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1B); }
/*0x0FC*/
ref auto oYoshiChosenHome(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1D); }
/*0x100*/
ref auto oYoshiTargetYaw(Object_* obj) { return obj.OBJECT_FIELD_S32(0x1E); }
