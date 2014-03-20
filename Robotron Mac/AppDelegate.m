//
//  AppDelegate.m
//  Robotron
//
//  Created by Mark Alldritt on 2/9/2014.
//  Copyright (c) 2014 Late Night Software Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "MyScene.h"
#import <DDHidLib/DDHidLib.h>


@interface AppDelegate ()

@property (strong, nonatomic) MyScene* gameScene;
@property (strong, nonatomic) NSArray* joysticks;

@end

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    /* Pick a size for the scene */
    self.gameScene = [MyScene sceneWithSize:CGSizeMake(1024, 768)];

    /* Set the scale mode to scale to fit the window */
    self.gameScene.scaleMode = SKSceneScaleModeAspectFit;

    [self.skView presentScene:self.gameScene];

    // Configure the view.
    self.skView.showsFPS = YES;
    self.skView.showsNodeCount = YES;
    
    self.joysticks = [DDHidJoystick allJoysticks];
    [self.joysticks makeObjectsPerformSelector:@selector(setDelegate:) withObject:self];
    [self.joysticks makeObjectsPerformSelector:@selector(startListening) withObject:nil];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

- (void) ddhidJoystick: (DDHidJoystick *) joystick
                 stick: (unsigned) stick
              xChanged: (int) value {
    value = value / 16000;
    
    if (value == 0)
        self.gameScene.moveX = 0;
    else if (value < 0)
        self.gameScene.moveX = -1;
    else
        self.gameScene.moveX = 1;
}

- (void) ddhidJoystick: (DDHidJoystick *) joystick
                 stick: (unsigned) stick
              yChanged: (int) value {
    value = value / 16000;
    
    if (value == 0)
        self.gameScene.moveY = 0;
    else if (value > 0)
        self.gameScene.moveY = -1;
    else
        self.gameScene.moveY = 1;
}

- (void) ddhidJoystick: (DDHidJoystick *) joystick
                 stick: (unsigned) stick
             otherAxis: (unsigned) otherAxis
          valueChanged: (int) value {
    value = value / 16000;

    if (otherAxis == 0) {
        if (value == 0)
            self.gameScene.fireX = 0;
        else if (value < 0)
            self.gameScene.fireX = -1;
        else
            self.gameScene.fireX = 1;
    }
    else if (otherAxis == 1) {
        if (value == 0)
            self.gameScene.fireY = 0;
        else if (value > 0)
            self.gameScene.fireY = -1;
        else
            self.gameScene.fireY = 1;
    }
}

- (void) ddhidJoystick: (DDHidJoystick *) joystick
                 stick: (unsigned) stick
             povNumber: (unsigned) povNumber
          valueChanged: (int) value {
    //NSLog(@"ddhidJoystick: %@ stick: %d povNumber: %d valueChanged: %d", joystick, stick, povNumber, value);
}

- (void) ddhidJoystick: (DDHidJoystick *) joystick
            buttonDown: (unsigned) buttonNumber {
    //NSLog(@"ddhidJoystick: %@ buttonDown: %d", joystick, buttonNumber);
    //  On my Logitech Dual Action game controller, buttons 10 and 11 happen when either of the joysticks
    //  are pressed down which happens accepdently too often, so I'm disabling them here.

    if (buttonNumber != 10 &&
        buttonNumber != 11)
        [self.gameScene mouseDown:nil];
}

- (void) ddhidJoystick: (DDHidJoystick *) joystick
              buttonUp: (unsigned) buttonNumber {
    //NSLog(@"ddhidJoystick: %@ buttonUp: %d", joystick, buttonNumber);
}

@end
