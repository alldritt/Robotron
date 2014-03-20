//
//  ShootableSpriteNode.m
//  Robotron
//
//  Created by Mark Alldritt on 2014-02-27.
//  Copyright (c) 2014 Late Night Software Ltd. All rights reserved.
//

#import "ShootableSpriteNode.h"

@implementation ShootableSpriteNode

- (void)hitByBullet:(Bullet*)bullet {
    NSAssert(NO, @"subclass responsibility");
}

@end
