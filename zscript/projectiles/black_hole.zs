class PN_Black_Hole : Actor
{
	default
	{
		Radius 16;
		Height 16;
		
		Speed 10;
		Projectile;

		+RANDOMIZE;

		Obituary "%o was sucked into the black hole create by %k.";
	}

	Vector3 start_vel;
	float real_height;

	int self_dmg_cd;
	int pull_cd;

	bool is_dissapearing;

	override void BeginPlay()
	{
		super.BeginPlay();
		self_dmg_cd = 60;
		pull_cd = 30;
		is_dissapearing = false;
	}
	override void PostBeginPlay()
	{
		super.PostBeginPlay();
		real_height = self.height;
		start_vel = self.vel;
	}

	override void Tick()
	{
		super.tick();

		if(self_dmg_cd > 0)
			self_dmg_cd--;

		if(pull_cd > 0)
			pull_cd--;
		else
			A_RadiusThrust(-150 * (self.radius / 16), self.radius * 8, RTF_NOIMPACTDAMAGE | RTF_THRUSTZ | RTF_AFFECTSOURCE);

		BlockThingsIterator it = BlockThingsIterator.Create(self, 1024);
		Actor a;
		it.next();
		do{
			a = it.thing;
			if(Distance3D(a) <= self.radius){
				SpecialMissileHit(a);
			}
		} while(it.next());
	}
	override int SpecialMissileHit(Actor victim)
	{
		if(victim == target && self_dmg_cd > 0)
			return 1;
		
		float victim_volume = (victim.radius * victim.radius * 3.1416) * victim.height;
		float bh_volume = (self.radius * self.radius * 3.1416) * self.height;
		
		int dmg_amnt = 250 * (bh_volume / victim_volume);

		// growing on actor's mass
		float mass_mult = 0.1;
		float victim_avg_dim = mass_mult * (((victim.radius * 2 + victim.height) / 3) * 0.2);
		real_height += victim_avg_dim;
		A_SetSize(float(self.radius) + victim_avg_dim, float(self.real_height));
		A_SetScale(float(self.radius) / 16, real_height / 16);

		self.vel = start_vel * (16 / float(self.radius));

		if(victim.health <= dmg_amnt && victim != target)
		{
			// making a dead actor dissapear
			Actor t = self.master;
			self.master = victim;
			A_RemoveMaster(RMVF_EVERYTHING);
			self.master = t;
		}
		else
		{
			// damaging the actor after growing on it's mass
			victim.DamageMobj(self, target, dmg_amnt, "None");
		}

		return 1;
	}

	states
	{
		Spawn:
			BHOL ABCDEF 6;
			Loop;
		Death:
			BHOL G 0{
				self.is_dissapearing = true;
			}
			BHOL GHI 12;
			Stop;
	}
}
