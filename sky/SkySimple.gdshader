shader_type canvas_item;

uniform vec4 sky_color: hint_color;
uniform vec4 cloud_color: hint_color;
uniform sampler2D noise;

void fragment() {
	vec4 col = sky_color;
	
	float clouds = texture(noise, UV+vec2(TIME*0.1, 0)).x;
	col = mix(col, cloud_color, clouds);
	
	COLOR = col;
}