//#version 310


attribute vec4 position;
attribute vec4 inColor;

varying vec4 outColor;

uniform vec3 offset;
uniform mat4 perspectiveMatrix;

void main()
{
	vec4 cameraPos = position + vec4(offset.x, offset.y, offset.z, 0.0);
	
	gl_Position = perspectiveMatrix * cameraPos;
	outColor = inColor;
}