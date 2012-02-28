attribute vec4 position;
attribute vec4 inColor;
attribute vec3 normal;

varying vec4 outColor;

uniform mat4 modelToWorldMatrix;
uniform mat4 worldToCameraMatrix;
uniform mat4 cameraToClipMatrix;

void main()
{
    vec4 temp = modelToWorldMatrix * position;
    temp = worldToCameraMatrix * temp;
    gl_Position = cameraToClipMatrix * temp;
    
    
	outColor = inColor + vec4(normal,1.0);
}