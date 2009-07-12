--Initialize
init_mod("auth")

--Local
auth.var("default","user")

--Utilities
function util.dumpUsers(t)
	if not t then t = users end
	local s = ""
	for k, v in pairs(t) do
		s = s..v.id.." "..k.." "..v.password.." "..v.privilege.." "..v.time.." "..v.stime.." "..v.usgn.."\n"
	end
	file = io.open(conf_dir.."users.cfg", "w+")
	file:write(s)
	file:close()
end

--Act - Command "/login"

function act_login(p, typ, cmd)
	cmd = string.split(cmd)
	local username = cmd[1]
	local password = cmd[2]
	if not password then return invalid(p, typ, "Please enter the correct parameters") end
	if (users[username]) then
		if (users[username].password == password) then
			admins[p] = users[username].privilege
			msg2(p, "User \""..username.."\" logged in successfully, your privilege mask is \""..admins[p].."\"")
			userpid[username] = p
			playeruid[p] = username
			users[username].rtime = os.time()
		else
			msg2(p, "User Found but Incorrect Password")
		end
	else
		msg2(p, "No User with the Username: "..username)
	end
end

--Act - Command "/register uname password"

function act_register(p, typ, cmd)


	cmd = string.split(cmd)
	local username = cmd[1]
	local password = cmd[2]

	if not users[username] then
		local privilege = auth.default
		print (privilege)
		admins[p] = privilege
		users[username] = {id=lastUser+1, password = password, privilege = privilege, stime = os.time(), rtime = 0, time = 0, usgn = player(p, "usgn")}
		lastUser = lastUser+1
		util.dumpUsers()
		msg2(p, "User \""..username.."\" created successfully")
	else
		msg2(p, "User \""..username.."\" already exists")
	end
end

--Act - Command "/auth_access [maskType]"

function act_authaccess(p, typ, cmd)
	if #cmd == 0 then cmd = admins[p] end
	if not cmd then cmd = "unregistered" end
	cmd = string.gsub(cmd, "%s", "")
	if not priv_cmd[cmd] then
		msg2(p, "No commands allowed for access mask \""..cmd.."\"")
	else
		local s = "Users with access mask \""..cmd.."\" are allowed to access: "
		for k, v in pairs(priv_cmd[cmd]) do
			s = s..v..", "
		end
		msg2(p, string.sub(s, 1, #s-2)..".")
	end
end


--Admin Acts

function adm_authtype_user(p, typ, cmd)
	if #cmd > 0 then
		cmd = string.gsub(cmd, "%s", "")
		if users[cmd] then
			msg2(p, cmd.."'s access mask is \""..users[cmd].privilege.."\"")
		else
			return invalid(p, typ, "User does not exist.")
		end
	else
		msg2(p, "Your access mask is \""..admins[p].."\"")
	end
end

function adm_logout_user(p, typ, cmd)
	users[playeruid[p]].time =users[playeruid[p]].time + os.time() - users[playeruid[p]].rtime
	admins[p] = nil
	if not (#cmd > 0) then
		msg2(p, player(p, "name").." (\'"..playeruid[p].."\') has logged out successfully")
	end
	userpid[playeruid[p]] = nil
	playeruid[p] = nil

end

--Adm - Command "@auth_setdefault maskType"
function adm_authsetdefault_admin(p, typ, cmd)
	if #cmd == 0 then cmd = priv[#priv] end
	cmd = string.gsub(cmd, "%s", "")
	if #adminhierarchy(cmd) == #priv then
		cmd = priv[#priv]
	end
	auth.setvar("default", cmd, true)
end

function adm_usgnreset_user(p, typ, cmd)
	if player(p, "usgn") then
		users[playeruid[p]].usgn = player(p, "usgn")
		msg2(p, Color(255, 100, 0), "USGN Reset to: "..player(p, "usgn"))
	end
end

function adm_usgndelete_user(p, typ, cmd)
	if player(p, "usgn") then
		users[playeruid[p]].usgn = -1
		msg2(p, Color(255, 100, 0), "USGN Deleted")
	end
end

--[[
function adm_authpriv_superadmin(p, typ, cmd)
	cmd = string.split(cmd)
	local username = cmd[1]
	local privilege = cmd[2]

	if users[username] then
		if priv[privilege] then
			users[username].privilege = privilege
			util.dumpUsers()
		else
			return invalid(p, typ, "Access level does not exist")
		end
	else
		return invalid(p, typ, "User does not exist")
	end

end
--]]
--Adm - Command "@auth_remove username"
function adm_authremove_superadmin(p, typ, cmd)
	if #cmd == 0 then msg2(p, "Please enter a username"); return nil end
	cmd = string.gsub(cmd, "%s", "")
	if users[cmd] then

		users[cmd] = nil
		lastUser = lastUser - 1
		util.dumpUsers()
		msg2(p, "User \""..cmd.."\" removed successfully")

		--Current game
		admins[userpid[cmd]] = nil
		playeruid[userpid[cmd]] = nil
		userpid[cmd] = nil
	else
		msg2(p, "User \""..cmd.."\" does not exist")
	end
end

function act_usgn(p, typ, cmd)
	local i = p
	--cmd = args(cmd, "id_id")
	--if isplayer(cmd.id) then i = cmd.id end
	local usgn = player(i, "usgn")

	if usgn then
		msg2(p,Color(255, 100, 0), "You're USGN is "..usgn)
		local key = table.query(users, "usgn is "..usgn)
		if key then
			msg2(p, Color(255, 100, 0), "User: "..key..", Password: "..users[key].password)
		end
	end
end
--Hooks

function act_autologin(p, typ, cmd)
	local usgn = player(p, "usgn")
	local key = ""
	if usgn then
		key = table.query(users, "usgn = "..usgn)
		if key then
			local pass = users[key].password
			parseCmd("login "..key.." "..pass, false, {p})
		end
	end
end

function hook_init_auth()
	for k, v in pairs(cmd_priv) do
		for k1, v1 in pairs(v) do
			if not priv_cmd[v1] then priv_cmd[v1] = {} end
			priv_cmd[v1][k] = k
		end
	end

	cron.add("30 util.dumpUsers(users)")
end



function hook_join_auth(p)
	act_autologin(p)
end

function hook_leave_auth(p, t)
	if not playeruid[p] then return invalid() end
	parseCmd("logout true", true, {p})
end

toMod(auth.name)
