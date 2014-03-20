//
//  MyScene.m
//  SpriteKitTest
//
//  Created by Mark Alldritt on 1/31/2014.
//  Copyright (c) 2014 Late Night Software Ltd. All rights reserved.
//

#import "GameMetrics.h"
#import "MyScene.h"
#import "Bullet.h"
#import "Hulk.h"
#import "Human.h"
#import "Electrode.h"
#import "Grunt.h"
#import "Spheroid.h"
#import "Enforcer.h"
#import "EnforcerBullet.h"
#import "Brain.h"
#import "SKSpriteNode+Robotron.h"
#import "ColorCycle1.h"
#import "ColorCycle2.h"
#import "RandomColorCycle1.h"
#import "RandomColorCycle2.h"


@interface MyScene ()

@property (assign, nonatomic) CGFloat lastMoveX;
@property (assign, nonatomic) CGFloat lastMoveY;
@property (assign, nonatomic) NSTimeInterval lastFireTime;
@property (assign, nonatomic) NSTimeInterval lastUpdateTime;
@property (assign, nonatomic, getter=isPlaying) BOOL playing;
@property (assign, nonatomic) BOOL canPlayerMove;
@property (assign, nonatomic, getter=isSuspended) BOOL suspended;
@property (assign, nonatomic) NSUInteger levelSpheroids;

@property (strong, nonatomic) NSMutableArray* pendingContacts;
@property (strong, nonatomic) NSArray* colorCycle1; // red, orange, green, blue - used for "WAVE" and others
@property (strong, nonatomic) NSArray* colorCycle2; // used for score and others

@end


@implementation MyScene

- (void)showSkullAt:(CGPoint) where {
    SKSpriteNode* skullNode = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"PLAYER_SKULL"]];
    skullNode.position = where;
    [skullNode runAction:[SKAction sequence:@[[SKAction playSoundFileNamed:@"HumanDies.wav" waitForCompletion:NO],
                                              [SKAction waitForDuration:1.5],
                                              [SKAction removeFromParent]]]];
    [self.boardNode addChild:skullNode];
}

- (void)showSkeletonAt:(CGPoint) where {
#if 0
    //  I thought I understood what Robotron does when a brain or tank moves over a human, but as I watch the
    //  video more, I see there is more going on than I first saw.  I'll come back to this later one.
    SKSpriteNode* skullNode = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"PLAYER_SKULL2"]];
    skullNode.position = where;
    
    //  Make the skull vibrate up and down a little
    SKAction* vibrate = [SKAction repeatAction[SKAction sequence:@[[SKAction moveByX:0 y:5.0 duration:0.0],
                                              [SKAction waitForDuration:.1],
                                              [SKAction moveByX:0 y:-10.0 duration:0.0],
                                              [SKAction waitForDuration:.1],
                                              [SKAction moveByX:0 y:5.0 duration:0.0]]]];
    
    [SKAction moveByX:0 y:5.0 duration:0.0]
    [skullNode runAction:[SKAction sequence:@[[SKAction waitForDuration:1.0], [SKAction removeFromParent]]]];
    [self.boardNode addChild:skullNode];
#else
    [self showSkullAt:where];
#endif
}

- (void)showBonus:(NSUInteger) bonus at:(CGPoint) where {
    SKSpriteNode* parentNode = [SKSpriteNode spriteNodeWithColor:nil size:CGSizeMake(20.0, 10.0)];
    SKSpriteNode* zerosNode = [SKSpriteNode spriteNodeWithTexture:[self.bonusAtlas textureNamed:@"000"]];
    SKSpriteNode* digitNode = nil;
    
    switch (bonus) {
        default:
            NSAssert(NO, @"invalid bonus (%d) passed to showBonus:at:", (int)bonus);
        case 1000:
            digitNode = [SKSpriteNode spriteNodeWithTexture:[self.bonusAtlas textureNamed:@"1"]];
            [digitNode runAction:[ColorCycle1 colorCycle]];
            [zerosNode runAction:[ColorCycle1 colorCycle]];
            break;
            
        case 2000:
            digitNode = [SKSpriteNode spriteNodeWithTexture:[self.bonusAtlas textureNamed:@"2"]];
            [digitNode runAction:[ColorCycle1 colorCycle]];
            [zerosNode runAction:[ColorCycle2 colorCycle]];
            break;
            
        case 3000:
            digitNode = [SKSpriteNode spriteNodeWithTexture:[self.bonusAtlas textureNamed:@"3"]];
            [digitNode runAction:[ColorCycle1 colorCycle]];
            [zerosNode runAction:[RandomColorCycle2 showNextColor]];
            break;
            
        case 4000:
            digitNode = [SKSpriteNode spriteNodeWithTexture:[self.bonusAtlas textureNamed:@"4"]];
            [digitNode runAction:[ColorCycle1 colorCycle]];
            [zerosNode runAction:[ColorCycle2 colorCycle]];
            break;
            
        case 5000:
            digitNode = [SKSpriteNode spriteNodeWithTexture:[self.bonusAtlas textureNamed:@"5"]];
            [digitNode runAction:[RandomColorCycle1 showNextColor]];
            [zerosNode runAction:[RandomColorCycle2 showNextColor]];
            break;
    }

    digitNode.position = CGPointMake(-7.0, 0.0);
    [parentNode addChild:digitNode];
    zerosNode.position = CGPointMake(3.0, 0.0);
    [parentNode addChild:zerosNode];
    parentNode.position = where;
    [self.boardNode addChild:parentNode];
    [parentNode runAction:[SKAction sequence:@[[SKAction playSoundFileNamed:@"HumanBonus.wav" waitForCompletion:NO],
                                               [SKAction waitForDuration:kBonusDisplayDuration],
                                               [SKAction removeFromParent]]]];
}

- (void)constrainToBoard:(SKSpriteNode*)sprite {
    CGRect playArea = CGRectInset(self.playArea, 1.0, 1.0);
    CGRect spriteArea = sprite.frame;
    CGFloat n;
    CGPoint p = sprite.position;
    
    if ((n = CGRectGetMinX(spriteArea) - CGRectGetMinX(playArea)) < 0.0) {
        p.x -= n;
        sprite.position = p;
    }
    else if ((n = CGRectGetMaxX(spriteArea) - CGRectGetMaxX(playArea)) > 0.0) {
        p.x -= n;
        sprite.position = p;
    }
    if ((n = CGRectGetMinY(spriteArea) - CGRectGetMinY(playArea)) < 0.0) {
        p.y -= n;
        sprite.position = p;
    }
    else if ((n = CGRectGetMaxY(spriteArea) - CGRectGetMaxY(playArea)) > 0.0) {
        p.y -= n;
        sprite.position = p;
    }
}

-(id)initWithSize:(CGSize)size {
    if ((self = [super initWithSize:size])) {
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
        self.physicsWorld.contactDelegate = self;
        self.pendingContacts = [NSMutableArray arrayWithCapacity:40];
        
        //  Player SpriteKit assets & actions
        self.playerMoveLeftAction = [SKAction repeatActionForever:[SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:@"PLAYER_LEFT1"],
                                                                                                  [SKTexture textureWithImageNamed:@"PLAYER_LEFT2"],
                                                                                                  [SKTexture textureWithImageNamed:@"PLAYER_LEFT3"]]
                                                                                   timePerFrame:1.0 / 15.0
                                                                                         resize:YES
                                                                                        restore:YES]];
        self.playerMoveRightAction = [SKAction repeatActionForever:[SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:@"PLAYER_RIGHT1"],
                                                                                                   [SKTexture textureWithImageNamed:@"PLAYER_RIGHT2"],
                                                                                                   [SKTexture textureWithImageNamed:@"PLAYER_RIGHT3"]]
                                                                                    timePerFrame:1.0 / 15.0
                                                                                          resize:YES
                                                                                         restore:YES]];
        self.playerMoveUpAction = [SKAction repeatActionForever:[SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:@"PLAYER_UP1"],
                                                                                                [SKTexture textureWithImageNamed:@"PLAYER_UP2"],
                                                                                                [SKTexture textureWithImageNamed:@"PLAYER_UP3"]]
                                                                                 timePerFrame:1.0 / 15.0
                                                                                       resize:YES
                                                                                      restore:YES]];
        self.playerMoveDownAction = [SKAction repeatActionForever:[SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:@"PLAYER_DOWN1"],
                                                                                                  [SKTexture textureWithImageNamed:@"PLAYER_DOWN2"],
                                                                                                  [SKTexture textureWithImageNamed:@"PLAYER_DOWN3"]]
                                                                                   timePerFrame:1.0 / 15.0
                                                                                         resize:YES
                                                                                        restore:YES]];

        //  Projectile sprites
        self.projectileAtlas = [SKTextureAtlas atlasNamed:@"Projectiles"];

        self.enforcerBulletAction = [SKAction repeatActionForever:[SKAction animateWithTextures:@[[self.projectileAtlas textureNamed:@"Y1"],
                                                                                                  [self.projectileAtlas textureNamed:@"Y2"],
                                                                                                  [self.projectileAtlas textureNamed:@"Y3"],
                                                                                                  [self.projectileAtlas textureNamed:@"Y4"]]
                                                                                   timePerFrame:1.0 / 5.0
                                                                                         resize:YES
                                                                                        restore:YES]];

        //  Electrode sprites
        self.electrodeAtlas = [SKTextureAtlas atlasNamed:@"Electrodes"];
        self.electrodeAAction = [SKAction sequence:@[[SKAction animateWithTextures:@[[self.electrodeAtlas textureNamed:@"A1"],
                                                                                     [self.electrodeAtlas textureNamed:@"A2"],
                                                                                     [self.electrodeAtlas textureNamed:@"A3"]]
                                                                      timePerFrame:1.0 / 15.0
                                                                            resize:YES
                                                                           restore:NO],
                                                     [SKAction removeFromParent]]];
        self.electrodeBAction = [SKAction sequence:@[[SKAction animateWithTextures:@[[self.electrodeAtlas textureNamed:@"B1"],
                                                                                     [self.electrodeAtlas textureNamed:@"B2"],
                                                                                     [self.electrodeAtlas textureNamed:@"B3"]]
                                                                      timePerFrame:1.0 / 15.0
                                                                            resize:YES
                                                                           restore:NO],
                                                     [SKAction removeFromParent]]];
        self.electrodeCAction = [SKAction sequence:@[[SKAction animateWithTextures:@[[self.electrodeAtlas textureNamed:@"C1"],
                                                                                     [self.electrodeAtlas textureNamed:@"C2"],
                                                                                     [self.electrodeAtlas textureNamed:@"C3"]]
                                                                      timePerFrame:1.0 / 6.0
                                                                            resize:YES
                                                                           restore:YES],
                                                     [SKAction removeFromParent]]];
        self.electrodeDAction = [SKAction sequence:@[[SKAction animateWithTextures:@[[self.electrodeAtlas textureNamed:@"D1"],
                                                                                     [self.electrodeAtlas textureNamed:@"D2"],
                                                                                     [self.electrodeAtlas textureNamed:@"D3"]]
                                                                      timePerFrame:1.0 / 15.0
                                                                            resize:YES
                                                                           restore:YES],
                                                     [SKAction removeFromParent]]];
        self.electrodeEAction = [SKAction sequence:@[[SKAction animateWithTextures:@[[self.electrodeAtlas textureNamed:@"E1"],
                                                                                     [self.electrodeAtlas textureNamed:@"E2"],
                                                                                     [self.electrodeAtlas textureNamed:@"E3"]]
                                                                      timePerFrame:1.0 / 15.0
                                                                            resize:YES
                                                                           restore:YES],
                                                     [SKAction removeFromParent]]];
        self.electrodeFAction = [SKAction sequence:@[[SKAction animateWithTextures:@[[self.electrodeAtlas textureNamed:@"F1"],
                                                                                     [self.electrodeAtlas textureNamed:@"F2"],
                                                                                     [self.electrodeAtlas textureNamed:@"F3"]]
                                                                      timePerFrame:1.0 / 15.0
                                                                            resize:YES
                                                                           restore:YES],
                                                     [SKAction removeFromParent]]];
        self.electrodeGAction = [SKAction sequence:@[[SKAction animateWithTextures:@[[self.electrodeAtlas textureNamed:@"G1"],
                                                                                     [self.electrodeAtlas textureNamed:@"G2"],
                                                                                     [self.electrodeAtlas textureNamed:@"G3"]]
                                                                      timePerFrame:1.0 / 15.0
                                                                            resize:YES
                                                                           restore:YES],
                                                     [SKAction removeFromParent]]];
        self.electrodeHAction = [SKAction sequence:@[[SKAction animateWithTextures:@[[self.electrodeAtlas textureNamed:@"H1"],
                                                                                     [self.electrodeAtlas textureNamed:@"H2"],
                                                                                     [self.electrodeAtlas textureNamed:@"H3"]]
                                                                      timePerFrame:1.0 / 15.0
                                                                            resize:YES
                                                                           restore:YES],
                                                     [SKAction removeFromParent]]];
        self.electrodeIAction = [SKAction sequence:@[[SKAction animateWithTextures:@[[self.electrodeAtlas textureNamed:@"I1"],
                                                                                     [self.electrodeAtlas textureNamed:@"I2"],
                                                                                     [self.electrodeAtlas textureNamed:@"I3"]]
                                                                      timePerFrame:1.0 / 15.0
                                                                            resize:YES
                                                                           restore:YES],
                                                     [SKAction removeFromParent]]];
        
        //  Mom SpriteKit assets & actions
        self.momAtlas = [SKTextureAtlas atlasNamed:@"Mom"];
        self.momMoveLeftAction = [SKAction repeatActionForever:[SKAction animateWithTextures:@[[self.momAtlas textureNamed:@"LEFT1"],
                                                                                               [self.momAtlas textureNamed:@"LEFT2"],
                                                                                               [self.momAtlas textureNamed:@"LEFT3"]]
                                                                                timePerFrame:1.0 / 10.0
                                                                                      resize:YES
                                                                                     restore:YES]];
        self.momMoveRightAction = [SKAction repeatActionForever:[SKAction animateWithTextures:@[[self.momAtlas textureNamed:@"RIGHT1"],
                                                                                                [self.momAtlas textureNamed:@"RIGHT2"],
                                                                                                [self.momAtlas textureNamed:@"RIGHT3"]]
                                                                                 timePerFrame:1.0 / 10.0
                                                                                       resize:YES
                                                                                      restore:YES]];
        self.momMoveUpAction = [SKAction repeatActionForever:[SKAction animateWithTextures:@[[self.momAtlas textureNamed:@"UP1"],
                                                                                             [self.momAtlas textureNamed:@"UP2"],
                                                                                             [self.momAtlas textureNamed:@"UP3"]]
                                                                              timePerFrame:1.0 / 10.0
                                                                                    resize:YES
                                                                                   restore:YES]];
        self.momMoveDownAction = [SKAction repeatActionForever:[SKAction animateWithTextures:@[[self.momAtlas textureNamed:@"DOWN1"],
                                                                                               [self.momAtlas textureNamed:@"DOWN2"],
                                                                                               [self.momAtlas textureNamed:@"DOWN3"]]
                                                                                timePerFrame:1.0 / 10.0
                                                                                      resize:YES
                                                                                     restore:YES]];

        //  Dad SpriteKit assets & actions
        self.dadAtlas = [SKTextureAtlas atlasNamed:@"Dad"];
        self.dadMoveLeftAction = [SKAction repeatActionForever:[SKAction animateWithTextures:@[[self.dadAtlas textureNamed:@"LEFT1"],
                                                                                               [self.dadAtlas textureNamed:@"LEFT2"],
                                                                                               [self.dadAtlas textureNamed:@"LEFT3"]]
                                                                                timePerFrame:1.0 / 10.0
                                                                                      resize:YES
                                                                                     restore:YES]];
        self.dadMoveRightAction = [SKAction repeatActionForever:[SKAction animateWithTextures:@[[self.dadAtlas textureNamed:@"RIGHT1"],
                                                                                                [self.dadAtlas textureNamed:@"RIGHT2"],
                                                                                                [self.dadAtlas textureNamed:@"RIGHT3"]]
                                                                                 timePerFrame:1.0 / 10.0
                                                                                       resize:YES
                                                                                      restore:YES]];
        self.dadMoveUpAction = [SKAction repeatActionForever:[SKAction animateWithTextures:@[[self.dadAtlas textureNamed:@"UP1"],
                                                                                             [self.dadAtlas textureNamed:@"UP2"],
                                                                                             [self.dadAtlas textureNamed:@"UP3"]]
                                                                              timePerFrame:1.0 / 10.0
                                                                                    resize:YES
                                                                                   restore:YES]];
        self.dadMoveDownAction = [SKAction repeatActionForever:[SKAction animateWithTextures:@[[self.dadAtlas textureNamed:@"DOWN1"],
                                                                                               [self.dadAtlas textureNamed:@"DOWN2"],
                                                                                               [self.dadAtlas textureNamed:@"DOWN3"]]
                                                                                timePerFrame:1.0 / 10.0
                                                                                      resize:YES
                                                                                     restore:YES]];

        //  Son SpriteKit assets & actions
        self.sonAtlas = [SKTextureAtlas atlasNamed:@"Son"];
        self.sonMoveLeftAction = [SKAction repeatActionForever:[SKAction animateWithTextures:@[[self.sonAtlas textureNamed:@"LEFT1"],
                                                                                               [self.sonAtlas textureNamed:@"LEFT2"],
                                                                                               [self.sonAtlas textureNamed:@"LEFT3"]]
                                                                                timePerFrame:1.0 / 10.0
                                                                                      resize:YES
                                                                                     restore:YES]];
        self.sonMoveRightAction = [SKAction repeatActionForever:[SKAction animateWithTextures:@[[self.sonAtlas textureNamed:@"RIGHT1"],
                                                                                                [self.sonAtlas textureNamed:@"RIGHT2"],
                                                                                                [self.sonAtlas textureNamed:@"RIGHT3"]]
                                                                                 timePerFrame:1.0 / 10.0
                                                                                       resize:YES
                                                                                      restore:YES]];
        self.sonMoveUpAction = [SKAction repeatActionForever:[SKAction animateWithTextures:@[[self.sonAtlas textureNamed:@"UP1"],
                                                                                             [self.sonAtlas textureNamed:@"UP2"],
                                                                                             [self.sonAtlas textureNamed:@"UP3"]]
                                                                              timePerFrame:1.0 / 10.0
                                                                                    resize:YES
                                                                                   restore:YES]];
        self.sonMoveDownAction = [SKAction repeatActionForever:[SKAction animateWithTextures:@[[self.sonAtlas textureNamed:@"DOWN1"],
                                                                                               [self.sonAtlas textureNamed:@"DOWN2"],
                                                                                               [self.sonAtlas textureNamed:@"DOWN3"]]
                                                                                timePerFrame:1.0 / 10.0
                                                                                      resize:YES
                                                                                     restore:YES]];

        //  Grunt SpriteKit assets & actions
        self.gruntAtlas = [SKTextureAtlas atlasNamed:@"Grunt"];
        self.gruntAction = [SKAction repeatActionForever:[SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:@"GRUNT_1"],
                                                                                         [SKTexture textureWithImageNamed:@"GRUNT_2"],
                                                                                         [SKTexture textureWithImageNamed:@"GRUNT_3"]]
                                                                          timePerFrame:1.0 / 12.0
                                                                                resize:YES
                                                                               restore:YES]];

        //  Hulk SpriteKit assets & actions
        self.hulkAtlas = [SKTextureAtlas atlasNamed:@"Hulk"];
        self.hulkMoveLeftAction = [SKAction repeatActionForever:[SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:@"HULK_LEFT1"],
                                                                                                [SKTexture textureWithImageNamed:@"HULK_LEFT2"],
                                                                                                [SKTexture textureWithImageNamed:@"HULK_LEFT3"]]
                                                                                 timePerFrame:1.0 / 12.0
                                                                                       resize:YES
                                                                                      restore:YES]];
        self.hulkMoveRightAction = [SKAction repeatActionForever:[SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:@"HULK_RIGHT1"],
                                                                                                 [SKTexture textureWithImageNamed:@"HULK_RIGHT2"],
                                                                                                 [SKTexture textureWithImageNamed:@"HULK_RIGHT3"]]
                                                                                  timePerFrame:1.0 / 12.0
                                                                                        resize:YES
                                                                                       restore:YES]];
        self.hulkMoveDownAction =
        self.hulkMoveUpAction = [SKAction repeatActionForever:[SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:@"HULK_1"],
                                                                                              [SKTexture textureWithImageNamed:@"HULK_2"],
                                                                                              [SKTexture textureWithImageNamed:@"HULK_3"]]
                                                                               timePerFrame:1.0 / 12.0
                                                                                     resize:YES
                                                                                    restore:YES]];

        //  Brain SpriteKit assets & actions
        self.brainMoveLeftAction = [SKAction repeatActionForever:[SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:@"BRAIN_LEFT1"],
                                                                                                 [SKTexture textureWithImageNamed:@"BRAIN_LEFT2"],
                                                                                                 [SKTexture textureWithImageNamed:@"BRAIN_LEFT3"]]
                                                                                  timePerFrame:1.0 / 10.0
                                                                                        resize:YES
                                                                                       restore:YES]];
        self.brainMoveRightAction = [SKAction repeatActionForever:[SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:@"BRAIN_RIGHT1"],
                                                                                                  [SKTexture textureWithImageNamed:@"BRAIN_RIGHT2"],
                                                                                                  [SKTexture textureWithImageNamed:@"BRAIN_RIGHT3"]]
                                                                                   timePerFrame:1.0 / 10.0
                                                                                         resize:YES
                                                                                        restore:YES]];
        self.brainMoveUpAction = [SKAction repeatActionForever:[SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:@"BRAIN_UP1"],
                                                                                               [SKTexture textureWithImageNamed:@"BRAIN_UP2"],
                                                                                               [SKTexture textureWithImageNamed:@"BRAIN_UP3"]]
                                                                                timePerFrame:1.0 / 10.0
                                                                                      resize:YES
                                                                                     restore:YES]];
        self.brainMoveDownAction = [SKAction repeatActionForever:[SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:@"BRAIN_DOWN1"],
                                                                                                 [SKTexture textureWithImageNamed:@"BRAIN_DOWN2"],
                                                                                                 [SKTexture textureWithImageNamed:@"BRAIN_DOWN3"]]
                                                                                  timePerFrame:1.0 / 10.0
                                                                                        resize:YES
                                                                                       restore:YES]];

        //  Shperoid SpriteKit assets & actions
        self.spheroidAtlas = [SKTextureAtlas atlasNamed:@"Spheroid"];
        self.spheroidAction = [SKAction repeatActionForever:[SKAction animateWithTextures:@[[self.spheroidAtlas textureNamed:@"1"],
                                                                                            [self.spheroidAtlas textureNamed:@"2"],
                                                                                            [self.spheroidAtlas textureNamed:@"3"],
                                                                                            [self.spheroidAtlas textureNamed:@"4"],
                                                                                            [self.spheroidAtlas textureNamed:@"5"],
                                                                                            [self.spheroidAtlas textureNamed:@"6"],
                                                                                            [self.spheroidAtlas textureNamed:@"7"],
                                                                                            [self.spheroidAtlas textureNamed:@"8"],
                                                                                            [self.spheroidAtlas textureNamed:@"7"],
                                                                                            [self.spheroidAtlas textureNamed:@"6"],
                                                                                            [self.spheroidAtlas textureNamed:@"5"],
                                                                                            [self.spheroidAtlas textureNamed:@"4"],
                                                                                            [self.spheroidAtlas textureNamed:@"3"],
                                                                                            [self.spheroidAtlas textureNamed:@"2"]]
                                                                             timePerFrame:1.0 / 15.0
                                                                                   resize:YES
                                                                                  restore:YES]];

        //  Enforcer SpriteKit assets & actions
        self.enforcerAppearAction = [SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:@"ENFORCER_6"],
                                                                    [SKTexture textureWithImageNamed:@"ENFORCER_5"],
                                                                    [SKTexture textureWithImageNamed:@"ENFORCER_4"],
                                                                    [SKTexture textureWithImageNamed:@"ENFORCER_3"],
                                                                    [SKTexture textureWithImageNamed:@"ENFORCER_2"],
                                                                    [SKTexture textureWithImageNamed:@"ENFORCER_1"]]
                                                     timePerFrame:1.0 / 8.0
                                                           resize:YES
                                                          restore:NO];

        //  Bonus SpriteKit assets & actions
        self.bonusAtlas = [SKTextureAtlas atlasNamed:@"Bonus"];

        //  Restore previous game state and begin the fun!
        self.highScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"high_score"];
        [self gameOver];
    }
    return self;
}

- (void)startGame {
    NSParameterAssert(self.levelInfo[@"speed"]);
    
    [self.boardNode removeAllChildren];
    self.displayScore = self.gameScore = 0;
    self.displayLevel = 1;
    self.displayLives = kInitialLives - 1;
    self.playerSpeed = self.gameSpeed = 1.0;
    self.levelSpheroids = [self.levelInfo[@"spheroids"] intValue];
    [self startLevel];
}

- (void)startLevel {
    [self.boardNode removeAllActions];
    [self.boardNode removeAllChildren];

    self.humanBonus = kInitialHumanBonus;
    self.gameSpeed = MAX(self.gameSpeed, [self.levelInfo[@"speed"] doubleValue]);
    self.playerSpeed = MAX(self.playerSpeed, self.levelInfo[@"playerSpeed"] ? [self.levelInfo[@"playerSpeed"] doubleValue] : self.gameSpeed);

    [self makePlayer]; // created, but not yet visible
    [self startLevelStage1];
}

- (void)startLevelStage1 {
    [self makeHumansForLevel];

    [self.boardNode runAction:[SKAction group:@[[SKAction sequence:@[[SKAction waitForDuration:.25], [SKAction performSelector:@selector(startLevelStage2) onTarget:self]]],
                                                [SKAction sequence:@[[SKAction waitForDuration:.5], [SKAction performSelector:@selector(startLevelStage3) onTarget:self]]],
                                                [SKAction sequence:@[[SKAction waitForDuration:.5 + kImplodeDuration - .5], [SKAction performSelector:@selector(startLevelStage4) onTarget:self]]],
                                                ]]];
}

- (void)startLevelStage2 {
    [self makeElectrodesForLevel];
    [self makeSpheroidsForLevel];
}

- (void)startLevelStage3 {
    [self makeHulksForLevel];
    [self makeGruntsForLevel];
}

- (void)startLevelStage4 {
    [self revealPlayer];

    //  Then after a brief delay, let the game actually begin
    [self.boardNode runAction:[SKAction group:@[[SKAction sequence:@[[SKAction waitForDuration:kImplodeDuration / 3.0], [SKAction performSelector:@selector(startLevelStage5) onTarget:self]]],
                                                [SKAction sequence:@[[SKAction waitForDuration:kImplodeDuration / 1.6], [SKAction performSelector:@selector(startLevelStage6) onTarget:self]]]]]];
}

- (void)startLevelStage5 {
    self.canPlayerMove = YES;
}

- (void)startLevelStage6 {
    //  Its possible that the player has hit something already.  If this has happened, -gameOver has been called, and we can check to
    //  see if canPlayerMove is NO.
    
    if (self.canPlayerMove)
        self.playing = YES;
}

- (void)startNewLevel {
    self.canPlayerMove = self.playing = NO;
    self.displayLevel += 1;
    self.levelSpheroids = [self.levelInfo[@"spheroids"] intValue];
    [self startLevel];
}

- (void)playerHitBy:(BaseSpriteNode*) sprite {
    if ([sprite isKindOfClass:[ShootableSpriteNode class]] && ((ShootableSpriteNode*) sprite).hasBeenHit)
        return; // don't let baddies that have been shot kill anything (they are in the process of exploding)
    
    self.canPlayerMove = self.playing = NO;
    [self.playerSprite runAction:[SKAction group:@[[SKAction playSoundFileNamed:@"PlayerDies.wav" waitForCompletion:NO],
                                                   [RandomColorCycle1 showNextColor],
                                                   [SKAction sequence:@[[SKAction waitForDuration:2.0],
                                                                        [SKAction performSelector:@selector(playerDied) onTarget:self]]]]]];
}

- (void)playerDied {
    self.canPlayerMove = self.playing = NO;
    if (self.displayLives == 0)
        [self gameOver];
    else {
        if (self.displayLives > 0)
            self.displayLives -= 1;
        [self startLevel];
    }
}

- (void)gameOver {
    self.canPlayerMove = self.playing = NO;
    self.suspended = NO;
    self.highScore = MAX(self.highScore, self.gameScore);
    [[NSUserDefaults standardUserDefaults] setInteger:self.highScore forKey:@"high_score"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    if (self.isSuspended) {
        [self.boardNode enumerateChildNodesWithName:@"paused" usingBlock:^(SKNode *node, BOOL *stop) {
            [node removeFromParent];
        }];
        self.suspended = NO;
    }

    SKLabelNode* sprite1 = [SKLabelNode labelNodeWithFontNamed:kGameFont];
    sprite1.position = CGPointMake(CGRectGetMidX(self.boardNode.frame), CGRectGetMidY(self.boardNode.frame));
    sprite1.fontSize = 40.0;
    sprite1.text = @"Tap To Start";
    sprite1.name = @"restart";
    [sprite1 runAction:[RandomColorCycle1 showNextColor]];
    [self.boardNode addChild:sprite1];

    if (self.highScore > 0) {
        SKLabelNode* sprite2 = self.highScore > 0 ? [SKLabelNode labelNodeWithFontNamed:kGameFont] : nil;
        sprite2.position = CGPointMake(CGRectGetMidX(self.boardNode.frame), CGRectGetMidY(self.boardNode.frame) - 30.0);
        sprite2.fontSize = 20.0;
        sprite2.text = [NSString stringWithFormat:@"High Score: %d", (int)self.highScore];
        sprite2.name = @"high_score";

        [sprite2 runAction:[ColorCycle2 colorCycle]];
        [self.boardNode addChild:sprite2];
    }
}

- (void)makePlayer {
    CGSize boardSize = self.boardNode.frame.size;
    
    self.playerSprite = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"PLAYER_STILL"]];
    self.playerSprite.name = @"player";
    self.playerSprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.playerSprite.size];
    self.playerSprite.physicsBody.dynamic = YES;
    self.playerSprite.physicsBody.categoryBitMask = kPlayerCategory;
    self.playerSprite.physicsBody.contactTestBitMask = kBorderEdgeCategory | kKillsPlayerCategory | kHumanCategory;
    self.playerSprite.physicsBody.collisionBitMask = 0;
    self.playerSprite.position = CGPointMake(boardSize.width / 2.0, boardSize.height / 2.0);
    self.playerSprite.hidden = YES;
    
    [self.boardNode addChild:self.playerSprite];
}

- (void)revealPlayer {
    //  There is an animation and a sound for this too, but that will come later
    self.playerSprite.hidden = NO;
    self.playerSprite.texture = [SKTexture textureWithImageNamed:@"PLAYER_STILL"];
    [self.playerSprite implodePlayer];
}

- (void)makeHumansForLevel {
    CGSize boardSize = self.boardNode.frame.size;
    CGRect playerFrame = CGRectInset(self.playerSprite.frame, -50.0, -50.0);
    NSDictionary* levelInfo = self.levelInfo;
    NSUInteger numHumans = [levelInfo[@"humans"] intValue];
    NSUInteger numMoms = [levelInfo[@"moms"] intValue];
    NSUInteger numDads = [levelInfo[@"dads"] intValue];
    NSUInteger numSons = [levelInfo[@"sons"] intValue];
    
    for (NSUInteger i = 0; i < numHumans; ++i) {
        Human* sprite;
        
        switch (i % 3) {
            case 0: // mom
                sprite = [MomHuman humanWithTexture:[self.momAtlas textureNamed:@"STILL"]];
                break;
                
            case 1: // dad
                sprite = [DadHuman humanWithTexture:[self.dadAtlas textureNamed:@"STILL"]];
                break;
                
            case 2: // son
                sprite = [SonHuman humanWithTexture:[self.sonAtlas textureNamed:@"STILL"]];
                break;
        }

        sprite.levelInfo = levelInfo;

        do {
            sprite.position = CGPointMake((arc4random() % (int)boardSize.width), (arc4random() % (int)boardSize.height));
            [self constrainToBoard:sprite];
        } while (CGRectIntersectsRect(playerFrame, sprite.frame));
                
        [self.boardNode addChild:sprite];
    }
    
    for (NSUInteger i = 0; i < numMoms; ++i) {
        Human* sprite = [MomHuman humanWithTexture:[self.momAtlas textureNamed:@"STILL"]];
        sprite.levelInfo = levelInfo;
        
        do {
            sprite.position = CGPointMake((arc4random() % (int)boardSize.width), (arc4random() % (int)boardSize.height));
            [self constrainToBoard:sprite];
        } while (CGRectIntersectsRect(playerFrame, sprite.frame));
        
        [self.boardNode addChild:sprite];
    }

    for (NSUInteger i = 0; i < numDads; ++i) {
        Human* sprite = [DadHuman humanWithTexture:[self.dadAtlas textureNamed:@"STILL"]];
        sprite.levelInfo = levelInfo;
        
        do {
            sprite.position = CGPointMake((arc4random() % (int)boardSize.width), (arc4random() % (int)boardSize.height));
            [self constrainToBoard:sprite];
        } while (CGRectIntersectsRect(playerFrame, sprite.frame));
        
        [self.boardNode addChild:sprite];
    }

    for (NSUInteger i = 0; i < numSons; ++i) {
        Human* sprite = [SonHuman humanWithTexture:[self.sonAtlas textureNamed:@"STILL"]];
        sprite.levelInfo = levelInfo;
        
        do {
            sprite.position = CGPointMake((arc4random() % (int)boardSize.width), (arc4random() % (int)boardSize.height));
            [self constrainToBoard:sprite];
        } while (CGRectIntersectsRect(playerFrame, sprite.frame));
        
        [self.boardNode addChild:sprite];
    }
}

- (void)makeHulksForLevel {
    CGSize boardSize = self.boardNode.frame.size;
    CGRect playerFrame = CGRectInset(self.playerSprite.frame, -50.0, -50.0);
    NSDictionary* levelInfo = self.levelInfo;
    NSUInteger numHulks = [levelInfo[@"hulks"] intValue];
    
    for (NSUInteger i = 0; i < numHulks; ++i) {
        Hulk* sprite = [Hulk hulkWithTexture:[SKTexture textureWithImageNamed:@"HULK_1"]];
        sprite.levelInfo = levelInfo;
        
        do {
            sprite.position = CGPointMake((arc4random() % (int)boardSize.width), (arc4random() % (int)boardSize.height));
            [self constrainToBoard:sprite];
        } while (CGRectIntersectsRect(playerFrame, sprite.frame));
        
        [self.boardNode addChild:sprite];
        if (arc4random() % 2 == 0)
            [sprite implodeHorizontally];
        else
            [sprite implodeVertically];
    }
}

- (void)makeBrainsForLevel {
    CGSize boardSize = self.boardNode.frame.size;
    CGRect playerFrame = CGRectInset(self.playerSprite.frame, -50.0, -50.0);
    NSDictionary* levelInfo = self.levelInfo;
    NSUInteger numBrains = [levelInfo[@"brains"] intValue];
    
    for (NSUInteger i = 0; i < numBrains; ++i) {
        Brain* sprite = [Brain brainWithTexture:[SKTexture textureWithImageNamed:@"BRAIN_STILL"]];
        sprite.levelInfo = levelInfo;
        
        do {
            sprite.position = CGPointMake((arc4random() % (int)boardSize.width), (arc4random() % (int)boardSize.height));
            [self constrainToBoard:sprite];
        } while (CGRectIntersectsRect(playerFrame, sprite.frame));
        
        [self.boardNode addChild:sprite];
        //TODO create "trwinkling animation
    }
}

- (void)makeGruntsForLevel {    
    CGSize boardSize = self.boardNode.frame.size;
    CGRect playerFrame = CGRectInset(self.playerSprite.frame, -60.0, -60.0);
    NSDictionary* levelInfo = self.levelInfo;
    NSUInteger numGrunts = [levelInfo[@"grunts"] intValue];
    
    for (NSUInteger i = 0; i < numGrunts; ++i) {
        Grunt* sprite = [Grunt gruntWithTexture:[SKTexture textureWithImageNamed:@"GRUNT_1"]];
        sprite.levelInfo = levelInfo;
        
        do {
            sprite.position = CGPointMake((arc4random() % (int)boardSize.width), (arc4random() % (int)boardSize.height));
            [self constrainToBoard:sprite];
        } while (CGRectIntersectsRect(playerFrame, sprite.frame));

        [self.boardNode addChild:sprite];
        if (arc4random() % 2 == 0)
            [sprite implodeHorizontallyWithAction:self.gruntAction];
        else
            [sprite implodeVerticallyWithAction:self.gruntAction];
    }
}

- (void)makeElectrodesForLevel {
    CGSize boardSize = self.boardNode.frame.size;
    CGRect playerFrame = CGRectInset(self.playerSprite.frame, -50.0, -50.0);
    NSDictionary* levelInfo = self.levelInfo;
    NSUInteger numElectrods = [levelInfo[@"electrodes"] intValue];
    SKTexture* texture = nil;

    if ([levelInfo[@"electrodeType"] isEqualToString:@"star"])
        texture = [self.electrodeAtlas textureNamed:@"A1"];
    else if ([levelInfo[@"electrodeType"] isEqualToString:@"snowflake"])
        texture = [self.electrodeAtlas textureNamed:@"B1"];
    else if ([levelInfo[@"electrodeType"] isEqualToString:@"square"])
        texture = [self.electrodeAtlas textureNamed:@"C1"];
    else if ([levelInfo[@"electrodeType"] isEqualToString:@"triangle"])
        texture = [self.electrodeAtlas textureNamed:@"D1"];
    else if ([levelInfo[@"electrodeType"] isEqualToString:@"rectangle"])
        texture = [self.electrodeAtlas textureNamed:@"E1"];
    else if ([levelInfo[@"electrodeType"] isEqualToString:@"diamond"])
        texture = [self.electrodeAtlas textureNamed:@"F1"];
    else
        NSAssert1(NO, @"Umknown electrode type '%@'", levelInfo[@"electrodeType"]);
    
    for (NSUInteger i = 0; i < numElectrods; ++i) {
        Electrode* sprite = [Electrode electrodeWithTexture:texture];
        sprite.levelInfo = levelInfo;
        [sprite applyNamedColor:levelInfo[@"electrodeColor"]];

        do {
            sprite.position = CGPointMake((arc4random() % (int)boardSize.width), (arc4random() % (int)boardSize.height));
            [self constrainToBoard:sprite];
        } while (CGRectIntersectsRect(playerFrame, sprite.frame));
                
        [self.boardNode addChild:sprite];
    }
}

- (void)makeSpheroidsForLevel {
    CGSize boardSize = self.boardNode.frame.size;
    CGRect interiorFrame = CGRectInset(CGRectMake(0.0, 0.0, boardSize.width, boardSize.height), 40.0, 40.0);
    NSDictionary* levelInfo = self.levelInfo;
    NSUInteger numSpheroids = self.levelSpheroids > 0 ? [levelInfo[@"spheroids"] intValue] : 0;
    SKTexture* texture = [self.spheroidAtlas textureNamed:@"1"];
    
    for (NSUInteger i = 0; i < numSpheroids; ++i) {
        Spheroid* sprite = [Spheroid spheroidWithTexture:texture];
        sprite.levelInfo = levelInfo;
        
        do {
            sprite.position = CGPointMake((arc4random() % (int)boardSize.width), (arc4random() % (int)boardSize.height));
            [self constrainToBoard:sprite];
        } while (CGRectIntersectsRect(interiorFrame, sprite.frame));
        
        [self.boardNode addChild:sprite];
        [sprite runAction:self.spheroidAction];
    }
}

#if TARGET_OS_IPHONE
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins - this is iOS only at present, but I'll get it working on the Mac at some point. */
    
    if (self.displayLives == 0)
        [self startGame];
    else {
        if (self.isSuspended)
            [self.boardNode enumerateChildNodesWithName:@"paused" usingBlock:^(SKNode *node, BOOL *stop) {
                [node removeFromParent];
            }];
        else {
            SKLabelNode* sprite1 = [SKLabelNode labelNodeWithFontNamed:kGameFont];
            sprite1.position = CGPointMake(CGRectGetMidX(self.boardNode.frame), CGRectGetMidY(self.boardNode.frame));
            sprite1.fontSize = 40.0;
            sprite1.text = @"Tap To Resume";
            sprite1.name = @"paused";
            [sprite1 runAction:[RandomColorCycle1 showNextColor]];
            [self.boardNode addChild:sprite1];
        }
        self.suspended = !self.isSuspended;
    }
}
#elif TARGET_OS_MAC && !TARGET_OS_IPHONE
-(void)mouseDown:(NSEvent *)theEvent {
    /* Called when a mouse click occurs */
    
    if (self.displayLives == 0)
        [self startGame];
    else {
        if (self.isSuspended)
            [self.boardNode enumerateChildNodesWithName:@"paused" usingBlock:^(SKNode *node, BOOL *stop) {
                [node removeFromParent];
            }];
        else {
            SKLabelNode* sprite1 = [SKLabelNode labelNodeWithFontNamed:kGameFont];
            sprite1.position = CGPointMake(CGRectGetMidX(self.boardNode.frame), CGRectGetMidY(self.boardNode.frame));
            sprite1.fontSize = 40.0;
            sprite1.text = @"Tap To Resume";
            sprite1.name = @"paused";
            [sprite1 runAction:[RandomColorCycle1 showNextColor]];
            [self.boardNode addChild:sprite1];
        }
        self.suspended = !self.isSuspended;
    }
}
#endif

- (void)updateProcessCollisions {
    //  Process collisions that hapened since this routine was last called
    for (SKPhysicsContact* contact in self.pendingContacts) {
        SKNode* bodyA = contact.bodyA.node;
        NSUInteger bodyACategoryBitMask = bodyA.physicsBody.categoryBitMask;
        SKNode* bodyB = contact.bodyB.node;
        NSUInteger bodyBCategoryBitMask = bodyB.physicsBody.categoryBitMask;
        
        if (bodyACategoryBitMask & kPlayerCategory &&
            bodyBCategoryBitMask & kKillsPlayerCategory) {
            [self playerHitBy:(BaseSpriteNode*)bodyB];
        }
        else if (bodyBCategoryBitMask & kPlayerCategory &&
                 bodyACategoryBitMask & kKillsPlayerCategory) {
            [self playerHitBy:(BaseSpriteNode*)bodyA];
        }
        else if ((bodyACategoryBitMask & kBulletCategory) &&
                 (bodyBCategoryBitMask & kBorderEdgeCategory)) {
            [(Bullet*)bodyA hitAWall];
        }
        else if ((bodyBCategoryBitMask & kBulletCategory) &&
                 (bodyACategoryBitMask & kBorderEdgeCategory)) {
            [(Bullet*)bodyB hitAWall];
        }
        else if ((bodyBCategoryBitMask & kGruntCategory) &&
                 (bodyACategoryBitMask & kElectrodeCategory)) {
            [(Electrode*)bodyA hitByGrunt:(Grunt*)bodyB];
        }
        else if ((bodyACategoryBitMask & kGruntCategory) &&
                 (bodyBCategoryBitMask & kElectrodeCategory)) {
            [(Electrode*)bodyB hitByGrunt:(Grunt*)bodyA];
        }
        else if ((bodyACategoryBitMask & kBulletCategory) &&
                 (bodyBCategoryBitMask & kCanBeShotCategory)) {
            [(ShootableSpriteNode*) bodyB hitByBullet:(Bullet*)bodyA];
            [(Bullet*)bodyA hitSomething];
        }
        else if ((bodyBCategoryBitMask & kBulletCategory) &&
                 (bodyACategoryBitMask & kCanBeShotCategory)) {
            [(ShootableSpriteNode*) bodyA hitByBullet:(Bullet*)bodyB];
            [(Bullet*)bodyB hitSomething];
        }
        else if ((bodyACategoryBitMask & kHumanCategory) &&
                 (bodyBCategoryBitMask & kPlayerCategory)) {
            [(Human*)bodyA hitByPlayer];
        }
        else if ((bodyBCategoryBitMask & kHumanCategory) &&
                 (bodyACategoryBitMask & kPlayerCategory)) {
            [(Human*)bodyB hitByPlayer];
        }
        else if ((bodyACategoryBitMask & kHumanCategory) &&
                 (bodyBCategoryBitMask & kKillsHumansCategory)) {
            [(Human*) bodyA hitByRobotron:(BaseSpriteNode*)bodyB];
        }
        else if ((bodyBCategoryBitMask & kHumanCategory) &&
                 (bodyACategoryBitMask & kKillsHumansCategory)) {
            [(Human*) bodyB hitByRobotron:(BaseSpriteNode*)bodyA];
        }
    }
    
    [self.pendingContacts removeAllObjects];
}

- (void)updatePlayerMovement:(NSTimeInterval) currentTime {
    if (self.canPlayerMove && !self.isSuspended) {
        CGSize boardSize = self.boardNode.frame.size;
        CGPoint p = self.playerSprite.position;
        
        p.x += kPlayerStepSize * self.moveX * self.playerSpeed;
        p.y += kPlayerStepSize * self.moveY * self.playerSpeed;
        p.x = MAX(0.0, MIN(boardSize.width, p.x));
        p.y = MAX(0.0, MIN(boardSize.height, p.y));
        self.playerSprite.position = p;
        [self constrainToBoard:self.playerSprite];
        
        if (self.moveX != self.lastMoveX || self.moveY != self.lastMoveY) {
            [self.playerSprite removeAllActions];
            
            if (self.moveX == 0 && self.moveY == 0)
                self.playerSprite.texture = [SKTexture textureWithImageNamed:@"PLAYER_STILL"];
            else if (self.moveX < 0)
                [self.playerSprite runAction:self.playerMoveLeftAction];
            else if (self.moveX > 0)
                [self.playerSprite runAction:self.playerMoveRightAction];
            else if (self.moveY < 0)
                [self.playerSprite runAction:self.playerMoveUpAction];
            else if (self.moveY > 0)
                [self.playerSprite runAction:self.playerMoveDownAction];
            
            self.lastMoveX = self.moveX;
            self.lastMoveY = self.moveY;
        }
    }
}

- (void)updatePlayerFiring:(NSTimeInterval) currentTime {
    if (self.isPlaying && !self.isSuspended &&
        (self.fireX != 0 || self.fireY != 0) && self.lastFireTime + kFireInterval <= currentTime) {
        Bullet* bullet;
        CGPoint start = self.playerSprite.position;
        
        if (self.fireX > 0) {
            if (self.fireY > 0) {
                //  Shoot right & up
                bullet = [Bullet bulletWithDeltaX:self.fireX deltaY:self.fireY texture:[self.projectileAtlas textureNamed:@"BLTR"]];
                start.x = CGRectGetMaxX(self.playerSprite.frame);
                start.y = CGRectGetMaxY(self.playerSprite.frame);
            }
            else if (self.fireY < 0) {
                //  Shoot right & down
                bullet = [Bullet bulletWithDeltaX:self.fireX deltaY:self.fireY texture:[self.projectileAtlas textureNamed:@"TLBR"]];
                start.x = CGRectGetMaxX(self.playerSprite.frame);
                start.y = CGRectGetMinY(self.playerSprite.frame);
            }
            else {
                //  Shoot right
                bullet = [Bullet bulletWithDeltaX:self.fireX deltaY:self.fireY texture:[self.projectileAtlas textureNamed:@"LR"]];
                start.x = CGRectGetMaxX(self.playerSprite.frame);
            }
        }
        else if (self.fireX < 0) {
            if (self.fireY > 0) {
                //  Shoot left & up
                bullet = [Bullet bulletWithDeltaX:self.fireX deltaY:self.fireY texture:[self.projectileAtlas textureNamed:@"TLBR"]];
                start.x = CGRectGetMinX(self.playerSprite.frame);
                start.y = CGRectGetMaxY(self.playerSprite.frame);
            }
            else if (self.fireY < 0) {
                //  Shoot left & down
                bullet = [Bullet bulletWithDeltaX:self.fireX deltaY:self.fireY texture:[self.projectileAtlas textureNamed:@"BLTR"]];
                start.x = CGRectGetMinX(self.playerSprite.frame);
                start.y = CGRectGetMinY(self.playerSprite.frame);
            }
            else {
                //  Shoot left
                bullet = [Bullet bulletWithDeltaX:self.fireX deltaY:self.fireY texture:[self.projectileAtlas textureNamed:@"LR"]];
                start.x = CGRectGetMinX(self.playerSprite.frame);
            }
        }
        else {
            if (self.fireY > 0) {
                //  Shoot up
                bullet = [Bullet bulletWithDeltaX:self.fireX deltaY:self.fireY texture:[self.projectileAtlas textureNamed:@"TB"]];
                start.y = CGRectGetMaxY(self.playerSprite.frame);
            }
            else if (self.fireY < 0) {
                //  Shoot down
                bullet = [Bullet bulletWithDeltaX:self.fireX deltaY:self.fireY texture:[self.projectileAtlas textureNamed:@"TB"]];
                start.y = CGRectGetMinY(self.playerSprite.frame);
            }
        }
        
        bullet.position = start;
        [bullet runAction:[SKAction group:@[[SKAction playSoundFileNamed:@"Fire.wav" waitForCompletion:NO],
                                            [SKAction sequence:@[[SKAction moveBy:CGVectorMake(1000 * self.fireX, 1000 * self.fireY) duration:2.0],
                                                                 [SKAction removeFromParent]]]]]];
        [bullet runAction:[SKAction sequence:@[[SKAction moveBy:CGVectorMake(1000 * self.fireX, 1000 * self.fireY) duration:2.0],
                                               [SKAction removeFromParent]]]];
        [self.boardNode addChild:bullet];
        self.lastFireTime = currentTime;
    }
}

- (void)updateHumans:(CFTimeInterval)currentTime {
    if (self.isPlaying) {
        [self.boardNode enumerateChildNodesWithName:@"human"
                                         usingBlock:^(SKNode *node, BOOL *stop) {
                                             [(Human*) node update:currentTime];
                                         }];
    }
}

- (void)updateElectrodes:(CFTimeInterval)currentTime {
    //  Electrodes don't move
}

- (void)updateHulks:(CFTimeInterval)currentTime {
    if (self.isPlaying) {
        [self.boardNode enumerateChildNodesWithName:@"hulk"
                                         usingBlock:^(SKNode *node, BOOL *stop) {
                                             [(Hulk*) node update:currentTime];
                                         }];
    }
}

- (void)updateGrunts:(CFTimeInterval)currentTime {
    if (self.isPlaying) {
        __block NSUInteger numGrunts = 0;
        [self.boardNode enumerateChildNodesWithName:@"grunt"
                                         usingBlock:^(SKNode *node, BOOL *stop) {
                                             [(Grunt*) node update:currentTime];
                                             ++numGrunts;
                                         }];
        self.numGrunts = numGrunts;
    }
}

- (void)updateBrains:(CFTimeInterval)currentTime {
    if (self.isPlaying) {
        __block NSUInteger numBrains = 0;
        [self.boardNode enumerateChildNodesWithName:@"brain"
                                         usingBlock:^(SKNode *node, BOOL *stop) {
                                             [(Grunt*) node update:currentTime];
                                             ++numBrains;
                                         }];
        self.numBrains = numBrains;
    }
}

- (void)updateSpheroids:(CFTimeInterval)currentTime {
    if (self.isPlaying) {
        __block NSUInteger numSpheroids = 0;
        [self.boardNode enumerateChildNodesWithName:@"spheroid"
                                         usingBlock:^(SKNode *node, BOOL *stop) {
                                             [(Spheroid*) node update:currentTime];
                                             ++numSpheroids;
                                         }];
        self.levelSpheroids = self.numSpheroids = numSpheroids;
    }
}

- (void)updateEnforcers:(CFTimeInterval)currentTime {
    if (self.isPlaying) {
        __block NSUInteger numEnforcers = 0;
        [self.boardNode enumerateChildNodesWithName:@"enforcer"
                                         usingBlock:^(SKNode *node, BOOL *stop) {
                                             [(Enforcer*) node update:currentTime];
                                             ++numEnforcers;
                                         }];
        self.numEnforcers = numEnforcers;
    }
}

- (void)uodateEnforcerBullet:(CFTimeInterval)currentTime {
    if (self.isPlaying) {
        [self.boardNode enumerateChildNodesWithName:@"enforcerBullet"
                                         usingBlock:^(SKNode *node, BOOL *stop) {
                                             [(EnforcerBullet*) node update:currentTime];
                                         }];
    }
}

-(void) update:(CFTimeInterval)currentTime {
    [self updateProcessCollisions];
    
    [RandomColorCycle1 updateColor];
    [RandomColorCycle2 updateColor];

    if (!self.isSuspended) {
        //  Only run game logic every 1/15th of a second
        if (currentTime - self.lastUpdateTime >= 1.0 / 15.0) {
            [self updateElectrodes:currentTime];
            [self updateGrunts:currentTime];
            [self updateSpheroids:currentTime];
            [self updateEnforcers:currentTime];
            [self uodateEnforcerBullet:currentTime];
            [self updateHulks:currentTime];
            //[self updateTanks:currentTime];
            //[self updateTankBullets:currentTime];
            //[self updateQuarks:currentTime];
            [self updateBrains:currentTime];
            [self updateHumans:currentTime];
            [self updatePlayerMovement:currentTime];
            [self updatePlayerFiring:currentTime];

            self.lastUpdateTime = currentTime;
            if ((self.displayScore % kBonusLifePoints) > (self.gameScore % kBonusLifePoints)) {
                self.displayLives += 1;
                // Play bonus life sound
            }
            self.displayScore = self.gameScore;
            
            if (self.isPlaying &&
                self.numGrunts == 0 &&
                self.numSpheroids == 0 &&
                self.numEnforcers == 0 &&
                self.numBrains == 0 &&
                self.numQuarks == 0 &&
                self.numTanks == 0) {
                [self startNewLevel];
            }
        }
    }
}

//  SKPhysicsWorldDelegate

- (void)didBeginContact:(SKPhysicsContact *)contact {
    if (self.isPlaying)
        [self.pendingContacts addObject:contact];
}

@end
