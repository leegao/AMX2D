newMod("sampleads")


function hook_join_ads(p, t)
	msg2(p,"Welcome on my Server, "..player(p,"name").."!")
end

function hook_init_ads(p, t)
	cron.add("60 msg(\"This server is powered by\");msg(\"www.UnrealSoftware.de & www.CS2D.com\")")
end

return sampleads.name
