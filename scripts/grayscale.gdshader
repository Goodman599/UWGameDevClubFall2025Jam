shader_type canvas_item;
uniform bool active = false;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	
	vec4 tex_color = texture(TEXTURE, UV);
	float gray = tex_color.r * 0.299 + tex_color.g * 0.587 + tex_color.b * 0.144;
	if (active)	COLOR = vec4(vec3(gray), tex_color.a);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
