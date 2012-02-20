attribute vec4 position;
attribute vec4 inColor;
attribute vec3 normal;

varying vec4 outColor;

uniform vec3 offset;

uniform mat4 cameraToClipMatrix;
uniform mat4 worldToCameraMatrix;
uniform mat4 modelToWorldMatrix;

void main()
{
    vec4 temp = modelToWorldMatrix *  (position + vec4(0.25,-1.5,-5.0,1.0)); //Shift position to avoid clipping 
//    temp = worldToCameraMatrix * temp;
    gl_Position = cameraToClipMatrix *  temp;
    
	outColor = inColor + vec4(normal,1.0);
}