initDir = ""
amx2d = "b0.3.1"

function main(_initDir, _mods)

	old_G = _G

	--[[--

	Author: Lee Gao
	License: Creative Common
	Title: AMX2D

	--]]--

	--[-- Directory Definitions. Structural.
	if not _initDir then initDir = "sys/lua/amx2d" else initDir = _initDir.."/" end
	conf_dir = initDir.."settings/"
	core_dir = initDir.."core/"
	test_dir = initDir.."test/"
	mods_dir = initDir.."mods/"
	--]--

	--[-- Check MOD set via amx2d/settings/mod.cfg.
	if not _mods then
		local f = io.open(conf_dir.."mod.cfg")
		_mods = f:read()
		if #_mods == 4 then _mods = "mods.cfg" end
		f:close()
	end
	--]--

	--***************--
	--*Load Function*--
	--***************--
	--- Takes in a file name and loads it into the Lua Engine
	-- This function will automatically check whether the file exists,
	-- whether
	function load(file)
		local f = {}
		if not (string.sub(file, 1, 2) == "--") then
			for word in string.gmatch(file, "%w+") do
				table.insert(f, word)
			end
			if f[#f] == "lua" then
				f = loadfile(file)
				if not f then print("Failed to load "..file); return false else f(); return true end
			else
				f = loadfile(file..".lua")
				if not f then print("Failed to load "..file..".lua"); return false else f(); return true end
			end
		end
		return true
	end


	--*********************--
	--*Core Initialization*--
	--*********************--
	function core_init()
		for line in io.lines(conf_dir.."core.cfg") do
			if load(core_dir..line) then
				print("Core: "..line.." successfully initialized")
			end
		end
	end

	--*******--
	--*Hooks*--
	--*******--
	function hook_init()

		--[-- Core INITIALIZATION
		--Initialize the Core system
		core_init()
		--Initialize the User system
		user_init()
		--Initialize the Mods system
		mod_init(_mods)
		--Initialize the Commands system
		cmd_init()
		--]--

		--[-- Do Not Close
		for i, fn in ipairs(hooks.init) do
			_G[fn]()
		end
		--]--

		--[-- Debug
		if sv.debug > 0 then
			debug.sethook(trace, "c")
		end
		--]]-- Close this out if you wishes to disable the Debug system

	end

	--[[--

	lua "loadstring(\"for k, v in pairs(_G) do print(k) end\")"

	--]]--

	function hook_say(p, t)
		local ret = 0 -- Default Return value- 0:Normal
		for k, v in pairs(cmd_prefix) do
			--Cmd Prefix is defined in amx2d/settings/cmds.cfg
			if string.lower(string.sub(t, 1, #k))==k then
				t = string.sub(t, #k+1)
				--parseCmd(text, admin, {playerid})
				--core/cmd.lua
				ret = parseCmd(v.cmd..t, v.admin, {p})
				--Automatically defaults to 1 on return.
			end
			--if ret == 0 then ret = 1 end
		end

		return ret
		--hook_say shouldn't need a mod iteration.
	end
	addhook("say", "hook_say", 10)

	--[-- lua reset()
	function reset()
		old_G.initDir = initDir
		_G = old_G
		main(initDir)
		return
	end
	--]-- Obsolete reset function. Soft reset.

	--[-- @amx2d ModSet
	function adm_amx2d_superadmin(p, typ, cmd)
		if #cmd == 0 then cmd = "mods"
		else
			cmd = "mods/"..cmd:trim()
		end
		cmd = trim(cmd)
		local f = io.open(conf_dir.."mod.cfg", "w")
		f:write(cmd..".cfg")
		f:close()
		cron.add(string.format('1 parse("map %s")', map("name")))
		msg(Color(255, 0, 0), "Switiching MODS - AMX2D", true)
	end
	--]-- Resets AMX2D, if given a parameter, will reload the new mod

	hook_init()
	--Initialization.

end


--[[-- If this is the server.lua, uncomment this out.
main("sys/lua")
--]]--
