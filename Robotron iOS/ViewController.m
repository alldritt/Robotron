//
//  ViewController.m
//  SpriteKitTestIOS
//
//  Created by Mark Alldritt on 1/31/2014.
//  Copyright (c) 2014 Late Night Software Ltd. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
#import <GameController/GameController.h>


@interface ViewController ()

@property (strong, nonatomic) GCController* controller;

@end

@implementation ViewController

- (SKView*)sceneView {
    return (SKView*)self.view;
}

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

    [[NSNotificationCenter defaultCenter] addObserverForName:GCControllerDidConnectNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification* note) {
                                                      GCController* controller = (GCController*) note.object;
                                                      GCExtendedGamepad* gamepad = controller.extendedGamepad;
                                                      
                                                      if (gamepad)
                                                          [self connectToController:controller];
                                                  }];
    [[NSNotificationCenter defaultCenter] addObserverForName:GCControllerDidDisconnectNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification* note) {
                                                      GCController* controller = (GCController*) note.object;
                                                      
                                                      if (self.controller == controller)
                                                          [self disconnectController:controller];
                                                  }];
    
    [GCController startWirelessControllerDiscoveryWithCompletionHandler:^{
        NSLog(@"controllers: %@", [GCController controllers]);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Configure the view.
    SKView* view = self.sceneView;
    
    view.showsFPS = YES;
    view.showsNodeCount = YES;
    
    NSLog(@"self.view.frame: %@", NSStringFromCGRect(self.view.frame));
    
    // Create and configure the scene.
    self.gameScene = [[MyScene alloc] initWithSize:view.bounds.size withVisualController:TRUE];
    self.gameScene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [(SKView*)self.view presentScene:self.gameScene];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskLandscape;
    } else {
        return UIInterfaceOrientationMaskLandscape;
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
    self.sceneView.paused = YES;
}

- (void)handleApplicationDidBecomeActive:(NSNotification*)note {
    self.sceneView.paused = NO;
}


//  MARK: GCController callbacks

- (void) connectToController:(GCController*) controller {
    if (self.controller) {
        [self disconnectController:self.controller];
    }
    
    self.controller = controller;
    self.moveStick.hidden = true;
    self.fireStick.hidden = true;

    
    controller.extendedGamepad.leftThumbstick.valueChangedHandler = ^(GCControllerDirectionPad * dpad, float xValue, float yValue) {
        //  Move stick
        self.gameScene.moveX = ABS(xValue) <= 0.15 ? 0.0 : (xValue > 0.0 ? 1.0 : -1.0);
        self.gameScene.moveY = ABS(yValue) <= 0.15 ? 0.0 : (yValue > 0.0 ? 1.0 : -1.0);
    };
    controller.extendedGamepad.rightThumbstick.valueChangedHandler = ^(GCControllerDirectionPad * dpad, float xValue, float yValue) {
        //  Fire stick
        self.gameScene.fireX = ABS(xValue) <= 0.15 ? 0.0 : (xValue > 0.0 ? 1.0 : -1.0);
        self.gameScene.fireY = ABS(yValue) <= 0.15 ? 0.0 : (yValue > 0.0 ? 1.0 : -1.0);
    };
    controller.extendedGamepad.buttonX.pressedChangedHandler = ^(GCControllerButtonInput* button, float value, BOOL pressed) {
        if (pressed) {
            [self.gameScene togglePaused];
        }
    };
    controller.extendedGamepad.buttonY.pressedChangedHandler = ^(GCControllerButtonInput* button, float value, BOOL pressed) {
        if (pressed) {
            [self.gameScene togglePaused];
        }
    };
    controller.extendedGamepad.buttonA.pressedChangedHandler = ^(GCControllerButtonInput* button, float value, BOOL pressed) {
        if (pressed) {
            [self.gameScene togglePaused];
        }
    };
    controller.extendedGamepad.buttonB.pressedChangedHandler = ^(GCControllerButtonInput* button, float value, BOOL pressed) {
        if (pressed) {
            [self.gameScene togglePaused];
        }
    };

    // Create and configure the scene.
    self.gameScene = [[MyScene alloc] initWithSize:self.sceneView.bounds.size withVisualController:FALSE];
    self.gameScene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [self.sceneView presentScene:self.gameScene];
}

- (void) disconnectController:(GCController*) controller {
    self.controller.extendedGamepad.leftThumbstick.valueChangedHandler = nil;
    self.controller.extendedGamepad.rightThumbstick.valueChangedHandler = nil;
    self.controller = nil;
    
    self.moveStick.hidden = false;
    self.fireStick.hidden = false;

    // Create and configure the scene.
    self.gameScene = [[MyScene alloc] initWithSize:self.sceneView.bounds.size withVisualController:TRUE];
    self.gameScene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [self.sceneView presentScene:self.gameScene];
}

@end

