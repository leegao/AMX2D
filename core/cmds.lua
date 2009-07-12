--[[--
	Command Parser
	Initializes the CMD System. Use settings/cmd.cfg
	Format:
	Symbol Admin Preprocessed code
	Example:
	? false help

	Typing in "?" will be the same as typing in "!help "
	Typing in "?gg" will be the same as typing in "!help gg"
--]]--

--[-- Command Prefix.
function cmd_init()
	for line in io.lines(conf_dir.."cmds.cfg") do
		local cmd = {}

		--Future: string.split()
		for word in string.gmatch(line, "[^%s]+") do
			table.insert(cmd, word)
		end

		local symbol = cmd[1] -- Symbol
		local admin = cmd[2] -- Admin or Not
		local text = cmd[3] -- What to parse

		--[--
		if not admin then admin = "false" end
		if not text then text = "" end
		--]-- Condition Chunk for all cmds to work.

		if symbol and admin then
			text = string.sub(line, #symbol+#admin+2)
		end

		if not (string.lower(admin) == "true" or string.lower(admin) == "false") and type(admin) == "string" then
			text=admin
			admin = false
		elseif string.lower(admin) == "true" then
			admin = true
		else
			admin = false
		end

		cmd_prefix[symbol]={cmd = text, admin = admin}
	end
end
--]--

function parseCmd(t, priv, p)
	local cmd = {}
	if type(p) == "table" then p = p[1] end

	if (type(priv) ~= "boolean") then p = priv; priv = false end

	for word in string.gmatch(t, "[^%s]+") do
		table.insert(cmd, word)
	end

	if not cmd[1] then return invalid() end
	local typ = string.lower(string.gsub(cmd[1], "_", ""))
	if typ == "act" then return nil end
	table.remove(cmd, 1)
	if priv then
		--[[--
		if (typ == "login") then
			local username = cmd[1]
			local password = cmd[2]
			if (users[username]) then
				if (users[username].password == password) then
					admins[p] = users[username].privilege
					msg2(p, "User \""..username.."\" logged in successfully, your privilege mask is \""..admins[p].."\"")
				else
					msg2(p, "User Found but Incorrect Password")
				end
			else
				msg2(p, "No User with the Username: "..username)
			end
		else
		--]]--
		if (cmd_priv[typ]) then
			if cmd_priv[typ][admins[p]] then
				local privilege = admins[p]
				command = tableToString(cmd)
				admin_action:act(typ, p, command)
			else
				msg2(p, "You do not have sufficient privilege to use this command")
			end
		elseif not cmd_priv[typ] then
			msg2(p, "Admin command \""..typ.."\' does not exist")
		else
			msg2(p, "You must log in to use this command")
		end
	else
		command = tableToString(cmd)
		action:act(typ, p, command)
	end
	return 1
end
