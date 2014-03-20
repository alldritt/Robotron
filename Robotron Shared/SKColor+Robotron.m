//
//  SKColor+Robotron.m
//  Robotron
//
//  Created by Mark Alldritt on 2014-03-06.
//  Copyright (c) 2014 Late Night Software Ltd. All rights reserved.
//

#import "SKColor+Robotron.h"

@implementation SKColor (Robotron)

+ (SKColor*)namedColor:(NSString*) color {
    static NSDictionary* sNamedColors = nil;
    
    if (!sNamedColors)
        sNamedColors = @{@"red": [SKColor robotronRedColor],
                         @"blue": [SKColor robotronBlueColor],
                         @"purple": [SKColor robotronPurpleColor],
                         @"magenta": [SKColor robotronMagentaColor],
                         @"ltpurple": [SKColor robotronLtPurpleColor],
                         @"orange": [SKColor robotronOrangeColor],
                         @"white": [SKColor robotronWhiteColor],
                         @"black": [SKColor robotronBlackColor],
                         @"paleblue": [SKColor robotronPaleBlueColor],
                         @"dkpurple": [SKColor robotronDkPurpleColor],
                         @"yellow": [SKColor robotronYellowColor],
                         @"ltorange": [SKColor robotronLtOrangeColor],
                         @"ltblue": [SKColor robotronLtBlueColor],
                         @"limegreen": [SKColor robotronLimeGreenColor],
                         @"royalblue": [SKColor robotronRoyalBlueColor],
                         @"green" : [SKColor robotronGreenColor]};
    
    NSAssert1(sNamedColors[color], @"No colour found for '%@'", color);
    return sNamedColors[color];
}

+ (SKColor*)robotronRedColor { return [SKColor colorWithRed:0.914 green:0.040 blue:0.342 alpha:1.000]; }
+ (SKColor*)robotronBlueColor { return [SKColor colorWithRed:0.155 green:0.055 blue:0.974 alpha:1.000]; }
+ (SKColor*)robotronPurpleColor { return [SKColor colorWithRed:0.577 green:0.093 blue:0.886 alpha:1.000]; }
+ (SKColor*)robotronMagentaColor { return [SKColor colorWithRed:0.904 green:0.064 blue:0.594 alpha:1.000]; }
+ (SKColor*)robotronLtPurpleColor { return [SKColor colorWithRed:0.894 green:0.081 blue:0.926 alpha:1.000]; }
+ (SKColor*)robotronOrangeColor { return [SKColor colorWithRed:0.798 green:0.590 blue:0.202 alpha:1.000]; }
+ (SKColor*)robotronWhiteColor { return [SKColor whiteColor]; }
+ (SKColor*)robotronBlackColor { return [SKColor blackColor]; }
+ (SKColor*)robotronPaleBlueColor { return [SKColor colorWithRed:0.349 green:0.975 blue:0.955 alpha:1.000]; }
+ (SKColor*)robotronDkPurpleColor { return [SKColor colorWithRed:0.393 green:0.129 blue:0.872 alpha:1.000]; }
+ (SKColor*)robotronYellowColor { return [SKColor colorWithRed:0.892 green:0.834 blue:0.165 alpha:1.000]; }
+ (SKColor*)robotronLtOrangeColor { return [SKColor colorWithRed:0.886 green:0.597 blue:0.146 alpha:1.000]; }
+ (SKColor*)robotronLtBlueColor { return [SKColor colorWithRed:0.406 green:0.909 blue:0.935 alpha:1.000]; }
+ (SKColor*)robotronLimeGreenColor { return [SKColor colorWithRed:0.657 green:0.968 blue:0.159 alpha:1.000]; }
+ (SKColor*)robotronRoyalBlueColor { return [SKColor colorWithRed:0.201 green:0.585 blue:0.940 alpha:1.000]; }
+ (SKColor*)robotronGreenColor { return [SKColor colorWithRed:0.256 green:0.893 blue:0.133 alpha:1.000]; }

@end
