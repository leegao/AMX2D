if not ReadLine then
	dofile("struct.lua")
end

if not table.dump then
	dofile("table.lua")
end

map = {
	code = "99856x63$160312%28176708",
	name = "de_dust",
	[2] = {},
	[1] = {},
	collision = {},
	maxx = 0,
	maxy = 0,
	vipspawn = {0, 0},
	vipescape = {},
	hostages = {},
	hostagecount = 0,
	resethostages = {},
	hostagerescure = {},
}

mapdir = "maps/"
mapheader = "Unreal Software's Counter-Strike 2D Map File"
mapcheck = 'ed.erawtfoslaernu'

function loadmap(mapname)
	map.name = mapname
	map.typ = 0
	mapc = io.open(mapname..".map")
	if not mapc then return print("Can Not Load File: "..mapname) end
	mapname = mapc:read(100)
	while true do
		local block = mapc:read(100)
		if not block then break end
		mapname = mapname..block
	end
	--mapname = mapc:read(2^13)
	mapc:close()
	maphd = ReadLine(mapname)
	--print(maphd)
	if maphd == mapheader then
		for i=1, 9, 1 do
			ReadByte(mapname)
		end
		for i=1, 10, 1 do
			ReadInt(mapname)
		end
		for i=1, 10, 1 do
			ReadLine(mapname)
		end
	elseif maphd == "Unreal Software's Counter-Strike 2D Map File (max)" then
		for i = 1, 10, 1 do
			ReadLine(mapname)
		end
	else
		return print("Wrong Map Header")
	end
	map.code = ReadLine(mapname)

	ReadLine(mapname)

	maptilesc_loaded = ReadByte(mapname)
	--print(maptilesc_loaded)
	maxx = ReadInt(mapname)
	maxy = ReadInt(mapname)
	--print(maptilesc_loaded, maxx, maxy)
	map.maxx = maxx
	map.maxy = maxy

	ReadLine(mapname)
    ReadInt(mapname)
    ReadInt(mapname)
    ReadByte(mapname)
    ReadByte(mapname)
    ReadByte(mapname)

	if not (ReadLine(mapname) == mapcheck) then
		return print("Wrong MapCheck")
	end
	tile_modes = {}
	n = 1
	for i = 1, maptilesc_loaded+1, 1 do
		tile_modes[i] = ReadByte(mapname)
		--print(tile_modes[i])

	end

	map.map = {}
	for i = 1, maxx+1, 1 do

		local cache = {}
		for o = 1, maxy+1, 1 do
			local bytecache = ReadByte(mapname)
			if n == 442 then
				print(#mapname)
				print(#s_get(mapname))
				print(ReadLine(mapname))
				return
			end
			--print(bytecache)
			if bytecache > maptilesc_loaded then
				--print(bytecache)
				bytecache = 0
			else
				bytecache = tile_modes[bytecache]
			end
			table.insert(cache, bytecache)
			n=n+1
		end
		table.insert(map.map, cache)
	end
	print(n)
	--table.dump(map.map)
	ec = ReadInt(mapname)
	--print(ec)
	print(s_get(mapname))
end

loadmap("../../../../maps/de_cs2d")
