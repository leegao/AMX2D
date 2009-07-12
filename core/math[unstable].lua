if not table.split then dofile("table.lua") end

operators = {}

function math.parse(t, i)
    if not i then i = 1 end

    local open = string.find(t, "[\(]", i)
    if not open then return nil end

    local close = string.find(t, "[\)]", open)

    if not close then return nil end

    local nextopen = string.find(t, "[\(]", open+1)
    if nextopen then
        open, close = math.parse(t, nextopen)
    end
    --print(t)
    return open, close
end

function math.replace(t, op)
    local open, close = math.parse(t)
    if not open then return nil end
    table.insert(op,{text= t:sub(open+1, close-1), var = "&"..#op+1})
    t = t:sub(1, open-1).."&"..#op..t:sub(close+1)
    return t, op
end

function math._eval(t)
    t = "("..t..")"
	local op = {}
    t, op = math.replace(t, op)
    while t do t = math.replace(t, op) end
	return op, #op
end

math.var = {}

function math.eval(exp, oop)
	local op, n = math._eval(exp)
	if not oop then oop = op end
	local exp = op[n].text



	while string.find(exp, "&%d+") do
		local o, c = string.find(exp, "&%d+")
		local _n = tonumber(string.sub(exp, o+1, c))


		local s = math.eval(oop[_n].text, oop)
		exp = string.sub(exp, 1, o-1)..s..string.sub(exp, c+1)
	end


	if math.isEvaluable(exp) then
		local _exp = loadstring("return "..exp)
		if not _exp then print("EXP: "..exp); _exp = exp else exp = _exp() end
	else
		exp = "("..exp..")"
	end

	return exp
end

function math.isEvaluable(exp)
	if string.find(exp, "%a+") then return false end
	return true
end

function out(op)
    for i, v in ipairs(op) do
        print(v.var.." = "..v.text)
    end
end

