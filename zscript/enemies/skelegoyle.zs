// Make it summon ghosts as a medium-range attack
class PN_SkeleGoyle : PN_Monster
{
	default
	{
		Health 2500;

		Radius 64;
		Height 64;

		Speed 24;
		Mass 500;

		+NOPAIN
		+MISSILEMORE
		+MISSILEEVENMORE

		+FLOAT +NOGRAVITY
		+NOBLOOD

		SeeSound "enemies/skelegoyle/see";
		DeathSound "enemies/skelegoyle/death";
	}

	int cstrafe_time_min;
	int cstrafe_time_max;
	int cstrafe_timer;
	float cstrafe_dir;

	override void BeginPlay()
	{
		cstrafe_time_min = 2 * 35;
		cstrafe_time_max = 4 * 35;
		cstrafe_timer = 0;
		cstrafe_dir = 1.0;
	}

	states
	{
		Spawn:
			SGOL ABCD 8 A_Look;
			Loop;
		See:
			SGOL ABCD 4{
				A_Chase();
				if(cstrafe_timer <= 0){
					cstrafe_timer = random(cstrafe_time_min, cstrafe_time_max);
					if(random(1,2) == 1)
						cstrafe_dir = 1.0;
					else
						cstrafe_dir = -1.0;
				}
				--cstrafe_timer;
				A_ChangeVelocity(cstrafe_dir * 2.0, 0.0, 0.0, CVF_RELATIVE);
			}
			Loop;

		Death:
			SGOL A 70 A_Scream;
			SGOL H 12;
			SGOL I 8;
			SGOL J 8 A_NoBlocking;
			SGOL K -1;
			Stop;

		Missile:
			SGOL E 0{
				if(!target)
					return ResolveState("See");

				if(Distance3D(target) <= 256.0)
					if(random(1,3) == 1)
						return ResolveState("MissileBlackHole");
					else
						return ResolveState("MissileCircleBarrage");

				if(Distance3D(target) <= 512.0)
					if(random(1,6) == 1)
						return ResolveState("MissileRectBarrage");
					else
						return ResolveState("MissileDoublePredict");

					if(random(1, 4) == 1)
						return ResolveState("MissileBlackHole");
					else
						return ResolveState("MissileSprayBarrage");
			}
			Goto See;

		MissileCircleBarrage:
			SGOL E 8;
			SGOL F 12 A_StartSound("weapons/plasma_burner/attack", CHAN_AUTO);
			SGOL G 16{
				Vector3 m_pos;

				double m_ang = GetAngle(0);
				for(float r = 1.0; r <= 5.0; r += 1.0){
					for(float c_ang = 0.0; c_ang <= 360.0; c_ang += (360.0 / 3.0**(r-1)) ){
						float x_off = cos(c_ang) * r;
						float z_off = sin(c_ang) * r + 3.0;
						m_pos = pos;
						m_pos.x += sin(-m_ang) * x_off * 8.0;
						m_pos.y += cos(-m_ang) * x_off * 8.0;
						m_pos.z += z_off * 8.0;

						Actor missl = SpawnMissileXYZ(m_pos, target, "PN_SkeleGoyle_Plasma_Ball");
						if(!missl)
							continue;
						Vector2 proj_vel_xy = missl.vel.xy;
						proj_vel_xy = RotateVector(proj_vel_xy, x_off * 1.25);

						Actor t = target;
						target = missl;
						A_ChangeVelocity(proj_vel_xy.x, proj_vel_xy.y, missl.vel.z, CVF_REPLACE, AAPTR_TARGET);
						target = t;				
					}
				}
			}
			Goto See;

		MissileRectBarrage:
			SGOL E 8;
			SGOL F 12 A_StartSound("weapons/plasma_burner/attack", CHAN_AUTO);
			SGOL G 16{
				Vector3 m_pos;

				double m_ang = GetAngle(0);
				for(float x = -5.0; x <= 5.0; x += 1.0){
					for(float y = 1.0; y <= 9.0; y += 0.75){
						float x_off = x;
						float z_off = y;
						m_pos = pos;
						m_pos.x += sin(-m_ang) * x_off * 10.0;
						m_pos.y += cos(-m_ang) * x_off * 10.0;
						m_pos.z += z_off * 10.0;

						Actor missl = SpawnMissileXYZ(m_pos, target, "PN_SkeleGoyle_Plasma_Ball");
						Vector2 proj_vel_xy = missl.vel.xy;
						proj_vel_xy = RotateVector(proj_vel_xy, x * 2.0);

						Actor t = target;
						target = missl;
						A_ChangeVelocity(proj_vel_xy.x, proj_vel_xy.y, missl.vel.z, CVF_REPLACE, AAPTR_TARGET);
						target = t;							
					}
				}
			}
			Goto See;

		MissileDoublePredict:
			SGOL E 8;
			SGOL F 3 A_FaceTarget;
			SGOL F 0 A_StartSound("weapons/plasma_burner/attack", CHAN_AUTO);
			SGOL G 3{
				SpawnMissile(target, "PN_SkeleGoyle_Plasma_Ball");

				Actor missl = SpawnMissile(target, "PN_SkeleGoyle_Plasma_Ball");
				double init_dist = Distance3D(target);
				double init_proj_speed = sqrt(missl.vel.x ** 2 + missl.vel.y ** 2 + missl.vel.z ** 2);
				double init_proj_time = init_dist / init_proj_speed * 1.25; // we need to overshoot a little bit
				Vector3 estim_target_loc;
				estim_target_loc.x = target.pos.x + target.vel.x * init_proj_time;
				estim_target_loc.y = target.pos.y + target.vel.y * init_proj_time;
				estim_target_loc.z = target.pos.z + target.vel.z * init_proj_time;
				Vector3 proj_dr = estim_target_loc - pos;
				double proj_dr_ln = sqrt(proj_dr.x ** 2 + proj_dr.y ** 2 + proj_dr.z ** 2);
				proj_dr.x /= proj_dr_ln; proj_dr.y /= proj_dr_ln; proj_dr.z /= proj_dr_ln;
				Vector3 proj_new_vel = proj_dr * init_proj_speed;

				Actor t = target;
				target = missl;
				A_ChangeVelocity(proj_new_vel.x, proj_new_vel.y, proj_new_vel.z, CVF_REPLACE, AAPTR_TARGET);
				target = t;

				if(!CheckIfTargetInLos(170.0)){
					return ResolveState("See");
				}
				return ResolveState(null);
			}
			Goto MissileDoublePredict+1;
			

		MissileSprayBarrage:
			SGOL E 6;
			SGOL F 10 A_StartSound("weapons/plasma_burner/attack", CHAN_AUTO);
			SGOL G 12{
				Vector3 m_pos;

				double m_ang = GetAngle(0);
				for(float ang_i = -7.0; ang_i < 7.0; ang_i += 1.0)
				{
					float ang_off = ang_i * 6.0;
					Actor missl = SpawnMissile(target, "PN_SkeleGoyle_Plasma_Ball");
					Vector2 proj_vel_xy = missl.vel.xy;
					proj_vel_xy = RotateVector(proj_vel_xy, ang_off);

					Actor t = target;
					target = missl;
					A_ChangeVelocity(proj_vel_xy.x, proj_vel_xy.y, missl.vel.z, CVF_REPLACE, AAPTR_TARGET);
					target = t;
				}
			}
			Goto See;
		MissileBlackHole:
			SGOL E 12;
			SGOL F 16 A_StartSound("weapons/bh_generator/attack", CHAN_AUTO);
			SGOL G 20{
				Actor missl = SpawnMissile(target, "PN_Black_Hole");
				double init_dist = Distance3D(target);
				double init_proj_speed = sqrt(missl.vel.x ** 2 + missl.vel.y ** 2 + missl.vel.z ** 2);
				double init_proj_time = init_dist / init_proj_speed * 1.20; // we need to overshoot a little bit
				Vector3 estim_target_loc;
				estim_target_loc.x = target.pos.x + target.vel.x * init_proj_time;
				estim_target_loc.y = target.pos.y + target.vel.y * init_proj_time;
				estim_target_loc.z = target.pos.z + target.vel.z * init_proj_time;
				Vector3 proj_dr = estim_target_loc - pos;
				double proj_dr_ln = sqrt(proj_dr.x ** 2 + proj_dr.y ** 2 + proj_dr.z ** 2);
				proj_dr.x /= proj_dr_ln; proj_dr.y /= proj_dr_ln; proj_dr.z /= proj_dr_ln;
				Vector3 proj_new_vel = proj_dr * init_proj_speed;

				Actor t = target;
				target = missl;
				A_ChangeVelocity(proj_new_vel.x, proj_new_vel.y, proj_new_vel.z, CVF_REPLACE, AAPTR_TARGET);
				target = t;
			}
	}
}
