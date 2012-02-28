//
//  Octnode.m
//  Cubeworld
//
//  Created by Tom Jones on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Octnode.h"

@implementation Octnode

-(id)initWithTreeHeight:(unsigned int)nodeHeight nodeSize:(float)nodeSize orign:(vec4 *)nodeOrigin memoryPointer:(void *)mem
{
    if(self = [super init]) {
        height = nodeHeight;
        size = nodeSize;
        
        origin.x = nodeOrigin->x;
        origin.y = nodeOrigin->y;
        origin.z = nodeOrigin->z;
        origin.w = nodeOrigin->w;
        voxelPtr = mem;
        
        if(height > 0)
            [self createSubnodes];
        else
            [self addVoxelData];
        
    }
    return self;
}

-(void)createSubnodes
{
   // NSLog(@"Creating subnodes");
    
    vec4 newOrigin,offsetVec;
    float scale = size/4;
    int newHeight = height-1;
    float newSize = size/2;
    voxelData *memPtr = voxelPtr;
    int offset = ((int)pow(8.0, height)) / 8;
    
    nodes = [[NSMutableArray alloc]init];
    
    //Top Nodes
    //Back left
    offsetVec.x = -1.0;
    offsetVec.y = 1.0;
    offsetVec.z = -1.0;
    
    [self calculateNewOrigin:&newOrigin OldOrigin:&origin offsetVec:&offsetVec scale:scale];
    [nodes addObject:[[Octnode alloc]initWithTreeHeight:newHeight nodeSize:newSize orign:&newOrigin memoryPointer:memPtr]];
    
    //Adjust the memory pointer to the next 8th of data.
    memPtr += offset;
    
    //Back Right
    offsetVec.x = 1.0;
    offsetVec.y = 1.0;
    offsetVec.z = -1.0;
    
    [self calculateNewOrigin:&newOrigin OldOrigin:&origin offsetVec:&offsetVec scale:scale];
    [nodes addObject:[[Octnode alloc]initWithTreeHeight:newHeight nodeSize:newSize orign:&newOrigin memoryPointer:memPtr]];
    
    memPtr += offset;
    
    //Front left
    offsetVec.x = -1.0;
    offsetVec.y = 1.0;
    offsetVec.z = 1.0;
    
    [self calculateNewOrigin:&newOrigin OldOrigin:&origin offsetVec:&offsetVec scale:scale];
    [nodes addObject:[[Octnode alloc]initWithTreeHeight:newHeight nodeSize:newSize orign:&newOrigin memoryPointer:memPtr]];
    
    memPtr += offset;
    
    //Front right
    offsetVec.x = 1.0;
    offsetVec.y = 1.0;
    offsetVec.z = 1.0;
    
    [self calculateNewOrigin:&newOrigin OldOrigin:&origin offsetVec:&offsetVec scale:scale];
    [nodes addObject:[[Octnode alloc]initWithTreeHeight:newHeight nodeSize:newSize orign:&newOrigin memoryPointer:memPtr]];
    
    //Bottom Nodes
    memPtr += offset;
    
    //Back left
    offsetVec.x = -1.0;
    offsetVec.y = -1.0;
    offsetVec.z = -1.0;
    
    [self calculateNewOrigin:&newOrigin OldOrigin:&origin offsetVec:&offsetVec scale:scale];
    [nodes addObject:[[Octnode alloc]initWithTreeHeight:newHeight nodeSize:newSize orign:&newOrigin memoryPointer:memPtr]];
    
    memPtr += offset;
    
    //Front left
    offsetVec.x = 1.0;
    offsetVec.y = -1.0;
    offsetVec.z = -1.0;
    
    [self calculateNewOrigin:&newOrigin OldOrigin:&origin offsetVec:&offsetVec scale:scale];
    [nodes addObject:[[Octnode alloc]initWithTreeHeight:newHeight nodeSize:newSize orign:&newOrigin memoryPointer:memPtr]];
    
    memPtr += offset;
    
    //Front Right
    offsetVec.x = -1.0;
    offsetVec.y = -1.0;
    offsetVec.z = 1.0;
    
    [self calculateNewOrigin:&newOrigin OldOrigin:&origin offsetVec:&offsetVec scale:scale];
    [nodes addObject:[[Octnode alloc]initWithTreeHeight:newHeight nodeSize:newSize orign:&newOrigin memoryPointer:memPtr]];
        
    memPtr += offset;
    
    //Back Right
    offsetVec.x = 1.0;
    offsetVec.y = -1.0;
    offsetVec.z = 1.0;
    
    [self calculateNewOrigin:&newOrigin OldOrigin:&origin offsetVec:&offsetVec scale:scale];
    [nodes addObject:[[Octnode alloc]initWithTreeHeight:newHeight nodeSize:newSize orign:&newOrigin memoryPointer:memPtr]];
    return;
}


//Add the voxel data for this part of the tree to the VBO
-(void)addVoxelData
{
   // NSLog(@"Adding data to voxel array at orign (%f,%f,%f)",origin.x,origin.y,origin.z);
    voxelData *tmp = calloc(1,sizeof(voxelData));
    
    float offset = size/2;
    
    //Face 1
    //Vertex 1
    tmp->face1.vertex1.v.x = origin.x - offset;
    tmp->face1.vertex1.v.y = origin.y + offset;
    tmp->face1.vertex1.v.z = origin.z + offset;
    tmp->face1.vertex1.v.w = 1.0f;
    
    tmp->face1.vertex1.c.red = 1.0f;
    tmp->face1.vertex1.c.green = 1.0f;
    tmp->face1.vertex1.c.blue = 1.0f;
    tmp->face1.vertex1.c.alpha = 1.0f;
    
    tmp->face1.vertex1.n.x = 0.0f;
    tmp->face1.vertex1.n.y = 0.0f;
    tmp->face1.vertex1.n.z = -1.0f;
    
    //Vertex 2
    tmp->face1.vertex2.v.x = origin.x + offset;
    tmp->face1.vertex2.v.y = origin.y + offset;
    tmp->face1.vertex2.v.z = origin.z + offset;
    tmp->face1.vertex2.v.w = 1.0f;
    
    tmp->face1.vertex2.c.red = 1.0f;
    tmp->face1.vertex2.c.green = 1.0f;
    tmp->face1.vertex2.c.blue = 1.0f;
    tmp->face1.vertex2.c.alpha = 1.0f;
    
    tmp->face1.vertex2.n.x = 0.0f;
    tmp->face1.vertex2.n.y = 0.0f;
    tmp->face1.vertex2.n.z = -1.0f;
    
    //Vertex 3
    tmp->face1.vertex3.v.x = origin.x + offset;
    tmp->face1.vertex3.v.y = origin.y - offset;
    tmp->face1.vertex3.v.z = origin.z + offset;
    tmp->face1.vertex3.v.w = 1.0f;
    
    tmp->face1.vertex3.c.red = 1.0f;
    tmp->face1.vertex3.c.green = 1.0f;
    tmp->face1.vertex3.c.blue = 1.0f;
    tmp->face1.vertex3.c.alpha = 1.0f;
    
    tmp->face1.vertex3.n.x = 0.0f;
    tmp->face1.vertex3.n.y = 0.0f;
    tmp->face1.vertex3.n.z = -1.0f;
    
    //Vertex 4
    tmp->face1.vertex4.v.x = origin.x - offset;
    tmp->face1.vertex4.v.y = origin.y - offset;
    tmp->face1.vertex4.v.z = origin.z + offset;
    tmp->face1.vertex4.v.w = 1.0f;
    
    tmp->face1.vertex4.c.red = 1.0f;
    tmp->face1.vertex4.c.green = 1.0f;
    tmp->face1.vertex4.c.blue = 1.0f;
    tmp->face1.vertex4.c.alpha = 1.0f;
    
    tmp->face1.vertex4.n.x = 0.0f;
    tmp->face1.vertex4.n.y = 0.0f;
    tmp->face1.vertex4.n.z = -1.0f;
    
    //Face 2
    //Vertex 1
    tmp->face2.vertex1.v.x = origin.x - offset;
    tmp->face2.vertex1.v.y = origin.y - offset;
    tmp->face2.vertex1.v.z = origin.z - offset;
    tmp->face2.vertex1.v.w = 1.0f;
    
    tmp->face2.vertex1.c.red = 1.0f;
    tmp->face2.vertex1.c.green = 1.0f;
    tmp->face2.vertex1.c.blue = 1.0f;
    tmp->face2.vertex1.c.alpha = 1.0f;
    
    tmp->face2.vertex1.n.x = 0.0f;
    tmp->face2.vertex1.n.y = 0.0f;
    tmp->face2.vertex1.n.z = 1.0f;
    
    //Vertex 2
    tmp->face2.vertex2.v.x = origin.x + offset;
    tmp->face2.vertex2.v.y = origin.y - offset;
    tmp->face2.vertex2.v.z = origin.z - offset;
    tmp->face2.vertex2.v.w = 1.0f;
    
    tmp->face2.vertex2.c.red = 1.0f;
    tmp->face2.vertex2.c.green = 1.0f;
    tmp->face2.vertex2.c.blue = 1.0f;
    tmp->face2.vertex2.c.alpha = 1.0f;
    
    tmp->face2.vertex2.n.x = 0.0f;
    tmp->face2.vertex2.n.y = 0.0f;
    tmp->face2.vertex2.n.z = 1.0f;
    
    //Vertex 3
    tmp->face2.vertex3.v.x = origin.x + offset;
    tmp->face2.vertex3.v.y = origin.y + offset;
    tmp->face2.vertex3.v.z = origin.z - offset;
    tmp->face2.vertex3.v.w = 1.0f;
    
    tmp->face2.vertex3.c.red = 1.0f;
    tmp->face2.vertex3.c.green = 1.0f;
    tmp->face2.vertex3.c.blue = 1.0f;
    tmp->face2.vertex3.c.alpha = 1.0f;
    
    tmp->face2.vertex3.n.x = 0.0f;
    tmp->face2.vertex3.n.y = 0.0f;
    tmp->face2.vertex3.n.z = 1.0f;
    
    //Vertex 4
    tmp->face2.vertex4.v.x = origin.x - offset;
    tmp->face2.vertex4.v.y = origin.y + offset;
    tmp->face2.vertex4.v.z = origin.z - offset;
    tmp->face2.vertex4.v.w = 1.0f;
    
    tmp->face2.vertex4.c.red = 1.0f;
    tmp->face2.vertex4.c.green = 1.0f;
    tmp->face2.vertex4.c.blue = 1.0f;
    tmp->face2.vertex4.c.alpha = 1.0f;
    
    tmp->face2.vertex4.n.x = 0.0f;
    tmp->face2.vertex4.n.y = 0.0f;
    tmp->face2.vertex4.n.z = 1.0f; 
    
    //Face 3
    //Vertex 1
    tmp->face3.vertex1.v.x = origin.x - offset;
    tmp->face3.vertex1.v.y = origin.y + offset;
    tmp->face3.vertex1.v.z = origin.z - offset;
    tmp->face3.vertex1.v.w = 1.0f;
    
    tmp->face3.vertex1.c.red = 1.0f;
    tmp->face3.vertex1.c.green = 1.0f;
    tmp->face3.vertex1.c.blue = 1.0f;
    tmp->face3.vertex1.c.alpha = 1.0f;
    
    tmp->face3.vertex1.n.x = -1.0f;
    tmp->face3.vertex1.n.y = 0.0f;
    tmp->face3.vertex1.n.z = 0.0f;
    
    //Vertex 2
    tmp->face3.vertex2.v.x = origin.x - offset;
    tmp->face3.vertex2.v.y = origin.y + offset;
    tmp->face3.vertex2.v.z = origin.z + offset;
    tmp->face3.vertex2.v.w = 1.0f;
    
    tmp->face3.vertex2.c.red = 1.0f;
    tmp->face3.vertex2.c.green = 1.0f;
    tmp->face3.vertex2.c.blue = 1.0f;
    tmp->face3.vertex2.c.alpha = 1.0f;
    
    tmp->face3.vertex2.n.x = -1.0f;
    tmp->face3.vertex2.n.y = 0.0f;
    tmp->face3.vertex2.n.z = 0.0f;
    
    //Vertex 3
    tmp->face3.vertex3.v.x = origin.x - offset;
    tmp->face3.vertex3.v.y = origin.y - offset;
    tmp->face3.vertex3.v.z = origin.z + offset;
    tmp->face3.vertex3.v.w = 1.0f;
    
    tmp->face3.vertex3.c.red = 1.0f;
    tmp->face3.vertex3.c.green = 1.0f;
    tmp->face3.vertex3.c.blue = 1.0f;
    tmp->face3.vertex3.c.alpha = 1.0f;
    
    tmp->face3.vertex3.n.x = -1.0f;
    tmp->face3.vertex3.n.y = 0.0f;
    tmp->face3.vertex3.n.z = 0.0f;
    
    //Vertex 4
    tmp->face3.vertex4.v.x = origin.x - offset;
    tmp->face3.vertex4.v.y = origin.y - offset;
    tmp->face3.vertex4.v.z = origin.z - offset;
    tmp->face3.vertex4.v.w = 1.0f;
    
    tmp->face3.vertex4.c.red = 1.0f;
    tmp->face3.vertex4.c.green = 1.0f;
    tmp->face3.vertex4.c.blue = 1.0f;
    tmp->face3.vertex4.c.alpha = 1.0f;
    
    tmp->face3.vertex4.n.x = -1.0f;
    tmp->face3.vertex4.n.y = 0.0f;
    tmp->face3.vertex4.n.z = 0.0f; 
    
    //Face 4
    //Vertex 1
    tmp->face4.vertex1.v.x = origin.x + offset;
    tmp->face4.vertex1.v.y = origin.y + offset;
    tmp->face4.vertex1.v.z = origin.z + offset;
    tmp->face4.vertex1.v.w = 1.0f;
    
    tmp->face4.vertex1.c.red = 1.0f;
    tmp->face4.vertex1.c.green = 1.0f;
    tmp->face4.vertex1.c.blue = 1.0f;
    tmp->face4.vertex1.c.alpha = 1.0f;
    
    tmp->face4.vertex1.n.x = 1.0f;
    tmp->face4.vertex1.n.y = 0.0f;
    tmp->face4.vertex1.n.z = 0.0f;
    
    //Vertex 2
    tmp->face4.vertex2.v.x = origin.x + offset;
    tmp->face4.vertex2.v.y = origin.y + offset;
    tmp->face4.vertex2.v.z = origin.z - offset;
    tmp->face4.vertex2.v.w = 1.0f;
    
    tmp->face4.vertex2.c.red = 1.0f;
    tmp->face4.vertex2.c.green = 1.0f;
    tmp->face4.vertex2.c.blue = 1.0f;
    tmp->face4.vertex2.c.alpha = 1.0f;
    
    tmp->face4.vertex2.n.x = 1.0f;
    tmp->face4.vertex2.n.y = 0.0f;
    tmp->face4.vertex2.n.z = 0.0f;
    
    //Vertex 3
    tmp->face4.vertex3.v.x = origin.x + offset;
    tmp->face4.vertex3.v.y = origin.y - offset;
    tmp->face4.vertex3.v.z = origin.z - offset;
    tmp->face4.vertex3.v.w = 1.0f;
    
    tmp->face4.vertex3.c.red = 1.0f;
    tmp->face4.vertex3.c.green = 1.0f;
    tmp->face4.vertex3.c.blue = 1.0f;
    tmp->face4.vertex3.c.alpha = 1.0f;
    
    tmp->face4.vertex3.n.x = 1.0f;
    tmp->face4.vertex3.n.y = 0.0f;
    tmp->face4.vertex3.n.z = 0.0f;
    
    //Vertex 4
    tmp->face4.vertex4.v.x = origin.x + offset;
    tmp->face4.vertex4.v.y = origin.y - offset;
    tmp->face4.vertex4.v.z = origin.z + offset;
    tmp->face4.vertex4.v.w = 1.0f;
    
    tmp->face4.vertex4.c.red = 1.0f;
    tmp->face4.vertex4.c.green = 1.0f;
    tmp->face4.vertex4.c.blue = 1.0f;
    tmp->face4.vertex4.c.alpha = 1.0f;
    
    tmp->face4.vertex4.n.x = 1.0f;
    tmp->face4.vertex4.n.y = 0.0f;
    tmp->face4.vertex4.n.z = 0.0f; 
    
    //Face 5
    //Vertex 1
    tmp->face5.vertex1.v.x = origin.x - offset;
    tmp->face5.vertex1.v.y = origin.y + offset;
    tmp->face5.vertex1.v.z = origin.z - offset;
    tmp->face5.vertex1.v.w = 1.0f;
    
    tmp->face5.vertex1.c.red = 1.0f;
    tmp->face5.vertex1.c.green = 1.0f;
    tmp->face5.vertex1.c.blue = 1.0f;
    tmp->face5.vertex1.c.alpha = 1.0f;
    
    tmp->face5.vertex1.n.x = 0.0f;
    tmp->face5.vertex1.n.y = 1.0f;
    tmp->face5.vertex1.n.z = 0.0f;
    
    //Vertex 2
    tmp->face5.vertex2.v.x = origin.x + offset;
    tmp->face5.vertex2.v.y = origin.y + offset;
    tmp->face5.vertex2.v.z = origin.z - offset;
    tmp->face5.vertex2.v.w = 1.0f;
    
    tmp->face5.vertex2.c.red = 1.0f;
    tmp->face5.vertex2.c.green = 1.0f;
    tmp->face5.vertex2.c.blue = 1.0f;
    tmp->face5.vertex2.c.alpha = 1.0f;
    
    tmp->face5.vertex2.n.x = 0.0f;
    tmp->face5.vertex2.n.y = 1.0f;
    tmp->face5.vertex2.n.z = 0.0f;
    
    //Vertex 3
    tmp->face5.vertex3.v.x = origin.x + offset;
    tmp->face5.vertex3.v.y = origin.y + offset;
    tmp->face5.vertex3.v.z = origin.z + offset;
    tmp->face5.vertex3.v.w = 1.0f;
    
    tmp->face5.vertex3.c.red = 1.0f;
    tmp->face5.vertex3.c.green = 1.0f;
    tmp->face5.vertex3.c.blue = 1.0f;
    tmp->face5.vertex3.c.alpha = 1.0f;
    
    tmp->face5.vertex3.n.x = 0.0f;
    tmp->face5.vertex3.n.y = 1.0f;
    tmp->face5.vertex3.n.z = 0.0f;
    
    //Vertex 4
    tmp->face5.vertex4.v.x = origin.x - offset;
    tmp->face5.vertex4.v.y = origin.y + offset;
    tmp->face5.vertex4.v.z = origin.z + offset;
    tmp->face5.vertex4.v.w = 1.0f;
    
    tmp->face5.vertex4.c.red = 1.0f;
    tmp->face5.vertex4.c.green = 1.0f;
    tmp->face5.vertex4.c.blue = 1.0f;
    tmp->face5.vertex4.c.alpha = 1.0f;
    
    tmp->face5.vertex4.n.x = 0.0f;
    tmp->face5.vertex4.n.y = 1.0f;
    tmp->face5.vertex4.n.z = 0.0f; 
    
    //Face 6
    //Vertex 1
    tmp->face6.vertex1.v.x = origin.x - offset;
    tmp->face6.vertex1.v.y = origin.y - offset;
    tmp->face6.vertex1.v.z = origin.z + offset;
    tmp->face6.vertex1.v.w = 1.0f;
    
    tmp->face6.vertex1.c.red = 1.0f;
    tmp->face6.vertex1.c.green = 1.0f;
    tmp->face6.vertex1.c.blue = 1.0f;
    tmp->face6.vertex1.c.alpha = 1.0f;
    
    tmp->face6.vertex1.n.x = 0.0f;
    tmp->face6.vertex1.n.y = -1.0f;
    tmp->face6.vertex1.n.z = 0.0f;
    
    //Vertex 2
    tmp->face6.vertex2.v.x = origin.x + offset;
    tmp->face6.vertex2.v.y = origin.y - offset;
    tmp->face6.vertex2.v.z = origin.z + offset;
    tmp->face6.vertex2.v.w = 1.0f;
    
    tmp->face6.vertex2.c.red = 1.0f;
    tmp->face6.vertex2.c.green = 1.0f;
    tmp->face6.vertex2.c.blue = 1.0f;
    tmp->face6.vertex2.c.alpha = 1.0f;
    
    tmp->face6.vertex2.n.x = 0.0f;
    tmp->face6.vertex2.n.y = -1.0f;
    tmp->face6.vertex2.n.z = 0.0f;
    
    //Vertex 3
    tmp->face6.vertex3.v.x = origin.x + offset;
    tmp->face6.vertex3.v.y = origin.y - offset;
    tmp->face6.vertex3.v.z = origin.z - offset;
    tmp->face6.vertex3.v.w = 1.0f;
    
    tmp->face6.vertex3.c.red = 1.0f;
    tmp->face6.vertex3.c.green = 1.0f;
    tmp->face6.vertex3.c.blue = 1.0f;
    tmp->face6.vertex3.c.alpha = 1.0f;
    
    tmp->face6.vertex3.n.x = 0.0f;
    tmp->face6.vertex3.n.y = -1.0f;
    tmp->face6.vertex3.n.z = 0.0f;
    
    //Vertex 4
    tmp->face6.vertex4.v.x = origin.x - offset;
    tmp->face6.vertex4.v.y = origin.y - offset;
    tmp->face6.vertex4.v.z = origin.z - offset;
    tmp->face6.vertex4.v.w = 1.0f;
    
    tmp->face6.vertex4.c.red = 1.0f;
    tmp->face6.vertex4.c.green = 1.0f;
    tmp->face6.vertex4.c.blue = 1.0f;
    tmp->face6.vertex4.c.alpha = 1.0f;
    
    tmp->face6.vertex4.n.x = 0.0f;
    tmp->face6.vertex4.n.y = -1.0f;
    tmp->face6.vertex4.n.z = 0.0f;
    
    
    //Copy tmp data into the vbo ptr provided
    memcpy(voxelPtr,tmp,sizeof(voxelData));
}

-(void)renderElements:(unsigned int *)elements offset:(unsigned int)offset
{
    if(height > 0) {
        unsigned int *memPtr = elements;
        int memOffset = (((int)pow(8.0, height)) / 8) * 36;
        int indexOffset =  (((int)pow(8.0, height)) / 8) * 24;
        
        for(Octnode *n in nodes) {
            [n renderElements:memPtr offset:offset];
            memPtr += memOffset;
            offset = offset + indexOffset;
            
        }
    } else {
        int i = 0;
        unsigned int *nelements = calloc(36, sizeof(unsigned int));
        
        //Face 1
        nelements[i++] = 0;
        nelements[i++] = 1;
        nelements[i++] = 2;
        
        nelements[i++] = 2;
        nelements[i++] = 3;
        nelements[i++] = 0;
        
        //Face 2
        nelements[i++] = 4;
        nelements[i++] = 5;
        nelements[i++] = 6;
        
        nelements[i++] = 6;
        nelements[i++] = 7;
        nelements[i++] = 4;
        
        //Face 3
        nelements[i++] = 8;
        nelements[i++] = 9;
        nelements[i++] = 10;
        
        nelements[i++] = 10;
        nelements[i++] = 11;
        nelements[i++] = 8;
        
        //Face 4
        nelements[i++] = 12;
        nelements[i++] = 13;
        nelements[i++] = 14;
        
        nelements[i++] = 14;
        nelements[i++] = 15;
        nelements[i++] = 12;
        
        //Face 5
        nelements[i++] = 16;
        nelements[i++] = 17;
        nelements[i++] = 18;
        
        nelements[i++] = 18;
        nelements[i++] = 19;
        nelements[i++] = 16;
        
        
        //Face 6
        nelements[i++] = 20;
        nelements[i++] = 21;
        nelements[i++] = 22;
        
        nelements[i++] = 22;
        nelements[i++] = 23;
        nelements[i++] = 20;
        
        for(i = 0;i < 36;i++)
            nelements[i] += offset;
        
        memcpy(elements, nelements, sizeof(unsigned int) * 36);
        
        free(nelements);
    }
}

-(void)updateColours:(colour *)newColour
{
    
    if(height > 0) {
        for(Octnode *n in nodes)
            [n updateColours:newColour];
    } else {
        voxelPtr->face1.vertex1.c.red = newColour->red;
        voxelPtr->face1.vertex1.c.green = newColour->green;
        voxelPtr->face1.vertex1.c.blue = newColour->blue;
        voxelPtr->face1.vertex1.c.alpha = newColour->alpha;
        
        voxelPtr->face1.vertex2.c.red = newColour->red;
        voxelPtr->face1.vertex2.c.green = newColour->green;
        voxelPtr->face1.vertex2.c.blue = newColour->blue;
        voxelPtr->face1.vertex2.c.alpha = newColour->alpha;
        
        voxelPtr->face1.vertex3.c.red = newColour->red;
        voxelPtr->face1.vertex3.c.green = newColour->green;
        voxelPtr->face1.vertex3.c.blue = newColour->blue;
        voxelPtr->face1.vertex3.c.alpha = newColour->alpha;
        
        voxelPtr->face1.vertex4.c.red = newColour->red;
        voxelPtr->face1.vertex4.c.green = newColour->green;
        voxelPtr->face1.vertex4.c.blue = newColour->blue;
        voxelPtr->face1.vertex4.c.alpha = newColour->alpha;
        
        voxelPtr->face2.vertex1.c.red = newColour->red;
        voxelPtr->face2.vertex1.c.green = newColour->green;
        voxelPtr->face2.vertex1.c.blue = newColour->blue;
        voxelPtr->face2.vertex1.c.alpha = newColour->alpha;
        
        voxelPtr->face2.vertex2.c.red = newColour->red;
        voxelPtr->face2.vertex2.c.green = newColour->green;
        voxelPtr->face2.vertex2.c.blue = newColour->blue;
        voxelPtr->face2.vertex2.c.alpha = newColour->alpha;
        
        voxelPtr->face2.vertex3.c.red = newColour->red;
        voxelPtr->face2.vertex3.c.green = newColour->green;
        voxelPtr->face2.vertex3.c.blue = newColour->blue;
        voxelPtr->face2.vertex3.c.alpha = newColour->alpha;
        
        voxelPtr->face2.vertex4.c.red = newColour->red;
        voxelPtr->face2.vertex4.c.green = newColour->green;
        voxelPtr->face2.vertex4.c.blue = newColour->blue;
        voxelPtr->face2.vertex4.c.alpha = newColour->alpha;
        
        voxelPtr->face3.vertex1.c.red = newColour->red;
        voxelPtr->face3.vertex1.c.green = newColour->green;
        voxelPtr->face3.vertex1.c.blue = newColour->blue;
        voxelPtr->face3.vertex1.c.alpha = newColour->alpha;
        
        voxelPtr->face3.vertex2.c.red = newColour->red;
        voxelPtr->face3.vertex2.c.green = newColour->green;
        voxelPtr->face3.vertex2.c.blue = newColour->blue;
        voxelPtr->face3.vertex2.c.alpha = newColour->alpha;
        
        voxelPtr->face3.vertex3.c.red = newColour->red;
        voxelPtr->face3.vertex3.c.green = newColour->green;
        voxelPtr->face3.vertex3.c.blue = newColour->blue;
        voxelPtr->face3.vertex3.c.alpha = newColour->alpha;
        
        voxelPtr->face3.vertex4.c.red = newColour->red;
        voxelPtr->face3.vertex4.c.green = newColour->green;
        voxelPtr->face3.vertex4.c.blue = newColour->blue;
        voxelPtr->face3.vertex4.c.alpha = newColour->alpha;
        
        voxelPtr->face4.vertex1.c.red = newColour->red;
        voxelPtr->face4.vertex1.c.green = newColour->green;
        voxelPtr->face4.vertex1.c.blue = newColour->blue;
        voxelPtr->face4.vertex1.c.alpha = newColour->alpha;
        
        voxelPtr->face4.vertex2.c.red = newColour->red;
        voxelPtr->face4.vertex2.c.green = newColour->green;
        voxelPtr->face4.vertex2.c.blue = newColour->blue;
        voxelPtr->face4.vertex2.c.alpha = newColour->alpha;
        
        voxelPtr->face4.vertex3.c.red = newColour->red;
        voxelPtr->face4.vertex3.c.green = newColour->green;
        voxelPtr->face4.vertex3.c.blue = newColour->blue;
        voxelPtr->face4.vertex3.c.alpha = newColour->alpha;
        
        voxelPtr->face4.vertex4.c.red = newColour->red;
        voxelPtr->face4.vertex4.c.green = newColour->green;
        voxelPtr->face4.vertex4.c.blue = newColour->blue;
        voxelPtr->face4.vertex4.c.alpha = newColour->alpha;
        
        voxelPtr->face5.vertex1.c.red = newColour->red;
        voxelPtr->face5.vertex1.c.green = newColour->green;
        voxelPtr->face5.vertex1.c.blue = newColour->blue;
        voxelPtr->face5.vertex1.c.alpha = newColour->alpha;
        
        voxelPtr->face5.vertex2.c.red = newColour->red;
        voxelPtr->face5.vertex2.c.green = newColour->green;
        voxelPtr->face5.vertex2.c.blue = newColour->blue;
        voxelPtr->face5.vertex2.c.alpha = newColour->alpha;
        
        voxelPtr->face5.vertex3.c.red = newColour->red;
        voxelPtr->face5.vertex3.c.green = newColour->green;
        voxelPtr->face5.vertex3.c.blue = newColour->blue;
        voxelPtr->face5.vertex3.c.alpha = newColour->alpha;
        
        voxelPtr->face5.vertex4.c.red = newColour->red;
        voxelPtr->face5.vertex4.c.green = newColour->green;
        voxelPtr->face5.vertex4.c.blue = newColour->blue;
        voxelPtr->face5.vertex4.c.alpha = newColour->alpha;
        
        voxelPtr->face6.vertex1.c.red = newColour->red;
        voxelPtr->face6.vertex1.c.green = newColour->green;
        voxelPtr->face6.vertex1.c.blue = newColour->blue;
        voxelPtr->face6.vertex1.c.alpha = newColour->alpha;
        
        voxelPtr->face6.vertex2.c.red = newColour->red;
        voxelPtr->face6.vertex2.c.green = newColour->green;
        voxelPtr->face6.vertex2.c.blue = newColour->blue;
        voxelPtr->face6.vertex2.c.alpha = newColour->alpha;
        
        voxelPtr->face6.vertex3.c.red = newColour->red;
        voxelPtr->face6.vertex3.c.green = newColour->green;
        voxelPtr->face6.vertex3.c.blue = newColour->blue;
        voxelPtr->face6.vertex3.c.alpha = newColour->alpha;
        
        voxelPtr->face6.vertex4.c.red = newColour->red;
        voxelPtr->face6.vertex4.c.green = newColour->green;
        voxelPtr->face6.vertex4.c.blue = newColour->blue;
        voxelPtr->face6.vertex4.c.alpha = newColour->alpha;
    }
}

-(bool)updatePoint:(vec4 *)point withColour:(colour *)newColour
{
    if([self collidesWithPoint:point]) {
        if(height > 0) {
            for(Octnode *n in nodes)
                if([n collidesWithPoint:point])
                    return [n updatePoint:point withColour:newColour];
        } else {
            [self updateColours:newColour];
            return YES;
        }
    }else {
        return NO;
    }
    return NO;
}

-(bool)collidesWithPoint:(vec4 *)point
{
    NSLog(@"Voxel with origin (%f,%f,%f) checking for collision with (%f,%f,%f)",origin.x,origin.y,origin.z,point->x,point->y,point->z);
    float offset = size/2;
    if((point->x > (origin.x + offset) || point->x < (origin.x - offset)))
        return NO;
    
    if((point->y > (origin.y + offset) || point->y < (origin.y - offset)))
        return NO;
    
    if((point->z > (origin.z + offset) || point->z < (origin.z - offset)))
        return NO;
    NSLog(@"Collision!!!");
    return YES;
}

-(void)calculateNewOrigin:(vec4 *)v1 OldOrigin:(vec4 *)v2 offsetVec:(vec4 *)offvec scale:(float)scale
{
    v1->x = 0;
    v1->y = 0;
    v1->z = 0;
    
    v1->x = v2->x + (offvec->x * scale);
    v1->y = v2->y + (offvec->y * scale);
    v1->z = v2->z + (offvec->z * scale);
}

-(int)numberOfVoxels
{
    return (int)pow(8, height);
}
@end
