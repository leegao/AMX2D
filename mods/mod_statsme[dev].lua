--Initialize mod_statsme.lua
init_mod("sm")
sm.var("cats", {})
sm.var("stime", {})
sm.var("specialKill", {})
--Global
stats = {}
ranks = {}
--statsme Functions
function sm.new(t)
	for i, v in ipairs(sm.cats) do
		if not stats[t] then stats[t] = {} end
		if i == 1 then
			stats[t][v] = t
		else
			stats[t][v] = 0
		end
	end

	table.insert(ranks, {username = t, score = stats[t].score})
	stats[t].rank = #ranks
	sm.stime[t] = os.time()
end

function sm.updateall()
	for k, v in pairs(playeruid) do
		--print(k)
		--print(stats[k])
		if not stats[k] then sm.new(k) end
		if not v.rtime then return invalid() end
		stats[k].timeplayed = os.time() - v.rtime + v.time
	end
	sm.dump()
end

function sm.newParse(p, typ, cmd)
	print(cmd)
	t = toTable(cmd)
	print(t[1])
	if t[1] then
		sm.new(t[1])
	end
end

function sm.dump()
	local s = ""
	for i, t in ipairs(sm.cats) do
		s = s..t.." "
	end
	s = s.."\n"
	for u, v in pairs(stats) do
		for i, t in ipairs(sm.cats) do
			s = s..stats[u][t].." "
		end
		s = s.."\n"
	end
	local f = io.open(sm.dir.."stats/stats.txt", "w+")
	f:write(s)
	f:close()
	s = ""
	for i, v in ipairs(ranks) do
		s = s..v.username.." "..v.score.."\n"
	end
	f = io.open(sm.dir.."stats/rank.txt", "w+")
	f:write(s)
	f:close()

end

function sm.score(p, n, b)
	if not tonumber(n) then return invalid() end
	if not admins[p] then return invalid() end
	if not stats[playeruid[p]] then sm.new(playeruid[p]) end
	sm.update2(p, "score", n+stats[playeruid[p]].score)
	if b then msg2(p, "You have earned "..n.." points") end
	ranks[stats[playeruid[p]].rank].score = stats[playeruid[p]].score
	sm.rankSort(playeruid[p])
end

function sm.rankup(t)
	local rank = stats[t].rank
	if not ranks[rank-1] then return true end
	--print("true")
	if ranks[rank-1].score < ranks[rank].score then
		local _r = ranks[rank-1]
		ranks[rank-1] = ranks[rank]
		ranks[rank] = _r
		stats[t].rank=rank-1
		stats[_r.username].rank = rank
		msg2(userpid[t], "You have ranked up to #"..(rank-1).." out of "..#ranks.." users")
		msg2(userpid[_r.username], "You have ranked down to #"..(rank).." out of "..#ranks.." users")
	else
		return true
	end
end

function sm.rankdown(t)
	local rank = stats[t].rank
	if not ranks[rank+1] then return true end
	if ranks[rank+1].score > ranks[rank].score then
		local _r = ranks[rank+1]
		ranks[rank+1] = ranks[rank]
		ranks[rank] = _r
		stats[t].rank = rank+1
		stats[_r.username].rank = rank
		--print(userpid[t], "You have ranked down to "..(rank+1))
		--print(userpid[_r.username], "You have ranked up to "..(rank))
	else
		return true
	end
end

function sm.rankSort(t)
	while not sm.rankup(t) do

	end

	while not sm.rankdown(t) do

	end
end

function sm.updateTime(t)
	if not stats[t] then return end
	stats[t].timeplayed = stats[t].timeplayed + math.ceil(os.time() - sm.stime[t])
end

function sm.update2(p, k, v)
	if not playeruid[p] then return invalid() end
	if not stats[playeruid[p]] then sm.new(playeruid[p]) end
	if not stats[playeruid[p]][k] then return invalid(p, k, "Couldn't update your stats - Wrong Category") end
	stats[playeruid[p]][k] = v
	sm.updateTime(playeruid[p])
	--sm.dump()
	return true
end

function sm.update(t, k, v)
	if not userpid[t] then return invalid() end
	if not stats[t] then sm.new(t) end
	if not stats[t][k] then return invalid(userpid[t], k, "Couldn't update your stats - Wrong Category") end
	stats[t][k] = v
	sm.updateTime(t)
	--sm.dump()
	return true
end

function sm.add(p, k, x)
	local username, b = sm.check(p)
	if not username then return invalid() end
	v = stats[username][k]
	if not v then return invalid() end
	sm.update(username, k, v+x)
end

function sm.check(p, cmd)
	if not tonumber(cmd) then cmd = p else cmd = tonumber(cmd) end
	if not playeruid[cmd] then return invalid(p, 1, "Player is not logged in") end
	local username = playeruid[cmd]
	sm.updateTime(username)
	if not stats[username] then sm.new(username) end
	return username, p == cmd
end

--Acts
function act_rawstats(p, typ, cmd)

	local username, b = sm.check(p, cmd)
	if not username then return invalid() end
	local s = ""
	for i, v in ipairs(sm.cats) do
		s = s..v..": "..stats[username][v].." "
	end
	msg2(p, s)
end

function act_rank(p, typ, cmd)
	local username, b = sm.check(p, cmd)
	if not username then return invalid() end
	if not b then
		if not player(tonumber(cmd), "name") then return invalid(p, typ, "Player ID is not valid") end
		msg2(p, player(tonumber(cmd), "name").." (\'"..username.."\') is ranked #"..stats[username].rank.." out of "..#ranks.." users")

	else
		msg2(p, "You are ranked #"..stats[username].rank.." out of "..#ranks.." users")
	end
end



--Hooks
function hook_init_sm()
	sm.cfg = "stats"
	sm.loadcfg()

	local first = true
	for line in io.lines(sm.dir.."stats/stats.txt") do
		local _stat = toTable(line)
		if first then
			for i, v in ipairs(_stat) do
				table.insert(sm.cats, v)
			end
			first = false
		else
			for i, v in ipairs(sm.cats) do
				if not stats[_stat[1]] then stats[_stat[1]] = {} end
				if tonumber(_stat[i]) then _stat[i] = tonumber(_stat[i]) end
				stats[_stat[1]][v] = _stat[i]
			end
			table.insert(ranks,stats[_stat[1]].rank,{username = _stat[1], score = stats[_stat[1]].score})
			sm.stime[_stat[1]] = os.time()
		end

	end
	--print("Patching SM")
	patch("act_register", sm.newParse)
	--print(stats["admin"].kills)
	cron.add("30 msg(\"StatsMe mod made using the AMX2D System\");")
	cron.add("30 sm.updateall()")
end


function hook_kill_sm(k, v, w)
	local _score = sm.normalKill
	if sm.specialKill[wpn[w]] then
		_score = sm.specialKill[wpn[w]]
	end
	sm.score(k, _score, true)
	sm.add(k, "kills", 1)
	sm.score(v, sm.deathRatio*_score, true)
	sm.add(v, "deaths", 1)

end


return sm.name
