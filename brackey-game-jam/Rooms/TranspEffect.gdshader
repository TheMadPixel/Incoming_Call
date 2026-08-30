shader_type canvas_item;

uniform vec2 player_screen_position = vec2(-10000.0, -10000.0);
uniform vec2 screen_size = vec2(1920.0, 1080.0);

uniform float fade_radius = 70.0;
uniform float edge_softness = 6.0;

void fragment() {
	vec4 color = texture(TEXTURE, UV);

	vec2 pixel_position = SCREEN_UV * screen_size;

	float distance_to_player = distance(
		pixel_position,
		player_screen_position
	);

	float fade = smoothstep(
		fade_radius - edge_softness,
		fade_radius,
		distance_to_player
	);

	color.a *= fade;

	COLOR = color;
}