init_mod("authset")

function adm_authset_superadmin(p, typ, cmd)
	cmd = toTable(cmd)
	local username = cmd[1]
	local privilege = cmd[2]

	if users[username] then
		if adminhierarchy(privilege) then
			users[username].privilege = privilege
			util.dumpUsers()
		else
			return invalid(p, typ, "Access level does not exist")
		end
	else
		return invalid(p, typ, "User does not exist")
	end

end

return authset.name
