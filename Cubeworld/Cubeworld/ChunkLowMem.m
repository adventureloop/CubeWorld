//
//  Chunk.m
//  Cubeworld
//
//  Created by Tom Jones on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChunkLowMem.h"
#import <OpenGL/gl.h>
#import "BlockTypes.h"


#define ALLOC_SIZE 128
#define INIT_ALLOC_SIZE 512

@implementation ChunkLowMem
@synthesize readyToRender;

-(id)init
{
    return [self initWithNumberOfTrees:8 treeHeight:4];
}

-(id)initWithNumberOfTrees:(int)ntrees treeHeight:(int)ntreeHeight
{        
    if(self = [super init]) {
        [self setReadyToRender:NO];
        
        trees = ntrees;
        treeHeight = ntreeHeight;
        
        //Find the cube root of the number voxels in a node
        //this gives the x and z widths of the chunk
        chunkWidth = pow(pow(8,treeHeight),1.0/3.0);
        
        nodes = [[NSMutableArray alloc]initWithCapacity:8];
        
        maxVoxels = INIT_ALLOC_SIZE;
        unsigned int numElements = trees * ((int)pow(8, treeHeight)) * VOXEL_INDICES_COUNT;
        
        vertexData = calloc(maxVoxels, sizeof(voxelData));
        
        indexArray = calloc(numElements, sizeof(unsigned int));
        tmpIndexArray = malloc(numElements * sizeof(long));
        
        memset(tmpIndexArray, -1, numElements * sizeof(int));
        
        nodeSize = 16.0;
        int offset = ((int)pow(8.0, treeHeight));
        
        
        localOrigin.x = 0.0;
        localOrigin.y = (nodeSize / 2);
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
        
        glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, sizeof(colouredNormalVertex), 0);
        glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, sizeof(colouredNormalVertex), (void*)sizeof(vertex));
        glVertexAttribPointer(2, 3, GL_FLOAT, GL_FALSE, sizeof(colouredNormalVertex), (void *) ( sizeof(vertex) + sizeof(colour)));
        
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBufferObject);
        
        glBindVertexArrayAPPLE(0);
        
        free(tmpIndexArray);
        tmpIndexArray = nil;
    }
    return self;
}

-(void)render;
{
    if(!readyToRender)
        return;
    
    if(needsUpdate) {
        [self update];
        needsUpdate = NO;
    }
    
    int numElements = [self voxelsToRender] * VOXEL_INDICES_COUNT;
    
    glBindVertexArrayAPPLE(vertexArrayObject);
    
    glDrawElements(GL_TRIANGLES, numElements, GL_UNSIGNED_INT, 0);
    glBindVertexArrayAPPLE(0);
}

-(void)update
{
    unsigned int numVoxels = trees * ((int)pow(8, treeHeight));
    unsigned int numElements = numVoxels * VOXEL_INDICES_COUNT;
    int offset = ((int)pow(8.0, treeHeight));
    
    if(tmpIndexArray == nil)
        tmpIndexArray = malloc(numElements * sizeof(long));
    
    memset(tmpIndexArray, -1, numElements * sizeof(int));
    
    for(int i = 0;i < trees;i++) {
        int memOffset = i * offset;
        int indexOffset = memOffset * VOXEL_INDICES_COUNT;
        
        OctnodeLowMem *tmp = [nodes objectAtIndex:i];
        [tmp renderElements:tmpIndexArray+indexOffset];
        [nodes addObject:tmp];
    }
    
    memset(indexArray, 0, numElements * sizeof(int));
    
    for(int i = 0,j = 0;i < numElements;i++) 
        if(tmpIndexArray[i] >= 0)
            indexArray[j++] = tmpIndexArray[i];
    
    free(tmpIndexArray);
    tmpIndexArray = nil;
    
    //Update the buffers on the GPU
    glBindVertexArrayAPPLE(vertexArrayObject);
    
    glBufferData(GL_ARRAY_BUFFER,voxelCounter * sizeof(voxelData), vertexData, GL_DYNAMIC_DRAW);
    glBufferSubData(GL_ELEMENT_ARRAY_BUFFER,0, numElements * sizeof(unsigned int), indexArray);
    
    glBindVertexArrayAPPLE(0);
}

-(int)voxelsToRender
{
    return trees * ((int)pow(8, treeHeight));
}

-(BOOL)updateBlockType:(int)type forPoint:(vec3 *)point
{
    if([self collidesWithPoint:point])
        for(OctnodeLowMem *n in nodes)
            if([n collidesWithPoint:point])
                return [n updatePoint:point withBlockType:type];
    return NO;
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

-(void)point:(vec3 *)point forX:(float)x Y:(float)y Z:(float)z
{
    if(x > chunkWidth || x < 0)
        return;
    if(z > chunkWidth || z < 0)
        return;
    if(y > (chunkWidth * trees) || y < 0)
        return;
    
    int node = (int)y / (int)chunkWidth;
    if(node > [nodes count]-1)
        return;
    
    y = (int)y % (int)chunkWidth;
    
    vec3 *origin = [[nodes objectAtIndex:node] origin];
    
    float voxelSize = (nodeSize / chunkWidth);
    float shift = 0.5 * chunkWidth * voxelSize;
    
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

-(bool)collidesWithPoint:(vec3 *)point
{
    return YES;
    float offset = nodeSize/2;
    if((point->x > (worldOrigin.x + offset) || point->x < (worldOrigin.x - offset)))
        return NO;
    
    if((point->z > (worldOrigin.z + offset) || point->z < (worldOrigin.z - offset)))
        return NO;
    
    offset = ([nodes count] * nodeSize)/2;
    if((point->y > (worldOrigin.y + offset) || point->y < (worldOrigin.y - offset)))
        return NO;
    
    return YES;
}

-(vec3 *)worldOrigin
{
    return &worldOrigin;
}

-(void)setWorldOrigin:(vec3 *)newOrigin
{
    worldOrigin.x = newOrigin->x;
    worldOrigin.y = newOrigin->y;
    worldOrigin.z = newOrigin->z;
}

-(float)chunkDimensions
{
    return nodeSize * chunkWidth;
}

-(int)height
{
    return trees * chunkWidth;
}

-(void)updateAllToColour:(colour *)colour
{
    for(OctnodeLowMem *o in nodes)
        [o updateColours:colour];
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

-(NSString *)description
{
    NSMutableString *desc = [[[NSMutableString alloc]init] autorelease];//[@"<chunk x='0' z='0'>\n" mutableCopy];
    
    for(int x = 0;x < 16;x++) {
        for(int z = 0;z < 16;z++)
            for(int y = 0;y < 127;y++) {
                int type = [self blockTypeForX:x Y:y Z:z];
                if(type != BLOCK_AIR)
                    [desc appendFormat:@"\t<voxel x=%d y=%d z=%d>%d</voxel>\n",x,y,z,type];
            }
    }
//    [desc appendFormat:@"</chunk>\n"];
    
    return desc; 
}

-(void)setChunkLocationForX:(float)x Z:(float)z
{
    chunkLocation.x = x;
    chunkLocation.z = z;
}

-(vec3 *)chunkLocation
{
    return &chunkLocation;
}

-(void)dealloc
{
    [nodes release];
    free(indexArray);
    free(vertexData);
    
    [super dealloc];
}
@end
