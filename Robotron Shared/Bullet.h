//
//  Bullet.h
//  Robotron
//
//  Created by Mark Alldritt on 2014-02-27.
//  Copyright (c) 2014 Late Night Software Ltd. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "BaseSpriteNode.h"

@class MyScene;


@interface Bullet : BaseSpriteNode

@property (readonly, nonatomic) CGFloat deltaX;
@property (readonly, nonatomic) CGFloat deltaY;

+ (instancetype)bulletWithDeltaX:(CGFloat) deltaX deltaY:(CGFloat) deltaY texture:(SKTexture*) texture;

- (instancetype)initWithDeltaX:(CGFloat) deltaX deltaY:(CGFloat) deltaY texture:(SKTexture*) texture;

- (void)hitSomething;
- (void)hitAWall;

@end
