shader_type canvas_item;

uniform float strength = 0.2;
uniform float power = 0.5;
uniform bool flip = false;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	float gradient = UV.y;
	if (flip) {
		gradient = 1.0 - gradient;
	}
	gradient = pow(gradient, power) * strength;
	COLOR.a = COLOR.a - gradient;
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
