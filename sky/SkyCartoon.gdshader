shader_type canvas_item;

uniform vec4 sky_color: hint_color;
uniform vec4 cloud_color: hint_color;
uniform sampler2D noise;

void fragment() {
	vec4 col = sky_color;
	
	float clouds = texture(noise, UV+vec2(TIME*0.1, 0)).x;
	clouds *= texture(noise, UV+vec2(0, TIME*0.1)).x;
	clouds *= 1.3;
	col = mix(col, vec4(0,0,0,1), step(0.5, clouds));
	col = mix(col, cloud_color, step(0.51, clouds));
	
	COLOR = col;
}