//
//  BaseSpriteNode.m
//  Robotron
//
//  Created by Mark Alldritt on 2014-02-27.
//  Copyright (c) 2014 Late Night Software Ltd. All rights reserved.
//

#import "BaseSpriteNode.h"
#import "MyScene.h"


@implementation BaseSpriteNode

- (MyScene*) gameScene {
    if (!self.scene) {
        NSLog(@"xxx");
    }
    NSAssert1(self.scene, @"%@ has been removed form the scene!", self);
    NSAssert1([self.scene isKindOfClass:[MyScene class]], @"%@ is cannot be coerced to MyScene", self);
    return (MyScene*) self.scene;
}

- (void) update:(CFTimeInterval)currentTime {
    NSAssert(NO, @"subclass responsibility");
}

@end
