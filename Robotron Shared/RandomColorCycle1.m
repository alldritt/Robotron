//
//  RandomColorCycle1.m
//  ColorCycleTest
//
//  Created by Mark Alldritt on 2014-03-06.
//  Copyright (c) 2014 Late Night Software Ltd. All rights reserved.
//

#import "RandomColorCycle1.h"
#import "SKColor+Robotron.h"


static NSUInteger sColorIndex = NSNotFound;

@implementation RandomColorCycle1

+ (void)updateColor {
    sColorIndex = NSNotFound;
}

+ (SKColor*)nextColorWithDuration:(CFTimeInterval*) duration {
    NSParameterAssert(duration);
    
    static NSArray* sColors = nil;
    static NSArray* sDurations = nil;
    
    if (!sColors) {
        sColors = @[[SKColor robotronWhiteColor], // white
                    [SKColor robotronPaleBlueColor], // pale blue
                    [SKColor robotronWhiteColor], // white (2)
                    [SKColor robotronDkPurpleColor], // dk purple
                    [SKColor robotronYellowColor], // yellow
                    [SKColor robotronPurpleColor], // purple
                    [SKColor robotronOrangeColor], // orange
                    [SKColor robotronLtOrangeColor], // lt orange
                    [SKColor robotronLtPurpleColor], // lt purple
                    [SKColor robotronLtBlueColor], // lt blue
                    [SKColor robotronWhiteColor], // white (4)
                    [SKColor robotronMagentaColor], // magenta
                    [SKColor robotronLimeGreenColor], // lime green
                    [SKColor robotronRoyalBlueColor], // royal blue
                    [SKColor robotronRedColor], // red
                    [SKColor robotronGreenColor]]; // green
        sDurations = @[@2, @2, @2, @2, @2, @2, @2, @2, @2, @2, @4, @2, @2, @2, @2, @2];
    }
    
    if (sColorIndex == NSNotFound)
        sColorIndex = arc4random() % sColors.count;
    SKColor* color = sColors[sColorIndex];
    NSUInteger timeSteps = [sDurations[sColorIndex] intValue];
    CFTimeInterval step = 1.0 / 12.0;
    
    *duration = step * (CGFloat)timeSteps;
    return color;
}

+ (SKAction*) showNextColor {
    CFTimeInterval duration;
    SKColor* color = [[self class] nextColorWithDuration:&duration];
    
    return [SKAction sequence:@[[SKAction colorizeWithColor:color colorBlendFactor:1 duration:0.0],
                                [SKAction waitForDuration:duration],
                                [SKAction customActionWithDuration:0.0 actionBlock:^(SKNode *node, CGFloat elapsedTime) {
        [node runAction:[[self class] showNextColor]];
    }]]];
}

@end
