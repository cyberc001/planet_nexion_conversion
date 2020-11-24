class PN_Atom_Shredder : Weapon
{
	default
	{
		Weapon.SelectionOrder 4800;
		Weapon.SlotNumber 2;
		
		Weapon.Kickback 200;

		Weapon.AmmoUse 1;
		Weapon.AmmoGive 2;
		Weapon.AmmoType "PN_Antimatter_Ammo";

		Tag "Atom shredder";
		Inventory.PickupMessage "Got atomic shredder!";	
		Obituary "%o's atoms were disintegrated by %k's atom shredder.";
	}

	states
	{
		Spawn:
			SHRD A -1;
			Stop;
		Ready:
			SHRD B 1 A_WeaponReady;
			Loop;
		Select:
			SHRD B 1 A_Raise;
			Loop;
		Deselect:
			SHRD B 1 A_Lower;
			Loop;
		Fire:
			SHRD B 5;
			SHRD C 7;
			SHRD D 0 A_StartSound("weapons/atom_shredder/attack", CHAN_WEAPON, 0, 1.0);
			SHRD D 0 A_GunFlash;
			SHRD D 3 A_FireBullets(0.0, 0.0, 1, 20 + random(0, 25), "BulletPuff", FBF_NORANDOM | FBF_USEAMMO);
			SHRD E 11;
			SHRD F 4 A_ReFire();
			Goto Ready;
		Flash:
			SHRF A 3 Bright A_Light1;
			Goto LightDone;
	}
}
