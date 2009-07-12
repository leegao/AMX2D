init_mod("ng")
ng.players= {}
ng.startna = 5
ng.startcr = 10
for i = 1, 32, 1 do
	ng.players[i] = {nades = ng.startna, gun = 0, credits = ng.startcr}
end
ng.teams = {0, 0, 0}
ng.t = "Red"
ng.ct = "Blue"
ng.team = {ng.t, ng.ct}
ng.maxscore = 50
ng.teamstext = 'hudtxt %s "%s>>Scores: T - %s, CT - %s. To Win: %s Points <<" 130 100 1'
ng.nadetext = 'hudtxt2 %s %s "%s>>You have %s grenades<<" 130 120 1'
ng.credittext = 'hudtxt2 %s %s "%s>>You have %s credits<<" 130 140 1'
ng.guntext = 'hudtxt2 %s %s "%s>>%s<<" 130 160 1'

ng.adverts = {n = 1,
				Color(055, 100, 200).."Type !buy to see the buy menu",
				Color(255, 100, 0).."Type !nade to buy nades",
				Color(0, 255, 150).."Type !heal to buy health",
				Color(70, 75, 60).."Type !armor to buy armor",
				Color(0, 255, 150).."Type !speed to buy speed",
				"©255100000Welcome to the Grenade Mod Test"
			}

parse('hudtxt 5 "©255100000Welcome to the Grenade Mod Test" 130 200 1')
function ng.update(p)
	parse(string.format(ng.teamstext, 1, "©055255250", ng.teams[1], ng.teams[2], ng.maxscore))
	if p then
		local nades = ng.players[p].nades
		if ng.players[p].nades <= 0 then nades = "no" end
		local gun = "Your Gun is a "..ng.players[p].gun
		if ng.players[p].gun == 0 then gun = "You do not have a gun" end

		parse(string.format(ng.nadetext, p, 2, "©255000000", nades))
		parse(string.format(ng.credittext, p, 3, "©000000250", ng.players[p].credits))
		parse(string.format(ng.guntext, p, 4, "©155100200", gun))
	end
end


function ng.change()
	parse(string.format('hudtxt 5 "%s" 130 200 1', ng.adverts[ng.adverts.n]))
	ng.adverts.n = ng.adverts.n + 1
	if ng.adverts.n > #ng.adverts then
		ng.adverts.n = 1
	end
end

function hook_startround_ng()
	for i = 1, 32, 1 do
		if player(i, "exists") then ng.update(i) end
	end
end

function hook_die_ng(p, w)
	if ng.players[p].nades < 5 then
		ng.players[p].nades = 5

	end
	ng.players[p].credits = ng.players[p].credits + 5
	ng.update(p)
end

function hook_spawn_ng(p, w)
	ng.update(p)
	parse("strip "..p.." 0")
	parse("equip "..p.." 51")
	if not ng.players[p].gun == 0 then
		parse("equip "..p.." "..ng.players[p].gun)
	end
	parse("strip "..p.." 50")
	parse("equip "..p.." 50")
	parse("speedmod "..p.." 10")
end

function hook_walkover_ng(p, i, t)
	if not (t == HE) then
		return 1
	else
		strip(p, HE)
		ng.players[p].nades = ng.players[p].nades + 1
	end
end

function hook_drop_ng(p, iid, w)
	if not (w == HE) then
		return 1
	end
	ng.players[p].nades = ng.players[p].nades - 1
end

function hook_buy_ng(p)
	return 1
end

function hook_projectile_ng(p, w)
	if w == HE then
		ng.players[p].nades = ng.players[p].nades - 1
		ng.update(p)
		if ng.players[p].nades > 0 then
			parse("equip "..p.." 51")
		end
	end
end

function hook_kill_ng(p, v)
	ng.teams[player(p, "team")] = ng.teams[player(p, "team")] + 1
	if ng.teams[player(p, "team")] >= ng.maxscore then
		msg(Color(255, 0, 0), string.format("The %s Team has won", ng.team[player(p, "team")]), true)
		msg(Color(255, 0, 0), string.format("NextMap: %s in 5 seconds...", game("nextmap")), true)
		cron.add('5 parse("map "..game("nextmap"))', 1)
	end
	df = 0
	if w == 50 then
		df = 5
	end
	ng.players[p].nades = ng.players[p].nades + 2 + df
	ng.players[p].credits = ng.players[p].credits + 3 + df
	ng.update(p)
	parse("equip "..p.." 51")
	--setscore(p, 0)
	setdeaths(v, 0)
end

function hook_leave_ng(p)
	ng.players[p] = {nades = 5, gun = 0, credits = 10}
end

function hook_join_ng(p)
	
end

function hook_init_ng()
	parse("hud_fireinthehole 0")
	parse("debuglua 0")
	cron.add('2 parse("sv_gamemode 2")', true)
	ngbuymenu = newMenu("What do you want to buy?", "ngbuymenu", {"Nades|2 Credits - 2 Nades", "Health|1 Credit - 10Hp", "Armor|1 Credit - 20AP", "Speed|5 Credits - +1 Speed", "Guns| Depends"})
	cron.add("5 ng.change()")
	cron.add("5 ng.update()")
end

function menu_ngbuymenu(p, sel)
	msg2(p, Color(255, 0, 0), "Buying is not working atm. It'll be up in future updates. Type !nade for more nades.")
end

function act_nade(p, t, cmd)
	if ng.players[p].credits >= 2 then
		ng.players[p].credits = ng.players[p].credits - 2
		ng.players[p].nades = ng.players[p].nades + 2
		ng.update(p)
		parse("equip "..p.." 51")
		msg2(p, "©155200000You have bought 2 Nades for 2 Credits.")
	else
		msg2(p, "©255100000You do not have enough credits")
	end
end

function act_heal(p,t, cmd)

end

function act_buy(p, t, cmd)
	ngbuymenu.show(p)
end

return ng.name
