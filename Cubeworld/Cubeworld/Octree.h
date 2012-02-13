//
//  Octree.h
//  Cubeworld
//
//  Created by Tom Jones on 13/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Octree : NSObject
{
    NSMutableArray *leaves;
}

-(void)addObject:(id)obj atIndex:(int) index;
-(id)objectAtIndex:(int)index;
@end
