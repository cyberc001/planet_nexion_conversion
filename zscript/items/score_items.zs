class PN_KnowledgeBit : Inventory
{
	default
	{
		Inventory.Amount 1;
		Inventory.MaxAmount 250;
	}

	override void ModifyDamage(int damage, Name damageType, out int newdamage, bool passive, Actor inflictor, Actor source, int flags)
	{
		if(passive)
			return;

		newdamage = damage * ( 1 + sqrt(self.amount / 100.0) ); // Make a better formula
	}
}

class PN_LNA : CustomInventory
{
	default
	{
		Inventory.PickupMessage "Picked up an LNA sample.";
	}

	states
	{
		Spawn:
			LNAA A 1;
			Loop;
		Pickup:
			TNT1 A 0 A_GiveInventory("PN_KnowledgeBit", 40);
			Stop;
	}
}

class PN_PCD : CustomInventory
{
	default
	{
		Inventory.PickupMessage "Picked up a sample of plasmatic crystal drops.";
	}

	states
	{
		Spawn:
			PCDA A 1;
			Loop;
		Pickup:
			TNT1 A 0 A_GiveInventory("PN_KnowledgeBit", 20);
			Stop;
	}
}

class PN_TitaniumCube : CustomInventory
{
	default
	{
		Inventory.PickupMessage "Picked a cube made of molecular titanium.";
	}

	states
	{
		Spawn:
			TCUB A 1;
			Loop;
		Pickup:
			TNT1 A 0 A_GiveInventory("PN_KnowledgeBit", 5);
			Stop;
	}
}
