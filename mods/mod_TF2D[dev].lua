init_mod("tf")

--Classes
tf.var("classes", {"Scout","Soldier","Pyro","Demoman","Heavy","Engineer","Sniper","Spy","Doctor"})
--Defaults
tf.buy(0)
tf.collect(0)
tf.drop(0)
tf.players = initArray(32, false)
--Global Scope
classmenu = newMenu("Select Your Class", "classmenu", tf.classes)

--TF Classes Functionality - Called After Spawn.
function tf.Scout(p)
	parse(string.format("speedmod %s 15", p))
end

function tf.Soldier(p)

end

function tf.Pyro(p)

end

function tf.Demoman(p)

end

function tf.Heavy(p)

end

function tf.Engineer(p)

end

function tf.Sniper(p)

end

function tf.Spy(p)

end

function tf.Doctor(p)

end

--Menu Action
function menu_classmenu(p, sel)
	tf.players[p] = tf.classes[sel]
	tf[tf.classes[sel]](p)
	msg(string.format("Player %s is now a %s@C", player(p, "name"), tf.classes[sel]))
end

--Acts
function act_tf(p, typ, cmd)
	msg2(p, Color(225, 0, 0), "The TF2D Mode will try to recreate the TF2 Experience in CS2D", false)
end

function act_tfclasses(p, typ, cmd)
	msg2(p, Color(0, 255, 0), "Please Choose Your Class", true)
	classmenu.show(p)
end

function act_tfcolortest(p, typ, cmd)
	print(Color(0, 0, 0).."TFColorTest")
end

--Hooks
function hook_spawn_tf(p)
	if not tf.players[p] then return classmenu.show(p) end
	return tf[tf.players[p]](p)
end

function hook_leave_tf(p)
	tf.players[p] = false
end


--Init
function hook_init_tf(p, team)

end

return tf.name
