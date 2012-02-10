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
	//vec4 cameraPos = position + vec4(offset.x, offset.y, offset.z, 0.0);
	
	//gl_Position = perspectiveMatrix * cameraPos;
    
    vec4 temp = modelToWorldMatrix * position;
    temp = worldToCameraMatrix * temp;
    gl_Position = cameraToClipMatrix * temp;
    
	outColor = inColor;
}