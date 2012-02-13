//#version 310


attribute vec4 position;
attribute vec4 inColor;

varying vec4 outColor;

uniform vec3 offset;

uniform mat4 cameraToClipMatrix;
uniform mat4 worldToCameraMatrix;
uniform mat4 modelToWorldMatrix;

void main()
{
//    vec4 temp = modelToWorldMatrix * position;
//    temp = worldToCameraMatrix * temp;
//    gl_Position = cameraToClipMatrix * temp;
 
    vec4 temp = modelToWorldMatrix * (position + vec4(0.7,-0.55,-3.0,1.0));
   // temp = worldToCameraMatrix * temp;
    gl_Position = cameraToClipMatrix *  temp;
    
    
	outColor = inColor;
}