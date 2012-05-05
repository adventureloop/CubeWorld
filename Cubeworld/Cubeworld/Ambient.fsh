//#version 310


varying vec4 outColor;

uniform vec3 fogColour;
uniform float fogNear;
uniform float fogFar;

uniform bool fog;

void main()
{
    gl_FragColor = outColor;
    
    //////Do fog
    if(fog) {
        float depth = gl_FragCoord.z / gl_FragCoord.w;
        float fogFactor = smoothstep(fogNear, fogFar, depth);
        gl_FragColor = mix(gl_FragColor, vec4(fogColour, gl_FragColor.w), fogFactor);
    }
}