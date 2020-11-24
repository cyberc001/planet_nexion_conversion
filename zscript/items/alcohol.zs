class PN_Alcohol : Health
{
	default
	{
		Inventory.Amount 10;
		Inventory.MaxAmount 100;

		Inventory.PickupMessage "Drank some 99.9% alcohol bewerage.";
	}

	override void DoPickupSpecial(Actor toucher)
	{
		if(toucher is "PN_Player")
			(PN_Player(toucher)).ethanol_level += 25 * 35;
	}

	states
	{
		Spawn:
			BOOZ E 1;
			Loop;
	}
}


class PN_Alcohol_Cup : PN_Alcohol
{
	default
	{
		Inventory.Amount 2;

		Inventory.PickupMessage "Drank a cup of 99.9% alcohol bewerage.";
	}

	override void DoPickupSpecial(Actor toucher)
	{
		if(toucher is "PN_Player")
			(PN_Player(toucher)).ethanol_level += 5 * 35;
	}

	states
	{
		Spawn:
			BOOZ A 1;
			Loop;
	}
}
