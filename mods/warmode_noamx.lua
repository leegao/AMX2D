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
--Global--
sample.warmode.players = initArray(32)

addhook("say","sample.warmode.say")
function sample.warmode.say(p,txt)
    if(txt=="!ready") then
		msg(player(p, "name").." is ready! ");
		sample.warmode.players[p] = 1
	end
end

init_mod("warmode")
warmode.var("players", initArray(32)

function act_ready(p, x, cmd)
	msg(player(p, "name").."is ready!")
	warmode.players[p] = 1
end

return warmode.name
