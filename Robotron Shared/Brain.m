//
//  Brain.m
//  Robotron
//
//  Created by Mark Alldritt on 2014-03-19.
//  Copyright (c) 2014 Late Night Software Ltd. All rights reserved.
//

#import "GameMetrics.h"
#import "Brain.h"
#import "Electrode.h"
#import "SKSpriteNode+Robotron.h"


@interface Brain ()

@property (assign, nonatomic) CGFloat moveX;
@property (assign, nonatomic) CGFloat moveY;
@property (assign, nonatomic) NSTimeInterval moveEnd;

@end


@implementation Brain

+ (instancetype)brainWithTexture:(SKTexture *)texture {
    return [[Brain alloc] initWithTexture:texture];
}

- (instancetype)initWithTexture:(SKTexture *)texture {
    if ((self = [super initWithTexture:texture])) {
        self.name = @"brain";
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.dynamic = YES;
        self.physicsBody.categoryBitMask = kBrainCategory;
        self.physicsBody.contactTestBitMask = kBorderEdgeCategory | kBulletCategory;
        self.physicsBody.collisionBitMask = 0;
    }
    return self;
}

- (void)hitByBullet:(Bullet*)bullet {
    if (!self.hasBeenHit) {
        self.hasBeenHit = YES;
        self.physicsBody = nil;
        self.gameScene.gameScore += kBrainPoints;
        [self removeAllActions];
        [self explodeHorizontallyAndVertically];
    }
}

- (void)hitElectrode:(Electrode*) electrode {
    if (!self.hasBeenHit) {
        self.physicsBody = nil;
        self.hasBeenHit = YES;
        
        [self removeAllActions];
        [self explodeHorizontallyAndVertically];
    }
}

- (void)update:(CFTimeInterval)currentTime {
    if (!self.hasBeenHit) {
        
    }
}

@end
