class PN_Antimatter_Ammo : Ammo
{
	default
	{
		Inventory.PickupMessage "Picked up cells filled with antimatter.";
		Inventory.Icon "AMTRA0";
		
		Inventory.Amount 10;
		Inventory.MaxAmount 100;
		Ammo.BackpackAmount 10;
		Ammo.BackpackMaxAmount 200;

		Ammo.DropAmount 10;
	}

	states
	{
		Spawn:
			AMTR A -1;
			Stop;
	}
}
