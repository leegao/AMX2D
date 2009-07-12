--Initialize
init_mod("sv")

sv.var("prefix","Server echoed: ", "svar")
sv.var("broadcasttimeout", 60, "svar")
sv.var("debug", 0, "svar")
sv.var("buy", 1, "svar")
sv.var("drop", 1, "svar")
sv.var("collect", 1, "svar")
sv.broadcasttime = initArray(32)
sv.var("color", {})
--Act - Command "!echo"

function act_nextmap(p, typ, cmd)
	msg(string.format("nextmap: %s", game("nextmap")))
end

function act_broadcast(p, typ, cmd)
	cmd = trim(cmd)
	if os.time() > sv.broadcasttime[p] and #cmd > 0 then
		msg(Color(100, 255, 0), string.format("%s(BROADCAST): %s", player(p, "name"), cmd))
		msg2(p, Color(255, 100, 0),"You have a "..sv.broadcasttimeout.." second cool off period before the next broadcast")
		sv.broadcasttime[p] = os.time() + sv.broadcasttimeout
	else
		msg2(p, Color(255, 100, 0), string.format("You may not make another broadcast for %s more seconds", sv.broadcasttime[p] - os.time()))
	end
end

function adm_echo_admin(p, typ, cmd)
	msg(Color(255, 0, 0), sv.prefix..cmd)
end

function adm_say_admin(p, typ, cmd)
	local color = "©032178170"
	if sv.color[playeruid[p]] then
		color = sv.color[playeruid[p]]
	end
	msg(color..player(p, "name") .. "(ADMIN): "..cmd)
end

function adm_setcolor_admin(p, typ, cmd)
	local r = tonumber(ReadString(cmd, 3))
	local b = tonumber(ReadString(cmd, 3))
	local g = tonumber(ReadString(cmd, 3))
	local color = "©032178170"
	if r and b and g then
		color = Color(r, b, g)
	end
	sv.color[playeruid[p]] = color
	s = ""
	for k, v in pairs(sv.color) do
		s = s .. k .. " " .. v .. "\n"
	end
	local f = io.open(conf_dir.."color.cfg")
	f:write(s)
	f:close()
end

function adm_sayto_admin(p, typ, cmd)
	cmd = args(cmd, "id_id, msg")
	local i = cmd.id
	local _msg = cmd.msg
	if not player(i, "exists") then return invalid(p, typ) end
	if not _msg then return invalid() end
	msg2(i, Color(255, 100, 0), string.format("%s (PRIVATE): %s", player(i, "name"), _msg))
end

--Admin - Command "@echo_prefix"

function act_guns(p, typ, cmd)
	local s = ""
	for k, v in pairs(wpn.name) do
		s = s..v.. ", "
	end
	msg2(p, Color(255, 255, 255), s)
end

function adm_guns_admin(p, typ, cmd)
	cmd = args(cmd, "id_id, gunid")
	local ID = cmd.id
	local gunid = cmd.gunid
	if not isplayer(ID) then
		ID = p
		gunid = trim(tostring(cmd[1]))

	end
	if not gunid then return invalid(p, typ) end
	equip(ID, wpn.id[gunid], true)
end

function adm_teleport_admin(p, typ, cmd)
	cmd = args(cmd)
	local i = cmd[1]
	local x = cmd[2]
	local y = cmd[3]
	if not y then return invalid(p, typ) end
	if not player(i, "exists") then return invalid(p, typ, "Invalid Player") end
	parse(string.format("setpos %s %s %s", i, x, y))
end

function adm_teletile_admin(p, typ, cmd)
	cmd = args(cmd)
	local i = cmd[1]
	local x = cmd[2]
	local y = cmd[3]
	if not y then return invalid(p, typ) end
	if not player(i, "exists") then return invalid(p, typ, "Invalid Player") end
	parse(string.format("setpos %s %s %s", i, x*32+16, y*32+16))
end

function adm_getpos_admin(p, typ, cmd)
	local i = playerid(cmd)
	if not i then i = p end
	if not player(i, "exists") then return invalid(p, typ) end
	msg2(p, Color(255, 100, 0), string.format("%s is located at (%s, %s)", player(i, "name"), math.ceil(player(i, "x")), math.ceil(player(i, "y"))))
end

function adm_gettile_admin(p, typ, cmd)
	local i = playerid(cmd)
	if not i then i = p end
	if not player(i, "exists") then return invalid(p, typ) end
	msg2(p, Color(255, 100, 0), string.format("%s is located at (%s, %s)", player(i, "name"), player(i, "tilex"), player(i, "tiley")))
end

function adm_getid(p, typ, cmd)
     cmd = trim(cmd)
     local names = {}
     for i =1, 32, 1 do
          if player(i, "exists") then
               names[player(i, "name")] = i
          end
     end
     if names[cmd] then msg2(p, "Player '"..cmd.."' is at ID: "..names[cmd]) end
end

function act_getid(p, typ, cmd)
	msg2(p,Color(255, 0, 0), "Player '"..player(p, "name").."' is at ID: "..p)
end

function adm_getname(p, typ, cmd)
	cmd = tonumber(trim(cmd))
	if not cmd then return invalid(p, typ) end
	local name = name(cmd)
	if not name then return nil end
	msg2(p, "ID# "..cmd.." is Player '"..name.."'")
end

function adm_givemoney_admin(p, typ, cmd)
	cmd = args(cmd, "player_id, money")
	local player = playerid(cmd[1])
	local money = tonumber(cmd[2])

	if player and money then
		givemoney(player, money)
	end
end

function adm_kick_admin(p, typ, cmd)
	cmd = playerid(cmd)
	if not cmd then return invalid(p, typ) end

	kick(cmd)
end

function adm_ban_admin(p, typ, cmd)
	cmd = playerid(cmd)
	if not cmd then return invalid(p, typ) end

	ban(cmd)
end

function adm_banname_admin(p, typ, cmd)
	cmd = playerid(cmd)
	if not cmd then return invalid(p, typ) end

	banname(cmd)
end

function adm_impulse101_admin(p, typ, cmd)
	cmd = args(cmd, "id_id")
	if not cmd then cmd = {}; cmd.id = p end

	for i = 1, 90 do
		if (itemtype(i,"name")~="") and i ~= Flag then
				if i == Armor then break end
				equip(cmd.id, i)
		end
	end
end

function adm_nextmap_admin(p, typ, cmd)
	local nextmap = game("nextmap")
	parse("map "..nextmap)
end

function adm_map_admin(p, typ, cmd)
	parse("map "..cmd:trim())
end

function act_map(p, typ, cmd)
	msg2(p, "Current Map: "..game("map"))
end

function adm_slap_admin(p, typ, cmd)
	cmd = args(cmd, "id_id, health")

	if not cmd.id then return end
	if player(cmd.id, "health") > 0 then
		parse (string.format("setmaxhealth %s %s",cmd.id, player(cmd.id, "health")-cmd.health))
	end

end

function adm_armor_admin(p, typ, cmd)
	cmd = args(cmd, "id_id, armor")

	if not cmd.id then return end
	if player(cmd.id, "armor")< 200 then
		parse (string.format("setarmor %s %s",cmd.id, player(cmd.id, "armor")+cmd.armor))
	end

end

function adm_slay_admin(p, typ, cmd)
	cmd = playerid(cmd)
	if not isplayer(cmd) then return invalid(p, typ) end

	parse("killplayer "..cmd)
end

function adm_speed_admn(p, typ, cmd)
	cmd = args(cmd, "id_id, speed")

	if not cmd.id then return end
	--if player(cmd.id, "health") > 0 then
		parse (string.format("speedmod %s %s",cmd.id, cmd.speed))
	--end
end

function adm_parse_superadmin(p, typ, cmd)
	parse(cmd:trim())
	msg2(p, Color(255, 100, 0), "Server Parsed: "..cmd:trim())
end

--Overloading the default constructor, note, this will overwrite admin.
--[[--
@NOTE: This is very dangerous code and may have the potential to crash your
PC if not used correctly. Only use if you have good knowledge of Lua
and is in desperate needs to trace out the behavior of every function.
--]]--
function adm_svdebug_superadmin(p, typ, cmd)
	print(cmd)
	if not tonumber(cmd) then return end
	cmd = tonumber(cmd)
	sv.setvar("debug", cmd, true)
	if cmd < 1 then
		debug.sethook()
	else
		debug.sethook(trace, "c")
	end
end

function adm_svdump_superadmin(p, typ, cmd)
	dumpG()
end

function hook_init_sv()
	--Colors
	local colorfile = conf_dir.."color.cfg"
	for line in io.lines(colorfile) do
		local name = line:split()[1]
		local color = line:split()[2]
		sv.color[name] = color
	end
end

function hook_walkover_sv(p)
	if sv.collect == 0 then
		return 1
	end
end

function hook_drop_sv(p)
	if sv.drop == 0 then
		return 1
	end
end

function hook_buy_sv(p)
	if sv.buy == 0 then
		return 1
	end
end
toMod(sv.name)
