//
//  MyScene.h
//  SpriteKitTest
//

//  Copyright (c) 2014 Late Night Software Ltd. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "BoardScene.h"


@interface MyScene : BoardScene <SKPhysicsContactDelegate>

//  Controller inouts
@property (assign, nonatomic) CGFloat moveX;
@property (assign, nonatomic) CGFloat moveY;
@property (assign, nonatomic) CGFloat fireX;
@property (assign, nonatomic) CGFloat fireY;

//  Scene timing
@property (assign, nonatomic) CGFloat gameSpeed;
@property (assign, nonatomic) CGFloat playerSpeed;
@property (assign, nonatomic) NSUInteger gameScore;
@property (assign, nonatomic) NSUInteger highScore;

//  Scoring
@property (assign, nonatomic) NSUInteger humanBonus;
@property (assign, nonatomic) NSUInteger numGrunts;
@property (assign, nonatomic) NSUInteger numSpheroids;
@property (assign, nonatomic) NSUInteger numEnforcers;
@property (assign, nonatomic) NSUInteger numBrains;
@property (assign, nonatomic) NSUInteger numQuarks;
@property (assign, nonatomic) NSUInteger numTanks;

//  Board contents
@property (strong, nonatomic) SKSpriteNode* playerSprite;

//  SpriteKit assets and actions
@property (strong, nonatomic) SKAction* playerMoveLeftAction;
@property (strong, nonatomic) SKAction* playerMoveRightAction;
@property (strong, nonatomic) SKAction* playerMoveUpAction;
@property (strong, nonatomic) SKAction* playerMoveDownAction;

@property (strong, nonatomic) SKTextureAtlas* hulkAtlas;
@property (strong, nonatomic) SKAction* hulkMoveLeftAction;
@property (strong, nonatomic) SKAction* hulkMoveRightAction;
@property (strong, nonatomic) SKAction* hulkMoveUpAction;
@property (strong, nonatomic) SKAction* hulkMoveDownAction;

@property (strong, nonatomic) SKTextureAtlas* brainAtlas;
@property (strong, nonatomic) SKAction* brainMoveLeftAction;
@property (strong, nonatomic) SKAction* brainMoveRightAction;
@property (strong, nonatomic) SKAction* brainMoveUpAction;
@property (strong, nonatomic) SKAction* brainMoveDownAction;

@property (strong, nonatomic) SKTextureAtlas* dadAtlas;
@property (strong, nonatomic) SKAction* dadMoveLeftAction;
@property (strong, nonatomic) SKAction* dadMoveRightAction;
@property (strong, nonatomic) SKAction* dadMoveUpAction;
@property (strong, nonatomic) SKAction* dadMoveDownAction;

@property (strong, nonatomic) SKTextureAtlas* momAtlas;
@property (strong, nonatomic) SKAction* momMoveLeftAction;
@property (strong, nonatomic) SKAction* momMoveRightAction;
@property (strong, nonatomic) SKAction* momMoveUpAction;
@property (strong, nonatomic) SKAction* momMoveDownAction;

@property (strong, nonatomic) SKTextureAtlas* sonAtlas;
@property (strong, nonatomic) SKAction* sonMoveLeftAction;
@property (strong, nonatomic) SKAction* sonMoveRightAction;
@property (strong, nonatomic) SKAction* sonMoveUpAction;
@property (strong, nonatomic) SKAction* sonMoveDownAction;

@property (strong, nonatomic) SKTextureAtlas* gruntAtlas;
@property (strong, nonatomic) SKAction* gruntAction;

@property (strong, nonatomic) SKTextureAtlas* spheroidAtlas;
@property (strong, nonatomic) SKAction* spheroidAction;

@property (strong, nonatomic) SKTextureAtlas* electrodeAtlas;
@property (strong, nonatomic) SKAction* electrodeAAction;
@property (strong, nonatomic) SKAction* electrodeBAction;
@property (strong, nonatomic) SKAction* electrodeCAction;
@property (strong, nonatomic) SKAction* electrodeDAction;
@property (strong, nonatomic) SKAction* electrodeEAction;
@property (strong, nonatomic) SKAction* electrodeFAction;
@property (strong, nonatomic) SKAction* electrodeGAction;
@property (strong, nonatomic) SKAction* electrodeHAction;
@property (strong, nonatomic) SKAction* electrodeIAction;

@property (strong, nonatomic) SKAction* enforcerAppearAction;

@property (strong, nonatomic) SKTextureAtlas* bonusAtlas;

@property (strong, nonatomic) SKTextureAtlas* projectileAtlas;
@property (strong, nonatomic) SKAction* enforcerBulletAction;

- (void)showSkullAt:(CGPoint) where;
- (void)showSkeletonAt:(CGPoint) where;
- (void)showBonus:(NSUInteger) bonus at:(CGPoint) where;

- (void)constrainToBoard:(SKSpriteNode*)sprite;

@end
