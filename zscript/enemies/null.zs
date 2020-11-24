class PN_Null : actor
{
	default
	{
		Alpha 0;
	}
	states
	{
		Spawn:
			ZOMB A 1 A_Remove(AAPTR_DEFAULT);
			Stop;
	}
}
