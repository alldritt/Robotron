//
//  GameMetrics.h
//  Robotron
//
//  Created by Mark Alldritt on 2/9/2014.
//  Copyright (c) 2014 Late Night Software Ltd. All rights reserved.
//
//  This file defines constants that are used throughout the game locgic.
//

#define kGameFont               @"Robotron"
#define kGameFontSize           20.0

#define kTopBorder              40.0
#define kBottomBorder           150.0
#define kLeftBorder             30.0
#define kRightBorder            kLeftBorder


//  Scoring contents

#define kInitialLives           5
#define kBonusLifePoints        25000

#define kInitialHumanBonus      1000
#define kHumanBonusIncrement    1000
#define kMaxHumanBonus          5000

#define kPlayerStepSize         7.0
#define kHumanStepSize          2.0

#define kGruntPoints            100
#define kGruntStepSize          4.0

#define kHulkPoints             0
#define kHulkStepSize           2.5
#define kHulkNudgeSize          5.0

#define kElectrodePoints        0

#define kSpheroidPoints         1000  // show '1000' bonus
#define kSpheroidStepSize       15.0
#define kEnforcerPoints         250
#define kEnforcerStepSize       20.0
#define kEnforcersPerSpheroid   6
#define kEnforcerBulletPoints   0
#define kEnforcerBulletStepSize 10.0

#define kBrainPoints            500

#define kQuarkPoints            1000 // show '1000' bonus


//  Physics contants

#define kBorderEdgeCategory     (0x1 << 0)
#define kPlayerCategory         (0x1 << 1)
#define kHumanCategory          (0x1 << 2)
#define kBulletCategory         (0x1 << 3)
#define kBrainCategory          (0x1 << 4)
#define kElectrodeCategory      (0x1 << 5)
#define kGruntCategory          (0x1 << 6)
#define kHulkCategory           (0x1 << 7)
#define kSpheroidCategory       (0x1 << 8)
#define kEnforcerCategory       (0x1 << 9)
#define kEnforcerBulletCategory (0x1 << 10)
#define kQuarkCategory          (0x1 << 11)
#define kTankCategory           (0x1 << 12)
#define kTankBulletCategory     (0x1 << 13)

#define kCanBeShotCategory      (kBrainCategory | \
                                 kElectrodeCategory | \
                                 kGruntCategory | \
                                 kHulkCategory | \
                                 kSpheroidCategory | kEnforcerCategory | kEnforcerBulletCategory | \
                                 kQuarkCategory | kTankCategory | kTankBulletCategory)

#define kKillsHumansCategory    (kHulkCategory | kTankCategory | kBrainCategory)

#define kKillsPlayerCategory    (kBrainCategory | \
                                 kElectrodeCategory | \
                                 kGruntCategory | \
                                 kHulkCategory | \
                                 kSpheroidCategory | kEnforcerCategory | kEnforcerBulletCategory | \
                                 kQuarkCategory | kTankCategory | kTankBulletCategory)

//  Movement and timing constants

#define kFireInterval           (1.0 / 13.0)
#define kExplodeDuration        1.0
#define kExplodeExpansion       40.0
#define kImplodeDuration        1.5
#define kImplodeExpansion       50.0
#define kExplosionSliverSize    2.0
#define kBonusDisplayDuration   3.5

