
wpns = {}
for i = 1, 32, 1 do
	wpns[i] = {nades = 30, gun = 0, credits = 10}
end
nadetext = 'hudtxt2 %s %s "%s>>You have %s grenades<<" 160 100 1'
credittext = 'hudtxt2 %s %s "%s>>You have %s credits<<" 160 120 1'
guntext = 'hudtxt2 %s %s "%s>>%s<<" 160 140 1'

parse('hudtxt 4 "©255100000Type !nade to buy nades. - NadeGame Lite" 160 170 1')
function nade(p)
	local nades = wpns[p].nades
	if wpns[p].nades <= 0 then nades = "no" end
	local gun = "Your Gun is a "..wpns[p].gun
	if wpns[p].gun == 0 then gun = "You do not have a gun" end
	parse(string.format(nadetext, p, 1, "©255000000", nades))
	parse(string.format(credittext, p, 2, "©255000000", wpns[p].credits))
	parse(string.format(guntext, p, 3, "©255000000", gun))
end

addhook("startround", "init")
function init()
	for i = 1, 32, 1 do
		if player(i, "exists") then nade(i) end
	end
end

addhook("die", "die")

function die(p, w)
	if wpns[p].nades < 5 then
		wpns[p].nades = 5

	end
	wpns[p].credits = wpns[p].credits + 5
	nade(p)
end

addhook("spawn", "spawn")

function spawn(p, w)
	nade(p)
	parse("strip "..p.." 0")
	parse("equip "..p.." 51")
	if not wpns[p].gun == 0 then
		parse("equip "..p.." "..wpns[p].gun)
	end
	parse("strip "..p.." 50")
	parse("equip "..p.." 50")
end

addhook("collect", "collect")

function collect(p)
	return 1
end

addhook("buy", "buy")
function buy(p)
	return 1
end

addhook("projectile", "projectile")

function projectile(p, w)
	wpns[p].nades = wpns[p].nades - 1
	nade(p)
	if wpns[p].nades > 0 then
		parse("equip "..p.." 51")
	end
end

addhook("kill", "kill")

function kill(p, w)
	df = 0
	if w == 50 then
		df = 5
	end
	wpns[p].nades = wpns[p].nades + 2 + df
	wpns[p].credits = wpns[p].credits + 3 + df
	nades(p)
	parse("equip "..p.." 51")
end

addhook("leave", "leave")

function leave(p)
	wpns[p] = {nades = 5, gun = 0, credits = 10}
end

addhook("say", "say")
function say(p, t)
	if t == "!nade" then
		if wpns[p].credits >= 2 then
			wpns[p].credits = wpns[p].credits - 2
			wpns[p].nades = wpns[p].nades + 2
			nade(p)
			parse("equip "..p.." 51")
			msg2(p, "©155200000You have bought 2 Nades for 2 Credits.")
		else
			msg2(p, "©255100000You do not have enough credits")
		end
		return 1
	end
end
