//
//  Octree.m
//  Cubeworld
//
//  Created by Tom Jones on 13/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Octree.h"

@implementation Octree
-(id)init
{
    if(self = [super init]) {
        leaves = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)addObject:(id)obj atIndex:(int)index
{
    [leaves insertObject:obj atIndex:index];
}

-(id)objectAtIndex:(int)index
{
    return [leaves objectAtIndex:index];
}
@end
