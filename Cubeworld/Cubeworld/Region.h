//
//  Region.h
//  Cubeworld
//
//  Created by Tom Jones on 29/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChunkLowMem.h"
#import "ChunkManager.h"
#import "MatrixStack.h"
#import <OpenGL/gl.h>
#import "ChunkManager.h"

#import "ResourceManager.h"

/*!
 * @class Region
 * @abstract Rendering management of on screen view
 * @discussion Region Class controls the definition of the on screen view space 
 * renders only the immediate area around the users position.
 */
@interface Region : NSObject
{
    NSMutableArray *chunks;
    
    ChunkManager *chunkManager;
    vec3 focusPoint;
    
    MatrixStack *modelMatrix;
    
    GLuint program;
    GLuint modelMatrixUnif;
    GLuint transLocationUnif;
    
    float offsetX,offsetZ;
    
    ResourceManager *resourceManager;
}
@property float renderDistance;
/*!
 * @function initWithMatrixUnifLocation
 * @discussion initialise the region with the required shader locations.
 */
-(id)initWithMatrixUnifLocation:(GLuint) unifLocation translationLocation:(GLuint) transLoc program:(GLuint) programLocation;

/*!
 * @function render
 * @discussion Translates and requests chunks around the users location.
 */
-(void)render;

/*!
 * @discussion Updates the focus position.
 */
-(void)updateWithFocusPoint:(vec3 *)point;

/*!
 * @discussion Moves the focus position by x and z offset values.
 */
-(void)moveX:(float)x Z:(float)z;

-(void)serialize;
@end
