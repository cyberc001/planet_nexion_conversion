struct PN_Spawn_Group
{
	String replacee;
	String replacement;
	int leftovers; // in 1/256's
	int cur_leftovers;
}

class PN_EventHandler : StaticEventHandler
{
	PN_Spawn_Group spawn_groups[16];

	override void OnRegister()
	{
		spawn_groups[0].replacee = "ZombieMan"; spawn_groups[0].replacement = "PN_Zombie"; spawn_groups[0].leftovers = -64;
		spawn_groups[1].replacee = "ShotgunGuy"; spawn_groups[1].replacement = "PN_Zombie"; spawn_groups[1].leftovers = -16;
		spawn_groups[2].replacee = "ChainGuy"; spawn_groups[2].replacement = "PN_Drone"; spawn_groups[2].leftovers = -16;
		spawn_groups[3].replacee = "DoomImp"; spawn_groups[3].replacement = "PN_Eye"; spawn_groups[3].leftovers = -16;
		spawn_groups[4].replacee = "Demon"; spawn_groups[4].replacement = "PN_CeilingHanger"; spawn_groups[4].leftovers = -64;
		spawn_groups[5].replacee = "Spectre"; spawn_groups[5].replacement = "PN_CeilingHanger"; spawn_groups[5].leftovers = -16;
		spawn_groups[6].replacee = "LostSoul"; spawn_groups[6].replacement = "PN_Zombie"; spawn_groups[6].leftovers = -48;
		spawn_groups[7].replacee = "HellKnight"; spawn_groups[7].replacement = "PN_Abomination"; spawn_groups[7].leftovers = -96;
		spawn_groups[8].replacee = "BaronOfHell"; spawn_groups[8].replacement = "PN_Abomination"; spawn_groups[8].leftovers = 0;
		spawn_groups[9].replacee = "Fatso"; spawn_groups[9].replacement = "PN_Abomination"; spawn_groups[9].leftovers = -16;
		spawn_groups[10].replacee = "Revenant"; spawn_groups[10].replacement = "PN_Eye"; spawn_groups[10].leftovers = 0;
		spawn_groups[11].replacee = "Arachnotron"; spawn_groups[11].replacement = "PN_Drone"; spawn_groups[11].leftovers = 0;
		spawn_groups[12].replacee = "Cacodemon"; spawn_groups[12].replacement = "PN_Eye"; spawn_groups[12].leftovers = 0;
		spawn_groups[13].replacee = "PainElemental"; spawn_groups[13].replacement = "PN_Eye"; spawn_groups[13].leftovers = 0;
		spawn_groups[14].replacee = "SpiderMastermind"; spawn_groups[14].replacement = "PN_SkeleGoyle"; spawn_groups[14].leftovers = 0;
		spawn_groups[15].replacee = "Cyberdemon"; spawn_groups[15].replacement = "PN_SkeleGoyle"; spawn_groups[15].leftovers = 0;
	}

	override void WorldLoaded(WorldEvent e)
	{
		if(e.isSaveGame || e.isReopen)
			return;

		for(int i = 0; i < level.sectors.size(); ++i)
		{
			Actor thing_pt = level.sectors[i].thinglist;
			while(thing_pt)
			{
				if(!thing_pt.bSHOOTABLE || thing_pt.bNONSHOOTABLE)
				{
					thing_pt.bSHOOTABLE = true;
					thing_pt.bNONSHOOTABLE = false;
					thing_pt.bNOBLOOD = true;
					thing_pt.Health = 100;
				}
				thing_pt = thing_pt.snext;
			}
		}
	}

	override void CheckReplacement(ReplaceEvent e)
	{
		// TODO: make an option for not replacing the monsters, and also e.IsFinal status

		// Monsters:

		for(int i = 0; i <= 5; ++i)
			if(e.Replacee is spawn_groups[i].replacee){
				spawn_groups[i].cur_leftovers += spawn_groups[i].leftovers;
				if(spawn_groups[i].cur_leftovers <= -256){
					e.Replacement = "PN_Null";
					spawn_groups[i].cur_leftovers += 256;
					break;
				}
				/*else if(spawn_groups[i].cur_leftovers >= 256){
					while(spawn_groups[i].cur_leftovers >= 256){
						spawn_groups[i].cur_leftover -= 1;
						
					}
				}*/
				e.Replacement = spawn_groups[i].replacement;
				break;
			}
		

		// Weapons:
		if(e.Replacee is "Shotgun" || e.Replacee is "SuperShotgun")
			e.Replacement = "PN_Atom_Shredder";
		else if(e.Replacee is "Chaingun" || e.Replacee is "RocketLauncher")
			e.Replacement = "PN_Plasma_Burner";
		else if(e.Replacee is "PlasmaRifle" || "BFG9000")
			e.Replacement = "PN_BH_Generator";
		else if(e.Replacee is "Weapon" 
			&& !(e.Replacee is "PN_Atom_Shredder")
			&& !(e.Replacee is "PN_Plasma_Burner")
			&& !(e.Replacee is "PN_BH_Generator"))
			e.Replacement = "PN_Antimatter_Ammo"; // should I?

		// Ammo:
		if(e.Replacee is "Ammo"
		&& !(e.Replacee is "PN_Antimatter_Ammo")
		&& !(e.Replacee is "PN_Antimatter_TinyCell")
		&& !(e.Replacee is "PN_Antimatter_MediumCell"))
		{
			if(e.Replacee is "ClipBox"
			|| e.Replacee is "ShellBox"
			|| e.Replacee is "RocketBox"
			|| e.Replacee is "CellPack")
				e.Replacement = "PN_Antimatter_MediumCell";
			else if(e.Replacee is "Clip"
			|| e.Replacee is "Shell"
			|| e.Replacee is "RocketAmmo"
			|| e.Replacee is "Cell")
				e.Replacement = "PN_Antimatter_Ammo";;
		}

		// Health pickups:
		if(e.Replacee is "HealthBonus")
			e.Replacement = "PN_Alcohol_Cup";
		else if(e.Replacee is "Stimpack")
			e.Replacement = "PN_Alcohol";
		else if(e.Replacee is "Medikit")
			e.Replacement = "PN_Ether_Vial";
		else if(e.Replacee is "Soulsphere"
		     || e.Replacee is "Megasphere")
			e.Replacement = "PN_Spiritual_Heart";

		// Armor pickups:
		if(e.Replacee is "ArmorBonus")
			e.Replacement = "PN_TitaniumCube";
		else if(e.Replacee is "GreenArmor")
			e.Replacement = "PN_PCD";
		else if(e.Replacee is "BlueArmor")
			e.Replacement = "PN_LNA";
		else if(e.Replacee is "Armor")
			e.Replacement = "PN_PCD";
		
		// Keys:
		if(e.Replacee is "RedCard")
			e.Replacement = "PN_AccessCard_Red";
		else if(e.Replacee is "BlueCard")
			e.Replacement = "PN_AccessCard_Blue";
		else if(e.Replacee is "YellowCard")
			e.Replacement = "PN_AccessCard_Yellow";
		if(e.Replacee is "RedSkull")
			e.Replacement = "PN_Cardonite_Red";
		else if(e.Replacee is "BlueSkull")
			e.Replacement = "PN_Cardonite_Blue";
		else if(e.Replacee is "YellowSkull")
			e.Replacement = "PN_Cardonite_Yellow";
	}

	ui int overlay_tick;
	override void RenderOverlay(RenderEvent e)
	{
		overlay_tick++;
		if(overlay_tick > 35)
			overlay_tick = 0;

		PlayerInfo pl = players[consoleplayer];

		if(pl.mo is "PN_Player")
		{
			PN_Player pn_plr = PN_Player(pl.mo);

			if(pn_plr.ethanol_level > 25 * 35){
				Shader.SetUniform1i(pl, "PN_Drunk", "ethanol_level", pn_plr.ethanol_level);
				Shader.SetUniform1i(pl, "PN_Drunk", "ethanol_max", pn_plr.ethanol_max);
				Shader.SetUniform1i(pl, "PN_Drunk", "tick", overlay_tick);
				Shader.SetEnabled(pl, "PN_Drunk", true);
			}
			else
				Shader.SetEnabled(pl, "PN_Drunk", false);

			if(pn_plr.vision_dmg > 5 * 35){
				Shader.SetUniform1i(pl, "PN_VisionDamage", "vision_dmg", pn_plr.vision_dmg);
				Shader.SetUniform1i(pl, "PN_VisionDamage", "vision_dmg_effect_max", pn_plr.vision_dmg_effect_max);
				Shader.SetEnabled(pl, "PN_VisionDamage", true);
			}
			else
				Shader.SetEnabled(pl, "PN_VisionDamage", false);
		}
	}
}
