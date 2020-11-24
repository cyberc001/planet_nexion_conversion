class PN_CeilingHanger : PN_Monster
{
	default
	{
		Health 225;

		Radius 35;
		Height 50;

		Speed 14;
		Mass 200;

		+NOGRAVITY +DROPOFF
		+SPAWNCEILING
		+NOVERTICALMELEERANGE
		+NOPAIN

		DeathSound "enemies/generic/gib_death";

		Obituary "%o was torn apart by a ceiling hanger.";
	}

        override void BeginPlay()
        {
                super.BeginPlay();
                
                FCheckPosition fchk;
                CheckPosition(pos.xy, true, fchk);
                A_Warp(AAPTR_DEFAULT, pos.x, pos.y, fchk.ceilingz - height - 1, angle, WARPF_ABSOLUTEPOSITION | WARPF_NOCHECKPOSITION);
        }

	states
	{
		Spawn:
			CHNG ABCDE 4 A_Look();
			Loop;
		See:
			CHNG ABCDE 2 {
				A_Chase();
				if(self.bNOGRAVITY && Distance2D(target) <= 192.0)
				{
					self.bYFLIP = true;
					self.bNOVERTICALMELEERANGE = false;
					self.bNOGRAVITY = false;
					self.bCEILINGHUGGER = false;
					self.bFLOORCLIP = true;
				}
			}
			Loop;
		Melee:
			CHNG M 10;
			CHNG N 0 A_StartSound("enemies/ceiling_hanger/attack", CHAN_AUTO);
			CHNG N 8;
			CHNG O 6 A_CustomBulletAttack(0.0, 0.0, 1, 35 + random(0,4)*10, "BulletPuff", 0, CBAF_NORANDOM, AAPTR_TARGET, "", 0.0);
                        CHNG P 12;
			Goto See;
		Death:
			CHNG F 7 A_Scream;
			CHNG G 7;
			CHNG H 6;
			CHNG I 10;
			CHNG J 8;
			CHNG K 6 A_NoBlocking;
			CHNG L -1;
			Stop;
	}
}
