function newMod(name)
	local modTable = {}
	if type(_G[name]) == "table" then
		print("mod_"..name.." has already been initiated.")
	elseif _G[name] then
		print (name.." is already initialized as a "..type(_G[name]))
	end
	--Init the modTable
	modTable.name = name
	modTable.cfg = name
	modTable.privilege = {}
	modTable.acts = {}
	modTable.adms = {}
	modTable.typ  = {}
	modTable.dir = mods_dir
	modTable.parse = parse
	modTable.buy = function (n) sv.buy = n end
	modTable.collect = function (n) sv.collect = n end
	modTable.drop = function (n) sv.drop = n end
	modTable.var  = function(n, val, typ)
						if (type(n) == "string" and val ~= nil) then
							modTable[n] = val
							if (type(val) == "string") or (type(val) == "number") then
								local fn = [[
											function adm_%s_admin(p, t, cmd)
												cmd = trim(cmd)
												if tonumber(cmd) then cmd = tonumber(cmd) end
												--print("%s.setvar(%s, cmd, true)")
												%s.setvar("%s", cmd, true)
											end
											]]
								fn = loadstring(string.format(fn, name..n, name, n, name, n))
								if fn then fn() end
							end
							if not typ == "cvar" then typ = "svar" end
							modTable.typ[n] = typ
						end
					end
	modTable.setvar  = function(n, val, c)
						if c == nil then c = true end
						if (type(n) == "string" and val ~= nil) then
							modTable[n] = val
							if c then
								msg("Server svar \""..name.."_"..n.."\" changed to \""..val.."\"")
							end
							modTable.typ[n] = typ
						end
					end
	modTable.loadcfg = function()
							for line in io.lines(conf_dir..modTable.cfg..".cfg") do
								local fn = loadstring(modTable.name.."."..line)
								if fn then fn() end
							end
						end
	--Modifying the Global table
	if (type(name) == "string") then
		_G[name] = modTable
	end

	return modTable
end

function init_mod(name)
	return newMod(name)
end

function toMod(name)
	if not name then return nil end
	for g, v in pairs(_G) do
		if type(v) == "function" then
			local n = toTable(g, true)
			if n[1] == "hook" and n[3] == name then
				addhook(n[2], g, tonumber(n[4]))
			end
		end
	end
	return name, _G[name]
end

function mod_init(file)

	if (file == nil or type(file) ~= "string") then file = conf_dir.."mods.cfg" else file = conf_dir..file end
	if not io.open(file) then file = conf_dir.."mods.cfg" end
    for line in io.lines(file) do
		if not (string.sub(file, 1, 2) == "--") then
			local f = loadfile(mods_dir..line..".lua")
			if type(f) =="function" then
				f = toMod(f())
				print("Mod "..line..".lua sucessfully initialized")
			else
				print("Mod "..line..".lua failed to initialize")
			end
		end
	end
	alt_priv = {}
	for line in io.lines(conf_dir.."altprivileges.cfg") do
		local fn = loadstring("alt_priv."..line)
		if fn then fn() end
	end
	acts = {}
	acts.default = function(p, typ, cmd) msg2(p, "Error: Command Does Not Exist: "..typ) end
	admacts = {}
	admacts.default = function(p, typ, cmd) msg2(p, "Error: Admin Command Does Not Exist: "..typ) end
	for g, v in pairs(_G) do
		if type(v) == "function" then
			local n = {}
			for word in string.gmatch(g, "%w+") do
				table.insert(n, word)
			end
			if n[1] == "act" then
				acts[n[2]] = g
			elseif n[1] == "adm"then
				admacts[n[2]] = g
				if not n[3] then n[3] = "user" end
				if alt_priv[n[2]] then n[3] = alt_priv[n[2]] end
				tempPriv = {[n[3]] = n[3]}
				for i,word in ipairs(adminhierarchy(n[3])) do
					tempPriv[word] = word
				end
				cmd_priv[n[2]] = tempPriv

			end
		end
	end
	action = switch(acts)
	admin_action = switch(admacts)
end
