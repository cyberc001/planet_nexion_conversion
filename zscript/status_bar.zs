class PN_StatusBar : BaseStatusBar
{
	HUDFont f_stbarnums;

	override void Init()
	{
		Super.Init();
		SetSize(32, 320, 200);

		i_tick = 0;

		Font f_base = "PN_STATUSBAR_FONT";
		f_stbarnums = HUDFont.Create(f_base, f_base.GetCharWidth("0"), Mono_CellLeft);
	}

	override void Draw(int state, double tic_frac)
	{
		super.Draw(state, tic_frac);

		if(state == HUD_StatusBar)
		{
			BeginStatusBar();
			DrawStatusBar();
		}
		else if(state == HUD_Fullscreen)
		{
			BeginHUD();
			DrawFullscreenHUD();
		}
	}

	protected int i_tick;
	override void Tick()
	{
		super.Tick();
		i_tick++;
		if(i_tick > 35)
			i_tick = 0;
	}

	void DrawStatusBar()
	{		
		Fill(Color(255, 0, 0, 0), -350, 160, 1000, 40);
		DrawImage("PNSTBAR", (0, 160), DI_ITEM_OFFSETS);

		DrawTexture(GetMugshot(5), (144, 165), DI_ITEM_OFFSETS);

		DrawBarAmmo();
		DrawBarWeapons();
		DrawBarHealth();
		DrawBarKeys();
		DrawCompass();
		DrawLifeline();
	}

	void DrawFullscreenHUD()
	{
	}


	protected void DrawBarAmmo()
	{
		int amnt = GetAmount("PN_Antimatter_Ammo");
		DrawString(f_stbarnums, FormatNumber(amnt, 3), (258, 190), DI_TEXT_ALIGN_RIGHT);
	}
	protected void DrawBarWeapons()
	{
		if(GetAmount("PN_Deathbone") >= 1)
			DrawImage(CPlayer.ReadyWeapon is "PN_Deathbone" ? "PNSTWA1" : "PNSTWU1", (220, 165), DI_ITEM_OFFSETS);
		if(GetAmount("PN_Atom_Shredder") >= 1)
			DrawImage(CPlayer.ReadyWeapon is "PN_Atom_Shredder" ? "PNSTWA2" : "PNSTWU2", (220, 171), DI_ITEM_OFFSETS);
		if(GetAmount("PN_Plasma_Burner") >= 1)
			DrawImage(CPlayer.ReadyWeapon is "PN_Plasma_Burner" ? "PNSTWA3" : "PNSTWU3", (220, 177), DI_ITEM_OFFSETS);
		if(GetAmount("PN_BH_Generator") >= 1)
			DrawImage(CPlayer.ReadyWeapon is "PN_BH_Generator" ? "PNSTWA4" : "PNSTWU4", (220, 183), DI_ITEM_OFFSETS);
	}
	protected void DrawBarHealth()
	{
		DrawString(f_stbarnums, FormatNumber(CPlayer.health, 3), (130, 190), DI_TEXT_ALIGN_RIGHT);
	}
	protected void DrawBarKeys()
	{
		bool pkeys[6];
		for(int i = 0; i < 6; ++i)
			pkeys[i] = CPlayer.mo.CheckKeys(i + 1, false, true);

		if(pkeys[0]) DrawImage("PNSTKE2", (47, 185), DI_ITEM_OFFSETS);
		if(pkeys[1]) DrawImage("PNSTKE0", (50, 185), DI_ITEM_OFFSETS);
		if(pkeys[2]) DrawImage("PNSTKE1", (53, 185), DI_ITEM_OFFSETS);
		if(pkeys[3]) DrawImage("PNSTKE5", (73, 181), DI_ITEM_OFFSETS);
		if(pkeys[4]) DrawImage("PNSTKE3", (76, 181), DI_ITEM_OFFSETS);
		if(pkeys[5]) DrawImage("PNSTKE4", (79, 181), DI_ITEM_OFFSETS);
	}
	protected void DrawCompass()
	{
		double ang = abs(CPlayer.mo.Angle % 360);
		int byte_ang = round(ang / 45) + 1;
		if(byte_ang >= 9)
			byte_ang = 1;
		DrawImage(String.Format("PNSTCP%d", byte_ang), (196, 190));
	}
	protected void DrawLifeline()
	{
		int ll_num;
		if(i_tick >= 24) ll_num = 3;
		else if(i_tick >= 12) ll_num = 2;
		else ll_num = 1;

		if(CPlayer.health <= 0)
			ll_num = 0;
		else if(CPlayer.health < 50)
			ll_num += 3;

		DrawImage(String.Format("PNSTLL%d", ll_num), (120, 190));
	}
}
