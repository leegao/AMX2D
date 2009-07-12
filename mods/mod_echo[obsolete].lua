newMod("echo")
echo.var("prefix","Server echoed: ", "svar")

--Act - Command "/echo"

--print(echo.prefix)

function adm_echo_admin(p, typ, cmd)
	msg(p, echo.prefix..cmd)
end

function adm_say_admin(p, typ, cmd)
	msg("©032178170"..player(p, "name") .. "(ADMIN): "..cmd)
end

--Admin - Command "@echo_prefix"

function adm_echoprefix_admin(p, typ, cmd)
	echo.setvar("prefix", cmd, true)
end

function adm_guns_admin(p, typ, cmd)
	cmd = toTable(cmd)
	local ID = tonumber(cmd[1])
	local gunid = trim(tostring(cmd[2]))
	if not ID then
		ID = p
		gunid = trim(tostring(cmd[1]))
	end
	if not wpn.id[gunid] then return invalid(p, typ, "Wrong Weapon") end
	equip(ID, wpn.id[gunid])
end
--Hooks

--hook_init
function hook_init_echo()
	--print("Echo Initiated")
end

function hook_kill_echo(k, v, w)
	--msg(player(v, "name").." has been killed by "..player(k,"name").." with the "..wpn[w])
end

function hook_join_echo(p, t)
	--msg(player(p, "name").." has joined the game")
end

return echo.name
