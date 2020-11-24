class PN_Zombie : PN_Monster
{	
	default
	{
		Health 130;

		Radius 20;
		Height 62;

		Speed 12;
		Mass 350;
	
		PainChance 64;
		MeleeRange 70;

		+FLOORCLIP;

		SeeSound "enemies/zombie/see";
		AttackSound "enemies/zombie/attack";
		DeathSound "enemies/zombie/death";

		Obituary "%o was bit by a zombie.";

		// It wasn't in the original mod, but it's for a fair play
		DropItem "PN_Antimatter_Ammo", 8, 10;
		DropItem "PN_Antimatter_TinyCell", 32, 2;
		DropItem "PN_Alcohol", 8, 10;
		DropItem "PN_Alcohol_Cup", 16, 10;
	}
	states
	{
		Spawn:
			ZOMB A 20 A_Look;
			Loop;
		See:
			ZOMB A 8 A_Chase;
			ZOMB A 0 {if(random(0, 16) == 1) A_StartSound("enemies/zombie/see", CHAN_AUTO);}
			ZOMB A 0 A_JumpIf(random(1, 32) == 1 && Distance2D(target) <= 128.0, "MeleeLeap");
			ZOMB A 0 {if(ShouldDodge(5)) return A_Jump(256, "Dodge"); return ResolveState(null);}
			ZOMB B 8 A_Chase;
			ZOMB B 0 {if(random(0, 16) == 1) A_StartSound("enemies/zombie/see", CHAN_AUTO);}
			ZOMB B 0 A_JumpIf(random(1, 32) == 1 && Distance2D(target) <= 128.0, "MeleeLeap");
			ZOMB B 0 {if(ShouldDodge(4)) return A_Jump(256, "Dodge"); return ResolveState(null);}
			ZOMB C 8 A_Chase;
			ZOMB C 0 {if(random(0, 16) == 1) A_StartSound("enemies/zombie/see", CHAN_AUTO);}
			ZOMB C 0 A_JumpIf(random(1, 32) == 1 && Distance2D(target) <= 128.0, "MeleeLeap");
			ZOMB C 0 {if(ShouldDodge(4)) return A_Jump(256, "Dodge"); return ResolveState(null);}
			ZOMB D 8 A_Chase;
			ZOMB D 0 {if(random(0, 16) == 1) A_StartSound("enemies/zombie/see", CHAN_AUTO);}
			ZOMB D 0 A_JumpIf(random(1, 32) == 1 && Distance2D(target) <= 128.0, "MeleeLeap");
			ZOMB D 0 {if(ShouldDodge(3)) return A_Jump(256, "Dodge"); return ResolveState(null);}
			ZOMB E 8 A_Chase;
			ZOMB E 0 {if(random(0, 16) == 1) A_StartSound("enemies/zombie/see", CHAN_AUTO);}
			ZOMB E 0 A_JumpIf(random(1, 32) == 1 && Distance2D(target) <= 128.0, "MeleeLeap");
			ZOMB E 0 {if(ShouldDodge(3)) return A_Jump(256, "Dodge"); return ResolveState(null);}

			Loop;

		Melee:
			ZOMB F 0 A_JumpIf(random(1, 6) == 1 || (Distance2D(target) > 90.0 && random(1,3) != 1), "MeleeLeap");
			ZOMB F 15 A_FaceTarget;
			ZOMB G 0 A_JumpIf(random(1, 6) == 1 || (Distance2D(target) > 90.0 && random(1,3) != 1), "MeleeLeap");
			ZOMB G 15 A_FaceTarget;
			ZOMB H 0 A_StartSound("enemies/zombie/attack", CHAN_AUTO);
			ZOMB H 12 A_CustomBulletAttack(0.0, 0.0, 1, 20 + random(0,3)*8, "", 80, CBAF_NORANDOM);
			Goto See;
		MeleeLeap:
			ZOMB G 0 A_FaceTarget;
			ZOMB G 0 A_StartSound("enemies/zombie/attack", CHAN_AUTO);
			ZOMB G 15 A_ChangeVelocity(75.0 * (Distance2D(target) / 128.0), 0.0, 5.0, CVF_RELATIVE);
			ZOMB H 25 A_CustomBulletAttack(0.0, 0.0, 1, 20 + random(0,3)*8, "", 70, CBAF_NORANDOM);
		Dodge:
			ZOMB A 0 A_FaceTarget;
			ZOMB A 0 A_JumpIf(random(0,1) == 0, "DodgeRight");
			ZOMB B 0 A_ChangeVelocity(random(-2.5, 20.0) * (Distance2D(target) / 128.0), -15.0, 0.0, CVF_RELATIVE);
			ZOMB BCD 1;
			Goto See;
		DodgeRight:
			ZOMB B 0 A_ChangeVelocity(random(-2.5, 20.0) * (Distance2D(target) / 128.0), 15.0, 0.0, CVF_RELATIVE);
			ZOMB BCD 1;
			Goto See;

		Pain:
			ZOMB J 0 A_JumpIf(random(0,1) == 0, "PainRight");
			ZOMB J 6;
			ZOMB J 6;
			ZOMB J 6 {if(ShouldDodge(2)) return A_Jump(256, "Dodge"); return ResolveState(null);}
			Goto See;
		PainRight:
			ZOMB I 6;
			ZOMB I 6;
			ZOMB I 6 {if(ShouldDodge(2)) return A_Jump(256, "Dodge"); return ResolveState(null);}
			Goto See;

		Death:
			ZOMB K 9 A_Scream;
			ZOMB L 8;
			ZOMB M 7 A_NoBlocking;
			ZOMB N -1;
			Stop;
	}

	protected bool ShouldDodge(int chance_denom)
	{
		return target && target is "PlayerPawn"
		   && CheckIfTargetInLOS()
		   && (PlayerPawn(target).curstate == PlayerPawn(target).MissileState
		   ||  PlayerPawn(target).curstate == PlayerPawn(target).MeleeState)
		   && random(1,chance_denom) == 1;
	}
}
