//
//  Human.h
//  Robotron
//
//  Created by Mark Alldritt on 2/9/2014.
//  Copyright (c) 2014 Late Night Software Ltd. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "BaseSpriteNode.h"


@interface Human : BaseSpriteNode

@property (readonly, nonatomic) SKAction* moveLeftAction;
@property (readonly, nonatomic) SKAction* moveRightAction;
@property (readonly, nonatomic) SKAction* moveUpAction;
@property (readonly, nonatomic) SKAction* moveDownAction;

+ (instancetype)humanWithTexture:(SKTexture*) texture;

- (void)hitByPlayer;
- (void)hitByRobotron:(BaseSpriteNode*) robotron;

@end


@interface DadHuman : Human

@end


@interface MomHuman : Human

@end


@interface SonHuman : Human

@end