shader_type canvas_item;
render_mode blend_premul_alpha;

uniform bool render_sky = false;
uniform vec2 camera_offset;
uniform vec2 cloud_offset;
uniform vec4 sky_color: hint_color;
uniform vec4 cloud_color: hint_color;
uniform sampler2D noise;
uniform float speed: hint_range(0, 2) = 0.05;

void fragment() {
	vec4 col = vec4(0);
	vec2 offset = camera_offset + cloud_offset;
	
	float t = TIME;
	//st = 0.0;
	
	float clouds = texture(noise, UV+vec2(t*speed, 0)+offset).x;
	clouds *= texture(noise, UV+vec2(0, t*speed)+offset).x;
	clouds *= 1.35;
	//clouds *= 1.34;
	
	// Clamp so clouds don't blow out in the center
	//clouds = clamp(clouds, 0, .45);
	
	// Scale so clouds don't blow out in the center
	clouds = clouds * 0.3 + .3;
	
	if (render_sky) {
		// Mix with sky color
		//col = mix(sky_color, sky_color*0.1, UV.y + camera_offset.y - 1.0);
		col = sky_color;
		
		col = mix(col, cloud_color, smoothstep(0.4, 0.5, clouds));
	} else {
		// Mix with transparent
		col = mix(col, cloud_color, smoothstep(0.4, 0.5, clouds));
	}
	
	COLOR = col;
	
}