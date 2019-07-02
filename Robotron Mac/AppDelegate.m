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
#import <GameController/GameController.h>


@interface AppDelegate ()

@property (strong, nonatomic) MyScene* gameScene;
@property (strong, nonatomic) NSArray* joysticks;
@property (strong, nonatomic) GCController* controller;

@end

@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    /* Pick a size for the scene */
    self.gameScene = [[MyScene alloc] initWithSize:CGSizeMake(1024, 768) withVisualController:FALSE];

    /* Set the scale mode to scale to fit the window */
    self.gameScene.scaleMode = SKSceneScaleModeAspectFit;

    [self.skView presentScene:self.gameScene];

    // Configure the view.
    self.skView.showsFPS = YES;
    self.skView.showsNodeCount = YES;

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
    if (self.controller) return;
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
    if (self.controller) return;
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
    if (self.controller) return;
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
    if (self.controller) return;
    //NSLog(@"ddhidJoystick: %@ stick: %d povNumber: %d valueChanged: %d", joystick, stick, povNumber, value);
}

- (void) ddhidJoystick: (DDHidJoystick *) joystick
            buttonDown: (unsigned) buttonNumber {
    if (self.controller) return;
    //NSLog(@"ddhidJoystick: %@ buttonDown: %d", joystick, buttonNumber);
    //  On my Logitech Dual Action game controller, buttons 10 and 11 happen when either of the joysticks
    //  are pressed down which happens accepdently too often, so I'm disabling them here.

    if (buttonNumber != 10 &&
        buttonNumber != 11)
        [self.gameScene mouseDown:nil];
}

- (void) ddhidJoystick: (DDHidJoystick *) joystick
              buttonUp: (unsigned) buttonNumber {
    if (self.controller) return;
    //NSLog(@"ddhidJoystick: %@ buttonUp: %d", joystick, buttonNumber);
}

//  MARK: GCController callbacks

- (void) connectToController:(GCController*) controller {
    if (self.controller) {
        [self disconnectController:self.controller];
    }
    
    self.controller = controller;
    
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
}

- (void) disconnectController:(GCController*) controller {
    self.controller.extendedGamepad.leftThumbstick.valueChangedHandler = nil;
    self.controller.extendedGamepad.rightThumbstick.valueChangedHandler = nil;
    self.controller.extendedGamepad.buttonX.pressedChangedHandler = nil;
    self.controller.extendedGamepad.buttonY.pressedChangedHandler = nil;
    self.controller.extendedGamepad.buttonA.pressedChangedHandler = nil;
    self.controller.extendedGamepad.buttonB.pressedChangedHandler = nil;
    self.controller = nil;
    
}

@end
