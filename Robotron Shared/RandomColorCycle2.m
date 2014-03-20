//
//  RandomColorCycle2.m
//  ColorCycleTest
//
//  Created by Mark Alldritt on 2014-03-06.
//  Copyright (c) 2014 Late Night Software Ltd. All rights reserved.
//

#import "RandomColorCycle2.h"
#import "SKColor+Robotron.h"


static NSUInteger sColorIndex = NSNotFound;


@implementation RandomColorCycle2

+ (void)updateColor {
    sColorIndex = NSNotFound;
}

+ (SKColor*)nextColorWithDuration:(CFTimeInterval*) duration {
    NSParameterAssert(duration);
    
    static NSArray* sColors = nil;
    static NSArray* sDurations = nil;
    
    if (!sColors) {
        sColors = @[[SKColor robotronPurpleColor],
                    [SKColor robotronMagentaColor],
                    [SKColor robotronLtPurpleColor],
                    [SKColor robotronLtBlueColor],
                    [SKColor robotronRedColor]];
        sDurations = @[@2, @2, @2, @2, @2];
    }
                       
    if (sColorIndex == NSNotFound)
        sColorIndex = arc4random() % sColors.count;
    SKColor* color = sColors[sColorIndex];
    NSUInteger timeSteps = [sDurations[sColorIndex] intValue];
    CFTimeInterval step = 1.0 / 12.0;
    
    *duration = step * (CGFloat)timeSteps;
    return color;
}

@end
