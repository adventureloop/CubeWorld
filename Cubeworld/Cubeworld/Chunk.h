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
    
    vec3 origin;
}
-(id)initWithNumberOfTrees:(int)ntrees treeHeight:(int)ntreeHeight;

-(void)render;
-(int)voxelsToRender;
-(vec3 *)origin;
-(void)setOrigin:(vec3 *)newOrigin;

-(void)update;
@end
