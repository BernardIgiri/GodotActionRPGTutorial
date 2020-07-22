shader_type canvas_item;

uniform float brightness = 1.0;

void fragment() {
	vec4 c = texture(TEXTURE, UV);
	c.rgb = mix(vec3(0.0), c.rgb, brightness);
	COLOR = c;
}
