attribute vec4 position;
attribute vec4 inColor;
attribute vec3 normal;

varying vec4 outColor;

uniform mat4 modelToWorldMatrix;
uniform mat4 worldToCameraMatrix;
uniform mat4 cameraToClipMatrix;

uniform vec3 translation;

//uniform mat3 normalMatrix;

void main()
{
    vec4 temp = position + vec4(translation,1.0);
    
    temp = worldToCameraMatrix * temp;
    
    gl_Position = cameraToClipMatrix * temp;

    outColor = inColor + vec4(normal,1.0);
}