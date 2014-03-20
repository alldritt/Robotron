//
//  ColorCycle1.m
//  ColorCycleTest
//
//  Created by Mark Alldritt on 2014-03-06.
//  Copyright (c) 2014 Late Night Software Ltd. All rights reserved.
//

#import "ColorCycle1.h"
#import "SKColor+Robotron.h"

static SKAction* sColorCycle;


@implementation ColorCycle1

+ (void)initialize {
    //  colorCycle1: organge(2), red(4)
    CFTimeInterval step = 1.0 / 15.0;

    sColorCycle = [SKAction repeatActionForever:[SKAction sequence:@[[SKAction colorizeWithColor:[SKColor robotronOrangeColor] colorBlendFactor:1 duration:0],
                                                                     [SKAction waitForDuration:step * 2.0],
                                                                     [SKAction colorizeWithColor:[SKColor robotronRedColor] colorBlendFactor:1 duration:0],
                                                                     [SKAction waitForDuration:step * 4.0]]]];
}

+ (SKAction*) colorCycle {
    return sColorCycle;
};

@end
