//
//  Octnode.m
//  Cubeworld
//
//  Created by Tom Jones on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Octnode.h"

@implementation Octnode

-(id)initWithTreeHeight:(int)nodeHeight nodeSize:(float)nodeSize orign:(vec4 *)nodeOrigin memoryPointer:(void *)mem
{
    if(self = [super init]) {
        height = nodeHeight;
        size = nodeSize;
        
        origin.x = nodeOrigin->x;
        origin.y = nodeOrigin->y;
        origin.z = nodeOrigin->z;
        origin.w = nodeOrigin->w;
        
        voxelPtr = mem;
        
        if(size)
            [self createSubnodes];
        else
            [self addVoxelData];
        
    }
    return self;
}

-(void)createSubnodes
{
    return;
}

-(void)addVoxelData
{
    voxelData *tmp = calloc(1,sizeof(voxelData));
    
    float offset = size/2;
    
    //Face 1
    //Vertex 1
    tmp->face1.vertex1.v.x = origin.x - offset;
    tmp->face1.vertex1.v.y = origin.y + offset;
    tmp->face1.vertex1.v.z = origin.z + offset;
    tmp->face1.vertex1.v.w = 0.0f;
    
    tmp->face1.vertex1.c.red = 1.0f;
    tmp->face1.vertex1.c.green = 1.0f;
    tmp->face1.vertex1.c.blue = 1.0f;
    tmp->face1.vertex1.c.alpha = 1.0f;
    
    tmp->face1.vertex1.n.x = 1.0f;
    tmp->face1.vertex1.n.y = 1.0f;
    tmp->face1.vertex1.n.z = 1.0f;
    
    //Vertex 2
    tmp->face1.vertex2.v.x = origin.x + offset;
    tmp->face1.vertex2.v.y = origin.y + offset;
    tmp->face1.vertex2.v.z = origin.z + offset;
    tmp->face1.vertex2.v.w = 0.0f;
    
    tmp->face1.vertex2.c.red = 1.0f;
    tmp->face1.vertex2.c.green = 1.0f;
    tmp->face1.vertex2.c.blue = 1.0f;
    tmp->face1.vertex2.c.alpha = 1.0f;
    
    tmp->face1.vertex2.n.x = 1.0f;
    tmp->face1.vertex2.n.y = 1.0f;
    tmp->face1.vertex2.n.z = 1.0f;
    
    //Vertex 3
    tmp->face1.vertex3.v.x = origin.x + offset;
    tmp->face1.vertex3.v.y = origin.y - offset;
    tmp->face1.vertex3.v.z = origin.z + offset;
    tmp->face1.vertex3.v.w = 0.0f;
    
    tmp->face1.vertex3.c.red = 1.0f;
    tmp->face1.vertex3.c.green = 1.0f;
    tmp->face1.vertex3.c.blue = 1.0f;
    tmp->face1.vertex3.c.alpha = 1.0f;
    
    tmp->face1.vertex3.n.x = 1.0f;
    tmp->face1.vertex3.n.y = 1.0f;
    tmp->face1.vertex3.n.z = 1.0f;
    
    //Vertex 4
    tmp->face1.vertex4.v.x = origin.x - offset;
    tmp->face1.vertex4.v.y = origin.y - offset;
    tmp->face1.vertex4.v.z = origin.z + offset;
    tmp->face1.vertex4.v.w = 0.0f;
    
    tmp->face1.vertex4.c.red = 1.0f;
    tmp->face1.vertex4.c.green = 1.0f;
    tmp->face1.vertex4.c.blue = 1.0f;
    tmp->face1.vertex4.c.alpha = 1.0f;
    
    tmp->face1.vertex4.n.x = 1.0f;
    tmp->face1.vertex4.n.y = 1.0f;
    tmp->face1.vertex4.n.z = 1.0f;
    
    //Face 2
    //Vertex 1
    tmp->face2.vertex1.v.x = origin.x - offset;
    tmp->face2.vertex1.v.y = origin.y + offset;
    tmp->face2.vertex1.v.z = origin.z - offset;
    tmp->face2.vertex1.v.w = 0.0f;
    
    tmp->face2.vertex1.c.red = 1.0f;
    tmp->face2.vertex1.c.green = 1.0f;
    tmp->face2.vertex1.c.blue = 1.0f;
    tmp->face2.vertex1.c.alpha = 1.0f;
    
    tmp->face2.vertex1.n.x = 1.0f;
    tmp->face2.vertex1.n.y = 1.0f;
    tmp->face2.vertex1.n.z = 1.0f;
    
    //Vertex 2
    tmp->face2.vertex2.v.x = origin.x + offset;
    tmp->face2.vertex2.v.y = origin.y + offset;
    tmp->face2.vertex2.v.z = origin.z - offset;
    tmp->face2.vertex2.v.w = 0.0f;
    
    tmp->face2.vertex2.c.red = 1.0f;
    tmp->face2.vertex2.c.green = 1.0f;
    tmp->face2.vertex2.c.blue = 1.0f;
    tmp->face2.vertex2.c.alpha = 1.0f;
    
    tmp->face2.vertex2.n.x = 1.0f;
    tmp->face2.vertex2.n.y = 1.0f;
    tmp->face2.vertex2.n.z = 1.0f;
    
    //Vertex 3
    tmp->face2.vertex3.v.x = origin.x + offset;
    tmp->face2.vertex3.v.y = origin.y - offset;
    tmp->face2.vertex3.v.z = origin.z - offset;
    tmp->face2.vertex3.v.w = 0.0f;
    
    tmp->face2.vertex3.c.red = 1.0f;
    tmp->face2.vertex3.c.green = 1.0f;
    tmp->face2.vertex3.c.blue = 1.0f;
    tmp->face2.vertex3.c.alpha = 1.0f;
    
    tmp->face2.vertex3.n.x = 1.0f;
    tmp->face2.vertex3.n.y = 1.0f;
    tmp->face2.vertex3.n.z = 1.0f;
    
    //Vertex 4
    tmp->face2.vertex4.v.x = origin.x - offset;
    tmp->face2.vertex4.v.y = origin.y - offset;
    tmp->face2.vertex4.v.z = origin.z - offset;
    tmp->face2.vertex4.v.w = 0.0f;
    
    tmp->face2.vertex4.c.red = 1.0f;
    tmp->face2.vertex4.c.green = 1.0f;
    tmp->face2.vertex4.c.blue = 1.0f;
    tmp->face2.vertex4.c.alpha = 1.0f;
    
    tmp->face2.vertex4.n.x = 1.0f;
    tmp->face2.vertex4.n.y = 1.0f;
    tmp->face2.vertex4.n.z = 1.0f; 
    
    //Face 3
    //Vertex 1
    tmp->face3.vertex1.v.x = origin.x - offset;
    tmp->face3.vertex1.v.y = origin.y + offset;
    tmp->face3.vertex1.v.z = origin.z + offset;
    tmp->face3.vertex1.v.w = 0.0f;
    
    tmp->face3.vertex1.c.red = 1.0f;
    tmp->face3.vertex1.c.green = 1.0f;
    tmp->face3.vertex1.c.blue = 1.0f;
    tmp->face3.vertex1.c.alpha = 1.0f;
    
    tmp->face3.vertex1.n.x = 1.0f;
    tmp->face3.vertex1.n.y = 1.0f;
    tmp->face3.vertex1.n.z = 1.0f;
    
    //Vertex 2
    tmp->face3.vertex2.v.x = origin.x - offset;
    tmp->face3.vertex2.v.y = origin.y - offset;
    tmp->face3.vertex2.v.z = origin.z + offset;
    tmp->face3.vertex2.v.w = 0.0f;
    
    tmp->face3.vertex2.c.red = 1.0f;
    tmp->face3.vertex2.c.green = 1.0f;
    tmp->face3.vertex2.c.blue = 1.0f;
    tmp->face3.vertex2.c.alpha = 1.0f;
    
    tmp->face3.vertex2.n.x = 1.0f;
    tmp->face3.vertex2.n.y = 1.0f;
    tmp->face3.vertex2.n.z = 1.0f;
    
    //Vertex 3
    tmp->face3.vertex3.v.x = origin.x - offset;
    tmp->face3.vertex3.v.y = origin.y + offset;
    tmp->face3.vertex3.v.z = origin.z - offset;
    tmp->face3.vertex3.v.w = 0.0f;
    
    tmp->face3.vertex3.c.red = 1.0f;
    tmp->face3.vertex3.c.green = 1.0f;
    tmp->face3.vertex3.c.blue = 1.0f;
    tmp->face3.vertex3.c.alpha = 1.0f;
    
    tmp->face3.vertex3.n.x = 1.0f;
    tmp->face3.vertex3.n.y = 1.0f;
    tmp->face3.vertex3.n.z = 1.0f;
    
    //Vertex 4
    tmp->face3.vertex4.v.x = origin.x - offset;
    tmp->face3.vertex4.v.y = origin.y - offset;
    tmp->face3.vertex4.v.z = origin.z - offset;
    tmp->face3.vertex4.v.w = 0.0f;
    
    tmp->face3.vertex4.c.red = 1.0f;
    tmp->face3.vertex4.c.green = 1.0f;
    tmp->face3.vertex4.c.blue = 1.0f;
    tmp->face3.vertex4.c.alpha = 1.0f;
    
    tmp->face3.vertex4.n.x = 1.0f;
    tmp->face3.vertex4.n.y = 1.0f;
    tmp->face3.vertex4.n.z = 1.0f; 
    
    //Face 4
    //Vertex 1
    tmp->face4.vertex1.v.x = origin.x + offset;
    tmp->face4.vertex1.v.y = origin.y + offset;
    tmp->face4.vertex1.v.z = origin.z + offset;
    tmp->face4.vertex1.v.w = 0.0f;
    
    tmp->face4.vertex1.c.red = 1.0f;
    tmp->face4.vertex1.c.green = 1.0f;
    tmp->face4.vertex1.c.blue = 1.0f;
    tmp->face4.vertex1.c.alpha = 1.0f;
    
    tmp->face4.vertex1.n.x = 1.0f;
    tmp->face4.vertex1.n.y = 1.0f;
    tmp->face4.vertex1.n.z = 1.0f;
    
    //Vertex 2
    tmp->face4.vertex2.v.x = origin.x + offset;
    tmp->face4.vertex2.v.y = origin.y - offset;
    tmp->face4.vertex2.v.z = origin.z + offset;
    tmp->face4.vertex2.v.w = 0.0f;
    
    tmp->face4.vertex2.c.red = 1.0f;
    tmp->face4.vertex2.c.green = 1.0f;
    tmp->face4.vertex2.c.blue = 1.0f;
    tmp->face4.vertex2.c.alpha = 1.0f;
    
    tmp->face4.vertex2.n.x = 1.0f;
    tmp->face4.vertex2.n.y = 1.0f;
    tmp->face4.vertex2.n.z = 1.0f;
    
    //Vertex 3
    tmp->face4.vertex3.v.x = origin.x + offset;
    tmp->face4.vertex3.v.y = origin.y + offset;
    tmp->face4.vertex3.v.z = origin.z - offset;
    tmp->face4.vertex3.v.w = 0.0f;
    
    tmp->face4.vertex3.c.red = 1.0f;
    tmp->face4.vertex3.c.green = 1.0f;
    tmp->face4.vertex3.c.blue = 1.0f;
    tmp->face4.vertex3.c.alpha = 1.0f;
    
    tmp->face4.vertex3.n.x = 1.0f;
    tmp->face4.vertex3.n.y = 1.0f;
    tmp->face4.vertex3.n.z = 1.0f;
    
    //Vertex 4
    tmp->face4.vertex4.v.x = origin.x + offset;
    tmp->face4.vertex4.v.y = origin.y - offset;
    tmp->face4.vertex4.v.z = origin.z - offset;
    tmp->face4.vertex4.v.w = 0.0f;
    
    tmp->face4.vertex4.c.red = 1.0f;
    tmp->face4.vertex4.c.green = 1.0f;
    tmp->face4.vertex4.c.blue = 1.0f;
    tmp->face4.vertex4.c.alpha = 1.0f;
    
    tmp->face4.vertex4.n.x = 1.0f;
    tmp->face4.vertex4.n.y = 1.0f;
    tmp->face4.vertex4.n.z = 1.0f; 
    
    //Face 5
    //Vertex 1
    tmp->face5.vertex1.v.x = origin.x - offset;
    tmp->face5.vertex1.v.y = origin.y + offset;
    tmp->face5.vertex1.v.z = origin.z + offset;
    tmp->face5.vertex1.v.w = 0.0f;
    
    tmp->face5.vertex1.c.red = 1.0f;
    tmp->face5.vertex1.c.green = 1.0f;
    tmp->face5.vertex1.c.blue = 1.0f;
    tmp->face5.vertex1.c.alpha = 1.0f;
    
    tmp->face5.vertex1.n.x = 1.0f;
    tmp->face5.vertex1.n.y = 1.0f;
    tmp->face5.vertex1.n.z = 1.0f;
    
    //Vertex 2
    tmp->face5.vertex2.v.x = origin.x + offset;
    tmp->face5.vertex2.v.y = origin.y + offset;
    tmp->face5.vertex2.v.z = origin.z + offset;
    tmp->face5.vertex2.v.w = 0.0f;
    
    tmp->face5.vertex2.c.red = 1.0f;
    tmp->face5.vertex2.c.green = 1.0f;
    tmp->face5.vertex2.c.blue = 1.0f;
    tmp->face5.vertex2.c.alpha = 1.0f;
    
    tmp->face5.vertex2.n.x = 1.0f;
    tmp->face5.vertex2.n.y = 1.0f;
    tmp->face5.vertex2.n.z = 1.0f;
    
    //Vertex 3
    tmp->face5.vertex3.v.x = origin.x - offset;
    tmp->face5.vertex3.v.y = origin.y + offset;
    tmp->face5.vertex3.v.z = origin.z - offset;
    tmp->face5.vertex3.v.w = 0.0f;
    
    tmp->face5.vertex3.c.red = 1.0f;
    tmp->face5.vertex3.c.green = 1.0f;
    tmp->face5.vertex3.c.blue = 1.0f;
    tmp->face5.vertex3.c.alpha = 1.0f;
    
    tmp->face5.vertex3.n.x = 1.0f;
    tmp->face5.vertex3.n.y = 1.0f;
    tmp->face5.vertex3.n.z = 1.0f;
    
    //Vertex 4
    tmp->face5.vertex4.v.x = origin.x + offset;
    tmp->face5.vertex4.v.y = origin.y + offset;
    tmp->face5.vertex4.v.z = origin.z - offset;
    tmp->face5.vertex4.v.w = 0.0f;
    
    tmp->face5.vertex4.c.red = 1.0f;
    tmp->face5.vertex4.c.green = 1.0f;
    tmp->face5.vertex4.c.blue = 1.0f;
    tmp->face5.vertex4.c.alpha = 1.0f;
    
    tmp->face5.vertex4.n.x = 1.0f;
    tmp->face5.vertex4.n.y = 1.0f;
    tmp->face5.vertex4.n.z = 1.0f; 
    
    //Face 6
    //Vertex 1
    tmp->face6.vertex1.v.x = origin.x - offset;
    tmp->face6.vertex1.v.y = origin.y - offset;
    tmp->face6.vertex1.v.z = origin.z + offset;
    tmp->face6.vertex1.v.w = 0.0f;
    
    tmp->face6.vertex1.c.red = 1.0f;
    tmp->face6.vertex1.c.green = 1.0f;
    tmp->face6.vertex1.c.blue = 1.0f;
    tmp->face6.vertex1.c.alpha = 1.0f;
    
    tmp->face6.vertex1.n.x = 1.0f;
    tmp->face6.vertex1.n.y = 1.0f;
    tmp->face6.vertex1.n.z = 1.0f;
    
    //Vertex 2
    tmp->face6.vertex2.v.x = origin.x + offset;
    tmp->face6.vertex2.v.y = origin.y - offset;
    tmp->face6.vertex2.v.z = origin.z + offset;
    tmp->face6.vertex2.v.w = 0.0f;
    
    tmp->face6.vertex2.c.red = 1.0f;
    tmp->face6.vertex2.c.green = 1.0f;
    tmp->face6.vertex2.c.blue = 1.0f;
    tmp->face6.vertex2.c.alpha = 1.0f;
    
    tmp->face6.vertex2.n.x = 1.0f;
    tmp->face6.vertex2.n.y = 1.0f;
    tmp->face6.vertex2.n.z = 1.0f;
    
    //Vertex 3
    tmp->face6.vertex3.v.x = origin.x - offset;
    tmp->face6.vertex3.v.y = origin.y - offset;
    tmp->face6.vertex3.v.z = origin.z - offset;
    tmp->face6.vertex3.v.w = 0.0f;
    
    tmp->face6.vertex3.c.red = 1.0f;
    tmp->face6.vertex3.c.green = 1.0f;
    tmp->face6.vertex3.c.blue = 1.0f;
    tmp->face6.vertex3.c.alpha = 1.0f;
    
    tmp->face6.vertex3.n.x = 1.0f;
    tmp->face6.vertex3.n.y = 1.0f;
    tmp->face6.vertex3.n.z = 1.0f;
    
    //Vertex 4
    tmp->face6.vertex4.v.x = origin.x + offset;
    tmp->face6.vertex4.v.y = origin.y - offset;
    tmp->face6.vertex4.v.z = origin.z - offset;
    tmp->face6.vertex4.v.w = 0.0f;
    
    tmp->face6.vertex4.c.red = 1.0f;
    tmp->face6.vertex4.c.green = 1.0f;
    tmp->face6.vertex4.c.blue = 1.0f;
    tmp->face6.vertex4.c.alpha = 1.0f;
    
    tmp->face6.vertex4.n.x = 1.0f;
    tmp->face6.vertex4.n.y = 1.0f;
    tmp->face6.vertex4.n.z = 1.0f; 
    
}
@end
