shader_type canvas_item;
 
uniform vec4 target_color : source_color;
uniform vec4 replace_color : source_color; 
uniform float tolerance : hint_range(0, 1); 

varying flat vec4 modulate;
void vertex() {
	modulate = COLOR;
}

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
 
    float dist = distance(tex_color.rgb, target_color.rgb);
 
    if (dist < tolerance) {
        tex_color = replace_color * modulate;
    }
 
    COLOR = tex_color;
}