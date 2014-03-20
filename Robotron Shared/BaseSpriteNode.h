//
//  BaseSpriteNode.h
//  Robotron
//
//  Created by Mark Alldritt on 2014-02-27.
//  Copyright (c) 2014 Late Night Software Ltd. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "MyScene.h"


@interface BaseSpriteNode : SKSpriteNode

@property (readonly, nonatomic) MyScene* gameScene;
@property (strong, nonatomic) NSDictionary* levelInfo;

- (void) update:(CFTimeInterval) currentTime;

@end
