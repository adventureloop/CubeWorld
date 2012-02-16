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
    float *origin;
    float size;
    int height;
    
    voxelData *voxelPtr;
}

-(id)initWithTreeHeight:(int)nodeHeight nodeSize:(float)nodeSize orign:(float *)nodeOrigin;
@end
