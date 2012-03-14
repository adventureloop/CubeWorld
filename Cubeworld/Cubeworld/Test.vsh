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
    //®vec4 temp = modelToWorldMatrix * position;
    
    vec4 temp = position + vec4(translation,1.0);
    
    temp = worldToCameraMatrix * temp;
    
    gl_Position = cameraToClipMatrix * temp;
//    
//    mat3 normalMatrix = mat3(1.0);
//    
//    vec3 normCap = normalize(normalMatrix * normal);
//    
//    float cosAng = dot(normCap,vec3(0.75,0.75,0.0));
//    //cosAng = clamp(cosAng,0,1);
//    
//	outColor = (inColor * vec4(1.0,1.0,1.0,1.0) * cosAng) + (inColor * vec4(0.5,0.5,0.5,0.5));
    outColor = inColor + vec4(normal,1.0);
}