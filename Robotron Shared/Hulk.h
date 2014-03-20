//
//  Hulk.h
//  Robotron
//
//  Created by Mark Alldritt on 2/4/2014.
//  Copyright (c) 2014 Late Night Software Ltd. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ShootableSpriteNode.h"


@interface Hulk : ShootableSpriteNode

+ (instancetype)hulkWithTexture:(SKTexture*) texture;

@end
