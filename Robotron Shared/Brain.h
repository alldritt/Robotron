//
//  Brain.h
//  Robotron
//
//  Created by Mark Alldritt on 2014-03-19.
//  Copyright (c) 2014 Late Night Software Ltd. All rights reserved.
//

#import "ShootableSpriteNode.h"


@class Electrode;

@interface Brain : ShootableSpriteNode

+ (instancetype)brainWithTexture:(SKTexture*) texture;

- (void)hitElectrode:(Electrode*) electrode;

@end
