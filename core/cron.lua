init_mod("cron")

cron.queue = {}
cron.doNotSubscribe = {}
cron.subkeys = {}
cron.last = os.clock()
cron.interval = 1

function cron.add(_t, times)
	t = toTable(_t, false)
	local interval = tonumber(t[1])
	local _fn = loadstring(string.sub(_t, #t[1]+2))
	local once = false
	if times then once = true end
	if not (type(interval)=="number" and (type(_fn) == "function")) then return invalid() end
	table.insert(cron.queue, {time = os.time() + interval, interval = interval, fn = _fn, once = once, times = times, tostring = _t})
	print ("Cron Added: ".._t.." Once: "..tostring(once))
end

function cron.doNotSubscribeToHook(t)
	cron.doNotSubscribe["hook_"..t] = true
end

function cron.subscribe(h)
	if _G[h] then
		local k = patch(h, Cron)
		cron.subkeys[h] = k
		return true
	end
end

function cron.unsubscribe(h)
	if _G[h] then
		if cron.subkeys[h] then
			print(cron.subkeys[h])
			unpatch(h, cron.subkeys[h])
		else
			unpatch(h, Cron)
		end
	end
end

function cron.hooks()
	for k, v in pairs(_G) do
		local t = toTable(k, true)
		if t[1] == "hook" and not t[3] and not cron.doNotSubscribe[k] then
			cron.doNotSubscribe[k] = true
			patch(k, Cron)
		end
	end
end

function Cron()
	if not (os.time() >= cron.last) then return end
	cron.last = os.time() + cron.interval
	for k, v in pairs(cron.queue) do
		if os.time() >= v.time + v.interval then
			print("Cron Execution: "..v.tostring)
			v.time = os.time()
			v.fn()
			if v.once then
				cron.queue[k] = nil
			end
		end
	end
end


function hook_init_cron()
	cron.cfg = "cron"
	cron.loadcfg()
	addhook("second", "Cron")
end

toMod(cron.name)
