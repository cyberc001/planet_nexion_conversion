void main()
{
	FragColor = texture(InputTexture, TexCoord);
	float mulp = 1 - float(vision_dmg) / vision_dmg_effect_max;
	FragColor.r *= mulp;
	FragColor.g *= mulp;
	FragColor.b *= mulp;
}
