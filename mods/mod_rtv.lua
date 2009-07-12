init_mod("rtv")

rtv.var("toggle", 1, "svar")
rtv.var("players", {})
rtv.var("list", {})
rtv.var("totmaps", 0)
rtv.var("votable", 0)
rtv.var("men", "")
rtv.var("totrtv", 0)
rtv.var("totvotes", 0)
rtv.var("votemaps", {})
rtv.var("votes", {})
rtv.var("win", {})
rtv.var("totwin", 0)
rtv.var("totplayers",0)
rtv.var("maplist", 5)
rtv.var("voterate", .5)
rtv.var("checktime", 15)
rtv.var("votecolor", "©255255255")
rtv.var("votetext", 'hudtxt %s "%s%s %s" 200 %s 2')

function map(mc)
    parse("map "..mc)
    for i = 1,32 do
        rtv.players[i] = {vote = 0, rtv = 0}
    end
    rtv.votable = 0
    rtv.men = ""
    rtv.totrtv = 0
    rtv.totvotes = 0
    rtv.votemaps = {}
    for i = 1,9 do
        rtv.votes[i] = 0
    end
    rtv.win = {}
    rtv.totwin = 0
end

function checkexist()
    rtv.totplayers = 0
    for i = 1,32 do
        if player(i,"exists") then
            rtv.totplayers = rtv.totplayers + 1
        end
    end
end

function rtv.vote()
    local r = {}
    r[1] = 0
    rtv.men = "Votemaps"
    rtv.votemaps[1] = "Extend current map"
    rtv.men = rtv.men..","..rtv.votemaps[1]
    for i = 1,9 do
        rtv.votes[i] = 0
    end
    for i = 2,rtv.maplist+1 do
        local t = 0
        repeat
            t = 0
            r[i] = math.random(rtv.totmaps)
            for p = 2,rtv.maplist+1 do
                if r[i] == r[p] then
                    t = t + 1
                end
            end
        until t < 2
        rtv.votemaps[i] = rtv.list[r[i]]
        rtv.men = rtv.men..","..rtv.votemaps[i]
    end
    rtv.votable = 1
    rtv.hud()
    cron.add("30 rtv.voted()", 1)
end

function rtv.hud()
    local percent = ""
    parse(string.format(rtv.votetext, 1, rtv.votecolor, "Votemaps:", "", 160))
    parse(string.format(rtv.votetext, 2, rtv.votecolor, "Say /vote to vote", "", 100))
    for i = 1,rtv.maplist+1 do
        if rtv.totvotes == 0 then
            percent = ""
        else
            local cent = math.floor(100*rtv.votes[i]/rtv.totvotes)
            percent = "("..cent.."%)"
        end
        parse(string.format(rtv.votetext, i+2, rtv.votecolor, rtv.votemaps[i], percent, 180+20*i))
    end
end

function rtv.voted()
    if rtv.votable == 1 then
        for i = 1,rtv.maplist+3 do
            parse(string.format(rtv.votetext, i, "", "", "", 180+20*i))
        end
        msg("Voting over!")
        local r = {}
        for i = 1,9 do
            r[i] = 0
            for p = 1,9 do
                if rtv.votes[i] >= rtv.votes[p] then
                    r[i] = r[i] + 1
                end
            end
            if r[i] == 9 then
                rtv.totwin = rtv.totwin + 1
                rtv.win[rtv.totwin] = i
            end
        end
        if rtv.totwin == 1 then
            if not (rtv.win[1] == 1) then
                msg("Nextmap will be: "..rtv.votemaps[rtv.win[1]])
                msg("Mapchange in 10 seconds")
                cron.add("10  map(rtv.votemaps[rtv.win[1]])",1)
            else
                msg("Current map will be extended")
            end
        end
        if rtv.totwin > 1 then
            msg("Vote has resulted in a tie")
            msg("Nextmap will be randomly chosen out of tied maps")
            rtv.win[1] = rtv.win[math.random(rtv.totwin)]
            if not (rtv.win[1] == 1) then
                msg("Nextmap will be: "..rtv.votemaps[rtv.win[1]])
                msg("Mapchange in 10 seconds")
                cron.add("10  map(rtv.votemaps[rtv.win[1]])",1)
            else
                msg("Current map will be extended")
            end
        end
        if rtv.win[1] == 1 then
            for i = 1,32 do
                rtv.players[i] = {vote = 0, rtv = 0}
            end
            rtv.votable = 0
            rtv.men = ""
            rtv.totrtv = 0
            rtv.totvotes = 0
            rtv.votemaps = {}
            for i = 1,9 do
                rtv.votes[i] = 0
            end
            rtv.win = {}
            rtv.totwin = 0
        end
    end
end

function act_rtv(p, x, cmd)
    if rtv.toggle == 1 then
        if rtv.players[p]["rtv"] == 0 then
            rtv.players[p]["rtv"] = 1
            rtv.totrtv = rtv.totrtv + 1
            local r = math.floor(rtv.voterate*rtv.totplayers)
            if rtv.totrtv >= r then
                rtv.vote()
            else
                local u = r - rtv.totrtv
                msg(player(p,"name").." had rocked the vote")
                msg(tostring(u).." more players needed to rock the vote")
            end
        end
    end
end

function act_rockthevote(p, x, cmd)
    if rtv.toggle == 1 then
        if rtv.players[p]["rtv"] == 0 then
            rtv.players[p]["rtv"] = 1
            rtv.totrtv = rtv.totrtv + 1
            local r = math.floor(rtv.voterate*rtv.totplayers)
            if rtv.totrtv >= r then
                rtv.vote()
            else
                local u = r - rtv.totrtv
                msg(player(p,"name").." had rocked the vote")
                msg(tostring(u).." more players needed to rock the vote")
            end
        end
    end
end

function act_vote(p, x, cmd)
    if rtv.votable == 1 and rtv.players[p]["vote"] == 0 then
        menu(p,rtv.men)
    end
end

function adm_rtvtoggle_admin(p, x, cmd)
    cmd = tonumber(cmd)
    if not cmd then return invalid(p, x) end
    rtv.setvar("toggle", tonumber(cmd), true)
    if rtv.toggle < 0 then
        rtv.toggle = 0
    end
    if rtv.toggle > 1 then
        rtv.toggle = 1
    end
end

function adm_rtv_admin(p, x, cmd)
    msg("Vote has been rocked by Admin: "..player(p,"name"))
    rtv.vote()
end

function adm_rockthevote_admin(p, x, cmd)
    msg("Vote has been rocked by Admin: "..player(p,"name"))
    rtv.vote()
end

function hook_init_rtv()
    for i = 1,32 do
        rtv.players[i] = {vote = 0, rtv = 0}
    end
    for line in io.lines(conf_dir.."rtvlist.cfg") do
        local r = toTable(line)
        rtv.list[tonumber(r[1])] = r[2]
        rtv.totmaps = rtv.totmaps + 1
    end
    cron.add(rtv.checktime.." checkexist()")
end

function hook_join_rtv(p)
    rtv.totplayers = rtv.totplayers + 1
end

function hook_leave_rtv(p,r)
    rtv.totplayers = rtv.totplayers - 1
end

function hook_menu_rtv(p,t,b)
    if t == "Votemaps" then
        if b > 0 and b <= rtv.maplist + 1 then
            rtv.players[p]["vote"] = 1
            rtv.totvotes = rtv.totvotes + 1
            rtv.votes[b] = rtv.votes[b] + 1
            rtv.hud()
        end
    end
end

return rtv.name
