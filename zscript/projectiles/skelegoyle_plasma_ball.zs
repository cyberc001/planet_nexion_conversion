class PN_SkeleGoyle_Plasma_Ball : PN_Plasma_Ball
{
	default
	{
		Radius 6;
		Height 6;

		Speed 15;

		DamageFunction (10 + random(0,2)*4);
	}
}
