//
//  Structures.h
//  Cubeworld
//
//  Created by Tom Jones on 16/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef Cubeworld_Structures_h
#define Cubeworld_Structures_h

typedef struct
{
    float x;
    float y;
    float z;
//    float w;
} vertex;

typedef struct 
{
    float red;
    float green;
    float blue;
    float alpha;
} colour;

typedef struct 
{
    short int x;
    short int y;
    short int z;
} vertexNormal;

typedef struct 
{
    vertex v;
    colour c;
    vertexNormal n;
} colouredNormalVertex;

typedef struct 
{
    colouredNormalVertex vertex1;
    colouredNormalVertex vertex2;
    colouredNormalVertex vertex3;
    colouredNormalVertex vertex4;
}face;

typedef struct
{
    face face1;
    face face2;
    face face3;
    face face4;
    face face5;
    face face6;
}voxelData;

typedef struct
{
    float x;
    float y;
    float z;
} vec3;

typedef struct
{
    float x;
    float y;
    float z;
    float w;
}vec4;

#define VOXEL_INDICES_COUNT 36
#endif
