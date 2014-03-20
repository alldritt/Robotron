//
//  SKSpriteNode+Robotron.h
//  ExplodingTest
//
//  Created by Mark Alldritt on 2014-03-05.
//  Copyright (c) 2014 Late Night Software Ltd. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


@interface SKSpriteNode (Robotron)

- (void)explodeVertically;
- (void)explodeHorizontally;
- (void)explodeHorizontallyAndVertically;
- (void)explodeBLTR;
- (void)explodeTLBR;
- (void)implodeVertically;
- (void)implodeVerticallyWithAction:(SKAction*) action;
- (void)implodeHorizontally;
- (void)implodeHorizontallyWithAction:(SKAction*) action;
- (void)implodePlayer;

- (void)applyNamedColor:(NSString*)color;

@end
