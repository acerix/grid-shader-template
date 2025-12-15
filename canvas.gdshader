shader_type canvas_item;

//uniform float num_bands = 8;
//uniform float top_band = 3;
uniform float band_freq = 0.666;
uniform float band_value = 0.9;

vec2 rotate(vec2 uv, float angle) {
	float s = sin(angle), c = cos(angle);
	mat2 r = mat2(
		vec2(c, s),
		vec2(-s, c)
	);
	return uv * r;
}

void fragment() {
	// convert UV (0..1) to XY coord with center at origin (-1..1)
	vec2 CD = 2.0 * UV - vec2(1.0);
	// flip Y so up is positive
	CD.y = -CD.y;
	// equalize X/Y resolution
	CD *= SCREEN_PIXEL_SIZE.yx;
	// scale to fit screen
	float screen_scale = min(SCREEN_PIXEL_SIZE.x, SCREEN_PIXEL_SIZE.y);
	CD /= screen_scale;

	// uniform transforms
	//CD += position;
	//CD.x -= band_freq;
	//CD.y -= band_value;
	CD = rotate(CD, 0.5 * PI * band_freq);

	// draw params
	float line_width = 16.0 * screen_scale;

	// unit circle around origin
	float circle = band_value - dot(CD, CD);

	// background - black, going to white inside unit circle at origin
	COLOR.r = circle * (1.0 - band_freq);
	COLOR.g = circle + band_freq;
	COLOR.b = circle * band_freq;
	
	// X axis - red
	if (abs(CD.y) < line_width) {
		COLOR.r = 1.0;
		COLOR.g = 0.0;
		COLOR.b = 0.0;
	}
	// Y axis - green
	if (abs(CD.x) < line_width) {
		COLOR.r = 0.0;
		COLOR.g = 1.0;
		COLOR.b = 0.0;
	}
	
}
