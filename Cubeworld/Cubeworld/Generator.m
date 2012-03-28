//
//  Generator.m
//  Cubeworld
//
//  Created by Tom Jones on 08/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Generator.h"
#import "BlockTypes.h"
#include <time.h>
#import "PerlinNoise.h"

@implementation Generator
-(id)init
{
    if(self = [super init]) {
        //srandom(time(NULL));
    }
    return self;
}

-(Chunk *)chunkForX:(float)cx Z:(float)cz
{
    NSDate *methodStart = [NSDate date];
    
    Chunk *tmp = [[[Chunk alloc] init] autorelease];
    
    colour c;
    c.red = 0.0;
    c.green = 1.0;
    c.blue = 0.0;
    c.alpha = 1.0;
    
    [tmp updateAllToColour:&c];

    
    float baselimit = PerlinNoise2D((cx/10.0) + 0.2,(cz/10.0) + 0.2, 2, 2, 6);
    baselimit = baselimit * 64;
    baselimit = (baselimit > 0) ? baselimit : -baselimit;
    
    float variation = baselimit / 3.0;
    
    for(double x = 0;x < 16;x++) 
        for(double z = 0;z < 16;z++) {
            float limit = PerlinNoise2D((cx+x/10.0) + 0.4,(cz+z/10.0) + 0.4, 2, 2, 6);
            limit = limit * variation;
            for(double y = 0;y < 128;y++)
                if(y > baselimit+limit) 
                    [tmp updateBlockType:BLOCK_AIR forX:x Y:y Z:z];
        }
    
    NSDate *methodFinish = [NSDate date];
    NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
    NSLog(@"Generation time %f for (%.0f x,%.0f z)",executionTime,cx,cz);
    
    return tmp;
}

-(Chunk *)chunkForPoint:(vec3 *)point
{
    return nil;
}
@end
