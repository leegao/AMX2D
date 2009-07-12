-- Author, Kiffer-Opa; Thanks a lot for this.
-- item IDs
USP			= 1;
Glock		= 2;
Deagle		= 3;
P228		= 4;
Elite		= 5;
FiveSeven	= 6;

M3			=10;
XM1014		=11;

MP5			=20;
TMP			=21;
P90			=22;
Mac10		=23;
UMP45		=24;

Galil		=38;
Famas		=39;
AK47		=30;
M4A1		=32;
SG552		=31;
Aug          =33;
Scout          =34;
AWP          =35;
G3SG1          =36;
SG550          =37;

M249          =40;

PrimaryAmmo     =61;
SecondaryAmmo     =62;

HE          =51;
Flashbang     =52;
SmokeGrenade     =53;
Flare          =54;
DefuseKit     =56;
Kevlar          =57;
KevlarHelm     =58;
NightVision     =59;
TacticalShield     =41;

Knife           =50;
Machete          =69;
Wrench          =74;
Claw          =78;
Chainsaw     =85;

GasGrenade     =72;
MolotovCocktail     =73;
Snowball     =75;
AirStrike     =76;

Mine          =77;

Laser          =45;

Flamethrower     =46;

RPGLauncher     =47;
RocketLauncher     =48;
GrenadeLauncher     =49;

LightArmor     =79;
Armor          =80;
HeavyArmor     =81;
SuperArmor     =83;
MedicArmor     =82;

StealthSuit     =84;

Medikit          =64;
Bandage          =65;

Coins          =66;
Money          =67;
Gold          =68;

--Armor Values. Do not set this as the weapon ID.

-- armor IDs
-- use them as armor value to give a player a special armor item
a_LightArmor     = 201;
a_Armor          = 202;
a_HeavyArmor     = 203;
a_SuperArmor     = 205;
a_MedicArmor     = 204;
a_StealthSuit     = 206;

wpnid = {}

wpn = {}

wpnid.USP			= USP;
wpnid.Glock			= Glock;
wpnid.Deagle			= Deagle;
wpnid.P228			= P228;
wpnid.Elite			= Elite;
wpnid.FiveSeven		= FiveSeven;

wpnid.M3				= M3;
wpnid.XM1014			= XM1014;

wpnid.MP5			= MP5;
wpnid.TMP			= TMP;
wpnid.P90			= P90;
wpnid.Mac10			= Mac10;
wpnid.UMP45			= UMP45;

wpnid.Galil			= Galil;
wpnid.Famas			= Famas;
wpnid.AK47			= AK47;
wpnid.M4A1			= M4A1;
wpnid.SG552			= SG552;
wpnid.Aug    		= Aug;
wpnid.Scout  		= Scout;
wpnid.AWP    		= AWP;
wpnid.G3SG1  		= G3SG1;
wpnid.SG550  		= SG550;

wpnid.M249   		= M249;

wpnid.PrimaryAmmo	= PrimaryAmmo;
wpnid.SecondaryAmmo	= SecondaryAmmo;

wpnid.HE          	= HE;
wpnid.Flashbang     	= Flashbang;
wpnid.SmokeGrenade	= SmokeGrenade;
wpnid.Flare          = Flare;
wpnid.DefuseKit		= DefuseKit;
wpnid.Kevlar			= Kevlar;
wpnid.KevlarHelm		= KevlarHelm;
wpnid.NightVision	= NightVision;
wpnid.TacticalShield	= TacticalShield;

wpnid.Knife			= Knife;
wpnid.Machete		= Machete;
wpnid.Wrench			= Wrench;
wpnid.Claw			= Claw;
wpnid.Chainsaw		= Chainsaw;

wpnid.GasGrenade		= GasGrenade;
wpnid.MolotovCocktail= MolotovCocktail;
wpnid.Snowball		= Snowball;
wpnid.AirStrike		= AirStrike;

wpnid.Mine			= Mine;

wpnid.Laser			= Laser;

wpnid.Flamethrower	= Flamethrower;

wpnid.RPGLauncher	= RPGLauncher;
wpnid.RocketLauncher	= RocketLauncher;
wpnid.GrenadeLauncher= GrenadeLauncher;

wpnid.LightArmor		= LightArmor;
wpnid.Armor			= Armor;
wpnid.HeavyArmor		= HeavyArmor;
wpnid.SuperArmor		= SuperArmor;
wpnid.MedicArmor		= MedicArmor;

wpnid.StealthSuit	= StealthSuit;

wpnid.Medikit		= Medikit;
wpnid.Bandage		= Bandage;

wpnid.Coins			= Coins;
wpnid.Money			= Money;
wpnid.Gold			= Gold;

-----------------------------
wpn.id = {}

wpn.id.USP			= USP;
wpn.id.Glock			= Glock;
wpn.id.Deagle			= Deagle;
wpn.id.P228			= P228;
wpn.id.Elite			= Elite;
wpn.id.FiveSeven		= FiveSeven;

wpn.id.M3				= M3;
wpn.id.XM1014			= XM1014;

wpn.id.MP5			= MP5;
wpn.id.TMP			= TMP;
wpn.id.P90			= P90;
wpn.id.Mac10			= Mac10;
wpn.id.UMP45			= UMP45;

wpn.id.Galil			= Galil;
wpn.id.Famas			= Famas;
wpn.id.AK47			= AK47;
wpn.id.M4A1			= M4A1;
wpn.id.SG552			= SG552;
wpn.id.Aug    		= Aug;
wpn.id.Scout  		= Scout;
wpn.id.AWP    		= AWP;
wpn.id.G3SG1  		= G3SG1;
wpn.id.SG550  		= SG550;

wpn.id.M249   		= M249;

wpn.id.PrimaryAmmo	= PrimaryAmmo;
wpn.id.SecondaryAmmo	= SecondaryAmmo;

wpn.id.HE          	= HE;
wpn.id.Flashbang     	= Flashbang;
wpn.id.SmokeGrenade	= SmokeGrenade;
wpn.id.Flare          = Flare;
wpn.id.DefuseKit		= DefuseKit;
wpn.id.Kevlar			= Kevlar;
wpn.id.KevlarHelm		= KevlarHelm;
wpn.id.NightVision	= NightVision;
wpn.id.TacticalShield	= TacticalShield;

wpn.id.Knife			= Knife;
wpn.id.Machete		= Machete;
wpn.id.Wrench			= Wrench;
wpn.id.Claw			= Claw;
wpn.id.Chainsaw		= Chainsaw;

wpn.id.GasGrenade		= GasGrenade;
wpn.id.MolotovCocktail= MolotovCocktail;
wpn.id.Snowball		= Snowball;
wpn.id.AirStrike		= AirStrike;

wpn.id.Mine			= Mine;

wpn.id.Laser			= Laser;

wpn.id.Flamethrower	= Flamethrower;

wpn.id.RPGLauncher	= RPGLauncher;
wpn.id.RocketLauncher	= RocketLauncher;
wpn.id.GrenadeLauncher= GrenadeLauncher;

wpn.id.LightArmor		= LightArmor;
wpn.id.Armor			= Armor;
wpn.id.HeavyArmor		= HeavyArmor;
wpn.id.SuperArmor		= SuperArmor;
wpn.id.MedicArmor		= MedicArmor;

wpn.id.StealthSuit	= StealthSuit;

wpn.id.Medikit		= Medikit;
wpn.id.Bandage		= Bandage;

wpn.id.Coins			= Coins;
wpn.id.Money			= Money;
wpn.id.Gold			= Gold;

wpn.name = {}
wpn[USP]			= "USP";
wpn[Glock]			= "Glock";
wpn[Deagle]			= "Deagle";
wpn[P228]			= "P228";
wpn[Elite]			= "Elite";
wpn[FiveSeven]		= "FiveSeven";

wpn[M3]				= "M3";
wpn[XM1014]			= "XM1014";

wpn[MP5]			= "MP5";
wpn[TMP]			= "TMP";
wpn[P90]			= "P90";
wpn[Mac10]			= "Mac10";
wpn[UMP45]			= "UMP45";

wpn[Galil]			= "Galil";
wpn[Famas]			= "Famas";
wpn[AK47]			= "AK47";
wpn[M4A1]			= "M4A1";
wpn[SG552]			= "SG552";
wpn[Aug]    		= "Aug";
wpn[Scout]  		= "Scout";
wpn[AWP]    		= "AWP";
wpn[G3SG1]  		= "G3SG1";
wpn[SG550]  		= "SG550";

wpn[M249]   		= "M249";

wpn[PrimaryAmmo]	= "PrimaryAmmo";
wpn[SecondaryAmmo]	= "SecondaryAmmo";

wpn[HE]          	= "HE";
wpn[Flashbang]     	= "Flashbang";
wpn[SmokeGrenade]	= "SmokeGrenade";
wpn[Flare]          = "Flare";
wpn[DefuseKit]		= "DefuseKit";
wpn[Kevlar]			= "Kevlar";
wpn[KevlarHelm]		= "KevlarHelm";
wpn[NightVision]	= "NightVision";
wpn[TacticalShield]	= "TacticalShield";

wpn[Knife]			= "Knife";
wpn[Machete]		= "Machete";
wpn[Wrench]			= "Wrench";
wpn[Claw]			= "Claw";
wpn[Chainsaw]		= "Chainsaw";

wpn[GasGrenade]		= "GasGrenade";
wpn[MolotovCocktail]= "MolotovCocktail";
wpn[Snowball]		= "Snowball";
wpn[AirStrike]		= "AirStrike";

wpn[Mine]			= "Mine";

wpn[Laser]			= "Laser";

wpn[Flamethrower]	= "Flamethrower";

wpn[RPGLauncher]	= "RPGLauncher";
wpn[RocketLauncher]	= "RocketLauncher";
wpn[GrenadeLauncher]= "GrenadeLauncher";

wpn[LightArmor]		= "LightArmor";
wpn[Armor]			= "Armor";
wpn[HeavyArmor]		= "HeavyArmor";
wpn[SuperArmor]		= "SuperArmor";
wpn[MedicArmor]		= "MedicArmor";

wpn[StealthSuit]	= "StealthSuit";

wpn[Medikit]		= "Medikit";
wpn[Bandage]		= "Bandage";

wpn[Coins]			= "Coins";
wpn[Money]			= "Money";
wpn[Gold]			= "Gold";

-----------------------------------------

wpn.name[USP]			= "USP";
wpn.name[Glock]			= "Glock";
wpn.name[Deagle]			= "Deagle";
wpn.name[P228]			= "P228";
wpn.name[Elite]			= "Elite";
wpn.name[FiveSeven]		= "FiveSeven";

wpn.name[M3]				= "M3";
wpn.name[XM1014]			= "XM1014";

wpn.name[MP5]			= "MP5";
wpn.name[TMP]			= "TMP";
wpn.name[P90]			= "P90";
wpn.name[Mac10]			= "Mac10";
wpn.name[UMP45]			= "UMP45";

wpn.name[Galil]			= "Galil";
wpn.name[Famas]			= "Famas";
wpn.name[AK47]			= "AK47";
wpn.name[M4A1]			= "M4A1";
wpn.name[SG552]			= "SG552";
wpn.name[Aug]    		= "Aug";
wpn.name[Scout]  		= "Scout";
wpn.name[AWP]    		= "AWP";
wpn.name[G3SG1]  		= "G3SG1";
wpn.name[SG550]  		= "SG550";

wpn.name[M249]   		= "M249";

wpn.name[PrimaryAmmo]	= "PrimaryAmmo";
wpn.name[SecondaryAmmo]	= "SecondaryAmmo";

wpn.name[HE]          	= "HE";
wpn.name[Flashbang]     	= "Flashbang";
wpn.name[SmokeGrenade]	= "SmokeGrenade";
wpn.name[Flare]          = "Flare";
wpn.name[DefuseKit]		= "DefuseKit";
wpn.name[Kevlar]			= "Kevlar";
wpn.name[KevlarHelm]		= "KevlarHelm";
wpn.name[NightVision]	= "NightVision";
wpn.name[TacticalShield]	= "TacticalShield";

wpn.name[Knife]			= "Knife";
wpn.name[Machete]		= "Machete";
wpn.name[Wrench]			= "Wrench";
wpn.name[Claw]			= "Claw";
wpn.name[Chainsaw]		= "Chainsaw";

wpn.name[GasGrenade]		= "GasGrenade";
wpn.name[MolotovCocktail]= "MolotovCocktail";
wpn.name[Snowball]		= "Snowball";
wpn.name[AirStrike]		= "AirStrike";

wpn.name[Mine]			= "Mine";

wpn.name[Laser]			= "Laser";

wpn.name[Flamethrower]	= "Flamethrower";

wpn.name[RPGLauncher]	= "RPGLauncher";
wpn.name[RocketLauncher]	= "RocketLauncher";
wpn.name[GrenadeLauncher]= "GrenadeLauncher";

wpn.name[LightArmor]		= "LightArmor";
wpn.name[Armor]			= "Armor";
wpn.name[HeavyArmor]		= "HeavyArmor";
wpn.name[SuperArmor]		= "SuperArmor";
wpn.name[MedicArmor]		= "MedicArmor";

wpn.name[StealthSuit]	= "StealthSuit";

wpn.name[Medikit]		= "Medikit";
wpn.name[Bandage]		= "Bandage";

wpn.name[Coins]			= "Coins";
wpn.name[Money]			= "Money";
wpn.name[Gold]			= "Gold";
