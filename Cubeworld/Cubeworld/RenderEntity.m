//
//  RenderEntity.m
//  Cubeworld
//
//  Created by Tom Jones on 02/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RenderEntity.h"
#import "BlockTypes.h"

@implementation RenderEntity


#define ALLOC_SIZE 128
#define INIT_ALLOC_SIZE 512

-(id)initWithTreeHeight:(int)height size:(float)asize
{        
    if(self = [super init]) {
        treeHeight = height;
        nodeSize = asize;
        
        //Find the cube root of the number voxels in a node
        //this gives the x and z widths of the chunk
        entityWidth = pow(pow(8,treeHeight),1.0/3.0);
        
        nodes = [[NSMutableArray alloc]initWithCapacity:8];
        
        maxVoxels = INIT_ALLOC_SIZE;
        unsigned int numElements = trees * ((int)pow(8, treeHeight)) * VOXEL_INDICES_COUNT;
        
        vertexData = calloc(maxVoxels, sizeof(voxelData));
        
        indexArray = calloc(numElements, sizeof(unsigned int));
        tmpIndexArray = malloc(numElements * sizeof(long));
        
        memset(tmpIndexArray, -1, numElements * sizeof(int));
        
        nodeSize = 16.0;
        int offset = ((int)pow(8.0, treeHeight));
        
        vec3 localOrigin;
        localOrigin.x = 0.0;
        localOrigin.y = 0.0;
        localOrigin.z = 0.0;
        
        for(int i = 0;i < trees;i++) {
            localOrigin.y = (i * nodeSize) + (nodeSize/2);
            
            int memOffset = i * offset;
            int indexOffset = memOffset * VOXEL_INDICES_COUNT;
            
            OctnodeLowMem *tmp = [[OctnodeLowMem alloc]initWithTreeHeight:treeHeight 
                                                                 nodeSize:nodeSize 
                                                                    orign:&localOrigin 
                                                               dataSource:self];
            [tmp renderElements:tmpIndexArray+indexOffset];
            [nodes addObject:tmp];
            
            [tmp release];
        }
        
        for(int i = 0,j = 0;i < numElements;i++) 
            if(tmpIndexArray[i] >= 0)
                indexArray[j++] = tmpIndexArray[i];
        
        /* Set up vertex buffer and array objects */
        glGenBuffers(1, &vertexBufferObject);
        glBindBuffer(GL_ARRAY_BUFFER, vertexBufferObject);
        glBufferData(GL_ARRAY_BUFFER,maxVoxels * sizeof(voxelData), vertexData, GL_DYNAMIC_DRAW);
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        
        glGenBuffers(1, &indexBufferObject);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBufferObject);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, numElements * sizeof(unsigned int), indexArray, GL_DYNAMIC_DRAW);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
        
        glGenVertexArraysAPPLE(1, &vertexArrayObject);
        glBindVertexArrayAPPLE(vertexArrayObject);
        
        glBindBuffer(GL_ARRAY_BUFFER, vertexBufferObject);
        
        glEnableVertexAttribArray(0);
        glEnableVertexAttribArray(1);
        glEnableVertexAttribArray(2);
        
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(colouredNormalVertex), 0);
        glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, sizeof(colouredNormalVertex), (void*)sizeof(vertex));
        glVertexAttribPointer(2, 3, GL_SHORT, GL_FALSE, sizeof(colouredNormalVertex), (void *) ( sizeof(vertex) + sizeof(colour)));
        
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBufferObject);
        
        glBindVertexArrayAPPLE(0);
        
        free(tmpIndexArray);
        tmpIndexArray = nil;
    }
    return self;
}

-(void)render
{
    int numElements = [self voxelsToRender] * VOXEL_INDICES_COUNT;
    
    glBindVertexArrayAPPLE(vertexArrayObject);
    
    glDrawElements(GL_TRIANGLES, numElements, GL_UNSIGNED_INT, 0);
    glBindVertexArrayAPPLE(0);
}

-(voxelData *)getRenderMetaData:(int *)offset
{
    if(voxelCounter > maxVoxels-1) {
        maxVoxels += ALLOC_SIZE;
        NSLog(@"Increasing memory size in chunk to hold %d",maxVoxels);
        vertexData =  realloc(vertexData, (voxelCounter + ALLOC_SIZE) * sizeof(voxelData));
    }
    
    voxelData *memPtr = (voxelData *)vertexData;
    
    *offset = voxelCounter * 24;
    return memPtr+voxelCounter++;
}

-(voxelData *)updateRenderMetaData:(int)offset
{
    voxelData *memPtr = (voxelData *)vertexData;
    
    return memPtr+(offset/24);
}

-(int)voxelsToRender
{
    return ((int)pow(8, treeHeight));
}

-(void)point:(vec3 *)point forX:(float)x Y:(float)y Z:(float)z
{
    if(x > entityWidth || x < 0)
        return;
    if(z > entityWidth || z < 0)
        return;
    if(y > (entityWidth * trees) || y < 0)
        return;
    
    int node = (int)y / (int)entityWidth;
    if(node > [nodes count]-1)
        return;
    
    y = (int)y % (int)entityWidth;
    
    vec3 *origin = [[nodes objectAtIndex:node] origin];
    
    float voxelSize = (nodeSize /entityWidth);
    float shift = 0.5 *entityWidth * voxelSize;
    
    x = (x * voxelSize) + (0.5 * voxelSize);
    y = (y * voxelSize) + (0.5 * voxelSize);
    z = (z * voxelSize) + (0.5 * voxelSize);
    
    x -= shift;
    y -= shift;
    z -= shift;
    
    point->x = origin->x + x;
    point->y = origin->y + y;
    point->z = origin->z + z;
}

-(void)updateBlockType:(int)type forX:(float)x Y:(float)y Z:(float)z
{
    vec3 point;
    [self point:&point forX:x Y:y Z:z];
    
    for(OctnodeLowMem *n in nodes)
        if([n collidesWithPoint:&point]) {
            [n updatePoint:&point withBlockType:type];
            needsUpdate = YES;
            break;
        }
    
}

-(int)blockTypeForX:(float)x Y:(float)y Z:(float)z
{
    vec3 point;
    [self point:&point forX:x Y:y Z:z];
    
    for(OctnodeLowMem *n in nodes)
        if([n collidesWithPoint:&point])
            return [n typeForPoint:&point];
    return BLOCK_AIR;
}
@end
