//
//  ViewController.m
//  SpriteKitTestIOS
//
//  Created by Mark Alldritt on 1/31/2014.
//  Copyright (c) 2014 Late Night Software Ltd. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Configure controllers
    self.moveStick.delegate = self;
    self.fireStick.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleApplicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleApplicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];

    // Configure the view.
    ((SKView*)self.view).showsFPS = YES;
    ((SKView*)self.view).showsNodeCount = YES;
    
    // Create and configure the scene.
    self.gameScene = [MyScene sceneWithSize:((SKView*)self.view).bounds.size];
    self.gameScene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [(SKView*)self.view presentScene:self.gameScene];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)analogueStickDidChangeValue:(JSAnalogueStick *)analogueStick {
    if (analogueStick == self.moveStick) {
        self.gameScene.moveX = ABS(analogueStick.xValue) <= 0.2 ? 0.0 : (analogueStick.xValue > 0.0 ? 1.0 : -1.0);
        self.gameScene.moveY = ABS(analogueStick.yValue) <= 0.2 ? 0.0 : (analogueStick.yValue > 0.0 ? 1.0 : -1.0);
    }
    else if (analogueStick == self.fireStick) {
        self.gameScene.fireX = ABS(analogueStick.xValue) <= 0.2 ? 0.0 : (analogueStick.xValue > 0.0 ? 1.0 : -1.0);
        self.gameScene.fireY = ABS(analogueStick.yValue) <= 0.2 ? 0.0 : (analogueStick.yValue > 0.0 ? 1.0 : -1.0);
    }
}

- (void)handleApplicationWillResignActive:(NSNotification*)note {
    ((SKView*)self.view).paused = YES;
}

- (void)handleApplicationDidBecomeActive:(NSNotification*)note {
    ((SKView*)self.view).paused = NO;
}

@end
