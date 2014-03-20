//
//  ShootableSpriteNode.h
//  Robotron
//
//  Created by Mark Alldritt on 2014-02-27.
//  Copyright (c) 2014 Late Night Software Ltd. All rights reserved.
//

#import "BaseSpriteNode.h"
#import "Bullet.h"


@interface ShootableSpriteNode : BaseSpriteNode

@property (assign, nonatomic) BOOL hasBeenHit;

- (void)hitByBullet:(Bullet*) bullet;

@end
