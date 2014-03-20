//
//  Hulk.m
//  Robotron
//
//  Created by Mark Alldritt on 2/4/2014.
//  Copyright (c) 2014 Late Night Software Ltd. All rights reserved.
//

#import "GameMetrics.h"
#import "Hulk.h"


@interface Hulk ()

@property (assign, nonatomic) BOOL wasHitByBullet;
@property (assign, nonatomic) CGFloat moveX;
@property (assign, nonatomic) CGFloat moveY;
@property (assign, nonatomic) NSTimeInterval moveEnd;

@end

@implementation Hulk

+ (instancetype)hulkWithTexture:(SKTexture *)texture {
    return [[Hulk alloc] initWithTexture:texture];
}
            
- (instancetype)initWithTexture:(SKTexture *)texture {
    if ((self = [super initWithTexture:texture])) {
        self.name = @"hulk";
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.dynamic = YES;
        self.physicsBody.categoryBitMask = kHulkCategory;
        self.physicsBody.contactTestBitMask = kBorderEdgeCategory | kBulletCategory;
        self.physicsBody.collisionBitMask = 0;
    }
    return self;
}

- (void)hitByBullet:(Bullet*)bullet {
    CGPoint p = self.position;
    
    p.x += kHulkNudgeSize * bullet.deltaX;
    p.y += kHulkNudgeSize * bullet.deltaY;
    self.position = p;
    [self.gameScene constrainToBoard:self];
    self.wasHitByBullet = YES;
    self.gameScene.gameScore += kHulkPoints;
}

- (void)update:(CFTimeInterval)currentTime {
    MyScene* scene = self.gameScene;
    CGSize boardSize = scene.boardNode.frame.size;
    
    CGPoint p = self.position;
    
    if (self.moveEnd <= currentTime) {
        self.moveEnd = currentTime + ((arc4random() % 40) / 10.0);
        
        do {
            self.moveX = (arc4random() % 3) - 1.0;
            if ((self.moveX > 0 && p.x >= boardSize.width - kRightBorder) ||
                (self.moveX < 0 && p.x <= kLeftBorder))
                self.moveX = 0.0;
            
            if (self.moveX == 0.0)
                self.moveY = (arc4random() % 3) - 1.0;
            else
                self.moveY = 0.0;
            if ((self.moveY > 0 && p.y >= boardSize.height - kBottomBorder) ||
                (self.moveY < 0 && p.y <= kTopBorder))
                self.moveY = 0.0;
        } while (self.moveX == 0.0 && self.moveY == 0.0);
        
        [self removeAllActions];
        if (self.moveX < 0) {
            [self runAction:scene.hulkMoveLeftAction];
        }
        else if (self.moveX > 0) {
            [self runAction:scene.hulkMoveRightAction];
        }
        else if (self.moveY < 0) {
            [self runAction:scene.hulkMoveUpAction];
        }
        else if (self.moveY > 0) {
            [self runAction:scene.hulkMoveDownAction];
        }
    }
    
    if (!self.wasHitByBullet) {
        p.x += kHulkStepSize * self.moveX * scene.gameSpeed;
        p.y += kHulkStepSize * self.moveY * scene.gameSpeed;
        if (p.x <= 0.0) {
            p.x = 0.0;
            self.moveEnd = 0.0;
        }
        else if (p.x >= boardSize.width) {
            p.x = boardSize.width;
            self.moveEnd = 0.0;
        }
        if (p.y <= 0.0) {
            p.y = 0.0;
            self.moveEnd = 0.0;
        }
        if (p.y >= boardSize.height) {
            p.y = boardSize.height;
            self.moveEnd = 0.0;
        }
        self.position = p;
        [self.gameScene constrainToBoard:self];
    }
    else
        self.wasHitByBullet = NO;
}

@end
