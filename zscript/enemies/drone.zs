class PN_Drone : PN_Monster
{
	default
	{
		Health 180;

		Radius 20;
		Height 20;

		Speed 15;
		Mass 250; // This little thing being pushed away is the least pleasant thing ever

		+NOPAIN
		+MISSILEMORE
		+MISSILEEVENMORE
		MinMissileChance 255;

		+FLOAT +NOGRAVITY
		+NOBLOOD

		SeeSound "enemies/drone/see";

		Obituary "%o was turned into space cheese.";

		// It wasn't in the original mod, but it's for a fair play
		DropItem "PN_Antimatter_Ammo", 32, 10;
		DropItem "PN_Antimatter_TinyCell", 96, 2;
	}

	float spr_def; // default spread
	float spr_min; // minimum spread (const)
	float spr; // current spread
	float spr_dec; // spread decrement per attack
	override void BeginPlay()
	{
		super.BeginPlay();
		spr_def = 11.0;
		spr_min = 5.0;
		spr = spr_def;
		spr_dec = 0.15;
	}

	states
	{
		Spawn:
			DRON ABCDE 4 A_Look;
			Loop;
		See:
			DRON ABCDE 2 A_Chase;
			Loop;

		Missile:
			DRON K 8 A_FaceTarget;
			DRON L 0 A_StartSound("weapons/plasma_burner/attack", CHAN_WEAPON);
			DRON L 8 A_FaceTarget;
			DRON M 5 A_CustomBulletAttack(spr, spr, 1, 5 + random(0,5)*2, "", 0, CBAF_NORANDOM);
			DRON N 6 {
					if(spr - spr_dec > spr_min)
						spr -= spr_dec; 
					else
						spr = spr_min;
					spr_dec += 0.15;
				}
			DRON N 0 {
					if(!CheckIfTargetInLOS(170.0)){
						spr_def -= 2.0 * (1 - spr/spr_def);
						if(spr_def < spr_min)
							spr_def = spr_min;
						spr = spr_def;
						return ResolveState("See");
					}
					return ResolveState(null);
				}
			Goto Missile+1;
		Death:
			DRON G 12;
			DRON H 8;
			DRON I 7 A_NoBlocking;
			DRON J 7;
			TNT0 A -1;
			Stop;
	}
}
