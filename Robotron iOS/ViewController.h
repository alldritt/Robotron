//
//  ViewController.h
//  SpriteKitTestIOS
//

//  Copyright (c) 2014 Late Night Software Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "JSAnalogueStick.h"
#import "MyScene.h"

@interface ViewController : UIViewController <JSAnalogueStickDelegate>

@property (assign, nonatomic) IBOutlet JSAnalogueStick* moveStick;
@property (assign, nonatomic) IBOutlet JSAnalogueStick* fireStick;
@property (strong, nonatomic) MyScene* gameScene;

@end
