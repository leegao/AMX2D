--[[
Weapon/Item ID list
v1.1
by Kiffer-Opa

This file contains useful variables for many IDs used in CS2D. So you just
have to know the variables conventions instead of looking up every weapon
ID.
To include this file, you have to add this line of code into your files where
you need the variables:
dofile("sys/lua/wpnids.lua")

Remember: Lua is case-sensitive!

Item / weapon IDs
 have the same name like ingame, but with all spaces, "-" and "+" removed
  Example: "TacticalShield" for the Tactical Shield

Armor values for armor items like Light Armor
 start with an "a_" followed by the ingame name with all spaces removed
   Example: "a_LightArmor" for Light Armor

CS2D Lua scripting return values
  are written ALL CAPS. Most of them just tell to behave normally or ignore the hook
  "behave normally" returns have the same name like the hook funktion with "hook_" removed
  example: return the "BUY" variable  for proceed normally on hook_buy()

  "ignore": like "behave normally", with a "NO" before
  example: return the "NOBUY" variable for ignoring the buy on hook_buy()
  
  END OF INSTRUCTIONS]]
  
-- Item / weapon IDs
----- have the same name like ingame, but with all spaces, "-" and "+" removed
----- Example: Write TacticalShield for the Tactical Shield
USP     	= 1
Glock   	= 2
Deagle		= 3
P228		= 4
Elite		= 5
FiveSeven	= 6

M3		=10
XM1014		=11

MP5		=20
TMP		=21
P90		=22
Mac10		=23
UMP45		=24

Galil		=38
Famas		=39
AK47		=30
M4A1		=32
SG552		=31
Aug		=33
Scout		=34
AWP		=35
G3SG1		=36
SG550		=37

M249		=40

PrimaryAmmo	=61
SecondaryAmmo	=62

HE		=51
Flashbang	=52
SmokeGrenade	=53
Flare		=54
DefuseKit	=56
Kevlar		=57
KevlarHelm	=58
NightVision	=59
TacticalShield	=41

Bomb		=55

Knife 		=50
Machete		=69
Wrench		=74
Claw		=78
Chainsaw	=85

GasGrenade	=72
MolotovCocktail	=73
Snowball	=75
AirStrike	=76
GutBomb		=86

Mine		=76

Laser		=45

Flamethrower	=46

RPGLauncher	=47
RocketLauncher	=48
GrenadeLauncher	=49

LightArmor	=79
Armor		=80
HeavyArmor	=81
SuperArmor	=83
MedicArmor	=82

StealthSuit	=84

Medikit		=64
Bandage		=65

Coins		=66
Money		=67
Gold		=68


-- Armor values for armor items like Light Armor
----- start with an "a_" followed by the ingame name with all spaces removed
----- Example: "a_LightArmor" for Light Armor
a_LightArmor	= 201
a_Armor		= 202
a_HeavyArmor	= 203
a_SuperArmor	= 205
a_MedicArmor	= 204
a_StealthSuit	= 206


-- CS2D Lua scripting return values
----- are written ALL CAPS. Most of them just tell to behave normally or ignore the hook
----- "behave normally" have the same name like the hook funktion with "hook_" removed
----- - example: return the "BUY" variable  for proceed normally on hook_buy()
----- "ignore" like "behave normally", with a "NO" before
----- example: return the "NOBUY" variable for ignoring the buy on hook_buy()


-- teams
SPECTATOR = 0
TERRORISTS = 1
COUNTERTERRORISTS = 2

-- short names for teams
SPEC=SPECTATOR
T=   TERRORISTS
CT=  COUNTERTERRORISTS

BUY	  = 0
NOBUY	  = 1

TEAM	= 0
NOTEAM	= 1


PARSE		= 0
IGNOREUNKNOWN	= 1	-- parse and ignore unknown commands
NOPARSE		= 2

DROP		= 0
NODROP		= 1

SAY		= 0
NOSAY		= 1

SAYTEAM		= 0
NOSAYTEAM	= 1

RADIO		= 0
NORADIO		= 1

SPAWN		= ""		-- spawn normally
MELEEONLY	= "x"		-- spawn only with melee weapons

NAME		= 0
NONAME		= 1

TRIGGER		= 0
NOTRIGGER	= 1

TRIGGERENTITY	= 0
NOTRIGGERENTITY	= 1

WALKOVER	= 0
NOWALKOVER	= 1

DIE		= 0
DROPIMPORTANT	= 1		-- die and only drop bomb and flag

LOG		= 0
NOLOG		= 1