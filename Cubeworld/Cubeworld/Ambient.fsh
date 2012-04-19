//#version 310


varying vec4 outColor;

void main()
{
    gl_FragColor = outColor;
    
////Do fog
    vec3 fogColor = vec3(1.0,1.0,1.0);
    
    float fogNear = 60.0;
    float fogFar = 150.0;
    
    
    float depth = gl_FragCoord.z / gl_FragCoord.w;
    float fogFactor = smoothstep(fogNear, fogFar, depth);
    gl_FragColor = mix(gl_FragColor, vec4(fogColor, gl_FragColor.w), fogFactor);

}