shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float frequency = 60;
uniform float depth = 0.005;

void fragment() {
	vec2 uv = UV;
	
	uv.x += sin(uv.y * frequency + TIME) * depth;
	uv.x = clamp(uv.x, 0.0, 1.0);
	
	vec3 c = textureLod(TEXTURE, uv, 0.0).rgb;
	
	COLOR.rgb = c;
}