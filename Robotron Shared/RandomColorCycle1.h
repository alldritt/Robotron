//
//  RandomColorCycle1.h
//  ColorCycleTest
//
//  Created by Mark Alldritt on 2014-03-06.
//  Copyright (c) 2014 Late Night Software Ltd. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface RandomColorCycle1 : SKAction

+ (void)updateColor;
+ (SKColor*)nextColorWithDuration:(CFTimeInterval*) duration;

+ (SKAction*)showNextColor;

@end
