//
//  BoardScene.m
//  Robotron
//
//  Created by Mark Alldritt on 2/10/2014.
//  Copyright (c) 2014 Late Night Software Ltd. All rights reserved.
//

#import "GameMetrics.h"
#import "BoardScene.h"
#import "ColorCycle2.h"
#import "RandomColorCycle1.h"
#import "SKColor+Robotron.h"
#import "SKShapeNode+Robotron.h"


@interface BoardScene ()

@property (strong, nonatomic) SKLabelNode* scoreLabel;
@property (strong, nonatomic) SKLabelNode* levelLabel;
@property (strong, nonatomic) SKLabelNode* waveLabel;
@property (strong, nonatomic) SKSpriteNode* lives1;
@property (strong, nonatomic) SKSpriteNode* lives2;
@property (strong, nonatomic) SKSpriteNode* lives3;
@property (strong, nonatomic) SKSpriteNode* lives4;
@property (strong, nonatomic) SKSpriteNode* lives5;
@property (strong, nonatomic) SKSpriteNode* lives6;
@property (strong, nonatomic) SKSpriteNode* lives7;
@property (strong, nonatomic) SKSpriteNode* lives8;
@property (strong, nonatomic) SKSpriteNode* lives9;
@property (strong, nonatomic) SKSpriteNode* lives10;
@property (strong, nonatomic) SKAction* textColorCycleAction;

@end

@implementation BoardScene

- (void)_setup:(BOOL) hasVisualController {
    CGFloat bottomBorder = hasVisualController ? kBottomBorderForVisualController : kBottomBorder;
    
    CGRect frame = CGRectMake(0.0, 0.0, self.frame.size.width - kLeftBorder - kRightBorder, self.frame.size.height - kTopBorder - bottomBorder);
    
    //  Create the border rectangle
    CGMutablePathRef pathToDraw = CGPathCreateMutable();
    CGPathMoveToPoint(pathToDraw, NULL, CGRectGetMinX(frame), CGRectGetMinY(frame));
    CGPathAddLineToPoint(pathToDraw, NULL, CGRectGetMaxX(frame), CGRectGetMinY(frame));
    CGPathAddLineToPoint(pathToDraw, NULL, CGRectGetMaxX(frame), CGRectGetMaxY(frame));
    CGPathAddLineToPoint(pathToDraw, NULL, CGRectGetMinX(frame), CGRectGetMaxY(frame));
    CGPathAddLineToPoint(pathToDraw, NULL, CGRectGetMinX(frame), CGRectGetMinY(frame));
    
    _boardNode = [[SKShapeNode alloc] init];
    self.boardNode.name = @"border";
    self.boardNode.path = pathToDraw;
    self.boardNode.strokeColor = [SKColor robotronRedColor];
    self.boardNode.lineWidth = 1.0;
    self.boardNode.position = CGPointMake(kLeftBorder, bottomBorder);
    [self addChild:self.boardNode];
    self.boardNode.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:frame];
    self.boardNode.physicsBody.dynamic = YES;
    self.boardNode.physicsBody.categoryBitMask = kBorderEdgeCategory;
    self.boardNode.physicsBody.collisionBitMask = 0;

    //  Create the score display
    NSString* s = [NSString stringWithFormat:@"%02d", (int)self.displayScore];
#if TARGET_OS_IPHONE
    CGSize size = [s sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:kGameFont size:kGameFontSize]}];
#elif TARGET_OS_MAC && !TARGET_OS_IPHONE
    CGSize size = [s sizeWithAttributes:@{NSFontAttributeName:[NSFont fontWithName:kGameFont size:kGameFontSize]}];
#endif
    self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:kGameFont];
    self.scoreLabel.fontSize = kGameFontSize;
    self.scoreLabel.text = s;
    self.scoreLabel.position = CGPointMake(self.frame.size.width / 2.0 - size.width, self.frame.size.height - kTopBorder + 8.0);
    [self.scoreLabel runAction:[RandomColorCycle1 showNextColor]];
    [self addChild:self.scoreLabel];
    
    //  Create the lives display
    
    CGFloat lifeX = self.frame.size.width / 2.0 + 10.0;

    self.lives1 = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"PLAYER_STILL"]];
    self.lives1.position = CGPointMake(lifeX, self.frame.size.height - kTopBorder + 16.0);
    [self addChild:self.lives1];
    lifeX += self.lives1.size.width + 5.0;

    self.lives2 = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"PLAYER_STILL"]];
    self.lives2.position = CGPointMake(lifeX, self.frame.size.height - kTopBorder + 16.0);
    [self addChild:self.lives2];
    lifeX += self.lives2.size.width + 5.0;

    self.lives3 = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"PLAYER_STILL"]];
    self.lives3.position = CGPointMake(lifeX, self.frame.size.height - kTopBorder + 16.0);
    [self addChild:self.lives3];
    lifeX += self.lives3.size.width + 5.0;

    self.lives4 = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"PLAYER_STILL"]];
    self.lives4.position = CGPointMake(lifeX, self.frame.size.height - kTopBorder + 16.0);
    [self addChild:self.lives4];
    lifeX += self.lives4.size.width + 5.0;
    
    self.lives5 = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"PLAYER_STILL"]];
    self.lives5.position = CGPointMake(lifeX, self.frame.size.height - kTopBorder + 16.0);
    [self addChild:self.lives5];
    lifeX += self.lives5.size.width + 5.0;
    
    self.lives6 = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"PLAYER_STILL"]];
    self.lives6.position = CGPointMake(lifeX, self.frame.size.height - kTopBorder + 16.0);
    [self addChild:self.lives6];
    lifeX += self.lives6.size.width + 5.0;
    
    self.lives7 = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"PLAYER_STILL"]];
    self.lives7.position = CGPointMake(lifeX, self.frame.size.height - kTopBorder + 16.0);
    [self addChild:self.lives7];
    lifeX += self.lives7.size.width + 5.0;
    
    self.lives8 = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"PLAYER_STILL"]];
    self.lives8.position = CGPointMake(lifeX, self.frame.size.height - kTopBorder + 16.0);
    [self addChild:self.lives8];
    lifeX += self.lives8.size.width + 5.0;
    
    self.lives9 = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"PLAYER_STILL"]];
    self.lives9.position = CGPointMake(lifeX, self.frame.size.height - kTopBorder + 16.0);
    [self addChild:self.lives9];
    lifeX += self.lives9.size.width + 5.0;
    
    self.lives10 = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"PLAYER_STILL"]];
    self.lives10.position = CGPointMake(lifeX, self.frame.size.height - kTopBorder + 16.0);
    [self addChild:self.lives10];
    lifeX += self.lives10.size.width + 5.0;
    
    //  Create the wave display
    self.waveLabel = [SKLabelNode labelNodeWithFontNamed:kGameFont];
    self.waveLabel.fontSize = kGameFontSize;
    self.waveLabel.text = @"WAVE";
    self.waveLabel.position = CGPointMake(self.size.width / 2.0 + 10.0, bottomBorder - 25.0);
    [self.waveLabel runAction:[ColorCycle2 colorCycle]];
    [self addChild:self.waveLabel];

    self.levelLabel = [SKLabelNode labelNodeWithFontNamed:kGameFont];
    self.levelLabel.fontSize = kGameFontSize;
    self.levelLabel.text = [NSString stringWithFormat:@"%d", (int)self.displayLevel];
    self.levelLabel.position = CGPointMake(self.size.width / 2.0 - 50.0, bottomBorder - 25.0);
    [self.levelLabel runAction:[RandomColorCycle1 showNextColor]];
    [self addChild:self.levelLabel];
    _displayLives = -1;
    self.displayLives = 0;

    self.backgroundColor = [SKColor robotronBlackColor];
}

- (instancetype)initWithSize:(CGSize) size withVisualController:(BOOL) hasVisualController {
    if ((self = [super initWithSize:size])) {
        [self _setup:hasVisualController];
    }
    return self;
}

- (void)setDisplayScore:(NSUInteger)score {
    if (self.displayScore != score) {
        NSString* s = [NSString stringWithFormat:@"%d", (int)score];
#if TARGET_OS_IPHONE
        CGSize size = [s sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:kGameFont size:kGameFontSize]}];
#elif TARGET_OS_MAC && !TARGET_OS_IPHONE
        CGSize size = [s sizeWithAttributes:@{NSFontAttributeName:[NSFont fontWithName:kGameFont size:kGameFontSize]}];
#endif

        self.scoreLabel.text = s;
        self.scoreLabel.position = CGPointMake(self.frame.size.width / 2.0 - size.width, self.frame.size.height - kTopBorder + 8.0);
        _displayScore = score;
    }
}

- (void)setDisplayLevel:(NSUInteger)level {
    if (self.displayLevel != level) {
        _displayLevel = level;

        self.levelLabel.text = [NSString stringWithFormat:@"%5d", (int)level];
        [self.boardNode applyNamedColor:self.levelInfo[@"color"]];
    }
}

- (NSDictionary*) levelInfo {
    static NSDictionary* sLevels = nil;
    
    if (!sLevels)
        sLevels = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"levels" withExtension:@"plist"]];
    NSParameterAssert(sLevels);
    
    NSArray* levels = sLevels[@"levels"];
    NSUInteger index = (self.displayLevel - 1) % levels.count; // displayLevel is one-based while array indexes are zero-based
    
    return levels[index];
}

- (void)setDisplayLives:(NSUInteger)lives {
    if (self.displayLives != lives) {
        self.lives1.texture =
        self.lives2.texture =
        self.lives3.texture =
        self.lives4.texture =
        self.lives5.texture =
        self.lives6.texture =
        self.lives7.texture =
        self.lives8.texture =
        self.lives9.texture =
        self.lives10.texture = nil;
        
        if (lives > 0)
            self.lives1.texture = [SKTexture textureWithImageNamed:@"PLAYER_STILL"];
        if (lives > 1)
            self.lives2.texture = [SKTexture textureWithImageNamed:@"PLAYER_STILL"];
        if (lives > 2)
            self.lives3.texture = [SKTexture textureWithImageNamed:@"PLAYER_STILL"];
        if (lives > 3)
            self.lives4.texture = [SKTexture textureWithImageNamed:@"PLAYER_STILL"];
        if (lives > 4)
            self.lives5.texture = [SKTexture textureWithImageNamed:@"PLAYER_STILL"];
        if (lives > 5)
            self.lives6.texture = [SKTexture textureWithImageNamed:@"PLAYER_STILL"];
        if (lives > 6)
            self.lives7.texture = [SKTexture textureWithImageNamed:@"PLAYER_STILL"];
        if (lives > 7)
            self.lives8.texture = [SKTexture textureWithImageNamed:@"PLAYER_STILL"];
        if (lives > 8)
            self.lives9.texture = [SKTexture textureWithImageNamed:@"PLAYER_STILL"];
        if (lives > 9)
            self.lives10.texture = [SKTexture textureWithImageNamed:@"PLAYER_STILL"];
        
        _displayLives = lives;
    }
}

- (CGRect) playArea {
    CGRect r = self.boardNode.frame;

    return CGRectOffset(r, -r.origin.x, -r.origin.y);
}

@end
