shader_type canvas_item;

uniform bool is_active = false;

void fragment() {
  if (is_active) {
    vec4 previous_color = texture(TEXTURE, UV);
    COLOR = vec4(1.0, 0.0, 0.0, previous_color.a);
  }
}
