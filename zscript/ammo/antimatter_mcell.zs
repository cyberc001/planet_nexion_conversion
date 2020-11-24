class PN_Antimatter_MediumCell : PN_Antimatter_Ammo
{
	default
	{
		Inventory.PickupMessage "Picked up a medium cell filled with antimatter.";
		Inventory.Icon "AMTRC0";

		Inventory.Amount 20;

		Ammo.DropAmount 20;
	}

	states
	{
		Spawn:
			AMTR C -1;
			Stop;
	}
}
