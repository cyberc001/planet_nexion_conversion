class PN_Ether_Vial : Health
{
	default
	{
		Inventory.Amount 50;
		Inventory.MaxAmount 100;

		Inventory.PickupMessage "Picked up an ether vial.";
	}

	states
	{
		Spawn:
			VIAL A 1;
			Loop;
	}
}
