init_mod("cw")

cw.var("toggle", 0, "svar")
cw.var("team", {[0] = "spec", [1] = "t", [2] = "ct"})
cw.var("teamr", {[0] = "spec", [2] = "t", [1] = "ct"})
cw.var("teams", initArray(32))
function cw.reset()
	for i = 1, 32, 1 do
		if player(i, "exists") then
			parse("makespec "..i)
		end
	end
end
function cw.reverse()
	for i = 1, 32, 1 do
		if player(i, "exists") then
			parse("make"..cw.teamr[player(i, "team")].." "..i)
		end
	end
end
function adm_cwset_admin(p, x, cmd)
	cmd = toTable(cmd)
	local id = tonumber(cmd[1])
	local team = tonumber(cmd [2])
	if not team then return invalid(p, x) end
	if not cw.team[team] then return invalid(p, x, "Incorrect Team") end
	if not player(id, "exists") then return invalid(p, x, "No Player") end
	cw.teams[id] = team
	parse("make"..cw.team[team].." "..id)

end
function adm_cwlock_admin(p, x, cmd)
	cmd = tonumber(cmd)
	if not cmd then return invalid(p, x) end
	cw.setvar("toggle", tonumber(cmd), true)
	if cw.toggle == 1 then
		cw.reset()
	end
end
function hook_team_cw_2(p, t, l)
	if t > 0 then
		if cw.toggle == 1 then
			if not (cw.teams[p] == t) then
				return 1
			end
		end
	end
end

return cw.name
