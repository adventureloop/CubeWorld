attribute vec3 position;
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
    vec4 temp = vec4(position,1.0) + vec4(translation,1.0);
    temp = worldToCameraMatrix * temp;
    gl_Position = cameraToClipMatrix * temp;
    
    
//Calculate ambient lighting
    
    mat3 normalMatrix = mat3(1.0);
    
    vec3 normCap = normalize(normalMatrix * normal);
    
    float cosAng = dot(normCap,vec3(0.75,0.75,0.0));
    cosAng = clamp(cosAng,0.0,1.0);
    
	outColor = (inColor * vec4(1.0,1.0,1.0,1.0) * cosAng) + (inColor * vec4(0.5,0.5,0.5,0.5));
}