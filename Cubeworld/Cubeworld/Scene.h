//
//  Scene.h
//  Cubeworld
//
//  Created by Tom Jones on 07/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <OpenGL/gl.h>
#import <Carbon/Carbon.h>

/*!
 * @abstract UI scene class that provides skeleton functionality
 */ 
@interface Scene : NSObject
{
    NSTimer *animationTimer;
}

/*!
 * @discussion Create a new scene with given bounds.
 */
-(id)initWithBounds:(CGRect) newBounds;

/*!
 * @discussion start the animation loop for the scene
 */
-(void)startAnimating;

/*!
 * @discussion Stop the animation loop for the scene.
 */
-(void)stopAnimating;

/*!
 * @discussion Update the scenes components using their update logic.
 */
-(void)update;

/*!
 * @discussion Draw the content of the scene.
 */
-(void)render;

/*!
 * @discussion Configure OpenGL for the scene.
 */
-(void)setupOpenGL;

/*!
 * @discussion Hooks into window resizes.
 */ 
-(void)didResizeTo:(CGRect)newBounds;

/*!
 * @discussion Handle key down event.
 */ 
-(void)keyDown:(int)keyCode;

/*!
 * @discussion Hangle key up event.
 */
-(void)keyUp:(int)keyCode;

/*!
 * @discussion Receive mouse events.
 */
-(void)mouseMovedByX:(int)x Y:(int)y;

@property CGRect bounds;
@end
