class PN_Player : DoomPlayer
{
	default
	{
		Speed 0.6;
		
		Health 100;
		PainChance 255;
		
		Radius 16;
		Height 56;
		Mass 100;

		Player.DisplayName "Matt Wolf";
		Player.CrouchSprite "PLYC";
		
		Player.StartItem "PN_Deathbone";
		
		Player.WeaponSlot 1, "PN_Deathbone";
		Player.WeaponSlot 2, "PN_Atom_Shredder";
		Player.WeaponSlot 3, "PN_PlasmaBurner";
		Player.WeaponSlot 4, "PN_BH_Generator";
	}

	// "Ethanol level in blood"; Raised by picking up alcohol.
	int ethanol_level;
	int ethanol_max;

	// Vision damage; Used by floating eyes.
	int vision_dmg;
	int vision_dmg_effect_max;
	int vision_dmg_max;

	// Lingering slowdown; Caused by abominations.
	int injure_slowness;
	int injure_slowness_max;

	override void BeginPlay()
	{
		super.BeginPlay();

		ethanol_level = 0;
		ethanol_max = 100 * 35;
		vision_dmg = 0 * 35;
		vision_dmg_effect_max = 20 * 35;
		vision_dmg_max = 30 * 35;
		injure_slowness = 0;
		injure_slowness_max = 30 * 35;

		int pn_pstart = CVar.GetCVar("pn_pstart").GetInt();
		if(pn_pstart == 1)
			A_GiveInventory("PN_Atom_Shredder");
	}

	override void Tick()
	{
		super.Tick();
		if(!player || !player.mo || player.mo != self)
			return;

		if(ethanol_level > ethanol_max)
			ethanol_level = ethanol_max;
		if(ethanol_level > 0)
			ethanol_level--;

		if(vision_dmg > vision_dmg_max)
			vision_dmg = vision_dmg_max;
		if(vision_dmg > 0)
			vision_dmg--;

		if(injure_slowness > injure_slowness_max)
			injure_slowness = injure_slowness_max;
		if(injure_slowness > 0)
			injure_slowness--;
		speed = 0.6 - 0.4 * (float(injure_slowness) / injure_slowness_max);
	}
}
