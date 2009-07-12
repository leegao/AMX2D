--*******************--
--*Utility Functions*--
--*******************--

patches = {}

function error(t)
	if t then
		print(Color(255, 0, 0).."Error: "..t)
	else
		print(Color(255, 0, 0).."Error")
	end
end

function switch(t)
	t.act = function (self,x, p, com)
		local f=self[x] or self.default
		if f then
			if type(f)=="string" then
				_G[f](p, x, com)
			elseif type(f) == "function" then
				f(p, x, com)
			else
				error("case "..tostring(x).." not a function")
			end
		end
	end
  	return t
end





function split(t, b)
	return toTable(t, b)
end

function toTable(t, b)
	local cmd = {}
	local match = "[^%s]+"
	if b then
		match = "%w+"
	end
	if type(b) == "string" then match = "[^"..b.."]+" end
	if not t then return invalid() end
	for word in string.gmatch(t, match) do
		table.insert(cmd, word)
	end
	return cmd
end

function trim(t)
	t = string.split(t)
	s = ""
	if not t then return end
	for i, v in ipairs(t) do
		s = s.." "..v
	end
	s = string.sub(s, 2)
	return s
end

function initArray(i, x)
     local array = {}
	 if (x == nil) then x = 0 end
     for m = 1 , i do
          if (array[m] == nil) then
               array[m] = x
          end
     end
     return array
end


_tostring = tostring
function tostring(t, d)

	if type(t) == "table" then
		if not d then d = "," end
		t = tableToString(t, 1, d)
		t = string.sub(t, 1, #t-#d)
		return t
	end

	if type(_tostring(t)) == "string" then return _tostring(t) end
end

function inside(o, t)
	for i, v in ipairs(t) do
		if o==v then return true end
	end
end

function tableToString(t, n, d)
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

function invalid(p, typ, x)
	if p then
		if not typ then
			msg2(p, "Incorrect parameters")
		else
			if not x then
				msg2(p, "Incorrect parameters for \'"..typ.."\'")
			else
				msg2(p, "Error: "..x)
			end
		end
	end
	return nil
end

function _chkDep(t)
	if _G[t] then return true end
end

function chkDep(t)
	if not (type(t) == "table") then t = {t} end
	for i, v in ipairs(t) do
		if not _G[v] then return false end
	end
	return true
end

plocals = {}

function patch(ifn, fn, before, r)
	if type(ifn) == "string" then
		local nfn = fn

		if type(_G[ifn]) == "function" and type(nfn) == "function" then
			local _fn = _G[ifn]
			local fn = nfn
			if before then
				if not r then
					_G[ifn] = function(n1, n2, n3, n4, n5, n6)
									local _r = fn(n1, n2, n3, n4, n5, n6)
									return _fn(n1, n2, n3, n4, n5, n6)
								end
				elseif type(r) == "function" then
					plocals[ifn] = r
					_G[ifn] = function(n1, n2, n3, n4, n5, n6)
									local _r = fn(n1, n2, n3, n4, n5, n6)
									local _r2 = _fn(n1, n2, n3, n4, n5, n6)
									return plocals[ifn](_r, _r2)
								end
				else
					_G[ifn] = function(n1, n2, n3, n4, n5, n6)
								local _r = fn(n1, n2, n3, n4, n5, n6)
								_fn(n1, n2, n3, n4, n5, n6)
								return _r
							end
				end
			else
				if not r then
					_G[ifn] = function(n1, n2, n3, n4, n5, n6)
									local _r = _fn(n1, n2, n3, n4, n5, n6)
									fn(n1, n2, n3, n4, n5, n6)
									return _r
								end
				elseif type(r) == "function" then
					plocals[ifn] = r
					_G[ifn] = function(n1, n2, n3, n4, n5, n6)
									local _r2 = _fn(n1, n2, n3, n4, n5, n6)
									local _r = fn(n1, n2, n3, n4, n5, n6)
									return plocals[ifn](_r, _r2)
								end
				else
					_G[ifn] = function(n1, n2, n3, n4, n5, n6)
								local _r = _fn(n1, n2, n3, n4, n5, n6)
								return fn(n1, n2, n3, n4, n5, n6)
							end
				end
			end
			if not patches[ifn] then patches[ifn] = {} end
			patches[ifn][fn] = _fn
			local key = math.random(100000)
			while patches[ifn][key] do
				key = math.random(100000)
			end
			patches[ifn][key] = _fn
			return key
		else
			return invalid()
		end
	else
		return invalid()
	end
end

function unpatch(ifn, fn)
	if not patches[ifn] then return false end
	if not (patches[ifn][fn]) then return false end
	_G[ifn] = patches[ifn][fn]
end

function digits(n, p, m)
	if not m then m = 10^p - 1 end
	if n <= 0 then return "000" end
	if n <= m then
		local z = 0
		while (n < 10^(p-1)) do
			p = p-1
			z = z + 1
		end
		local str = n
		for i = 1, z, 1 do
			str = "0"..str
		end
		return str
	else
		return m
	end
end


function Color(r, b, g)
	return string.format("©%s%s%s", digits(r, 3, 255), digits(b, 3, 255),digits(g, 3, 255))
end

function caller()
	local n = 2
	local tab = {}
	while debug.getinfo(n) do
		local x = debug.getinfo(n)
		if not x.name then
			table.insert(tab, "(Anonymous)")
		else
			table.insert(tab, x.name)
		end
		n = n +1
	end
	return tab
end

--Trace Debug
tracetime = os.time()
--io.open(string.format("%s/traces/trace%s.log", initDir,tracetime), "w"):close()

function trace()
	local x = debug.getinfo(2)
	if not x.name then x.name = "(Anonymous)" end
	if x.name == "(for generator)" then return end
	if x.name == "pairs" then return end
	if x.name == "ipairs" then return end
	if x.name == "time" then return end
	if x.name == "insert" then return end
	local s = "Function: ".. x.name
	if x.currentline > 0 then
		s = s.." @ Line: "..x.currentline
	end
	if x.source ~= "=[C]" then
		s = s.." @ File: "..x.source
	end
	local n = 1
	while debug.getlocal(2, n) do
		local k, v = debug.getlocal(2, n)
		if type(v) == "string" then v = '"'..v..'"' end
		if k == "(*temporary)" then
			if type(v) == "table" then
				local s = ""
				for k, _v in pairs(v) do
					local _n = _v
					if type(_v) == "function" then
						_n = "Fn@"..debug.getinfo(_v).currentline
					end
					if string.sub(tostring(k), 1, 8) == "userdata" then s = "[ENV]"; break end
					s = s.."["..tostring(k).."] ="..tostring(_n)..";"
				end
				v = "{".._tostring(s).."}"
			end
			if type(v) == "boolean" then v = "true" end
			if v then s = s.."\n\t".."(Temp)".." = "..tostring(v) end
		else
			if not v then v = "nil" end
			if type(v) == "table" then
				local s = ""
				for k, _v in pairs(v) do
					local _n = _v
					if type(_v) == "function" then
						_n = "Fn@"..debug.getinfo(_v).currentline
					end
					if string.sub(tostring(k), 1, 8) == "userdata" then k = "[ENV]"; break end
					s = s.."["..tostring(k).."] = "..tostring(_n)..";"
				end
				v = "{".._tostring(s).."}"
			end
			if type(v) == "boolean" then v = "true" end
			s = s.."\n\t"..k.." = "..v
		end
		n=n+1
	end
	local f = io.open(string.format("%s/traces/trace%s.log", initDir,tracetime), "a+")
	f:write(os.clock().." "..s.."\n\n")
	f:close()
end


local s = ""
local seen={}



function getinfo(fn, i)
	local s = i.."Function\n"
	local t = debug.getinfo(fn)
	if t.short_src ~= "[C]" then
		s = s..i.."Source: "..t.short_src.."\n"
	end
	if t.currentline > 0 then
		s = s..i.."Line: "..t.currentline.."\n"
	end
	return s
end

function dump(t,i, fn)
	seen[t]=true
	local _n = 1

	for k,v in pairs(t) do
			local _v = _tostring(v)
			if type(v) == "function" then
				_V = "(FUNCTION)"
			elseif type(v) == "table" then
				_v = "("..type(v)..":"..table.length(v)..")"
			elseif type(v) == "string" then
				_v = "'"..v.."'"
			else
				_V = v
			end
			if not (type(v) == "function") then
			s = s.. i .. _n..".) ".. k .. " = ".._v.."\n"
			end
			if type(v)=="table" and not seen[v] then
				dump(v,i.."\t")
			end
			if type(v) == "function" then
				if debug.getinfo(v).short_src ~= "[C]" then
				s = s.. i .. _n..".) ".. k.. "(): \n" .. getinfo(v, i.."\t", true)
				else
					_n = _n-1
				end
			end
		_n = _n+1
	end
end

function dumpG()
	dump(_G,"")
	f = io.open("sys/lua/dump"..os.time()..".txt", "w")
	f:write(s)
	f:close()
	seen = {}
	s = ""
end

function getlocal(fn, b)
	if not (type(fn) == "string") then
		if fn then b = true end
		fn = lastcaller()
	end
	if table.find(caller(), fn) then
		local n = 1
		local i = table.find(caller(), fn)
		local _tab = {}
		while debug.getlocal(i, n) do
			local k, v = debug.getlocal(i, n)
			if v == nil then v = "nil" end
			_tab[k] = v
			if b then print(k, v) end
			n = n+1
		end
		if b then print("Function '"..fn.."' was called "..(i-1).." functions ago and has "..(n-1).." local variables") end
		return _tab
	else
		print("Function '"..fn.."' was never called")
	end
end

function lastcaller()
	return caller()[3]
end
