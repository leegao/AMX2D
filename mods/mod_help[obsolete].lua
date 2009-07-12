newMod("help")

--Global
conf_help = initDir.."help/"

--Variables
help.var("list", "")
help.var("isMenu", 1, "svar")

--Utilities
function util.loadhelp()
	for act, fn in pairs(acts) do
		file = io.open(conf_help..act..".help", "r")
		if file then
			local s = file:read("*all")
			file:close()
			help.add(act, s)
		end
	end

	for act, fn in pairs(admacts) do
		file = io.open(conf_help..act..".help", "r")
		if file then
			local s = file:read("*all")
			file:close()
			help.add(act, s)
		end
	end

end

--Help.add("mod", "command", "description") --Manual documenation of your code.
function help.add(c, d)
	if help[c] then return nil end
	if acts[c] then
		help[c] = {description = d}
	elseif cmd_priv[c] then
		help[c] = {description = d}
		help[c].access = ""
		for k, v in pairs(cmd_priv[c]) do
			help[c].access = k
			break
		end
	end
end

--Help.query("query") --Returns all matches with the query as the prefix
function help.query(t)
	local list = ""
	for act, fn in pairs(acts) do
		if not (act == "act" or act == "default") then
			if string.sub(act,1, #t) == t then
				if list == "" then
					list = "!"..t.."_"..string.sub(act,#t+1)
				else
					list = list..", !"..t.."_"..string.sub(act,#t+1)
				end
			end
		end
	end
	for act, fn in pairs(admacts) do

		if string.sub(act,1, #t) == t then

			if not (act == "act" or act == "default") then

				list = list..", *"..t.."_"..string.sub(act,#t+1)

			end
		end
	end
	--menuhelpquery = newMenu("Queried Menu", "menuhelpquery", list)
	--print(list)
	return list
end

--Admin - Command "/help command"

function menu_helpmenu(p, sel)
	local item = helpmenu.items[sel]
	item = item:sub(2)
	--msg("You've selected: "..item)
	--parse("help "..item)
	parseCmd("help "..item, false, {p})
end

function menu_menuhelpquery(p, sel)
	local item = helpmenu.items[sel]
	item = item:sub(2)
	--msg("You've selected: "..item)
	--parse("help "..item)
	parseCmd("help "..item, false, {p})
end

function act_help(p, typ, cmd)
	if not cmd then cmd =  "" end
	cmd = string.gsub(cmd, "%s", "")
	local t = string.gsub(cmd, "_", "")
	if t == "" then
		print("All available commands: "..help.list)
		helpmenu.show(p)
		--msg2(p, "Type /help command to get the description on that particular command.")
		return
	end

	if help[t] then
		local n = 1
		--print(help[t].description)
		for line in string.gmatch(help[t].description, "[^\n]+") do
			if n == 1 then
				msg2(p, "\""..cmd.."\"".." usage: "..line)
				n=n+1
			else
				msg2(p, "\""..cmd.."\""..": "..line)
			end
		end
		--msg2(p, "\""..cmd.."\"".." usage: "..help[t].description)
		if help[t].access then
			msg2(p, "Only users with an access mask of \""..help[t].access.."\" or greater can access this command")
		end
	else
		if acts[t] or admacts[t] then
			msg2(p, "The Command \""..cmd.."\" exists but does not have a help file")
			if cmd_priv[t] then
				if playeruid[p] then
					if cmd_priv[t][users[playeruid[p] ].privilege] then
						msg2(p, "You have sufficient privileges to access \'"..cmd.."\'")
					else
						msg2(p, "You DO NOT have sufficient privileges to access \'"..cmd.."\'")
					end
				end
			end
		else
			local list = help.query(cmd)
			if not (list == "") then
				msg2(p, "All commands with prefix \'"..cmd.."\': "..list)
				--menuhelpquery.show(p)
				msg2(p, "Type /help command to get the description on that particular command.")
			else
				msg2(p, "The Command \""..cmd.."\" does not exist.")
				parseCmd("help", false, {p})
			end
		end
	end

end

function hook_init_help()
	--print ( type(act) == "table")
	for act, fn in pairs(acts) do
		if not (act == "act" or act == "default") then
			if help.list == "" then help.list = "!"..act else
				help.list = help.list..", !"..act
			end
		end
	end
	for act, fn in pairs(admacts) do
		if not (act == "act" or act == "default") then
			help.list = help.list..", @"..act
			--print(act)
		end
	end
	helpmenu = newMenu("Commands", "helpmenu", help.list)
	--print(helpmenu.toString)
	util.loadhelp()
	help.loadcfg()
end

return help.name
