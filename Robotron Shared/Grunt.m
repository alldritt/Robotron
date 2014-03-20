//
//  Grunt.m
//  Robotron
//
//  Created by Mark Alldritt on 2/9/2014.
//  Copyright (c) 2014 Late Night Software Ltd. All rights reserved.
//

#import "GameMetrics.h"
#import "Grunt.h"
#import "Electrode.h"
#import "MyScene.h"
#import "SKSpriteNode+Robotron.h"

@implementation Grunt

+ (instancetype)gruntWithTexture:(SKTexture *)texture {
    return [[Grunt alloc] initWithTexture:texture];
}

- (instancetype)initWithTexture:(SKTexture *)texture {
    if ((self = [super initWithTexture:texture])) {
        self.name = @"grunt";
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.dynamic = YES;
        self.physicsBody.categoryBitMask = kGruntCategory;
        self.physicsBody.contactTestBitMask = kBorderEdgeCategory | kBulletCategory | kElectrodeCategory;
        self.physicsBody.collisionBitMask = 0;
    }
    return self;
}

- (void)hitByBullet:(Bullet *)bullet {
    if (!self.hasBeenHit) {
        self.gameScene.gameScore += kGruntPoints;
        self.physicsBody = nil;
        self.hasBeenHit = YES;

        [self removeAllActions];
        if (bullet.deltaX == 0)
            [self explodeHorizontally];
        else if (bullet.deltaY == 0)
            [self explodeVertically];
        else if ((bullet.deltaX == 1 && bullet.deltaY == 1) || (bullet.deltaX == -1 && bullet.deltaY == -1))
            [self explodeTLBR];
        else
            [self explodeBLTR];
    }
}

- (void)hitElectrode:(Electrode*) electrode {
    if (!self.hasBeenHit) {
        self.physicsBody = nil;
        self.hasBeenHit = YES;
        
        [self removeAllActions];
        
        CGRect frame = self.frame;
        CGRect electrodeFrame = electrode.frame;
        
        if (ABS(CGRectGetMidX(frame) - CGRectGetMidX(electrodeFrame)) >= (CGRectGetWidth(frame) * .3))
            [self explodeVertically];
        else if (ABS(CGRectGetMidY(frame) - CGRectGetMidY(electrodeFrame)) >= (CGRectGetHeight(frame) * .3))
            [self explodeHorizontally];
        else if ((CGRectGetMidX(electrodeFrame) < CGRectGetMidX(frame) && CGRectGetMidY(electrodeFrame) < CGRectGetMidY(frame)) ||
                 (CGRectGetMidX(electrodeFrame) > CGRectGetMidX(frame) && CGRectGetMidY(electrodeFrame) > CGRectGetMidY(frame)))
            [self explodeTLBR];
        else
            [self explodeBLTR];
    }
}

- (void)update:(CFTimeInterval)currentTime {
    MyScene* scene = self.gameScene;
    CGSize boardSize = scene.boardNode.frame.size;
    
    CGPoint playerPos = scene.playerSprite.position;

    CGPoint p = self.position;
    CGFloat moveX = 0;
    CGFloat moveY = 0;
    
    if (p.x < playerPos.x)
        moveX = 1.0;
    else if (p.x > playerPos.x)
        moveX = -1.0;
    if (p.y < playerPos.y)
        moveY = 1.0;
    else if (p.y > playerPos.y)
        moveY = -1.0;
    
    p.x += kGruntStepSize * moveX * scene.gameSpeed;
    p.y += kGruntStepSize * moveY * scene.gameSpeed;
    
    p.x = MAX(0.0, MIN(boardSize.width, p.x));
    p.y = MAX(0.0, MIN(boardSize.height, p.y));
    self.position = p;
    [self.gameScene constrainToBoard:self];
}

@end
