//
//  Spheroid.m
//  Robotron
//
//  Created by Mark Alldritt on 2014-03-18.
//  Copyright (c) 2014 Late Night Software Ltd. All rights reserved.
//

#import <math.h>
#import "GameMetrics.h"
#import "Spheroid.h"
#import "Enforcer.h"


@interface Spheroid ()

@property (assign, nonatomic) NSUInteger enforcersLeft;
@property (assign, nonatomic) CGFloat moveX;
@property (assign, nonatomic) CGFloat moveY;
@property (assign, nonatomic) NSTimeInterval moveEnd;
@property (assign, nonatomic) NSTimeInterval nextEnforcer;

@end

@implementation Spheroid

+ (instancetype)spheroidWithTexture:(SKTexture *)texture {
    return [[Spheroid alloc] initWithTexture:texture];
}

- (instancetype)initWithTexture:(SKTexture *)texture {
    if ((self = [super initWithTexture:texture])) {
        self.name = @"spheroid";
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.dynamic = YES;
        self.physicsBody.categoryBitMask = kSpheroidCategory;
        self.physicsBody.contactTestBitMask = kBorderEdgeCategory | kBulletCategory;
        self.physicsBody.collisionBitMask = 0;
        self.enforcersLeft = kEnforcersPerSpheroid;
    }
    return self;
}

- (void)hitByBullet:(Bullet*)bullet {
    if (!self.hasBeenHit) {
        self.hasBeenHit = YES;
        self.gameScene.gameScore += kSpheroidPoints;
        [self.gameScene showBonus:kSpheroidPoints at:self.position];
        [self.gameScene runAction:[SKAction playSoundFileNamed:@"HumanBonus.wav" waitForCompletion:NO]];
        [self removeFromParent];
    }
}

- (void)update:(CFTimeInterval)currentTime {
    MyScene* scene = self.gameScene;
    CGPoint p = self.position;
    CGPoint oldP = p;
    
    if (self.nextEnforcer == 0)
        self.nextEnforcer = currentTime + 2.0 + ((arc4random() % 40) / 10.0);
    
    if (self.moveEnd <= currentTime) {
        self.moveEnd = currentTime + ((arc4random() % 40) / 10.0);
        
        do {
            self.moveX = ((arc4random() % 30) - 15.0) / 15.0;
            self.moveY = ((arc4random() % 30) - 15.0) / 15.0;
        } while (fabs(self.moveX) + fabs(self.moveY) < 0.6);
    }
    
    if (!self.hasBeenHit) {
        p.x += kSpheroidStepSize * self.moveX * scene.gameSpeed;
        p.y += kSpheroidStepSize * self.moveY * scene.gameSpeed;
        self.position = p;
        [scene constrainToBoard:self];
        
        if (self.enforcersLeft > 0 &&  self.nextEnforcer <= currentTime) {
            Enforcer* sprite = [Enforcer enforcerWithTexture:[SKTexture textureWithImageNamed:@"ENFORCER_1"]];
            
            sprite.levelInfo = self.levelInfo;
            sprite.position = oldP;
            [self.gameScene.boardNode addChild:sprite];
            [sprite runAction:scene.enforcerAppearAction];
            
            self.enforcersLeft--;
            self.nextEnforcer = currentTime + ((arc4random() % 50) / 30.0);
        }
    }
}

@end
