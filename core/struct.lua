--**********************--
--**********************--
--****-=Struct.lua=-****--
--**********************--
--**********************--
--*****************************************--
--This is a port of 3rr0r's bb_udp.py******--
--Note, lua does not have native support***--
--for C styled Data Structure packing******--
--so the packing logic have to be rewritten--
--*****************************************--

--[[

**Author: Lee Gao
**Website: http://tgvserver.info
**Title: Struct.lua
**Description: This is a tool to treat data as
a stream and uses pointers to traverse the "stream"
This is a port of the standard library developed by
3rr0r which was used in the development of his dedicated
servers.

--]]

--Initialization--
readcount = {}

--Utility Functions
function isIn(t, a)
	for i,v in ipairs(a) do
		if v == t then return true end
	end
end

function s_delStream(t)
	if readcount[t] then
		readcount[t] = nil
	end
end

function s_get(t)
	if readcount[t] then
		return string.sub(t,readcount[t])
	else
		readcount[t] = 1
		return t
	end
end

function s_update(t, ln)
	readcount[t] = readcount[t] + ln
	if readcount[t] > #t then
		readcount[t] = 1
	end
end

function getByte(t)
	local t_ = {}
	for i = 1, #t, 1 do
		table.insert(t_, string.byte(t,i))
	end
	return t_
end

function isByte(n)
	for i, v in ipairs(n) do
		if v > 255 then return false end
	end
	return true
end



--Write Functions--

function WriteByte(p)
	if p > 255 then p = 255 elseif p < 0 then p = 0 end
	return(string.char(p))
end

function WriteShort(p)
	local b1 = p%256
	local b2 = (p-b1)/256
	--[[
	Concept: A short is 2 bytes, the first byte denotes the lower
	255 bytes and the 2nd denotes the upper 255^2 bytes.
	]]
	if not isByte({b1, b2}) then
		return string.char(255)..string.char(255)
	else
		return(string.char(b1)..string.char(b2))
	end
end

function WriteInt(p)
	local b1 = p%256
	local p2 = (p-b1)/256
	local b2 = p2%256
	local p3 = (p2-b2)/256
	local b3 = p3%256
	local b4 = (p3-b3)/256
	--[[
	Concept: Similar to short, but instead of 2 bytes,
	there are 4 bytes. The 1st byte denotes the lower
	255 bytes and the 2nd denotes the 255^2 bytes, the
	3rd denotes the 255^3 bytes and the 4th denotes the
	255^4
	]]
	if not isByte({b1, b2, b3, b4}) then
		return string.char(255)..string.char(255)..string.char(255)..string.char(255)
	end
	return(string.char(b1)..string.char(b2)..string.char(b3)..string.char(b4))
end

function WriteLine(t)
	return(t..string.char(13)..string.char(10))
end

function WriteString(t)
	return(WriteByte(#t)..t)
end

--Read Functions--

function ReadByte(t)
	local stream = s_get(t)
	local byte = getByte(stream)[1]
	s_update(t, 1)
	return byte
end

function ReadShort(t)
	local stream = s_get(t)
	local b1 = getByte(stream)[1]
	local b2 = getByte(stream)[2]
	s_update(t, 2)
	return b2*256+b1
end

function ReadInt(t)
	local stream = s_get(t)
	local b1 = getByte(stream)[1]
	local b2 = getByte(stream)[2]
	local b3 = getByte(stream)[3]
	local b4 = getByte(stream)[4]
	s_update(t, 4)
	return b2*256+b1+b3*256*256+b4*256*256*256
end

function ReadLine(t)
	s = s_get(t)
	if string.find(s, "\n") then
		i = string.find(s,"\n")
		x = string.find(s, string.char(13))
		if x then
			s = string.sub(s, 1, i-1)
		else
			s = string.sub(s, 1, i-1)
		end
		s_update(t, i)

		return s
	else
		s_update(t, #s)
		return s
	end
end

function ReadString(t,n)
	if not n then
		n = ReadByte(t)
	end

	s = s_get(t)
	s = string.sub(s,1,n)
	s_update(t, n)
	return s
end
