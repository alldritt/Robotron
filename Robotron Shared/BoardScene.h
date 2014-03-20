//
//  BoardScene
//  Robotron
//
//  Created by Mark Alldritt on 2/10/2014.
//  Copyright (c) 2014 Late Night Software Ltd. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BoardScene : SKScene

@property (assign, nonatomic) NSUInteger displayLives;
@property (assign, nonatomic) NSUInteger displayScore;
@property (assign, nonatomic) NSUInteger displayLevel;
@property (readonly, nonatomic) CGRect playArea;
@property (readonly, nonatomic) SKShapeNode* boardNode;
@property (readonly, nonatomic) NSDictionary* levelInfo;

@end
