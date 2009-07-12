function user_init()
	for line in io.lines(conf_dir.."users.cfg") do
		if #line > 0 then
			local tempUser = {}
			for word in string.gmatch(line, "%w+") do
				table.insert(tempUser, word)
			end
			if not tempUser[4] then
				tempUser[4] = "user"
			end
			users[tempUser[2]] = {id = tempUser[1], password=tempUser[3], privilege = tempUser[4], time = tempUser[5], stime = tempUser[6], usgn = tempUser[7]}
			lastUser = lastUser+1
		end
	end

	for line in io.lines(conf_dir.."priv.cfg") do
		if #line > 0 then
			table.insert(priv, line)
		end
	end

end

function adminhierarchy(t)
	local tab = {}
	for i, v in ipairs(priv) do
		if v == t then
			table.insert(tab, v)
			break
		end
		table.insert(tab, v)
	end

	return tab
end

