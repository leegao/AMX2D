menus = {}

_menu = menu

function menu(p, t)
	t = trim(t)

	local tab = toTable(t, ",")
	local title = tab[1]
	title = toTable(title, "-=-")[1]
	title = trim(title)
	local str = string.sub(t, #tab[1]+2)
	if not menus[title] then
		local menuname = tostring(title, "")
		if not _G[menuname] then
		_G[menuname] = newMenu(title, menuname, str)
		end
	end
	_menu(p, t)
end

function newMenu(title, menuname, items, cmd)
	local tab = {}
	if not menuname then return invalid() end
	if not _G[menuname] then _G[menuname] = {} end
	if not title then title = "" end
	menus[title] = {var = menuname}
	if cmd then tab.cmd = cmd end
	tab.title = title
	tab.page = 0
	tab.toString = title..""
	tab.lastid = 0
	tab.items = {}
	tab.var = menuname
	tab.add = function (items)
					items = tostring(items)
					if not items then return end
					for item in string.gmatch(items, "[^,]+") do
						item = trim(item)
						tab.lastid = tab.lastid+1
						tab.toString = tab.toString .. ", "..item
						item = split(item, "|")[1]
						table.insert(menus[title], item)
						if tab.id[item] then
							if type(tab.id[item]) == "number" then
								tab.id[item] = {tab.id[item]}
							end
							table.insert(tab.id[item], tab.lastid)
						else
							tab.id[item] = tab.lastid
						end
						tab.items[tab.lastid] = item
					end
				end
	tab.show = function(p, page)
					local tostr = tab.toString
					local tostrT = toTable(tostr, ",")
					if not page then page = tab.page end
					if #items > 9 then
						tostr = tab.title.." -=- Page "..(page+1)..", prev, "
						for i = 1, 7, 1 do
							if not tostrT[page*7 + i + 1] then break end
							tostr = tostr .. tostrT[page*7 + i + 1] .. ", "
						end
						tostr = tostr .. "next"
					end
					menu(p, tostr)
				end
	tab.next = function(p)
					local num = #tab.items
					local r = num%7
					local _num = num - r
					local pages = _num/7
					if tab.page >= pages then return nil end
					tab.page = tab.page + 1
					cron.add(string.format("1 %s.show(%s)", tab.var, p), 1)
				end
	tab.prev = function(p)
					if tab.page <= 0 then return nil end
					tab.page = tab.page - 1
					tab.show(p)
					cron.add(string.format("1 %s.show(%s)", tab.var, p), 1)
				end
	tab.id = {}
	tab.add(items)
	return tab
end
addhook("menu", "hook_menu_init")
function hook_menu_init(p, title, selection)
	if not selection then return end
	title = toTable(title, "-=-")[1]
	title = trim(title)
	local _menu = _G[menus[title].var]
	if #_menu.items > 9 then
		if selection == 9 then
			_menu.next(p)
			msg2(p, "Please wait a second")
			return
		elseif selection == 1 then
			msg2(p, "Please wait a second")
			_menu.prev(p)
			return
		elseif selection then
			selection = _menu.page*7 + (selection-1)
			_menu.page = 0
		end
	end
	local strmenu = "menu_"..menus[title].var
	if type(_G[strmenu]) == "function" then
		_G[strmenu](p, selection)
	end
	local strmenusel = strmenu .. "_"..menus[title][selection]
	if type(_G[strmenusel]) == "function" then
		_G[strmenusel](p, selection)
	end
	local selids = _G[menus[title].var].id[menus[title][selection]]
	if type(selids) == "table" then
		for i, v in ipairs(selids) do
			if selection == v then
				if type(_G[strmenusel.."_"..i]) == "function" then
					_G[strmenusel.."_"..i](p, sel)
				end
			end
		end
	end
end
