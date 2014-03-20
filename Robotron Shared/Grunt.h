//
//  Grunt.h
//  Robotron
//
//  Created by Mark Alldritt on 2/9/2014.
//  Copyright (c) 2014 Late Night Software Ltd. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ShootableSpriteNode.h"


@class Electrode;

@interface Grunt : ShootableSpriteNode

+ (instancetype)gruntWithTexture:(SKTexture*)texture;

- (void)hitElectrode:(Electrode*) electrode;

@end
