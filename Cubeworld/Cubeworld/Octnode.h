//
//  Octnode.h
//  Cubeworld
//
//  Created by Tom Jones on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Structures.h"

@interface Octnode : NSObject
{
    id nodes[8];
    vec4 origin;
    colour ncolour;
    float size;
    int height;
    
    voxelData *voxelPtr;
}

-(id)initWithTreeHeight:(int)nodeHeight nodeSize:(float)nodeSize orign:(vec4 *)nodeOrigin memoryPointer:(void *)mem;
-(void)createSubnodes;
-(void)addVoxelData;
@end
