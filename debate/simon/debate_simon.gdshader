shader_type sky;

uniform sampler2D sky_texture;
uniform float tile_amount = 1;
uniform sampler2D y_gradient;
uniform vec4 modulate : source_color = vec4(1, 1, 1, 1);

uniform vec2 distortion = vec2(0.0, 0.0);
uniform vec2 scroll_velocity = vec2(1.0,0.0);

vec2 rotateUV(vec2 uv, vec2 pivot, float rotation) {
    float sine = sin(rotation);
    float cosine = cos(rotation);

    uv -= pivot;
    uv.x = uv.x * cosine - uv.y * sine;
    uv.y = uv.x * sine + uv.y * cosine;
    uv += pivot;

    return uv;
}

void sky() {
	vec2 move = scroll_velocity * TIME;
	float offset_x = sin(SKY_COORDS.y * distortion.x) * .05;
	float offset_y = sin(SKY_COORDS.x * distortion.y) * .05;
	vec2 offset = vec2(offset_x, offset_y);

	COLOR = texture(sky_texture, SKY_COORDS * tile_amount + offset + move).rgb;
	COLOR *= texture(y_gradient, rotateUV(SKY_COORDS, vec2(0.5), PI/2.0)).rgb;
	COLOR *= modulate.rgb;
}