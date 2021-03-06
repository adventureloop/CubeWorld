//Shader for UI
attribute vec4 position;
attribute vec4 inColor;
attribute vec3 normal;

varying vec4 outColor;

void main()
{
    gl_Position = position;
    outColor = inColor;
}