shader_type canvas_item; // use "spatial" for 3D

// 0.0 = full color, 1.0 = full grayscale
uniform float grayscale_strength : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    vec4 color = texture(TEXTURE, UV);                    // get pixel color
    float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114)); // convert to luminance
    vec3 final_color = mix(color.rgb, vec3(gray), grayscale_strength); // blend
    COLOR = vec4(final_color, color.a);                   // output final color
}