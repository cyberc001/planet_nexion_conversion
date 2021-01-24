class PN_Eye : PN_Monster
{
	default
	{
		Health 95;

		Radius 30;
		Height 50;

		Speed 18;
		Mass 200;

		+NOPAIN
		+MISSILEMORE
		+MISSILEEVENMORE
		MinMissileChance 255;
		
		+FLOAT +NOGRAVITY
		
		DeathSound "enemies/generic/gib_death";
		Obituary "%o was stared at.";
	}

	int blinkfactor;
	override void BeginPlay()
	{
		super.BeginPlay();
		blinkfactor = 0;
	}

	states
	{
		Spawn:
			FEYE A 4 A_Look;
			FEYE A 0 {if(blinkfactor >= 10){return A_Jump(256, "Blink");}return ResolveState(null);}
			FEYE A 0 {blinkfactor += random(0,1);}
			FEYE B 4 A_Look;
			FEYE B 0 {if(blinkfactor >= 10){return A_Jump(256, "Blink");}return ResolveState(null);}
			FEYE b 0 {blinkfactor += random(0,1);}
			FEYE D 4 A_Look;
			FEYE D 0 {if(blinkfactor >= 10){return A_Jump(256, "Blink");}return ResolveState(null);}
			FEYE D 0 {blinkfactor += random(0,1);}
			Loop;
		See:
			FEYE A 3 A_Chase;
			FEYE A 0 {if(blinkfactor >= 10){return A_Jump(256, "Blink");}return ResolveState(null);}
			FEYE A 0 {blinkfactor += random(0,1);}
			FEYE B 3 A_Chase;
			FEYE B 0 {if(blinkfactor >= 10){return A_Jump(256, "Blink");}return ResolveState(null);}
			FEYE B 0 {blinkfactor += random(0,1);}
			FEYE D 3 A_Chase;
			FEYE D 0 {if(blinkfactor >= 10){return A_Jump(256, "Blink");}return ResolveState(null);}
			FEYE D 0 {blinkfactor += random(0,1);}
			Loop;
		Missile:
			FEYE I 0 A_StartSound("enemies/eye/attack", CHAN_AUTO);
			FEYE I 13 A_FaceTarget;
			FEYE I 0 {if(blinkfactor >= 10){blinkfactor = 0;return A_Jump(256, "Blink");}return ResolveState(null);}
			FEYE J 8 A_FaceTarget;
			FEYE J 0 {if(blinkfactor >= 10){blinkfactor = 0;return A_Jump(256, "Blink");}return ResolveState(null);}
			FEYE K 7 A_CustomBulletAttack(0.0, 0.0, 1, (15 + random(0,3)*5) * (Distance2D(target) <= 256.0 ? 1 : (1 - (Distance2D(target) - 256.0) / 768.0) ** 2 ), "PN_Eye_BlindPuff", 1024, CBAF_NORANDOM | CBAF_NORANDOMPUFFZ);
			FEYE K 0 {blinkfactor += 3;}
			FEYE K 0 {if(blinkfactor >= 10){blinkfactor = 0;return A_Jump(256, "Blink");}return ResolveState(null);}
			Goto See;
		Blink:
			FEYE C 15 {blinkfactor = 0;}
			Goto See;
		Death:
			FEYE E 8 A_Scream;
			FEYE F 7;
			FEYE G 6 A_NoBlocking;
			FEYE H -1;
			Stop;
	}
}

class PN_Eye_BlindPuff : actor
{
	default
	{
		+NOBLOCKMAP
		+NOGRAVITY
		+PUFFONACTORS

		+HITTRACER
		+PUFFGETSOWNER
	}
	states
	{
		XDeath:
			TNT0 A 0{
				if(tracer && tracer is "PN_Player"){
					PN_Player pl = PN_Player(tracer);
					pl.vision_dmg += (7 * 35) // base blind factor
								* (Distance2D(target) <= 256.0 ? 1 : (1 - ((Distance2D(target) - 256.0) / 768.0) ** 2 ));	// quadratic dropoff with distance
				}
			}
			Stop;
	}
}
