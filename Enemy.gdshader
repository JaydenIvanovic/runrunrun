shader_type canvas_item;

uniform float red = 0.0;
uniform float green = 0.0;
uniform float blue = 0.0;

void fragment() {
  COLOR = texture(TEXTURE, UV);

  COLOR.r = COLOR.r + red;
  COLOR.g = COLOR.g + green;
  COLOR.b = COLOR.b + blue;
}