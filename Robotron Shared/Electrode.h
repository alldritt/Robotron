//
//  Electrode.h
//  Robotron
//
//  Created by Mark Alldritt on 2014-02-27.
//  Copyright (c) 2014 Late Night Software Ltd. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ShootableSpriteNode.h"


@class MyScene;
@class Bullet;
@class Grunt;
@class Brain;

@interface Electrode : ShootableSpriteNode

+ (instancetype)electrodeWithTexture:(SKTexture*) texture;

- (void)hitByGrunt:(Grunt*) grunt;
- (void)hitByBrain:(Brain*) brain;

@end
