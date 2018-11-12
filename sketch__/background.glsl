// background.glsl
uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;

vec4 circle(vec2 center, float s){
	//Thid draws a circle with a glowing falloff
  vec2 p = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - 1.0;
	p -= center * 2.0 - 1.0;
	p.x *= resolution.x/resolution.y;
	float v =  s / length(p);
	return vec4(v, v, v, 1.0);
}

void main() {
  // gl_FragCoord
	vec2 fc = gl_FragCoord.xy / resolution;

	//I created a sine function with different frequencies and amplitudes
	//Anything under that sign function, I drew some redshifted noise function
	//Make whatever you like, juse use this circle function to color the ball
  vec4 color = vec4(0);
  color += circle(mouse, 0.1);

	//This is the output, sort of like return color
	gl_FragColor = color;
}
