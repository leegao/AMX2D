init_mod("tban")

tban.var("timeout", 600, "cvar") -- timeout = 10min

tban.players = {}

function adm_tban_admin(p, typ, cmd)
	cmd = args(cmd, "id_id, timeout")
	local id = cmd.id
	local timeout = cmd.timeout

	if not tonumber(timeout) then timeout = tban.timeout end
	if not isplayer(id) then return invalid(p, typ) end
	tban.players[player(p, "ip")] = os.time() + timeout
	cron.add(string.format("1 msg2(%s, 'You have been temp banned for %s seconds')", id, timeout), true)
	cron.add("3 parse('kick "..id.."')", true)
end

function hook_join_tban(p)
	if tban.players[player(p, "ip")] then
		if os.time() >= tban.players[player(p, "ip")] then
			tban.players[player(p, "ip")] = nil
			return
		end
		cron.add(string.format("1 msg2(%s, 'You have been temp banned for %s more seconds'", p, tban.players[player(p, "ip")] - os.time()), true)
		cron.add("3 parse('kick "..p.."')", true)
	end
end

return tban.name
