csstats = {}

if not WriteLine then
	dofile("struct.lua")
end

if not digits then
	dofile("utilities.lua")
end

local path = "../../../stats/"

function csstats.path()
	return path.."userstats.dat"
end

function csstats.read()
	local file = io.open(csstats.path(), "r")
	csstats.file = file:read("*all")
	file:close()
end

csstats.read()

function string.lines(t)
	local i = 1
	local n = 0
	while t:find("\n", i) do
		--print(i)
		n = n+1
		i = t:find("\n", i)+2
	end
	return n, i
end

function csstats.parse()
	local filelen = csstats.file:lines()
	print(filelen)
	print(#csstats.file)
end

csstats.parse()

--print(string.lines("adfsdaf\nasd\n"))
--print(csstats.file:lines())
