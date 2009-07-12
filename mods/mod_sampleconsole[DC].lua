newMod("sampleconsole")

--Admin - Command "@parse"

function act_myserverinfo(p, x, cmd)
	print("Server Name: "..game("sv_name"))
	print("Max Players: "..game("sv_maxplayers"))
end

function act_healthlist(p, x, cmd)
	for i=1,32 do
		if (player(i,"exists")) then
			hp=player(i,"health")
			if (hp>90) then
				print("©000255000"..player(i,"name").." -> HP: "..hp)
			elseif (hp>60) then
				print("©255255000"..player(i,"name").." -> HP: "..hp)
			elseif (hp>30) then
				print("©255128000"..player(i,"name").." -> HP: "..hp)
			else
				print("©255000000"..player(i,"name").." -> HP: "..hp)
			end
		end
	end
end

return sampleconsole.name
