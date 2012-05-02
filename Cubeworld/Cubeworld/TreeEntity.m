//
//  TreeEntity.m
//  Cubeworld
//
//  Created by Tom Jones on 02/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TreeEntity.h"
#import "BlockTypes.h"

@implementation TreeEntity

-(void)updateWithDelta:(NSTimeInterval)delta
{

}

-(void)grow
{
    if(chunk == nil){
        NSLog(@"I dont have a chunk to grow into :(");
        return;
    }
    float x = location.x;
    float y = location.y;
    float z = location.z;
    
    [chunk updateBlockType:BLOCK_WOOD forX:x Y:y++ Z:z];
    [chunk updateBlockType:BLOCK_WOOD forX:x Y:y++ Z:z];
    [chunk updateBlockType:BLOCK_WOOD forX:x Y:y++ Z:z];

    [chunk updateBlockType:BLOCK_LEAF forX:x-1 Y:y Z:z-1];
    [chunk updateBlockType:BLOCK_LEAF forX:x Y:y Z:z+1];
    [chunk updateBlockType:BLOCK_LEAF forX:x+1 Y:y Z:z+1];

    [chunk updateBlockType:BLOCK_LEAF forX:x-1 Y:y Z:z];
    [chunk updateBlockType:BLOCK_LEAF forX:x Y:y Z:z];
    [chunk updateBlockType:BLOCK_LEAF forX:x+1 Y:y Z:z];

    [chunk updateBlockType:BLOCK_LEAF forX:x-1 Y:y Z:z-1];
    [chunk updateBlockType:BLOCK_LEAF forX:x Y:y Z:z-1];
    [chunk updateBlockType:BLOCK_LEAF forX:x-1 Y:y++ Z:z+1];

    [chunk updateBlockType:BLOCK_LEAF forX:x Y:y Z:z];
}
@end
