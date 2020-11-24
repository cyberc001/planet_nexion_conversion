class PN_DeathBone : Weapon
{
	default
	{
		Weapon.SelectionOrder 4900;
		Weapon.SlotNumber 1;

		+WEAPON.MELEEWEAPON
		Weapon.Kickback 150;
		
		Tag "Deathbone";
		Obituary "%o was impaled by %k's deathbone.";
	}

	states
	{
		Ready:
			BONE B 1 A_WeaponReady;
			Loop;
		Select:
			BONE B 1 A_Raise;
			Loop;
		Deselect:
			BONE B 1 A_Lower;
			Loop;
		Fire:
			BONE C 2 A_StartSound("weapons/deathbone/attack", CHAN_WEAPON, 0, 1.0);
			BONE D 3;
			BONE E 6 A_CustomPunch(25 + random(0, 20), 1, CPF_NOTURN, "BulletPuff", 75, -1, -1, "", "", "");
			BONE F 8;
			BONE B 6;
			Goto Ready;
	}
} 
