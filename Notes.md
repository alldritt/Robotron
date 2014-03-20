# Robotron Development Notes

This document captures information about how the Robotron game plays.  I'm using this as a scratchpad to capture information that I have or will need to convert into code.

## Game controllers on the Mac

I started out planning to use the Mavericks GameController.framework, but I found that this new Mavericks feature is not compatible with old USB game controllers such as my old LogiTech "Dual Action" controller.  In the end, I went with the [Dave Dribin's DDHidLib](http://www.dribin.org/dave/software/).  So far my Mac code has only been tested with by LogiTech controller.

I have not bothered to implement a keyboard input system as an alternative to the Dual Joystick approach.  This is because the game was originally implemented with joysticks and the keyboard.

## Game controllers on the iPad

Presently, the I am using [JSController](https://github.com/jasarien/JSController) to implement on-screen joysticks in the iPad version.  At some point, I should probably look into using iOS 7's GameController.framework to support physical game controllers once compatible controllers appear on the market.

## Color Cycling

The original Robotron game used hardware color cycling which meant that any sprite that used a cycled color was synchronized with any other sprite using the same cycled color.  In Sprite Kit, my implementation for color cycling relies on Sprite Kit's color blending.  The problem is that each sprite may initiate its color cycle at slightly different times creating synchronization issues.

Also, it would appear that Sprite Kit's color blending depends on sprites having white portions that take the color blend color most easily.  I plan to experiment with this more to see if I can make this simpler.  However, what I have now is good enough to continue on with the project.

## Explosions & Implosions

There is a limitation to SpriteKit that has caused me to move some of my sprites out of SpriteKit Atlases.  The issue is that the `-[SKTexture textureWithRect:...]` call does not work correctly with textures that are loaded from Texture Atlases.  I struggled for a long time to try and work around this problem, but in the end I had to give up and move my textures out of atlases.  Once I did this, all my problems went away.

The tetures that are not stored in atlases are those that explode or implode during the course of the game.  The code that implements these effects reveals the Sprite Kit bug.

## Copyright Issues

The sprite artwork used in this project has been taken from various places around the web.  The audio clips have been taken from Robotron videos on YouTube.   We have to assume that all of this imagery and sound is owned by Williams and its successors, and so cannot really be used.
