class PN_AccessCard : DoomKey
{
	default
	{
		Radius 20;
		Height 20;
		+NOTDMATCH
	}
}
class PN_Cardonite : DoomKey
{
	default
	{
		Radius 30;
		Height 25;
		+NOTDMATCH;
	}
}

class PN_AccessCard_Blue : PN_AccessCard
{
	default
	{
		Inventory.PickupMessage "Got blue access card.";
	}
	
	states
	{
		Spawn:
			ACRD B 20;
			ACRD B 7 Bright;
			Loop;
	}
}
class PN_AccessCard_Yellow : PN_AccessCard
{
	default
	{
		Inventory.PickupMessage "Got yellow access card.";
	}
	
	states
	{
		Spawn:
			ACRD Y 20;
			ACRD Y 7 Bright;
			Loop;
	}
}
class PN_AccessCard_Red : PN_AccessCard
{
	default
	{
		Inventory.PickupMessage "Got red access card.";
	}
	
	states
	{
		Spawn:
			ACRD R 20;
			ACRD R 7 Bright;
			Loop;
	}
}

class PN_Cardonite_Blue : PN_Cardonite
{
	default
	{
		Inventory.PickupMessage "Got blue cardonite,";
	}
	
	states
	{
		Spawn:
			CRDT B 20;
			CRDT B 7 Bright;
			Loop;
	}
}
class PN_Cardonite_Yellow : PN_Cardonite
{
	default
	{
		Inventory.PickupMessage "Got yellow cardonite.";
	}
	
	states
	{
		Spawn:
			CRDT Y 20;
			CRDT Y 7 Bright;
			Loop;
	}
}
class PN_Cardonite_Red : PN_Cardonite
{
	default
	{
		Inventory.PickupMessage "Got red cardonite.";
	}
	
	states
	{
		Spawn:
			CRDT R 20;
			CRDT R 7 Bright;
			Loop;
	}
}
