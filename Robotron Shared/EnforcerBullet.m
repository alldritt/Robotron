//
//  EnforcerBullet.m
//  Robotron
//
//  Created by Mark Alldritt on 2014-03-19.
//  Copyright (c) 2014 Late Night Software Ltd. All rights reserved.
//

#import "GameMetrics.h"
#import "EnforcerBullet.h"

@interface EnforcerBullet ()

@property (assign, nonatomic) CFTimeInterval endTime;
@property (assign, nonatomic) CGFloat moveX;
@property (assign, nonatomic) CGFloat moveY;

@end

@implementation EnforcerBullet

+ (instancetype)enforcerBulletWithTexture:(SKTexture *)texture {
    return [[EnforcerBullet alloc] initWithTexture:texture];
}

- (instancetype)initWithTexture:(SKTexture *)texture {
    if ((self = [super initWithTexture:texture])) {
        self.name = @"enforcerBullet";
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.dynamic = YES;
        self.physicsBody.categoryBitMask = kEnforcerBulletCategory;
        self.physicsBody.contactTestBitMask = kBorderEdgeCategory | kBulletCategory;
        self.physicsBody.collisionBitMask = 0;
    }
    return self;
}

- (void)hitByBullet:(Bullet*)bullet {
    if (!self.hasBeenHit) {
        self.hasBeenHit = YES;
        self.gameScene.gameScore += kEnforcerBulletPoints;
        [self removeFromParent];
    }
}

- (void)update:(CFTimeInterval)currentTime {
    MyScene* scene = self.gameScene;
    CGPoint p = self.position;
    CGPoint playerP = scene.playerSprite.position;
    
    if (self.endTime == 0)
        self.endTime = currentTime + 2.0 + (arc4random() % 12) / 10.0;
    else if (self.endTime <= currentTime)
        [self removeFromParent];
    else {
        if (self.moveX == 0.0 && self.moveY == 0) {
            CGFloat distance = sqrt(pow(p.x - playerP.x, 2.0) + pow(p.y - playerP.y, 2.0));
            CGFloat xForce = (playerP.x - p.x) / distance;
            CGFloat yForce = (playerP.y - p.y) / distance;
            
            self.moveX = xForce * ((arc4random() % 15) / 10.0);
            self.moveY = yForce * ((arc4random() % 15) / 10.0);
        }

        if (!self.hasBeenHit) {
            p.x += kEnforcerBulletStepSize * self.moveX * scene.gameSpeed;
            p.y += kEnforcerBulletStepSize * self.moveY * scene.gameSpeed;
            self.position = p;
            [scene constrainToBoard:self];
        }
    }
}

@end
