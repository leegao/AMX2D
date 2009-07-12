init_mod("adsp")
adsp.var("ads", "")
adsp.var("starttext", {})
function hook_init_adsp()
	adsp.cfg = "advertisement"
	adsp.loadcfg()
end

function adsp.ads(t, i, o)
	if not i then return end
	local fn =  string.format("cron.add('%s msg(\"%s\")')", i, t)
	if type(o) == "number" then
		cron.add(string.format("%s %s", o, fn), true)
	else
		local f = loadstring(fn)
		if f then f() end
	end

end

function adsp.start(t)
	table.insert(adsp.starttext,t)
end

function hook_join_adsp(p)
	for i, v in ipairs(adsp.starttext) do
		msg2(p,v)
	end
end

return adsp.name
