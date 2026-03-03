shader_type canvas_item;

uniform vec2 direction = vec2(1.0, 0.0); // X/Y direction
uniform float speed = 0.5;               // Speed multiplier

void fragment() {
    vec2 uv = UV;
    uv += direction * TIME * speed;
    COLOR = texture(TEXTURE, uv);
}