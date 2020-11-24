void main()
{
	vec2 coord = TexCoord;
	coord.y /= 1 + ((float(ethanol_level) / ethanol_max) * (float(abs(tick - 18)) / 18)) / 2;
	FragColor = texture(InputTexture, coord);
}
