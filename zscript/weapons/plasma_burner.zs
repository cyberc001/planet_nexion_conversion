class PN_Plasma_Burner : Weapon
{
	default
	{
		Weapon.SelectionOrder 4700;
		Weapon.SlotNumber 3;

		Weapon.Kickback 200;

		Weapon.AmmoUse 1;
		Weapon.AmmoGive 2;
		Weapon.AmmoType "PN_Antimatter_Ammo";

		Tag "Plasma burner";
		Inventory.PickupMessage "Got plasma burner!";
		Obituary "%o was burned by %k.";
	}


	states
	{
		Spawn:
			PBRN A -1;
			Stop;
		Ready:
			PBRN B 1 A_WeaponReady;
			Loop;
		Select:
			PBRN B 1 A_Raise;
			Loop;
		Deselect:
			PBRN B 1 A_Lower;
			Loop;
		Fire:
			PBRN C 3;
			PBRN D 0 A_StartSound("weapons/plasma_burner/attack", CHAN_WEAPON, 0, 1.0);
			PBRN D 0 A_GunFlash;
			PBRN D 4 A_FireProjectile("PN_Plasma_Ball", 0.0, 1, -4, 12, 0, 0);
			PBRN E 3 A_ReFire();
			PBRN F 5;
			Goto Ready;
		Flash:
			PBRF A 4 Bright A_Light1;
			Goto LightDone;
	}
}
