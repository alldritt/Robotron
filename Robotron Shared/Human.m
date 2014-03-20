//
//  Human.m
//  Robotron
//
//  Created by Mark Alldritt on 2/9/2014.
//  Copyright (c) 2014 Late Night Software Ltd. All rights reserved.
//

#import "GameMetrics.h"
#import "Human.h"
#import "Hulk.h"

@interface Human ()

@property (assign, nonatomic) CGFloat moveX;
@property (assign, nonatomic) CGFloat moveY;
@property (assign, nonatomic) NSTimeInterval moveEnd;

@end


@implementation Human

+ (instancetype)humanWithTexture:(SKTexture*) texture {
    NSAssert(NO, @"subclass responsibility");
    return nil;
}

- (instancetype)initWithTexture:(SKTexture *)texture {
    if ((self = [super initWithTexture:texture])) {
        self.name = @"human";
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.dynamic = YES;
        self.physicsBody.categoryBitMask = kHumanCategory;
        self.physicsBody.contactTestBitMask = kBorderEdgeCategory | kPlayerCategory | kKillsHumansCategory;
        self.physicsBody.collisionBitMask = 0;
    }
    return self;
}

- (void)hitByPlayer {
    [self.gameScene showBonus:self.gameScene.humanBonus at:self.position];
    self.gameScene.gameScore += self.gameScene.humanBonus;
    if (self.gameScene.humanBonus < kMaxHumanBonus)
        self.gameScene.humanBonus += kHumanBonusIncrement;
    [self removeFromParent];
}

- (void)hitByRobotron:(BaseSpriteNode*) robotron {
    if ([robotron isKindOfClass:[Hulk class]])
        [self.gameScene showSkullAt:self.position];
    else
        [self.gameScene showSkeletonAt:self.position];
    [self removeFromParent];
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
            self.moveY = (arc4random() % 3) - 1.0;
            if ((self.moveY > 0 && p.y >= boardSize.height - kBottomBorder) ||
                (self.moveY < 0 && p.y <= kTopBorder))
                self.moveY = 0.0;
        } while (self.moveX == 0.0 && self.moveY == 0.0);
        
        [self removeAllActions];
        if (self.moveX < 0)
            [self runAction:self.moveLeftAction];
        else if (self.moveX > 0)
            [self runAction:self.moveRightAction];
        else if (self.moveY < 0)
            [self runAction:self.moveUpAction];
        else if (self.moveY > 0)
            [self runAction:self.moveDownAction];
    }
    
    p.x += kHumanStepSize * self.moveX * scene.gameSpeed;
    p.y += kHumanStepSize * self.moveY * scene.gameSpeed;
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

@end


@implementation DadHuman

+ (instancetype)humanWithTexture:(SKTexture*) texture {
    return [[DadHuman alloc] initWithTexture:texture];
}

- (SKAction*)moveLeftAction { return self.gameScene.dadMoveLeftAction; }
- (SKAction*)moveRightAction { return self.gameScene.dadMoveRightAction; }
- (SKAction*)moveUpAction { return self.gameScene.dadMoveUpAction; }
- (SKAction*)moveDownAction { return self.gameScene.dadMoveDownAction; }

@end


@implementation MomHuman

+ (instancetype)humanWithTexture:(SKTexture*) texture {
    return [[MomHuman alloc] initWithTexture:texture];
}

- (SKAction*)moveLeftAction { return self.gameScene.momMoveLeftAction; }
- (SKAction*)moveRightAction { return self.gameScene.momMoveRightAction; }
- (SKAction*)moveUpAction { return self.gameScene.momMoveUpAction; }
- (SKAction*)moveDownAction { return self.gameScene.momMoveDownAction; }

@end


@implementation SonHuman

+ (instancetype)humanWithTexture:(SKTexture*) texture {
    return [[SonHuman alloc] initWithTexture:texture];
}

- (SKAction*)moveLeftAction { return self.gameScene.sonMoveLeftAction; }
- (SKAction*)moveRightAction { return self.gameScene.sonMoveRightAction; }
- (SKAction*)moveUpAction { return self.gameScene.sonMoveUpAction; }
- (SKAction*)moveDownAction { return self.gameScene.sonMoveDownAction; }

@end