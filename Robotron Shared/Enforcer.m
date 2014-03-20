//
//  Enforcer.m
//  Robotron
//
//  Created by Mark Alldritt on 2014-03-18.
//  Copyright (c) 2014 Late Night Software Ltd. All rights reserved.
//

#import "GameMetrics.h"
#import "Enforcer.h"
#import "EnforcerBullet.h"
#import "SKSpriteNode+Robotron.h"


@interface Enforcer ()

@property (assign, nonatomic) CFTimeInterval nextFire;
@property (assign, nonatomic) CGFloat moveX;
@property (assign, nonatomic) CGFloat moveY;
@property (assign, nonatomic) NSTimeInterval moveEnd;

@end


@implementation Enforcer

+ (instancetype)enforcerWithTexture:(SKTexture *)texture {
    return [[Enforcer alloc] initWithTexture:texture];
}

- (instancetype)initWithTexture:(SKTexture *)texture {
    if ((self = [super initWithTexture:texture])) {
        self.name = @"enforcer";
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.dynamic = YES;
        self.physicsBody.categoryBitMask = kEnforcerCategory;
        self.physicsBody.contactTestBitMask = kBorderEdgeCategory | kBulletCategory;
        self.physicsBody.collisionBitMask = 0;
    }
    return self;
}

- (void)hitByBullet:(Bullet*)bullet {
    if (!self.hasBeenHit) {
        self.hasBeenHit = YES;
        self.gameScene.gameScore += kEnforcerPoints;        

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

- (void)update:(CFTimeInterval)currentTime {
    MyScene* scene = self.gameScene;
    CGPoint p = self.position;
    CGPoint playerP = scene.playerSprite.position;
    
    if (self.moveEnd <= currentTime) {
        self.moveEnd = currentTime + (arc4random() % 20) / 10.0;
        
        CGFloat distance = sqrt(pow(p.x - playerP.x, 2.0) + pow(p.y - playerP.y, 2.0));
        CGFloat xForce = (playerP.x - p.x) / distance;
        CGFloat yForce = (playerP.y - p.y) / distance;
        
        self.moveX = xForce * ((arc4random() % 12) / 10.0) * (1.0 - 1.0 / distance);
        self.moveY = yForce * ((arc4random() % 12) / 10.0) * (1.0 - 1.0 / distance);
    }
    
    if (!self.hasBeenHit) {
        p.x += kEnforcerStepSize * self.moveX * scene.gameSpeed;
        p.y += kEnforcerStepSize * self.moveY * scene.gameSpeed;
        self.position = p;
        [scene constrainToBoard:self];
        
        if (self.nextFire == 0)
            self.nextFire = currentTime + .2 + (arc4random() % 10) / 10.0;
        else if (self.nextFire <= currentTime) {
            EnforcerBullet* sprite = [EnforcerBullet enforcerBulletWithTexture:[scene.projectileAtlas textureNamed:@"Y1"]];
            sprite.levelInfo = self.levelInfo;
            sprite.position = p;
            [sprite runAction:scene.enforcerBulletAction];
            [scene.boardNode addChild:sprite];
            self.nextFire = currentTime + .2 + (arc4random() % 10) / 10.0;
        }
    }
}

@end
