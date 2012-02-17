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
    
    float *vertexData;
    unsigned int *indexArray;
}
-(id)initWithNumberOfTrees:(int)trees treeHeight:(int)treeHeight;

-(void)render;
-(int)voxelsToRender;
@end
