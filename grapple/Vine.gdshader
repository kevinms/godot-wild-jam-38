shader_type canvas_item;

uniform float rope_length;
uniform vec4 border_color: hint_color;
uniform vec4 fill_color: hint_color;

mat2 rot(float a) {
	float c = cos(a);
	float s = sin(a);
	return mat2(vec2(c, s), vec2(-s, c));
}

const float PI = 3.14159;

void fragment() {
	vec2 uv = UV - 0.5;
	vec4 col = fill_color;
	
	vec2 rv = UV;
	rv.x *= rope_length*0.5;
	rv *= rot(PI/2.5);
	//rv *= rope_length*0.1;
	
	//float ratio = rope_length / 80.0;
	
	col = mix(vec4(0,0,0,1), fill_color, fract(rv.x) * 0.5 + 0.5);
	
	//col = mix(col, border_color, step(0.4, abs(uv.x)));
	col = mix(col, border_color, step(0.45, abs(uv.y)));
	
	COLOR = col; //vec4(abs(uv.yyy*2.0), 1.0);
}