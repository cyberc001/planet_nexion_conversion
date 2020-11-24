class PN_BH_Generator : Weapon
{
	default
	{
		Weapon.SelectionOrder 4600;
		Weapon.SlotNumber 4;

		Weapon.AmmoUse 10;
		Weapon.AmmoGive 10;
		Weapon.AmmoType "PN_Antimatter_Ammo";
		
		Tag "Blackhole generator";
		Inventory.PickupMessage "Got BH Generator!";
		Obituary "%o was sucked into a black hole created by %k.";
	}

	states
	{
		Spawn:
			BHGN A -1;
			Stop;
		Ready:
			BHGN B 1 A_WeaponReady;
			Loop;
		Select:
			BHGN B 1 A_Raise;
			Loop;
		Deselect:
			BHGN B 1 A_Lower;
			Loop;
		Fire:
			BHGN B 7;
			BHGN C 10;
			BHGN D 6 A_StartSound("weapons/bh_generator/attack", CHAN_WEAPON, 0, 1.0);
			BHGN E 7 A_FireProjectile("PN_Black_Hole", 0.0, 1, -4, 0, 0, 0);
			BHGN F 4;
			Goto Ready;
	}
}
