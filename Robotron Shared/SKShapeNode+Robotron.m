//
//  SKShapeNode+Robotron.m
//  Robotron
//
//  Created by Mark Alldritt on 2014-03-06.
//  Copyright (c) 2014 Late Night Software Ltd. All rights reserved.
//

#import "SKShapeNode+Robotron.h"
#import "SKColor+Robotron.h"
#import "ColorCycle1.h"
#import "ColorCycle2.h"
#import "ColorCycle3.h"
#import "RandomColorCycle1.h"
#import "RandomColorCycle2.h"

@implementation SKShapeNode (Robotron)

- (void)applyNamedColor:(NSString *)color {
    if ([color isEqualToString:@"colorCycle1"])
        [self runAction:[ColorCycle1 colorCycle]];
    else if ([color isEqualToString:@"colorCycle2"])
        [self runAction:[ColorCycle2 colorCycle]];
    else if ([color isEqualToString:@"colorCycle3"])
        [self runAction:[ColorCycle3 colorCycle]];
    else if ([color isEqualToString:@"colorCycle4"])
        [self runAction:[ColorCycle3 colorCycle]]; // placeholder
    else if ([color isEqualToString:@"colorCycle5"])
        [self runAction:[ColorCycle3 colorCycle]]; // placeholder
    else if ([color isEqualToString:@"colorCycle6"])
        [self runAction:[RandomColorCycle1 showNextColor]];
    else if ([color isEqualToString:@"colorCycle7"])
        [self runAction:[RandomColorCycle2 showNextColor]];
    else
        self.strokeColor = [SKColor namedColor:color];
}

@end
