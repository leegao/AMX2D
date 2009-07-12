init_mod("menupage")

function act_menupage(p, x, cmd)
	menupagemenu1.show(p)
end

function menu2(p)
	menu(p, "OMG, omg, omg, omg, omg")
end

function menu_menupagemenu1_1(p)
	msg("selected 1")
end

function menu_menupagemenu1_2(p)
	msg("Selected 2 - This will call the default menu constructor and then create the same menu in AMX2D Menu.")
	menu2(p)
	msg(OMG.toString)
end

function menu_menupagemenu1_10(p)
	msg("selected 10")
end

function hook_init_menupage(p, t)
	menupagemenu1 = newMenu("Some menu", "menupagemenu1", {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"})
end

return menupage.name
