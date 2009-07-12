hooks = {}
hooks.init = {}

--Rewriting the addhooko function to include init as a valid function
_addhook = addhook
function addhook(h, f, p)
	if h == "init" then
		if not hooks[h] then hooks[h] = {} end
		table.insert(hooks.init, f)
		print("LUA: adding function \'"..f.."\' to hook \'Init\'")
		return
	end
	if not p then p = 0 end
	_addhook(h, f, p)
end

_print = print
function print(t)
	if not t then _print("nil");return end
	if not tostring(t) then
		_print("Unprintable")
	else
		_print(tostring(t))
	end
end

--Wrapper.lua
-------------------------------------------------------------------
-- Wrapper functions for easy usage of CS2D commands in Lua      --
-- 08.03.2009 - www.UnrealSoftware.de                            --
-------------------------------------------------------------------

-- Kill a player
function killplayer(id)
	parse("killplayer "..id)
end

function kick(id)
	parse("kick "..id)
end

function ban(id, name_)
	local ip = player(id, "ip")
	local usgn = player(id, "usgn")
	if ip then
		parse("banip "..ip)
	end
	if usgn then
		parse("banusgn "..usgn)
	end
	if name_ then
		banname(id)
	end
end

function banname(id)
	local name = player(id, "name")
	if name then
		parse("banname "..name)
	end

end

-- Spawn a player at a certain position
function spawnplayer(id,x,y)
	parse("spawnplayer "..id.." "..x.." "..y)
end

-- Set a player to a certain position
function setpos(id,x,y)
	parse("setpos "..id.." "..x.." "..y)
end

-- Set money
function setmoney(id,money)
	parse("setmoney "..id.." "..money)
end

function givemoney(id, dmoney)
	setmoney(id, dmoney+ player(id, "money"))
end

-- Set health
function sethealth(id,health)
	parse("sethealth "..id.." "..health)
end

-- Set armor
function setarmor(id,armor)
	parse("setarmor "..id.." "..armor)
end

-- Set score
function setscore(id,score)
	parse("setscore "..id.." "..score)
end

-- Set deaths
function setdeaths(id,deaths)
	parse("setdeaths "..id.." "..deaths)
end

-- Equip a player with an item
function equip(id,itemtype)
	parse("equip "..id.." "..itemtype)
end

-- Remove an item from a player
function strip(id,itemtype)
	parse("strip "..id.." "..itemtype)
end

-- Modify speed of a player
function speedmod(id,value)
	parse("speedmod "..id.." "..value)
end

-- Spawn item on map
function spawnitem(itemtype,x,y)
	parse("spawnitem "..itemtype.." "..x.." "..y)
end

-- Remove item from map
function removeitem(itemid)
	parse("removeitem "..itemid)
end

-- Trigger entities
function trigger(name)
	parse("trigger "..name)
end

_msg = msg
function msg(t1, t2, b)
	local centered = ""
	local color = ""
	local text = ""
	if t2 then
		color = t1
		text = t2
	else
		color = ""
		text = t1
	end

	if b then
		centered = "@C"
	end
	return _msg(color..text..centered)
end

say = msg

_msg2 = msg2
function msg2(p, t1, t2, b)

	local centered = ""
	local color = ""
	local text = ""
	if t2 then
		 color = t1
		 text = t2
	else
		 color = ""
		 text = t1
	end

	if b then
		centered = "@C"
	end
	print(string.format("%sSayTo(%s:ID#\'%s\'): %s", color, player(p,"name"), p, text))
	return _msg2(p, color..text..centered)
end

sayto = msg2

function selectMain(p)
	strip(p, Knife)
	equip(p, Knife)
end

-------------------------------------------------------------------
-- Utility: equip() Rewrite. Includes auto stripping. --
-- 31.03.2009 - http://amx2d.co.cc/ - AMX2D Scripting --
-- Author - Lee Gao
-- http://amx2d.co.cc/viewtopic.php?f=12&t=39
-------------------------------------------------------------------

--[[--
**INFO:**
This rewrite of the equip() function automatically
strips all of the conflicting weapons so the weapons
do not overlap. IE: No more of having an AK47 and a M4A1
at the same time.

**USAGE:**
Copy equip.lua (This file) into the sys/lua/ folder
In server.lua, add: dofile("sys/lua/equip.lua")

Equiping: equip(Player, Weapon(Name or ID), NoConflicts)

*Example:*
Player 1 has AK47, Deagle, HE, and Knife.

Do
	equip(1, "M4A1", true) leads to
Result: M4A1, Deagle, HE, and Knife

Do
	equip(1, "Laser", false) or equip(1, "Laser") leads to
Result: Laser, M4A1, Deagle, HE, and Knife.
--]]--

--###################################--
--############ Conditions ###########--
--###################################--

if not amx2d then
	print("Please read the comment on AMX2D exclusive features.")
end
if not equip then dofile("sys/lua/wrapper.lua") end
if not Knife then
	print("Please include Kiffer-Opa's Weapon list.")
	-- Author: Kiffer-Opa
	-- Melee Weapons
	Knife =50;
	Machete =69;
	Wrench =74;
	Claw =78;
	Chainsaw =85;
end
if not trim then
	--[[--
	If trim has not already been declared then just return the
	string and warn developers that they must not add extra spaces
	when calling equip - AMX2D.
	--]]--
	function trim(t) return t end
end

--###################################--
--############# equip() #############--
--###################################--

local _equip = equip -- Preparing to overload function equip.

function name2id(name)
	local names = {}
     for i =1, 32, 1 do
          if player(i, "exists") then
               names[player(i, "name")] = i
			end
     end
     if names[name] then return names[name] else return nil end
end

function id(name)
	return name2id(name)
end

function id2name(id)
	if player(id, "exists") then
		return player(id, "name")
	end
end

function name(id)
	return id2name(id)
end

function args(t, n)
	if #t < 1 then return {} end
	if not n then n = #t:split() end

	local arg = {}

	if type(n) == "table" then
		arg = n
		n = #n
	elseif type(n) == "string" then
		arg = table.trim(string.split(n, ","))
		n = #arg
	end

	local t = t:split()
	local _t = {}
	if #t < n then n = #t end
	for i = 1, n-1 do
		local x = t[i]
		if #arg > 0 then
			if arg[i]:split("_") then
				if arg[i]:split("_")[2] == "id" then
					x = playerid(x)
					arg[i] = arg[i]:split("_")[1]
				end
			end
		end
		if not x then x = t[i] end
		if tonumber(x) then x = tonumber(x) end
		x = string.trim(x)
		if #arg > 0 then
			_t[arg[i]] = x

		end

		table.insert(_t, string.trim(t[i]))
	end

	local last = table.tostring_(t, n)
	if #last == 0 then last = nil end
	local _l = last
	if #arg > 0 then
		if arg[n]:split("_") then
			if arg[n]:split("_")[1] == "id" then l = playerid(last);arg[n] = arg[n]:split("_")[1] end
		end
	end
	if l then last = l end
	if tonumber(last) then last = tonumber(last) end
	last = string.trim(last)
	if #arg > 0 then
		_t[arg[n]] = last
	end

	table.insert(_t, string.trim(table.tostring_(t, n)))
	return _t
end



function isplayer(p)
	p = playerid(p)
	if not (type(p) == "number") then return false end
	if not player(p, "exists") then return false end
	return true
end

function playerid(i)
	i = trim(i)
	if tonumber(i) then
		if player(tonumber(i), "exists") then return tonumber(i) end
	end
	i = name2id(i)
	return i
end

function equip(p, w, noConflict)
	--[[--
	Checks if w is a string, if it is, converts it to the
	wpntype equivalent. Then it checks if the wpntype ID exists.

	**Note:**
	Must have AMX2D loaded to have this feature on, else you
	must use WeaponType instead of a string.
	--]]--

	if amx2d then
		if type(w) == "string" then
			if wpn.id[trim(w)] then
				w = wpn.id[trim(w)]
			else return
			end
		end
	end
	--If used as equip(player, wpn), then return the normal version.
	if not noConflict then return _equip(p, w) end

	if not wpn.name[tonumber(w)] then return end

	--[[--
	This creates a list of all of the current weapons and
	strips them from the player, then gives him back the
	Knife.
	--]]--

	local _pwpn = {slot={}, oldslot = {}}

	local slot = function(_wpn)
		if (_wpn<=40 and _wpn>=10) or (_wpn<=49 and _wpn>=45) then
			--Primary Weapon - Slot 1
			return 1
		elseif (_wpn < 10) then
			--Secondary Weapon - Slot 2
			return 2
		elseif (_wpn == Knife or _wpn == Machete or _wpn == Wrench or _wpn == Claw or _wpn == Chainsaw) then
			--Melee - Slot 3
			return 3
		elseif (_wpn < 55 and _wpn > 50) then
			--Grenades - Slot 4
			return 4
		else
			--Slotless
			return 0
		end
	end

	while not (player(p, "weapontype") == 50 or player(p, "weapontype") == 0) do
		local _wpn = player(p, "weapontype")
		_pwpn.oldslot[slot(_wpn)] = _wpn
		_pwpn.slot[slot(_wpn)] = _wpn
		_pwpn[_wpn] = _wpn -- In case we need to call _pwpn[wpntyp] to see if it exists.
		strip(p, _wpn)
	end


	--Slot 1 or 2 should strip these weapons.
	if (slot(w) == 1) or (slot(w)==2) then
		_pwpn.slot[slot(w)] = w
	else
		equip(p, w)
	end

	--[[--
	Iterates through all of the slots of the new weapon table and
	equips them using equip (which we do not pass in the last boolean
	and thus will not do a full recusion)
	--]]--

	for k, v in pairs (_pwpn.slot) do
		--Will Re-equip everything, including Knife again.
		equip(p, v)
	end

	selectMain(p)
	return _pwpn -- Returns the old and current slot listing.
end
