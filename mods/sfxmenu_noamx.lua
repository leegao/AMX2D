--@Usage : !sfx or !sfx Sound Name
--Global Namespace--
sfx = {}

--Sounds - Taken from sample/sayfunctions.lua
sfx.sounds = {"The Way", "let's go", "zombies", "mystery"}
--Sound Files - Must match the elements from sfx.sounds in the same order.
sfx.files = {"fun/thats_the_way.wav", "hostage/hos2.wav", "player/zm_spray.wav", "env/mystery.wav"}

--[[--
@NOTE: There's a more intuitive way of doing this by using just sfx.sounds
as a key-value table but it'll require a bit more work.
--]]--

function sfx.play(sound)
	--Sound is a number
	--This will produce a string that will look like
	--sv_sound "fun/thats_the_way.wav"
	parse(string.format('sv_sound "%s"', sfx.files[sound]))
end

addhook("menu", "sfx.menu")
function sfx.menu(p, title, sel)
	if title == "Sounds" then
		--If we're dealing with the sound menu
		if sel <= #sfx.files then
			--#sfx.files = the number of elements inside the table sfx.files
			--In this case it is 4
			sfx.play(sel)
		end
	end
end

addhook("say","sfx.say")
function sfx.say(p,txt)
	txt = txt:trim() -- Get rid of leading spaces that can cause parser problems
	--Use the string.split() statement to seperate text by the spaces
	--We're looking for "!sfx Name" or just "!sfx"
    local cmd = txt:split()
	--cmd = {[1] = "!sfx", [2] = "soundName" or nil}
	if cmd[1] == "!sfx" then
		local sound = txt:sub(#cmd[1]+2) -- "soundName" or nil
		if not cmd[2] then
			-- If no name is given to play, just go ahead and display the menu
			menu(p, "Sounds"..string.join(sfx.sounds)) -- string.join will turn a table into a string with the menu format.
			--[[--
			print(string.join(sfx.sounds))
			OutPut:
			The Way,let's go,zombies,mystery
			--]]--
		else
			sound = sound:trim() -- Trims sound. Note: We must do this here because if sound is nil then it returns will return an error.
			if table.find(sfx.sounds, sound) then
				--table.find will find the first occurence of the sound in sfx.sound table
				--If it's not in the table then it will return a null value - nil
				sfx.play(table.find(sfx.sounds, sound))
			else
				--table.find returns nil, prints a message to the user.
				msg2(p, "This sound is not installed.")
			end
		end
		return 2 -- Do not display the text.
	end
end

--initArray--
function initArray(i, x)
     local array = {}
	 --if (array == nil) then array = {} end
     if (x == nil) then x = 0 end
     for m = 1 , i do
          if (array[m] == nil) then
               array[m] = x
          end
     end
     return array
end

if not string.split then
	function string.split(t, d)
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

	function string.join(t, n, d)
		local s = ""
		if (n == nil) then n = 1 end
		if not d then d = "," end
		while (n <= #t) do
			s = s .. t[n] .. "".. d
			n = n + 1
		end
		s = string.sub(s, 1, #s-#d)
		return s
	end

	function table.find(t, o)
		for k, v in pairs(t) do
			if v == o then
				return k
			end
		end
	end
end

