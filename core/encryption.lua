encryption = {}

if not WriteLine then
	dofile("struct.lua")
end

if not digits then
	dofile("utilities.lua")
end

--ReadByte and digits.

function encryption.load()
	local fn = loadstring(encryption.coredecode())
	if fn then fn() end
end

function encryption.binaryencode(file)
	local f = io.open(file)
	local file = f:read("*all")
	f:close()
	math.randomseed(os.time())
	local rand = math.random(1, 50)
	local x = WriteLine(WriteByte(rand))
	for i = 1, #file, 1 do
		x = x..WriteByte(ReadByte(file)+rand)
	end

	s_delStream(x)

	return x
end

function encryption.binarydecode(x)
	local rand = ReadByte(ReadLine(x))
	local dec = ""
	for i = 1, #s_get(x), 1 do
		local chr = ReadByte(x)-rand
		dec = dec .. WriteByte(chr)
	end

	s_delStream(x)

	return dec
end

function encryption.coredecode()
	local file = io.open("encryption.core")
	local f = file:read("*all")
	file:close()
	return encryption.binarydecode(f)
end

function encryption.encrypt(file)
	--local _f = file
	--local f = io.open(file, "r")
	--file = f:read("*all")
	--f:close()

	local x = encryption.toenc(file)

	s_delStream(file)

	--local f = io.open(_f..".enc", "w+")
	--f:write(x)

	--f:close()

	return x
end

function encryption.decrypt(file)
	--local _f = file

	--local f = io.open(file..".enc", "r")
	--if not f then
		--file = encryption.encrypt(file)
	--else
		--file = f:read("*all")
		--f:close()
	--end
	local x = encryption.todec(file)

	--local f = io.open(_f..".dec", "w+")

	s_delStream(file)

	--f:write(x)
	--f:close()
	return x
end

encryption.load()
