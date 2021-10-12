shader_type canvas_item;

const float PI = 3.14159;
const float TAU = PI;
uniform sampler2D noise;

uniform float effect_strength: hint_range(0,2) = 1.0;

void fragment() {
	vec2 uv = UV - 0.5;
	
	vec2 dir = normalize(uv);
	float d = length(uv);
	float a = atan(uv.x, uv.y) * 3.14159 * 2.0;
	
	// Worble
//	vec2 worble_offset = dir*sin(a*1.6+TIME*4.0)*d*0.06;
//	vec4 col = texture(TEXTURE, UV+effect_strength*worble_offset);
	
	// Portal collapse
	vec2 worble_offset = dir * texture(noise, dir+TIME).x*0.3;
	vec4 col = texture(TEXTURE, UV+effect_strength*worble_offset);
	
	// Rays of light
//	float ray_d = clamp(d / 0.5, 0, 1);
//	ray_d = smoothstep(0.5, 1.0, ray_d);
//	float rays = ceil(sin(a*3.0-TIME*4.0));
//	rays = mix(0, rays, ray_d);
//	rays = mix(0, rays, 1.-pow(ray_d, 2));
//	rays = mix(0, rays, 1.-UV.y);
//	col = mix(col, vec4(1,1,0,1), effect_strength*rays);
	
	COLOR = col;
}