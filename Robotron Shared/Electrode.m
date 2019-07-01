//
//  Electrode.m
//  Robotron
//
//  Created by Mark Alldritt on 2014-02-27.
//  Copyright (c) 2014 Late Night Software Ltd. All rights reserved.
//

#import "GameMetrics.h"
#import "Electrode.h"
#import "Grunt.h"
#import "Brain.h"


@implementation Electrode

+ (instancetype)electrodeWithTexture:(SKTexture*) texture {
    return [[Electrode alloc] initWithTexture:texture];
}

- (instancetype)initWithTexture:(SKTexture *)texture {
    if ((self = [super initWithTexture:texture])) {
        self.name = @"electrode";
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.dynamic = YES;
        self.physicsBody.categoryBitMask = kElectrodeCategory;
        self.physicsBody.contactTestBitMask = kBulletCategory | kGruntCategory;
        self.physicsBody.collisionBitMask = 0;
    }
    return self;
}

- (void)hitByGrunt:(Grunt*)grunt {
    if (!self.hasBeenHit) {
        self.physicsBody = nil;
        self.hasBeenHit = YES;
        [self removeAllActions];
        
        if ([self.levelInfo[@"electrodeType"] isEqualToString:@"star"])
            [self runAction:self.gameScene.electrodeAAction];
        else if ([self.levelInfo[@"electrodeType"] isEqualToString:@"snowflake"])
            [self runAction:self.gameScene.electrodeBAction];
        else if ([self.levelInfo[@"electrodeType"] isEqualToString:@"square"])
            [self runAction:self.gameScene.electrodeCAction];
        else if ([self.levelInfo[@"electrodeType"] isEqualToString:@"triangle"])
            [self runAction:self.gameScene.electrodeDAction];
        else if ([self.levelInfo[@"electrodeType"] isEqualToString:@"rectangle"])
            [self runAction:self.gameScene.electrodeEAction];
        else if ([self.levelInfo[@"electrodeType"] isEqualToString:@"diamond"])
            [self runAction:self.gameScene.electrodeFAction];
        else
            NSAssert1(NO, @"Umknown electrode type '%@'", self.levelInfo[@"electrodeType"]);
        
        [grunt hitElectrode:self];
    }
}

- (void)hitByBrain:(Brain*) brain {
    if (!self.hasBeenHit) {
        self.physicsBody = nil;
        self.hasBeenHit = YES;
        [self removeAllActions];
        
        if ([self.levelInfo[@"electrodeType"] isEqualToString:@"star"])
            [self runAction:self.gameScene.electrodeAAction];
        else if ([self.levelInfo[@"electrodeType"] isEqualToString:@"snowflake"])
            [self runAction:self.gameScene.electrodeBAction];
        else if ([self.levelInfo[@"electrodeType"] isEqualToString:@"square"])
            [self runAction:self.gameScene.electrodeCAction];
        else if ([self.levelInfo[@"electrodeType"] isEqualToString:@"triangle"])
            [self runAction:self.gameScene.electrodeDAction];
        else if ([self.levelInfo[@"electrodeType"] isEqualToString:@"rectangle"])
            [self runAction:self.gameScene.electrodeEAction];
        else if ([self.levelInfo[@"electrodeType"] isEqualToString:@"diamond"])
            [self runAction:self.gameScene.electrodeFAction];
        else
            NSAssert1(NO, @"Umknown electrode type '%@'", self.levelInfo[@"electrodeType"]);
        
        [brain hitElectrode:self];
    }
}

- (void)hitByBullet:(Bullet *)bullet {
    if (!self.hasBeenHit) {
        self.gameScene.gameScore += kElectrodePoints;
        self.physicsBody = nil;
        self.hasBeenHit = YES;
        [self removeAllActions];
        
        if ([self.levelInfo[@"electrodeType"] isEqualToString:@"star"])
            [self runAction:self.gameScene.electrodeAAction];
        else if ([self.levelInfo[@"electrodeType"] isEqualToString:@"snowflake"])
            [self runAction:self.gameScene.electrodeBAction];
        else if ([self.levelInfo[@"electrodeType"] isEqualToString:@"square"])
            [self runAction:self.gameScene.electrodeCAction];
        else if ([self.levelInfo[@"electrodeType"] isEqualToString:@"triangle"])
            [self runAction:self.gameScene.electrodeDAction];
        else if ([self.levelInfo[@"electrodeType"] isEqualToString:@"rectangle"])
            [self runAction:self.gameScene.electrodeEAction];
        else if ([self.levelInfo[@"electrodeType"] isEqualToString:@"diamond"])
            [self runAction:self.gameScene.electrodeFAction];
        else
            NSAssert1(NO, @"Umknown electrode type '%@'", self.levelInfo[@"electrodeType"]);
    }
}

- (void)update:(CFTimeInterval)currentTime {
    //  Electrodes don't move
}

@end
