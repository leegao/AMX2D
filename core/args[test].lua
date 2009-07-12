--AMX2D Already has this built in.
if amx2d then return true end

function string.trim(t)
	t = string.split(t)
	s = ""
	if not t then return end
	for i, v in ipairs(t) do
		s = s.." "..v
	end
	s = string.sub(s, 2)
	return s
end

function string.split(t, b)
	local cmd = {}
	local match = "[^%s]+"
	if b then
		match = "%w+"
	end
	if type(b) == "string" then match = "[^"..b.."]+" end
	if not t then return nil end
	for word in string.gmatch(t, match) do
		table.insert(cmd, word)
	end
	return cmd
end

function string.inside(o, t)
	for i, v in ipairs(t) do
		if o==v then return true end
	end
end

function string.qsplit(t, d)
	if not d then d = '"' end
	local tab = string.split(t, d)
	if #tab == 1 then
		return string.split(tab[1])
	end
	local ret = {}
	for i, v in ipairs(tab) do
		if i%2 ~= 0 then
			table.insert(ret, v)
		else
			v = string.split(v)
			for _i, _v in ipairs(v) do
				table.insert(ret, _v)
			end
		end
	end
	return ret
end

function table.trim(t)
	local tab = {}
	for k, v in pairs(t) do
		if type(k) == "string" then k = k:trim() end
		if type(v) == "string" then v = v:trim() end
		tab[k] = v
	end
	return tab
end

function table.toStr(t, n, d)
	local s = ""

	if (n == nil) then n = 1 end
	if n<1 then n = 1 end
	if not d then d = " " end
	while (n <= #t) do
		s = s .. t[n] .. "".. d
		n = n + 1
	end
	return s

end

function isplayer(p)
	p = playerid(p)
	if not (type(p) == "number") then return false end
	if not player(p, "exists") then return false end
	return true
end

function playerid(i)
	i = string.trim(i)
	if tonumber(i) then
		if player(tonumber(i), "exists") then return tonumber(i) end
	end
	i = name2id(i)
	return i
end

function name2id(name)
	local names = {}
     for i =1, 32, 1 do
          if player(i, "exists") then
               names[player(i, "name")] = i
			end
     end
     if names[name] then return names[name] else return nil end
end

function id(name)
	return name2id(name)
end

function id2name(id)
	if player(id, "exists") then
		return player(id, "name")
	end
end

function name(id)
	return id2name(id)
end

if not player then
	function player(p, n)
		return n
	end
end
function args(t, n)
	if #t < 1 then return end
	if not n then n = #t:split() end
	local arg = {}
	if type(n) == "table" then
		arg = n
		n = #n
	elseif type(n) == "string" then
		arg = table.trim(string.split(n, ","))
		n = #arg
	end

	local t = t:split()
	local _t = {}
	if #t < n then n = #t end
	for i = 1, n-1 do
		local x = t[i]
		if #arg > 0 then
			if arg[i]:split("_") then
				if arg[i]:split("_")[2] == "id" then
					x = playerid(x)
					arg[i] = arg[i]:split("_")[1]
				end
			end
		end
		if not x then x = t[i] end
		if tonumber(x) then x = tonumber(x) end
		x = string.trim(x)
		if #arg > 0 then
			_t[arg[i]] = x

		end

		table.insert(_t, string.trim(t[i]))
	end

	local last = table.toStr(t, n)
	if #last == 0 then last = nil end
	local _l = last
	if #arg > 0 then
		if arg[n]:split("_") then
			if arg[n]:split("_")[1] == "id" then l = playerid(last) end
		end
	end
	if l then last = l end
	if tonumber(last) then last = tonumber(last) end
	last = string.trim(last)
	if #arg > 0 then
		_t[arg[n]] = last
	end

	table.insert(_t, string.trim(table.toStr(t, n)))
	return _t
end

t=args("guns name AK47", "cmd, player_id, gun")

print(t.cmd, t.player, t.gun)
