//
//  MainScene.h
//  Cubeworld
//
//  Created by Tom Jones on 28/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Scene.h"
#import "WorldScene.h"
#import "SceneLoader.h"

@interface MainScene : Scene
{
    WorldScene *world;
    SceneLoader *loader;
}
@end
