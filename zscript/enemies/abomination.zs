class PN_Abomination : PN_Monster
{
	default
	{
		Health 750;

		Radius 80;
		Height 100;

		Speed 14;
		Mass 600;

		PainChance 64;
		MeleeRange 110;

		+FLOORCLIP;

		AttackSound "enemies/zombie/attack";
		DeathSound "enemies/abomination/death";

		Obituary "%o was murdered by an abomination.";
	}

	int acid_reserve; // "reserve" of acid in stomach for distant attacks

	int fear_health;
	int fear_timer;
	int fear_time;
	int fear_cd;

	int charge_timer;
	int charge_Time;

	override void BeginPlay()
	{
		super.BeginPlay();

		acid_reserve = 0;

		fear_health = 200;
		fear_time = 15 * 17;
		fear_cd = 60 * 17;
		fear_timer = 0;

		charge_time = 4 * 35;
		charge_timer = 0;
	}
	override void Tick()
	{
		super.Tick();
		// Engaging a charge attack
		if(health <= fear_health)
			return;
		if(charge_timer == 0 && random(1,10*35) == 1)
			charge_timer = charge_time;
		if(charge_timer > 0){
			--charge_timer;
			if(charge_timer > 1*35)
				A_FaceTarget();
			A_ChangeVelocity(12.0, 0.0, 0.0, CVF_RELATIVE);
		}
	}

	states
	{
		Spawn:
			ABOM AC 10 A_Look;
			Loop;
		See:
			ABOM ABCD 2{
				A_Chase();

				if(random(1,7) == 1) // passive acid regen
					acid_reserve++;

				if(bFRIGHTENED && fear_timer > 0){
					fear_timer--;
					return;
				}
				if(!bFRIGHTENED && fear_timer < 0){
					fear_timer++;
				}
				if(fear_timer == 0 && !bFRIGHTENED && health <= fear_health){
					fear_timer = fear_time;
					bFRIGHTENED = true;
					return;
				}
				if(fear_timer == 0 && bFRIGHTENED){
					fear_timer = fear_cd;
					bFRIGHTENED = false;
				}
				
				// On low health, choosing a target to feast on
				if(health <= fear_health)
				{
					double mindist = 999999.999999;
					double dist;
					BlockThingsIterator it = BlockThingsIterator.Create(self);
					it.next();
					do{
						if(it.thing == self
						|| it.thing is "PlayerPawn"
						|| it.thing.health <= 0
						|| !it.thing.bISMONSTER
						|| it.thing is "PN_Abomination")
							continue;

						dist = Distance2D(it.thing);
						if(dist < mindist){
							mindist = dist;
							target = it.thing;
						}
					}while(it.next());
					return;
				}
			}
			Loop;

		Melee:
			ABOM K 0 {if(target is "PlayerPawn") return ResolveState(null); return ResolveState("MeleeFeast");}
			ABOM K 0 {if(charge_timer > 0) charge_timer = 1*35;} // Keeping some momentum
			ABOM K 8 {if(health <= fear_health && target is "PlayerPawn") return ResolveState("See"); return ResolveState(null);}
			ABOM L 6 {if(health <= fear_health && target is "PlayerPawn") return ResolveState("See"); return ResolveState(null);}
			ABOM M 4 A_CustomBulletAttack(0.0, 0.0, 1, 20 + random(0,3)*5, "PN_Abomination_SlowPuff", 140, CBAF_NORANDOM);
			ABOM L 12 {if(health <= fear_health && target is "PlayerPawn") return ResolveState("See"); return ResolveState(null);}
			ABOM K 10;
			Goto See;
		Missile:
			ABOM K 0 {if(!(target is "PlayerPawn") || acid_reserve < 10) return ResolveState("See"); return ResolveState(null);}
			ABOM K 6;
			ABOM L 4;
			ABOM M 3{
				acid_reserve -= 10;
				SpawnMissile(target, "BaronBall");
			}
			ABOM L 8;
			ABOM K 6;
			Goto See;
		MeleeFeast:
			ABOM A 6;
			ABOM B 4;
			ABOM C 3 A_CustomBulletAttack(0.0, 0.0, 1, 20 + random(0,3)*5, "PN_Abomination_SlowPuff", 140, CBAF_NORANDOM);
			ABOM D 14;
			Goto See;

		Pain:
			ABOM F 10;
			Goto See;
		Death:
			ABOM F 8 A_Scream;
			ABOM G 16;
			ABOM H 12;
			ABOM I 8 A_NoBlocking;
			ABOM J -1;
			Stop;
	}
}

class PN_Abomination_SlowPuff : actor
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
					pl.injure_slowness += 10 * 35;
				}
				else if(tracer && tracer.bISMONSTER){
					target.health += 50;
					PN_Abomination(target).acid_reserve += 20;
				}
			}
			Stop;
	}
}
