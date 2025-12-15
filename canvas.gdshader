shader_type canvas_item;

uniform vec2 position = vec2(0.0, 0.0);
uniform float scale = 1.0;
uniform float rotation : hint_range(0, 1) = 0.0;

// translate by (-0.5,-0.5), scale by 2.0
//const mat3 TX = mat3(
	//vec3(2.0, 0.0, 0.0),
	//vec3(0.0, 2.0, 0.0),
	//vec3(vec2(-0.5), 1.0)
//);

//vec2 rotate(vec2 uv, vec2 pivot, float angle) {
vec2 rotate(vec2 uv, float angle) {
	float s = sin(angle), c = cos(angle);
	mat2 r = mat2(
		vec2(c, s),
		vec2(-s, c)
	);
	return uv * r;
	//return (uv - pivot) * r + pivot;
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
	CD += position;
	CD /= scale;
	CD = rotate(CD, rotation);
	
	// draw params
	float line_width = 16.0 * screen_scale;
	
	// unit circle around origin
	float circle = 1.0 - dot(CD, CD);
	
	// background - black, going to white inside unit circle at origin
	COLOR.rgb = vec3(circle);
	
	// unit square around origin - Q1: green, Q2: red, Q3: black, Q4: blue
	if (abs(CD.x) < 1.0 && abs(CD.y) < 1.0) {
		if (CD.y > 0.0) {
			if (CD.x > 0.0) {
				COLOR.g = 1.0;
			}
			else {
				COLOR.r = 1.0;
			}
		}
		if (CD.x > 0.0) {
			if (CD.y < 0.0) {
				COLOR.b = 1.0;
			}
		}
	}
	
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
	// origin - black
	if (dot(CD,CD) < line_width*line_width) {
		COLOR.rgb = vec3(0.0);
	}
	
	// unit circle around origin - white
	if (abs(circle) < line_width) {
		COLOR.rgb = vec3(1.0);
	}	
	
}
