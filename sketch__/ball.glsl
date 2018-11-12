#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

mat2 rot2d(float ang)
{
    float c = cos(ang);
    float s = sin(ang);
    return mat2(c, s, -s, c);
}

float numx = 24.0;
float numy = 12.0;
float speed = 1.0;

void main() {
    vec2 uv = gl_FragCoord.xy / resolution;
    vec2 st = uv * 2.0 - 1.0;
    st = fract(st * vec2(numx,numy) / 2.0);
    vec2 pos = rot2d(time * speed + uv.x + uv.y) * vec2(st.x,st.y);
    vec3 color = vec3(pos, 1.0);

    gl_FragColor = vec4(color, 1.0);
}
