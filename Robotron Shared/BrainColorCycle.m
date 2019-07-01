//
//  BrainColorCycle.m
//  Robotron
//
//  Created by Mark Alldritt on 2014-03-31.
//  Copyright (c) 2014 Late Night Software Ltd. All rights reserved.
//

#import "BrainColorCycle.h"
#import "SKColor+Robotron.h"


static SKAction* sColorCycle;

@implementation BrainColorCycle

+ (void)initialize {
    //  colorCycle2: blue(2), green(2), red(2)
    CFTimeInterval step = 1.0 / 15.0;
#warning TODO - these colors are just copied from ColorCycle3 and need to be adjusted to be Brain colors
    sColorCycle = [SKAction repeatActionForever:[SKAction sequence:@[[SKAction colorizeWithColor:[SKColor robotronBlueColor] colorBlendFactor:1 duration:0],
                                                                     [SKAction waitForDuration:step * 3.0],
                                                                     [SKAction colorizeWithColor:[SKColor robotronDkPurpleColor] colorBlendFactor:1 duration:0],
                                                                     [SKAction waitForDuration:step * 3.0],
                                                                     [SKAction colorizeWithColor:[SKColor robotronPurpleColor] colorBlendFactor:1 duration:0],
                                                                     [SKAction waitForDuration:step * 3.0],
                                                                     [SKAction colorizeWithColor:[SKColor robotronLtPurpleColor] colorBlendFactor:1 duration:0],
                                                                     [SKAction waitForDuration:step * 3.0],
                                                                     [SKAction colorizeWithColor:[SKColor robotronRedColor] colorBlendFactor:1 duration:0],
                                                                     [SKAction waitForDuration:step * 3.0],
                                                                     [SKAction colorizeWithColor:[SKColor robotronGreenColor] colorBlendFactor:1 duration:0],
                                                                     [SKAction waitForDuration:step * 3.0]]]];
}

+ (SKAction*) colorCycle {
    return sColorCycle;
};

@end
