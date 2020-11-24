class PN_Antimatter_TinyCell : PN_Antimatter_Ammo
{
	default
	{
		Inventory.PickupMessage "Picked up a tiny cell filled with antimatter.";
		Inventory.Icon "AMTRB0";

		Inventory.Amount 2;

		Ammo.DropAmount 2;
	}

	states
	{
		Spawn:
			AMTR B -1;
			Stop;
	}
}
