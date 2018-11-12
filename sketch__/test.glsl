#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float layers = 10.0;

const vec2 s = vec2(10.0, 10.0);

const float m = 8.0;
const float a = 3.13;
const float b = 1.9;
const float c = 5.0;

float f(float x) {
	float y = 0.0;
	for (float n = 1.0; n <= m; n += 1.0) {
		y += pow(n, -a) * sin(pow(n, b) * x - n * n * c);
	}
	return y;
}

void main( void ) {

	vec2 uv = gl_FragCoord.xy / resolution.xy;

	uv -= vec2(0.5);
	uv *= s;


	vec3 c = vec3(1.0);

	for (float j = 0.0; j < layers; j += 1.0) {
		float i = layers - j - 1.0;
		float tmp = 1.0 / layers *step(uv.y - 1.0 / layers * (i - layers / 2.0) * 5.0,  f(1.0 * uv.x - time * 0.05 * (layers - i) - pow(i, 1.49)));
		c -= tmp;


	}

	gl_FragColor = vec4(c, 1.0 );

}
