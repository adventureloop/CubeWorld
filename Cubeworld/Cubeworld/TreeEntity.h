//
//  TreeEntity.h
//  Cubeworld
//
//  Created by Tom Jones on 02/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"

@interface TreeEntity : Entity
{
    BOOL grown;
}

-(void)grow;
@end
