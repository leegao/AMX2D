init_mod("mute")
mute.var("toggle", 0, "cvar")

adm_mute_admin = adm_mutetoggle_admin

function say_mute(p, t)
    if mute.toggle == 1 then
        msg2(p, Color(255, 255, 255), player(p, "name").."(muted): "..t)
        return 1
    end
end

function mute.ret(mute, old)
	-- Only if say_mute = 1 do we return 1
	if mute == 1 then return mute end
	-- Since mute ~= 1 at this point, we return whatever the other say functions return

	--Note This patch(fnname, patchfn, before?, returnFn) can only be patched once per function.
	return old
end

patch("hook_say", say_mute, after, mute.ret) -- after = nil == false

return mute.name
