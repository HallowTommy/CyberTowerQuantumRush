shader_type canvas_item;

uniform int id : hint_range(-1, 8) = 4;
uniform vec4 outline_color : source_color = vec4(1.0,0.0,0.0,1.0);
uniform float outline_thickness : hint_range(0.0,0.1) = 0.02;

void fragment() {
    if (id < 0) {
        COLOR = vec4(0.0);
    } else {
        int x = id % 3;
        int y = id / 3; // top-left origin

        // Compute exact texel coordinates
        vec2 tex_size = vec2(textureSize(TEXTURE, 0)); // size in pixels
        vec2 cell_pixels = tex_size / 3.0;

        vec2 cell_min_px = vec2(float(x), float(y)) * cell_pixels;

        // Map UV (0-1) to exact texel coordinates
        vec2 uv_px = cell_min_px + UV * cell_pixels;

        // Convert back to normalized UV
        vec2 uv_tex = uv_px / tex_size;

        // local UV in cell for outline
        vec2 local_uv = (uv_px - cell_min_px) / cell_pixels;

        // Outline
        if (local_uv.x < outline_thickness || local_uv.x > 1.0 - outline_thickness ||
            local_uv.y < outline_thickness || local_uv.y > 1.0 - outline_thickness) {
            COLOR = outline_color;
        } else {
            // Pixel-perfect: use texel center
            COLOR = texture(TEXTURE, uv_tex);
        }
    }
}