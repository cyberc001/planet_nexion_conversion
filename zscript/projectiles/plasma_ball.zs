class PN_Plasma_Ball : Actor
{
	default
	{
		Radius 8;
		Height 8;

		Speed 40;
		Projectile;

		DamageFunction (20 + random(0,15));

		+RANDOMIZE;
		RenderStyle "Add";
		Alpha 0.8;

		SeeSound "weapons/plasmaf";
		SeeSound "weapons/plasmax";
		Obituary "%o was burned by %k.";
	}

	states
	{
		Spawn:
			PLAS AB 5 Bright;
			Loop;
		Death:
			PLAS ABABAB 2 Bright;
			Stop;
	}
}
