shader_type canvas_item;

uniform float whiteness = 0.0;

void fragment() {
	if (COLOR.a > 0.0){
		float offset = 0.0;
		if (COLOR.r < COLOR.b && COLOR.r < COLOR.g) {
			offset = 1.0 - COLOR.r;
		}
		else if (COLOR.b < COLOR.r && COLOR.b < COLOR.g) {
			offset = 1.0 - COLOR.b;
		}
		else {
			offset = 1.0 - COLOR.g;
		}
		COLOR.r = min(COLOR.r + offset * whiteness, 1.0);
		COLOR.g = min(COLOR.g + offset * whiteness, 1.0);
		COLOR.b = min(COLOR.b + offset * whiteness, 1.0);
	}
}
