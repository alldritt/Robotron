//
//  Bullet.m
//  Robotron
//
//  Created by Mark Alldritt on 2014-02-27.
//  Copyright (c) 2014 Late Night Software Ltd. All rights reserved.
//

#import "GameMetrics.h"
#import "Bullet.h"

@interface Bullet ()

@property (assign, nonatomic) BOOL hasHitSomething;

@end

@implementation Bullet

@synthesize deltaX = mDeltaX;
@synthesize deltaY = mDeltaY;

+ (instancetype)bulletWithDeltaX:(CGFloat) deltaX deltaY:(CGFloat) deltaY texture:(SKTexture*) texture {
    return [[Bullet alloc] initWithDeltaX:deltaX deltaY:deltaY texture:texture];
}

- (instancetype)initWithDeltaX:(CGFloat) deltaX deltaY:(CGFloat) deltaY texture:(SKTexture*) texture {
    NSParameterAssert(deltaX != 0 || deltaY != 0);

    if ((self = [super initWithTexture:texture])) {
        mDeltaX = deltaX;
        mDeltaY = deltaY;

        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.dynamic = YES;
        self.physicsBody.categoryBitMask = kBulletCategory;
        self.physicsBody.contactTestBitMask = kBorderEdgeCategory;
        self.physicsBody.collisionBitMask = 0;
    }
    return self;
}

- (void)hitSomething {
    if (!self.hasHitSomething) {
        self.hasHitSomething = YES;
        self.physicsBody = nil;
        [self removeAllActions];
        
        [self runAction:[SKAction group:@[[SKAction playSoundFileNamed:@"FireHit.wav" waitForCompletion:NO],
                                          [SKAction removeFromParent]]]];
    }
}

- (void)hitAWall {
    self.physicsBody = nil;
    [self removeAllActions];
    [self removeFromParent];
}

@end
