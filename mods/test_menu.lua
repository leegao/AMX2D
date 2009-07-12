init_mod("modmenu")

function act_menutest(p, x, cmd)
	menu1.show(p)
end

function act_menutest2(p, x, cmd)
	menu2.show(p)
end

function menu_menu1(p, sel)
	print("Selection: "..menu1.items[sel])
end

function menu_menu1_a(p)
	print (player(p, "name") .." chose choice A")
end

function menu_menu1_as_1(p)
	print (player(p, "name") .." chose choice first AS")
end

function menu_menu1_as_2(p)
	print (player(p, "name") .." chose choice second AS")
end

function menu_menu1_c(p)
	print ("You chose C, regardless of the order.")
end

function menu_menu1_c_1(p)
	print ("You chose first C")
end
function menu_menu1_c_2(p)
	print ("You chose second C")
end

function menu_menu2(p, sel)
	print("Menu 2 is used by player "..player(p, "name").." and he has selected "..menu2.items[sel])
end

function hook_init_modmenu(p, t)
	menu1 = newMenu("Some menu", "menu1", {"as", "as", "asdfda", "oO"})
	menu1.add({"a", "b"})
	menu1.add("c")
	menu1.add({"c"})
	menu2 = newMenu("Another menu", "menu2", "Item 1, Item 2, Item 3, Item 4")
end

return modmenu.name
