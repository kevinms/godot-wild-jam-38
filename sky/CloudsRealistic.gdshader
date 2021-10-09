shader_type canvas_item;
render_mode blend_premul_alpha;

uniform vec2 camera_offset;
uniform vec2 cloud_offset;
uniform vec4 sky_color: hint_color;
uniform vec4 cloud_color: hint_color;
uniform sampler2D noise;

void fragment() {
	vec4 col = vec4(0);
	
	vec2 offset = camera_offset + cloud_offset;
	
	float clouds = texture(noise, UV+vec2(TIME*0.1, 0)+offset).x;
	clouds *= texture(noise, UV+vec2(0, TIME*0.1)+offset).x;
	clouds *= 1.2;
	
	// Mix with sky color
	//col = mix(sky_color, cloud_color, smoothstep(0.4, 0.5, clouds));
	// Mix with transparent
	col = mix(col, cloud_color, smoothstep(0.4, 0.5, clouds));
	
	COLOR = col;
}