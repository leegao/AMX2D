if not toTable then
	dofile("utilities.lua")
end
function string.join(t, d)
	if not (type(t) == "table") then return end
	return tostring(t, d)
end

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
	if not t then return invalid() end
	for word in string.gmatch(t, match) do
		table.insert(cmd, word)
	end
	return cmd
end

function string.capitalize(t)
	local str = string.split(t)
	for i, word in ipairs(str) do
		local eword = string.sub(word, 2)
		local bword = string.upper(string.sub(word, 1, 1))
		str[i] = bword..eword
	end
	return tostring(str, " ")
end

function string.letters(t)
	local letters = {}
	for word in string.gmatch(t, ".") do
		table.insert(letters, word)
	end
	return letters
end

function string.word(t, sub)
	local str = string.split(t)
	sub = trim(sub)
	local tab = {}
	for i, word in ipairs(str) do
		if word == sub then
			table.insert(tab, i)
		end
	end
	return tab
end

function string.index(t, sub)
	local str = string.letters(t)
	local n = #sub
	local tab = {}
	for i, letter in ipairs(str) do
		if letter == string.sub(sub, 1, 1) then
			local _let = letter
			for _i = 1, n-1, 1 do
				if not str[_i+i] == string.sub(sub, _i, _i) then break end
				_let = _let .. str[_i+i]
			end
			if _let == sub then
				table.insert(tab, i)
			end
		end
	end
	return tab
end

function string.translate(t, d)
	if not (type(d) == "table") then d = split(d) end
	for i, v in ipairs(d) do
		d[tostring(v)] = true
	end
	local str = string.letters(t)
	local _t = ""
	for i, letter in ipairs(str) do
		if not d[letter] then
			_t = _t..letter
		end
	end
	return _t
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
