position = {}

if not table.dump then
	dofile("table.lua")
end

if not string.split then
	dofile("string.lua")
end

function position.player(p)
	return math.vector(player(p, "x"), player(p, "y"))
end

function position.all()
	local tab = {}
	for i = 1, 32, 1 do
		if player(i, "exists") then
			tab[i] = position.player(i)
		end
	end
	return tab
end

function position.playertile(p)
	return math.vector(player(p, "tilex"), player(p, "tiley"))
end

function position.alltile()
	local tab = {}
	for i = 1, 32, 1 do
		if player(i, "exists") then
			tab[i] = position.playertile(i)
		end
	end
	return tab
end
--[[
function position.surround(vector)

end
--]]
function math.vector(x, y)
	if not (type(x) == "number" and type(y) == "number") then
		return {x = 0, y = 0, vector = false}
	end
	return {x = x, y = y, vector = true}
end

function math.polar(vector)
	if not isTable(vector) then return end
	if not vector.vector then
		if not isTable(vector) then
			return {r = 0, theta = 0, polar = false}
		end
		vector = math.vector(vector[1], vector[2])
		if not vector.vector then return {r = 0, theta = 0, polar = false} end
	end
	local r = (vector.x^2 + vector.y^2)^(1/2)
	local theta = math.atan(vector.y/vector.x)*(360/(2*math.pi))
	return {r = r, theta = theta, polar = true}
end

function math.polar_rad(vector)
	local polar = math.polar(vector)
	polar.radians = math.radian(polar.theta)
	return polar
end

function math.components(polar)
	if not isTable(polar) then return end
	if not polar.polar then return {x = 0, y = 0, vector = false} end
	local radians = math.radian(polar.theta)
	local x = polar.r*math.cos(radians)
	local y = polar.r*math.sin(radians)
	return math.vector(x, y)
end

function math.resolve(vector)
	return math.polar(vector)
end

function math.radian(degrees)
	if type(degrees) ~= "number" then
		return 0
	end
	return degrees*(2*math.pi/360)
end

function math.degree(radians)
	if type(radians) ~= "number" then
		return 0
	end
	return radians*(2*math.pi/360)^(-1)
end

function math.round(n, df)
	if type(n) ~= "number" then return 0 end
	if not df then df = 3 end
	local n = tostring(n)
	n = string.split(n, ".")
	local n1 = tonumber(n[1])
	local n2 = n[2]
	if not n2 then return n1 end
	n = string.sub(n2, 1, df)
	if #n > 0 then n1 = n1 + tonumber("0."..n) end

	n = tonumber(string.sub(n2, df+1, df+1))
	if n then
		if n >= 5 then
			n1 = n1 + 10^(-df)
		end
	end
	return n1
end

function math.vectorequal(v1, v2)
	if not (isTable(v1) and isTable(v2)) then return false end
	if not (v1.vector and v2.vector) then return true end
	if table.equal(v1, v2) then return true end
end

function math.vectoradd(v1, v2)
	if not (isTable(v1) and isTable(v2)) then return false end
	if not (v1.vector and v2.vector) then return true end

	return math.vector(v1.x+v2.x, v1.y+v2.y)
end

function math.surround(vector)
	if not isTable(vector) then return end
	if vector.polar then vector = math.components(vector) end
	if not vector.vector then return end
	local North = math.vectoradd(vector, math.vector(0, 1))
	local NorthEast = math.vectoradd(vector, math.vector(1, 1))
	local East = math.vectoradd(vector, math.vector(1, 0))
	local SouthEast = math.vectoradd(vector, math.vector(1, -1))
	local South = math.vectoradd(vector, math.vector(0, -1))
	local SouthWest = math.vectoradd(vector, math.vector(-1, -1))
	local West = math.vectoradd(vector, math.vector(-1, 0))
	local NorthWest = math.vectoradd(vector, math.vector(-1, 1))

	return {North = North, NorthEast = NorthEast, East = East, SouthEast = SouthEast, South = South, SouthWest = SouthWest, West = West, NorthWest = NorthWest, Vector = vector}
end

function math.overlap(vector)
	local r1 = math.surround(vector)
	local r2 = math.surround(r1.North)
	r1 = table.invert(r1, true)
	r2 = table.invert(r2, true)
	local x = table.diff(r1, r2)
	r1 = table.invert(r1, true)
	r2 = table.invert(r2, true)
	--x = table.invert(x, true)
	return r1, r2, x
end

--[[
ro = math.vector(10, 12)
table.dump(ro)
ro = math.resolve(ro)
table.dump(ro)
ro = math.components(ro)
table.dump(ro)


r1, r2, x = math.overlap(ro)
table.dump(x)
--]]
