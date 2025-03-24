shader_type canvas_item;

uniform sampler2D overlay: source_color;

void fragment() {
	vec4 overlay_sample = texture(overlay, UV);
	vec4 texture_sample = texture(TEXTURE, UV);
	
	COLOR.rgb = texture_sample.rgb * overlay_sample.rgb;
	COLOR.a = texture_sample.a;
}