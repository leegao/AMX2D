--Initialize mod_gg.lua
init_mod("gg")
--Dynamic Lists
gg.var("wpnlvl", {})
gg.var("_wpnlvl_", {})
gg.var("wpnname", {})
gg.var("players", {})
gg.var("specWpn", {[Knife] = Knife})
--Static Variables
gg.var("maxlvl", 0)
gg.var("minlvl", 1)
--Dynamic variables
gg.var("pavg", 0)
gg.var("pmin", 0)
gg.var("pmax", 0)
--Cvars
gg.var("killmoney", 0, "cvar")
gg.var("mratio", 0, "cvar")
gg.var("hitheal", 1, "cvar")
gg.var("healpoints", 5, "cvar")
--Util functions
function util.tableReverse(t)
	local _t = {}
	for k, v in pairs(t) do
		_t[v] = k
	end
	return _t
end

function util.stripAll(p)
	strip(p, 0)
end

function util.toTime(time_)
	if time_ < 60 then
		return math.floor(time_).." Seconds"
	else
		return math.floor(time_/60).." Minutes and "..(math.floor(time_)-math.floor(time_/60)*60).." Seconds"
	end
end

--gg.localalized functions
function gg.setlevel(p, level, b)
	if level > gg.maxlvl then
		level = gg.maxlvl
		msg("©128000255"..player(p, "name").." Is The Winner@C")
		parse("map "..game("nextmap"))
	end
	if level < gg.minlvl then level = gg.minlvl end

	gg.players[p].level = level
	if b then
		gg.players[p].kills = 0
	end
	strip(p, Knife)
	util.stripAll(p)
	parse("equip "..p.. " "..gg.wpnlvl[level].wpn_id)
	--select(p, gg.wpnlvl[level].wpn_id, 1)
	act_ammo(p, "ammo", "")
	gg.relevel()

	if b then
		msg("Player \""..player(p, "name").."\" is now on level "..level)
	end
end

function gg.checksvars()
	if gg.joinlevel > 2 then gg.joinlevel = 2 end
	if gg.joinlevel < 0 then gg.joinlevel = 0 end
	if gg.killmoney > 16000 then gg.killmoney = 16000 end
	if gg.killmoney < 0 then gg.killmoney = 0 end
	gg.killmoney = gg.killmoney - 300
	if gg.mratio > 1 then gg.mratio = 1 end
	if gg.mratio < -1 then gg.mratio = -1 end
	gg.mratio = 1 + gg.mratio
end

function gg.relevel()
	gg.pmin = gg.maxlvl
	gg.pmax = gg.minlvl
	local n = 0
	local x = 0
	for k, v in pairs(gg.players) do
		local lvl = v.level
		if lvl < gg.pmin and lvl > gg.minlvl then gg.pmin = lvl end
		if lvl > gg.pmax and lvl <= gg.maxlvl then gg.pmax = lvl end
		if lvl >= gg.minlvl then
			n = n+1
			x = x+lvl
		end
	end
	gg.pavg = math.floor(x/n)
end

function gg.reverse()
	local t = {}
	for i = gg.minlvl, gg.maxlvl-1, 1 do
		t[i] = gg.maxlvl - i + gg.minlvl-1
	end
	t[gg.maxlvl] = gg.maxlvl
	local _wpnlvl = {}
	for k, v in pairs(t) do
		--print(k ,v)
		_wpnlvl[k] = gg.wpnlvl[v]
	end
	gg.wpnlvl = _wpnlvl
	gg.resetlvl()
end

function gg.randomize()
	math.randomseed( os.time() )
	local t = {}
	local i = gg.minlvl
	while (i< gg.maxlvl) do
		local n = math.random(gg.minlvl, gg.maxlvl-1)
		if t[n] and i < gg.maxlvl then
			i = i-1
		else
			t[n] = i
		end
		i = i+1
	end
	t[gg.maxlvl] = gg.maxlvl
	local _wpnlvl = {}

	for k, v in pairs(t) do
		--print(k ,v)
		_wpnlvl[k] = gg.wpnlvl[v]
	end

	gg.wpnlvl = _wpnlvl
	gg.resetlvl()
end

function gg.resetlvl()
	for k, v in pairs(gg.players) do
		if player(k, "health") then
			gg.setlevel(k, v.level)
		end
	end
end

--Acts
function act_ggavglvl_gg(p, typ, cmd)
	msg2(p, "The average GunGame level is: "..gg.pavg)
end

function act_nextmap(p, typ, cmd)
	msg("Next Map: "..game("nextmap"))
end

function act_ggmaxlvl_gg(p, typ, cmd)
	msg2(p, "The highest player GG level is: "..gg.pmax)
end

function act_ggminlvl_gg(p, typ, cmd)
	msg2(p, "The lowest player GG level is: "..gg.pmin)
end

function act_ggkills_gg(p, typ, cmd)
	if #cmd == 0 then
		msg2(p, "You have "..gg.players[p].kills.." out of ".. gg.wpnlvl[gg.players[p].level].kills.." kills required")
	end
	msg2(p, "You still need "..(gg.wpnlvl[gg.players[p].level].kills-gg.players[p].kills).." more kills to advance to the next level")
end

function act_ammo(p, typ, cmd)
	--util.stripAll(p)
	if gg.wpnlvl[gg.players[p].level] then
		parse("equip "..p.. " "..gg.wpnlvl[gg.players[p].level].wpn_id)
		strip(p, 50)
		equip(p, 50)
	end
end

function act_ammo2(p, typ, cmd)
	parse("equip "..p.. " "..player(p, "weapontype"))
	strip(p, 50)
	equip(p, 50)
	--select(p, player(p, "weapontype"))
end

function act_ggalllevels_gg(p, typ, cmd)
	local s = "All Levels: "
	for i, v in ipairs(gg.wpnlvl) do
		s = s .."Lv."..i.." = "..v.wpn_name..", "
	end
	msg2(p, s)
end

function act_ggspecweapons_gg(p, typ, cmd)
	local s = "The server's GG special weapons are: "
	for k, v in pairs(gg.specWpn) do
		--print(v)
		s=s.."\""..wpn[v].."\" "
	end
	msg2(p, s)
end

function act_ggavgtimealive_gg(p, typ, cmd)
	cmd = tonumber(cmd)
	if not cmd then cmd = p end
	local timer = os.clock()-gg.players[cmd].stimer
	local deaths = gg.players[cmd].cumdeaths
	if deaths <= 0 then deaths = 1 end
	msg2(p, "Your average time alive is "..util.toTime(math.ceil(timer/deaths)))
end

function act_ggavgtimeperkill_gg(p, typ, cmd)
	cmd = tonumber(cmd)
	if not cmd then cmd = p end

	if gg.players[cmd] then
		if gg.players[cmd].cumkills then
			local timer = os.clock()-gg.players[cmd].stimer
			local kills = gg.players[cmd].cumkills
			if kills <= 0 then kills = 1 end
			msg2(p, "Your average time per kill is "..util.toTime(math.ceil(timer/kills)))
		end
	else
		return invalid(p, typ)
	end
end

function act_ggtotalkills_gg(p, typ, cmd)
	cmd = tonumber(cmd)
	if not cmd then cmd = p end

	if gg.players[cmd] then
		if gg.players[cmd].cumkills then
			if cmd == p then
				msg2(p, "Your total kills for this round is: "..gg.players[cmd].cumkills)
			else
				msg2(p, player(cmd, "name").."\'s total kills for this round is: "..gg.players[cmd].cumkills)
			end
		end
	else
		return invalid(p, typ)
	end
end

function act_ggtotaldeaths_gg(p, typ, cmd)
	cmd = tonumber(cmd)
	if not cmd then cmd = p end

	if gg.players[cmd] then
		if gg.players[cmd].cumdeaths then
			if cmd == p then
				msg2(p, "Your total deaths for this round is: "..gg.players[cmd].cumdeaths)
			else
				msg2(p, player(cmd, "name").."\'s total deaths for this round is: "..gg.players[cmd].cumdeaths)
			end
		end
	else
		return invalid(p, typ)
	end
end

function act_ggtimeplayed_gg(p, typ, cmd)
	cmd = tonumber(cmd)
	if not cmd then cmd = p end

	if gg.players[cmd] then
		if gg.players[cmd].stimer then
			if cmd == p then
				msg2(p, "Your playtime for this round is: "..util.toTime(os.clock()-gg.players[cmd].stimer))
			else
				msg2(p, player(cmd, "name").."\'s playtime for this round is: "..util.toTime(os.clock()-gg.players[cmd].stimer))
			end
		end
	else
		return invalid(p, typ)
	end
end

function act_ggkillmoney_gg(p, typ, cmd)
	cmd = tonumber(cmd)
	if not cmd then cmd = p end

	if gg.players[cmd] then
		if gg.players[cmd].level >= gg.minlvl then
			local _money = math.ceil(((gg.mratio)^gg.players[cmd].level)*gg.killmoney) + 300
			if cmd == p then
				msg2(p, "Your payment per kill is $".._money)
			else
				msg2(p, player(cmd, "name").."\'s payment per kill is $".._money)
			end
			return
		end
	end

	return invalid(p, typ)
end

function act_ggbonus_gg(p, typ, cmd)
	cmd = tonumber(cmd)
	if not cmd then cmd = p end

	if gg.players[cmd] then
		if gg.players[cmd].level >= gg.minlvl then
			local _money = math.ceil(((gg.mratio)^gg.players[cmd].level)*gg.killmoney)-gg.killmoney
			if cmd == p then
				msg2(p, "Your bonus payment is $".._money)
			else
				msg2(p, player(cmd, "name").."\'s bonus payment is $".._money)
			end
			return
		end
	end

	return invalid(p, typ)
end

function act_ggmoneyratio_gg(p, typ, cmd)
	cmd = tonumber(cmd)
	if not cmd then cmd = p end

	if gg.players[cmd] then
		if gg.players[cmd].level >= gg.minlvl then
			local _r = ((gg.mratio)^gg.players[cmd].level)
			if cmd == p then
				msg2(p, "Your kill money bonus ratio is ".._r)
			else
				msg2(p, player(cmd, "name").."\'s kill money bonus ratio is ".._r)
			end
			return
		end
	end

	return invalid(p, typ)
end

function act_gginitialpayment_gg(p, typ, cmd)
	cmd = tonumber(cmd)
	if not cmd then cmd = p end

	if gg.players[cmd] then
		if gg.players[cmd].level >= gg.minlvl then
			local _money = gg.killmoney + 300
			if cmd == p then
				msg2(p, "Your initial payment per kill w/o any bonus is $".._money)
			else
				msg2(p, player(cmd, "name").."\'s initial payment per kill w/o any bonus is $".._money)
			end
			return
		end
	end

	return invalid(p, typ)
end

function act_gglevel_gg(p, typ, cmd)
	if #cmd == 0 then
		if not (gg.players[p].level >= gg.maxlvl) then
			msg2(p, "Your next level: "..(gg.players[p].level+1).." is the "..gg.wpnlvl[(gg.players[p].level+1)].wpn_name.." and requires "..gg.wpnlvl[(gg.players[p].level+1)].kills.." kills")
		else
			msg2(p, "You are on the last level")
		end
	else
		local t = tonumber(cmd)
		if t then
			if t <= gg.maxlvl and t >= gg.minlvl then
				msg2(p, "Level "..t.." is the "..gg.wpnlvl[t].wpn_name.." level and requires "..gg.wpnlvl[t].kills.." kills")
			else
				msg2(p, "Level "..gg.maxlvl.." is the last level with "..gg.wpnlvl[gg.maxlvl].wpn_name.." and requires "..gg.wpnlvl[gg.maxlvl].kills.." kills")
			end
		else
			cmd = string.gsub(cmd, "%s", "")
			if wpnid[cmd] then
				if gg.wpnname[cmd] then
					msg2(p, "The "..cmd.. " is on level "..gg.wpnname[cmd])
				else
					msg2(p, "The "..cmd.. " is not playable")
				end
			else
				msg2(p, "The "..cmd.. " is not a valid weapon, make sure you typed the name correctly")
			end
		end
	end
end

--Admacts
--++--++--
--+Svar+--
--++--++--
function adm_ggjoinlevel_admin(p, typ, cmd)
	cmd = tonumber(cmd)
	if not cmd then return invalid(p, typ) end
	if cmd > 2 then
		cmd = 2
	elseif cmd < 0 then
		cmd = 0
	end
	gg.setvar("joinlevel", cmd, true)
end

function adm_ggcollect_admin(p, typ, cmd)
	cmd = tonumber(cmd)
	if not cmd then return invalid(p, typ) end

	if cmd ~= 0 then cmd = 1 end
	gg.setvar("collect", cmd, true)
end

function adm_ggbuy_admin(p, typ, cmd)
	cmd = tonumber(cmd)
	if not cmd then return invalid(p, typ) end

	if cmd ~= 0 then cmd = 1 end
	gg.setvar("buy", cmd, true)
end

function adm_ggkillmoney_admin(p, typ, cmd)
	cmd = tonumber(cmd)
	if not cmd then return invalid(p, typ) end

	if cmd > 16000 then cmd = 16000 end
	if cmd <= 0 then cmd = 0 end

	local delta = cmd - 300

	gg.setvar("killmoney", delta, true)
end

function adm_ggmratio_admin(p, typ, cmd)
	cmd = tonumber(cmd)
	if not cmd then return invalid(p, typ) end

	if cmd > 1 then cmd = 1 end
	if cmd < -1 then cmd = -1 end

	local r = 1 + cmd

	gg.setvar("mratio", r, true)
end

function adm_ggsetlevel_admin(p, typ, cmd)
	cmd = toTable(cmd)
	if not (tonumber(cmd[2]) or tonumber(cmd[1])) then msg2(p, "Inccorect parameters"); return nil end
	gg.setlevel(tonumber(cmd[1]), tonumber(cmd[2]), true)
end

function adm_ggrandom_admin(p, typ, cmd)
	gg.randomize()
	msg("GunGame Levels have been Randomized")
	if #cmd == 0 then
		parse("restart")
	end
end

function adm_ggreverse_admin(p, typ, cmd)
	gg.reverse()
	msg("GunGame Levels have been Reversed")
	if #cmd == 0 then
		parse("restart")
	end
end

function adm_ggreset_admin(p, typ, cmd)
	gg.wpnlvl = gg._wpnlvl_
	gg.resetlvl()
	msg("GunGame Levels have reverted to Default")
	if #cmd == 0 then
		parse("restart")
	end
end

function adm_ggspecweapons_admin(p, typ, cmd)
	cmd = toTable(cmd)
	if not cmd then return nil end
	local s = "Gun Game Special Weapons: "
	for i, v in ipairs(cmd) do
		if wpnid[v] then
			gg.specWpn[wpnid[v]] = wpnid[v]
			s=s.."\""..v.."\" "
		end
	end
	msg2(p,s)
end

function adm_ggresettimer_admin(p, typ, cmd)
	cmd = tonumber(cmd)
	if not cmd then return nil end

	if gg.players[cmd] then
		if gg.players[cmd].stimer then
			gg.players[cmd].stimer = os.clock()
			return
		end
	end
	return invalid(p, typ)
end

function adm_ggresetkills_admin(p, typ, cmd)
	cmd = tonumber(cmd)
	if not cmd then return nil end

	if gg.players[cmd] then
		if gg.players[cmd].cumkills then
			gg.players[cmd].cumkills = 0
			return
		end
	end
	return invalid(p, typ)
end

function adm_ggresetdeaths_admin(p, typ, cmd)
	cmd = tonumber(cmd)
	if not cmd then return nil end

	if gg.players[cmd] then
		if gg.players[cmd].cumdeaths then
			gg.players[cmd].cumdeaths = 0
			return
		end
	end
	return invalid(p, typ)
end

--Hooks
function hook_init_gg()
	--cron.add("2 parse(\"sv_gamemode 2\")", 1)
	parse("sv_gamemode 2")
	--cron.add("1 print(\"Should be displayed 2ce\")", 2)
	for line in io.lines(conf_dir.."gg_levels.cfg") do
		local r = toTable(line)
		gg.wpnlvl[tonumber(r[1])] = {wpn_name = r[2],wpn_id = _G[r[2]], kills = tonumber(r[3])}
		gg._wpnlvl_ [tonumber(r[1])] = {wpn_name = r[2],wpn_id = _G[r[2]], kills = tonumber(r[3])}
		gg.wpnname[r[2]] = tonumber(r[1])
		if tonumber(r[1]) > gg.maxlvl then
			gg.maxlvl = tonumber(r[1])
		elseif tonumber(r[1]) < gg.minlvl then
			gg.minlvl = tonumber(r[1])
		end
	end
	for i = 1, 32, 1 do
		gg.players[i] = {level = 0, kills = 0, cumkills = 0, cumdeaths = 0, stimer = os.clock()}
		if player(i, "exists") then
			if player(i, "health") > 0 then
				gg.setlevel(i, 1)
			end
		end
	end
	gg.pmin = gg.minlvl
	gg.pmax = gg.minlvl
	gg.pavg = gg.minlvl
	gg.cfg = "GunGame"
	gg.loadcfg()

	gg.checksvars()
end

function hook_startround_gg(typ)
	for i = 1, 32, 1 do
		if player(i, "exists") then
			if player(i, "health") > 0 then
				gg.setlevel(i, gg.players[i].level)
			end
		end
		--gg.players[i].level = 0
		--gg.players[i].kills = 0
		--[[if player(i, "exists") then
			if player(i, "health") > 0 then
				gg.setlevel(i, 1)
			end
		end--]]--
	end
end

function hook_team_gg(p, t)
	--gg.players[p].kills = 0
	gg.players[p].level = gg.players[p].level - 1
	if gg.players[p].level < 1 then gg.players[p].level = 1 end
	--print(gg.players[p].level)
	gg.setlevel(p, gg.players[p].level, true)
	equip(p, gg.wpnlvl[gg.players[p].level].wpn_id)
	--cron.add("2 equip("..p..", gg.wpnlvl[gg.players["..p.."].level].wpn_id);", 10)

	--cron.add("1 msg2("..p.."\"Type /ammo to get your gun\")")
end

function hook_leave_gg(p, t)
	gg.players[p] = {level = 0, kills = 0, cumkills = 0, cumdeaths = 0, stimer = os.clock()}
end

function hook_join_gg(p, t)
	if gg.joinlevel == 0 then
		gg.setlevel(p, 1)
	elseif gg.joinlevel == 1 then
		gg.setlevel(p, gg.pmin, true)
	else
		gg.setlevel(p, gg.pavg, true)
	end
end

function hook_buy_gg(p, i)
	if gg.buy == 0 then
		return 1
	end
end
--[[--
function hook_collect_gg(p, i)
	if gg.collect == 0 then
		strip(p, i)
	end
end
--]]--
function hook_walkover_gg(p, i)
	if gg.collect == 0 then
		return 1
	end
end

function hook_select_gg(p, typ, id)
	if not (typ == Knife) then
		act_ammo(p, "ammo", "")
	end
end

function hook_spawn_gg(p)
	act_ammo(p, "ammo", "")
end
--[or (w == player(s, "weapontype"))
function hook_hit_gg(p, s,w, hp, ap)
	--if player(s, "health") <= 150 then
	--if (w == Knife)  then
	if gg.hitheal > 0 then
		sethealth(s, player(s, "health")+(hp/10)*(1+gg.healpoints/10))
		if gg.hitheal > 1 then
			setarmor(s, player(s, "armor")+(hp/10)*(1+gg.hitheal/10))
		end
		if player(s, "health") > 100 then
			sethealth(s, 100)
		end

		if player(s, "armor") > 150 then
			setarmor(s, 150)
		end
		--msg(player(s, "health"))
	end
	--end
end
--]]
function hook_kill_gg(k, v, w)
	--msg(w)
	if gg.players[k].level > gg.maxlvl or gg.players[k].level < gg.minlvl then return nil end
	if w == gg.wpnlvl[gg.players[k].level].wpn_id then
		gg.players[k].kills = gg.players[k].kills + 1
		--msg(gg.players[k].kills)
	end
	if gg.specWpn[w] then
		--Let the quakeMod do the usual humiliation stuff
		gg.setlevel(k, gg.players[k].level+1, true)
		if not gg.wpnlvl[gg.players[k].level-1].wpn_id == w then
			gg.setlevel(v, gg.players[v].level-1, true)
		end
	end

	if gg.players[k].kills >= gg.wpnlvl[gg.players[k].level].kills then
		gg.setlevel(k, gg.players[k].level+1, true)
	end
	gg.players[k].cumkills = gg.players[k].cumkills + 1
	gg.players[v].cumdeaths = gg.players[v].cumdeaths + 1

	local _money = math.ceil(((gg.mratio)^gg.players[k].level)*gg.killmoney)
	--msg2(k, "You have also received $".._money.." on top of your $300 fixed payment for the kill")
	givemoney(k, _money)
end


return gg.name
