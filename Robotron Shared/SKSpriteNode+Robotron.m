//
//  SKSpriteNode+Robotron.m
//  ExplodingTest
//
//  Created by Mark Alldritt on 2014-03-05.
//  Copyright (c) 2014 Late Night Software Ltd. All rights reserved.
//

#import "GameMetrics.h"
#import "SKSpriteNode+Robotron.h"
#import "SKColor+Robotron.h"
#import "ColorCycle1.h"
#import "ColorCycle2.h"
#import "ColorCycle3.h"
#import "RandomColorCycle1.h"
#import "RandomColorCycle2.h"


@implementation SKSpriteNode (Robotron)

//  The explode and implode routines work by taking a sprite's teture and dividing it up into a series of slivers that are then
//  animated, relative to the original sprite so they move with the sprite, to create the Robotron explosion effect.

- (void)explodeVertically {
    SKTexture* texture = self.texture;
    CGSize textureSize = texture.size;
    
    for (NSUInteger i = 0; i < textureSize.height; i += kExplosionSliverSize) {
        CGRect r = CGRectMake(0.0, (CGFloat)i / textureSize.height, 1.0, kExplosionSliverSize / textureSize.height);
        SKTexture* tx = [SKTexture textureWithRect:r inTexture:texture];
        SKSpriteNode* sn = [SKSpriteNode spriteNodeWithTexture:tx];
        
        sn.position = CGPointMake(0.0, i - textureSize.height / kExplosionSliverSize);
        
        [sn runAction:[SKAction sequence:@[[SKAction moveByX:0
                                                           y:(i - textureSize.height / kExplosionSliverSize) * kExplodeExpansion
                                                    duration:kExplodeDuration],
                                           [SKAction removeFromParent]]]];
        [self addChild:sn];
    }
    
    self.texture = nil;
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:kExplodeDuration], [SKAction removeFromParent]]]];
}

- (void)explodeHorizontally {
    SKTexture* texture = self.texture;
    CGSize textureSize = texture.size;
    
    for (NSUInteger i = 0; i < textureSize.height; i += kExplosionSliverSize) {
        CGRect r = CGRectMake((CGFloat)i / textureSize.height, 0.0, kExplosionSliverSize / textureSize.height, 1.0);
        SKTexture* tx = [SKTexture textureWithRect:r inTexture:texture];
        SKSpriteNode* sn = [SKSpriteNode spriteNodeWithTexture:tx];
        
        sn.position = CGPointMake(i - textureSize.height / kExplosionSliverSize, 0.0);
        
        [sn runAction:[SKAction sequence:@[[SKAction moveByX:(i - textureSize.height / kExplosionSliverSize) * kExplodeExpansion
                                                           y:0.0
                                                    duration:kExplodeDuration],
                                           [SKAction removeFromParent]]]];
        [self addChild:sn];
    }

    self.texture = nil;
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:kExplodeDuration], [SKAction removeFromParent]]]];
}

- (void)explodeHorizontallyAndVertically {
    SKTexture* texture = self.texture;
    CGSize textureSize = texture.size;
    
    for (NSUInteger i = 0; i < textureSize.height; i += kExplosionSliverSize) {
        CGRect r = CGRectMake(0.0, (CGFloat)i / textureSize.height, 1.0, kExplosionSliverSize / textureSize.height);
        SKTexture* tx = [SKTexture textureWithRect:r inTexture:texture];
        SKSpriteNode* sn = [SKSpriteNode spriteNodeWithTexture:tx];
        
        sn.position = CGPointMake(0.0, i - textureSize.height / kExplosionSliverSize);
        
        [sn runAction:[SKAction sequence:@[[SKAction moveByX:0
                                                           y:(i - textureSize.height / kExplosionSliverSize) * kExplodeExpansion
                                                    duration:kExplodeDuration],
                                           [SKAction removeFromParent]]]];
        [self addChild:sn];
    }

    for (NSUInteger i = 0; i < textureSize.height; i += kExplosionSliverSize) {
        CGRect r = CGRectMake((CGFloat)i / textureSize.height, 0.0, kExplosionSliverSize / textureSize.height, 1.0);
        SKTexture* tx = [SKTexture textureWithRect:r inTexture:texture];
        SKSpriteNode* sn = [SKSpriteNode spriteNodeWithTexture:tx];
        
        sn.position = CGPointMake(i - textureSize.height / kExplosionSliverSize, 0.0);
        
        [sn runAction:[SKAction sequence:@[[SKAction moveByX:(i - textureSize.height / kExplosionSliverSize) * kExplodeExpansion
                                                           y:0.0
                                                    duration:kExplodeDuration],
                                           [SKAction removeFromParent]]]];
        [self addChild:sn];
    }

    self.texture = nil;
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:kExplodeDuration], [SKAction removeFromParent]]]];
}

- (void)explodeBLTR {
    SKTexture* texture = self.texture;
    CGSize textureSize = texture.size;
    
    for (NSUInteger i = 0; i < textureSize.height; i += kExplosionSliverSize) {
        CGRect r = CGRectMake(0.0, (CGFloat)i / textureSize.height, 1.0, kExplosionSliverSize / textureSize.height);
        SKTexture* tx = [SKTexture textureWithRect:r inTexture:texture];
        SKSpriteNode* sn = [SKSpriteNode spriteNodeWithTexture:tx];
        
        sn.position = CGPointMake(0.0, i - textureSize.height / kExplosionSliverSize);
        
        [sn runAction:[SKAction sequence:@[[SKAction moveByX:(i - textureSize.height / kExplosionSliverSize) * kExplodeExpansion
                                                           y:(i - textureSize.height / kExplosionSliverSize) * kExplodeExpansion
                                                    duration:kExplodeDuration],
                                           [SKAction removeFromParent]]]];
        [self addChild:sn];
    }

    self.texture = nil;
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:kExplodeDuration], [SKAction removeFromParent]]]];
}

- (void)explodeTLBR {
    SKTexture* texture = self.texture;
    CGSize textureSize = texture.size;
    
    for (NSUInteger i = 0; i < textureSize.height; i += 2) {
        CGRect r = CGRectMake(0.0, (CGFloat)i / textureSize.height, 1.0, 2.0 / textureSize.height);
        SKTexture* tx = [SKTexture textureWithRect:r inTexture:texture];
        SKSpriteNode* sn = [SKSpriteNode spriteNodeWithTexture:tx];
        
        sn.position = CGPointMake(0.0, i - textureSize.height / 2);
        
        [sn runAction:[SKAction sequence:@[[SKAction moveByX:(i - textureSize.height / 2) * -kExplodeExpansion
                                                           y:(i - textureSize.height / 2) * kExplodeExpansion
                                                    duration:kExplodeDuration],
                                           [SKAction removeFromParent]]]];
        [self addChild:sn];
    }

    self.texture = nil;
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:kExplodeDuration], [SKAction removeFromParent]]]];
}

- (void)implodeVertically {
    [self implodeVerticallyWithAction:nil];
}

- (void)implodeVerticallyWithAction:(SKAction*) action {
    SKTexture* texture = self.texture;
    CGSize textureSize = texture.size;
    
    for (NSUInteger i = 0; i < textureSize.height; i += 2) {
        CGRect r = CGRectMake(0.0, (CGFloat)i / textureSize.height, 1.0, 2.0 / textureSize.height);
        SKTexture* tx = [SKTexture textureWithRect:r inTexture:texture];
        SKSpriteNode* sn = [SKSpriteNode spriteNodeWithTexture:tx];
        
        sn.position = CGPointMake(0.0, (i - textureSize.height / 2) + (i - textureSize.height / 2) * kImplodeExpansion);
        
        [sn runAction:[SKAction sequence:@[[SKAction moveToY:i - textureSize.height / 2
                                                    duration:kImplodeDuration],
                                           [SKAction removeFromParent]]]];
        [self addChild:sn];
    }
    
    self.texture = nil;
    if (action)
        [self runAction:[SKAction sequence:@[[SKAction waitForDuration:kImplodeDuration],
                                             [SKAction setTexture:texture],
                                             action]]];
    else
        [self runAction:[SKAction sequence:@[[SKAction waitForDuration:kImplodeDuration],
                                             [SKAction setTexture:texture]]]];
}

- (void)implodeHorizontally {
    [self implodeHorizontallyWithAction:nil];
}

- (void)implodeHorizontallyWithAction:(SKAction*) action {
    SKTexture* texture = self.texture;
    CGSize textureSize = texture.size;
    
    for (NSUInteger i = 0; i < textureSize.width; i += 2) {
        CGRect r = CGRectMake((CGFloat)i / textureSize.height, 0.0, 2.0 / textureSize.height, 1.0);
        SKTexture* tx = [SKTexture textureWithRect:r inTexture:texture];
        SKSpriteNode* sn = [SKSpriteNode spriteNodeWithTexture:tx];
        
        sn.position = CGPointMake((i - textureSize.width / 2) + (i - textureSize.width / 2) * kImplodeExpansion, 0.0);
        
        SKAction* ac = [SKAction sequence:@[[SKAction moveToX:(i - textureSize.width / 2)
                                                     duration:kImplodeDuration],
                                            [SKAction removeFromParent]]];
        [sn runAction:ac];
        [self addChild:sn];
    }
    
    self.texture = nil;
    if (action)
        [self runAction:[SKAction sequence:@[[SKAction waitForDuration:kImplodeDuration],
                                             [SKAction setTexture:texture],
                                             action]]];
    else
        [self runAction:[SKAction sequence:@[[SKAction waitForDuration:kImplodeDuration],
                                             [SKAction setTexture:texture]]]];
}

- (void)implodePlayer {
    SKTexture* texture = self.texture;
    NSParameterAssert(texture);
    CGSize textureSize = texture.size;
    
    //  Horizontal
    for (NSUInteger i = 0; i < textureSize.width; i += 2) {
        CGRect r = CGRectMake((CGFloat)i / textureSize.height, 0.0, kExplosionSliverSize / textureSize.height, 1.0);
        SKTexture* tx = [SKTexture textureWithRect:r inTexture:texture];
        SKSpriteNode* sn = [SKSpriteNode spriteNodeWithTexture:tx];
        
        sn.position = CGPointMake((i - textureSize.width / kExplosionSliverSize) + (i - textureSize.width / kExplosionSliverSize) * kExplodeExpansion, 0.0);
        
        SKAction* ac = [SKAction sequence:@[[SKAction moveToX:(i - textureSize.width / kExplosionSliverSize)
                                                     duration:kExplodeDuration],
                                            [SKAction removeFromParent]]];
        [sn runAction:ac];
        [self addChild:sn];
    }
    
    //  Vertical
    for (NSUInteger i = 0; i < textureSize.height; i += kExplosionSliverSize) {
        CGRect r = CGRectMake(0.0, (CGFloat)i / textureSize.height, 1.0, kExplosionSliverSize / textureSize.height);
        SKTexture* tx = [SKTexture textureWithRect:r inTexture:texture];
        SKSpriteNode* sn = [SKSpriteNode spriteNodeWithTexture:tx];
        
        sn.position = CGPointMake(0.0, (i - textureSize.height / kExplosionSliverSize) + (i - textureSize.height / kExplosionSliverSize) * kExplodeExpansion);
        
        SKAction* ac = [SKAction sequence:@[[SKAction moveToY:i - textureSize.height / kExplosionSliverSize
                                                     duration:kExplodeDuration],
                                            [SKAction removeFromParent]]];
        [sn runAction:ac];
        [self addChild:sn];
    }
    
    //  Top-Left to Bottom-Right
    for (NSUInteger i = 0; i < textureSize.height; i += kExplosionSliverSize) {
        CGRect r = CGRectMake(0.0, (CGFloat)i / textureSize.height, 1.0, kExplosionSliverSize / textureSize.height);
        SKTexture* tx = [SKTexture textureWithRect:r inTexture:texture];
        SKSpriteNode* sn = [SKSpriteNode spriteNodeWithTexture:tx];
        
        sn.position = CGPointMake((i - textureSize.height / kExplosionSliverSize) * -kExplodeExpansion, (i - textureSize.height / kExplosionSliverSize) + (i - textureSize.height / kExplosionSliverSize) * kExplodeExpansion);
        
        SKAction* ac = [SKAction sequence:@[[SKAction moveTo:CGPointMake(0.0, i - textureSize.height / kExplosionSliverSize)
                                                    duration:kExplodeDuration],
                                            [SKAction removeFromParent]]];
        [sn runAction:ac];
        [self addChild:sn];
    }
    
    //  Top-Right to Bottom-Left
    for (NSUInteger i = 0; i < textureSize.height; i += kExplosionSliverSize) {
        CGRect r = CGRectMake(0.0, (CGFloat)i / textureSize.height, 1.0, kExplosionSliverSize / textureSize.height);
        SKTexture* tx = [SKTexture textureWithRect:r inTexture:texture];
        SKSpriteNode* sn = [SKSpriteNode spriteNodeWithTexture:tx];
        
        sn.position = CGPointMake((i - textureSize.height / kExplosionSliverSize) * kExplodeExpansion, (i - textureSize.height / kExplosionSliverSize) + (i - textureSize.height / kExplosionSliverSize) * kExplodeExpansion);
        
        SKAction* ac = [SKAction sequence:@[[SKAction moveTo:CGPointMake(0.0, i - textureSize.height / kExplosionSliverSize)
                                                    duration:kExplodeDuration],
                                            [SKAction removeFromParent]]];
        [sn runAction:ac];
        [self addChild:sn];
    }
    
    self.texture = nil;
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:kExplodeDuration],
                                         [SKAction setTexture:texture]]]];
}

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
    else {
        self.color = [SKColor namedColor:color];
        self.colorBlendFactor = 1.0;
    }
}

@end
