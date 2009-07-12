init_mod("cron")
cron.queue = {}
cron.doNotSubscribe = {}
cron.subkeys = {}
cron.last = os.clock()
cron.interval = 1

function cron.add(_t, times)

	t = toTable(_t, false)
	local interval = tonumber(t[1])
	--print(string.sub(_t, #t[1]+2))

	local _fn = loadstring(string.sub(_t, #t[1]+2))
	--print(interval, _fn, times)
	--print(string.sub(_t, #t[1]+2))
	--print(type(_fn) == "function")
	--times = tonumber(times)
	--print(times)
	if not times then local once = false end
	if not (type(interval)=="number" and (type(_fn) == "function")) then return invalid() end
	table.insert(cron.queue, {time = os.clock() + interval, interval = interval, fn = _fn, once = once, times = times})
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
		--print(k)
		local t = toTable(k, true)
		if t[1] == "hook" and not t[3] and not cron.doNotSubscribe[k] then

			cron.doNotSubscribe[k] = true
			patch(k, Cron)
		end
	end
end

function Cron()
	--print("Cron")
	--if not (os.clock() >= cron.last) then return end
	cron.last = os.clock() + cron.interval
	for k, v in pairs(cron.queue) do
		if os.clock() > v.time then
			local stop = true
			while stop do
				stop = false
				v.time = v.time + v.interval
				v.fn()
				if not v.once then
					if v.times then
						v.times = v.times - 1
						if v.times <= 1 then v.once = true end
					end
					if not (v.time >= os.clock()) then stop = true end
				else
					cron.queue[k] = nil
					stop = false
				end
			end
		end
	end
end


function hook_init_cron()
	cron.cfg = "cron"
	cron.loadcfg()
	--cron.hooks()
	addhook("second", "Cron")
end

return cron.name
