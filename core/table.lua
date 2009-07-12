

if not amx2d then dofile("string.lua") end

if not _tostring then _tostring = tostring end

local _table = {}
for k, v in pairs(table) do _table[k] = v end

function table.find(t, o)
	for k, v in pairs(t) do
		if v == o then
			return k
		end
	end
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

function table.tostring_(t, n, d)
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

function table.seperate(t)
	local itab = {}
	local tab = {}
	for k, v in pairs(t) do
		if type(k) == "number" then
			itab[k] = v
		else
			tab[k] = v
		end
	end
	return itab, tab
end

function table.invert(t, _i)
	local tab = {}
	for k, v in pairs(t) do
		if type(v) == "table" and not _i then
			for _k, _v in pairs(v) do
				tab[_v] = k
			end
		else
			if not tab[v] then
				tab[v] = k
			else
				if not (type(tab[v]) == "table") then
					tab[v] = {tab[v], k}
				else
					table.insert(tab[v], k)
				end
			end
		end
	end
	return tab
end

function table.length(t)
	local n = 0
	for k, v in pairs(t) do
		n = n+1
	end
	return n
end

function table.ascend(x, y)
	return x<y
end

function table.descend(x, y)
	return x>y
end

function table.ssort(t,f)
	if not f then f = table.ascend end
	local i=1
	local x, _x = table.seperate(t)
	local n = table.length(x)
	while i<=n do
		local m,j=i,i+1
		while j<=n do
			if f(x[j],x[m]) then m=j end
			j=j+1
		end
		x[i],x[m]=x[m],x[i]			-- swap x[i] and x[m]
		i=i+1
	end
	return table.join(x, _x, false)
end

function table.sort(t, f)
	return table.seperate(table.ssort(t, f))
end

function table.first(t)
	for k, v in pairs(t) do
		return k, v
	end
end

function table.sfirst(t)
	for k, v in pairs(t) do
		if type(k) == "string" then
			return k, v
		end
	end
end

function table.ifirst(t)
	for k, v in pairs(t) do
		if type(k) == "number" then
			return k, v
		end
	end
end

function table.firstVal(t)
	for k, v in pairs(t) do
		return v
	end
end

function table.sfirstVal(t)
	for k, v in pairs(t) do
		if type(k) == "string" then
			return v
		end
	end
end

function table.ifirstVal(t)
	for k, v in pairs(t) do
		if type(k) == "number" then
			return v
		end
	end
end

function table.join(t1, t2, o)
	local tab = t1
	for k, v in pairs(t2) do
		if (t1[k] and o) or not (t1[k]) then
			tab[k] = v
		end
	end
	return tab
end

local seen = {}
local _s_ = ""
function table.dump(t,i, b)

	seen[t]=true
	if not i then i = "" end

	for k,v in pairs(t) do
		local _v, _b = table.tostring(v)
		_s_ = _s_..i.._tostring(table.tostring(k)).." = ".._tostring(_v).." \n"
		if _b and not seen[v] then
			table.dump(v, i.."\t", true)
		end
	end

	if not b then
		local name = table.find(_G, t)
		if not name then name = "(Anonymous)" end
		_s_ =  "[Table:"..name.. "]\n".._s_
		print (_s_)
		local r = _s_

		_s_ = ""
		seen = {}
		return r
	end
end

function table.tostring(t)
	if not (type(t)  == "table") then if type(t) == "function" then return "fn()" end return _tostring(t) end
	local s = "{"
	local b = false
	for k, v in pairs(t) do
		if type(v) == "string" then v = "'"..v.."'" end
		if type(v) == "function" then v= "fn()" end
		if type(v) == "table" then
			v = "[T]"
			b = true
		end
		s = s .. _tostring(k) .. " = " .. _tostring(v) .. ", "
	end
	s = string.sub(s, 1, #s - 2).."}"
	return s, b
end

function table.stripkeys(t, n)
	local tab = {}
	if not n then n = "key" end
	for k, v in pairs(t) do
		if isTable(v) then
			v[n] = k
			table.insert(tab,v)
		end
	end
	return tab
end

function table.getkeys(t)
	local tab = {}
	for k, v in pairs(t) do
		tab[k] = true
	end
	return tab
end

function table.ismatrix(t)
	local _k, _v = table.first(t)
	if not (type(_v) == "table") then return false end
	local keys = table.getkeys(_v)
	for k, v in pairs(t) do
		if not (type(v) == "table") then return false end
		if not table.havekeys(table.getkeys(v), keys) then return false end
	end
	return true
end

function table.equal(t1, t2)
	for k, v in pairs(t1) do
		if t2[k] ~= v then return false end
	end
	return true
end

function table.havekeys(t1, t2)
	for k, v in pairs(t1) do
		if not t2[k] then return false end
	end
	return true
end

function table.haskey(t, k)
	if not t[k] then return false end
	return true
end

function table.setkey(t, k, p)
	if not table.ismatrix(t) then return t end
	if not table.haskey(table.firstVal(t), k) then return t end
	local tab = {}

	for i, v in pairs(t) do
		tab[v[k]] = v
		if not p then
			tab[v[k]][k] = nil
		end
	end

	return tab
end

function table.get(t, key)
	if not table.ismatrix(t) then return t end
	if not table.haskey(table.firstVal(t), key) then return t end

	local tab = {}
	for k, v in pairs(t) do
		tab[k]= v[key]
	end
	return tab
end

function table.diff(t1, t2, b)
	local tab1, tab2 = "", ""
	if not b then
		tab1 = table.find(_G, t1)
		tab2 = table.find(_G, t2)
	end
	if not tab1 then tab1 = "Anon:T1" end
	if not tab2 then tab2 = "Anon:T2" end
	local changed = {}
	local removed = {}
	local new = {}
	local same = {}

	for k, v in pairs(t1) do
		if not t2[k] then
			removed[k] = v
		end

		if not (t2[k] == v) then
			changed[k] = {old = v, new = t2[k]}
		end

		if t2[k] == t1[k] then
			same[k] = v
		end
	end

	for k, v in pairs(t2) do
		if not (changed[k] or removed[k] or same[k]) then
			new[k] = v
		end
	end

	return {changed = changed, removed = removed, new = new, same = same, Tables = {t1 = tab1, t2 = tab2}}
end

function isTable(t)
	if type(t) == "table" then return true end
end

table.comps = {
[{"?", "of", "at", "@"}] = function(t, key, value)
							if not t then return true end
							local n = table.get(t, key)
							return n[value]
						end ,
[{"is", "=", "==", "eq"}] = function(t, key, value)
							if not t then return true end
							local n = table.get(t, key)
							for k, v in pairs(n) do
								if tostring(v) == value then
									return k, v
								end
							end
						end ,
}

function table.addquery(comps, fn)
	if type(comps) ~="table" then return end
	if type(fn) ~="function" then return end
	if not fn() then return end
	table.comps[comps] = fn
end

function table.query(t, cond)
	if not table.ismatrix(t) then return nil end

	cond = cond:qsplit("|")

	local key = cond[1]
	local comp = cond[2]
	local value = cond[3]

	local n = table.get(t, key)

	for k, v in pairs(table.comps) do
		if comp:inside(k) then
			return v(t, key, value, comp)
		end
	end

	return key, comp, value
end

--table.query("")
--[[--
_2d = {
	lee = {score = 1, rank = 3},
	joe = {score = 2, rank = 2},
	bob = {score = 5, rank = 1}
}
print(table.query(_2d, "score of lee"))
--]]--
--[[--
print("!Initial Values of test1d")
test1d = {a = 1, b=2, c=3, d = 3, 3, 2, 4, 2}
table.dump(test1d)

print("!Initial Values of sorted, which is test1d sorted via indices. Note the string keys are unsorted.")
sorted = table.ssort(test1d)
table.dump(sorted)

print("!Sorted using ssort to remove none-indices")
sorted = table.sort(test1d)
table.dump(sorted)

print("!The DIFF between test1d and sorted")
table.dump(table.diff(test1d, table.sort(test1d)))

print("!Inverted values of test1d")
test1d = table.invert(test1d)
table.dump(test1d)

print("!Inverted values of inverted values of test1d")
table.dump(table.invert(test1d, true))

print("!The DIFF between doubleinverted test1d and sorted")
table.dump(table.diff(table.invert(test1d, true), sorted))

print("!Inverted values of inverted values of test1d with smart keys")
test1d = table.invert(test1d)
table.dump(test1d)

print("!Initial Values of _2d matrix")
_2d = {
	lee = {score = 1, rank = 3},
	joe = {score = 2, rank = 2},
	bob = {score = 5, rank = 1}
}
table.dump(_2d)

print("!_2d with its keys stripped as 'name'")
_2d = table.stripkeys(_2d, "name")
table.dump(_2d)

print("!_2d with its 'score' column set as the keys")
_2d = table.setkey(_2d, "score", true)
table.dump(_2d)

print("!Returns a table of the values of column 'score'")
table.dump(table.get(_2d, "score"))

print("!Returns a table of the values of column 'rank'")
table.dump(table.get(_2d, "rank"))


--]]--
