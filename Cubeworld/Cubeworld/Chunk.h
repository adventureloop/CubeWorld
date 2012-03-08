//
//  Chunk.h
//  Cubeworld
//
//  Created by Tom Jones on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Octnode.h"

@interface Chunk : NSObject
{
    GLuint vertexBufferObject;
    GLuint vertexArrayObject;
    GLuint indexBufferObject;
    
    Octnode *node;
    NSMutableArray *nodes;
    
    float *vertexData;
    unsigned int *indexArray;
    int *tmpIndexArray;
    
    int trees;
    int treeHeight;
    float nodeSize;
    float chunkWidth;
    
    vec3 origin;
}
-(id)initWithNumberOfTrees:(int)ntrees treeHeight:(int)ntreeHeight;

-(void)render;
-(int)voxelsToRender;
-(vec3 *)origin;
-(void)setOrigin:(vec3 *)newOrigin;

-(void)update;

-(BOOL)updateBlockType:(int) type forPoint:(vec3 *)point;
-(BOOL)updateBlockType:(int)type forX:(float)x Y:(float)y Z:(float)z;
-(bool)collidesWithPoint:(vec3 *)point;
@end
