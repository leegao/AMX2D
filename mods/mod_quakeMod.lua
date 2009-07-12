--------------------------------------------------
-- UT+Quake Sounds Script by Unreal Software --
-- 22.02.2009 - www.UnrealSoftware.de --
-- Adds UT and Quake Sounds to your Server --
--------------------------------------------------
--** Ported By Lee Gao: http://tgvserver.info **--
init_mod("quakeMod")

--***********--
--*Variables*--
--***********--

quakeMod.var("sound" ,"fun")
quakeMod.var("timeout" , 3)
quakeMod.var("timer", {})
quakeMod.var("level",  {})
quakeMod.dir = quakeMod.dir..quakeMod.cfg.."/"

--************--
--*Initialize*--
--************--
function hook_init_quakeMod()
	--init the arrays so they don't return nil.
	quakeMod.loadcfg()
	quakeMod.level=initArray(32)
	quakeMod.timer=initArray(32)
end

--******--
--*Acts*--
--******--

--Sample command - sampleAct - parameters {p, typ, cmd}
function act_qklevel(p, x, cmd)
	local n = p
	if (cmd and tonumber(cmd)) then n = tonumber(cmd) end
	if quakeMod.level[n] then
		msg2(p, player(n,"name").." scored "..quakeMod.level[n].." kills")
	end
end
--Add the sampleAct command to the acts list - Do not forget to use all lower for the name of the field

function act_qktimeout(p, x, cmd)
	local n = p
	if (cmd and tonumber(cmd)) then n = tonumber(cmd) end
	if quakeMod.timer[n] then
		msg2(p, player(n,"name").." have "..math.floor(quakeMod.timeout-(os.clock()-quakeMod.timer[n])).." seconds until his level is reset")
	end
end

--************--
--*Admin Acts*--
--************--

--Sample command - sampleAdmAct - parameters {p, typ, cmd}
function adm_setsound_admin(p, x, cmd)
	if (type(cmd) == "string") then
		cmd = trim(cmd)
		--print (io.open("sound".."/prepare.wav"))
		if (io.open("sound/"..cmd.."/prepare.wav")) then
			quakeMod.setvar("sound", cmd, true)
		end
	end
end

--Sample command - sampleAdmAct - parameters {p, typ, cmd}
function adm_settimeout_admin(p, x, cmd)
	if (cmd and tonumber(cmd)) then
		quakeMod.setvar("timeout", tonumber(cmd), true)
	end
end
--*******--
--*Hooks*--
--*******--

--startround
function hook_startround_quakeMod()
	--start round stuff
	parse("sv_sound \""..quakeMod.sound.."/prepare.wav\"");
end

function hook_kill_quakeMod(killer,victim,weapon)
	--On kill
     if (os.clock()-quakeMod.timer[killer])>quakeMod.timeout then
          quakeMod.level[killer]=0;
     end

	 if player(victim, "health") then
		quakeMod.level[victim] = 0
		quakeMod.timer[victim] = os.clock()
	end

     quakeMod.level[killer]=quakeMod.level[killer]+1;
	 local level = quakeMod.level[killer]
     quakeMod.timer[killer]=os.clock();
     -- HUMILIATION? (KNIFEKILL)
	if (weapon==Knife) then
          -- HUMILIATION!
          parse("sv_sound \""..quakeMod.sound.."/humiliation.wav\"");
          msg ("©000000255"..player(killer,"name").." humiliated "..player(victim,"name").."!@C");
	else

          -- REGULAR KILL
          if (level==1) then
               -- Single Kill! Nothing Special!
          elseif (level==2) then
               parse("sv_sound \""..quakeMod.sound.."/doublekill.wav\"");
               msg ("©000000255"..player(killer,"name").." made a Doublekill!@C");
          elseif (level==3) then
               parse("sv_sound \""..quakeMod.sound.."/multikill.wav\"");
               msg ("©000000255"..player(killer,"name").." made a Multikill!@C");
          elseif (level==4) then
               parse("sv_sound \""..quakeMod.sound.."/ultrakill.wav\"");
               msg ("©000000255"..player(killer,"name").." made an ULTRAKILL!@C");
          elseif (level==5) then
               parse("sv_sound \""..quakeMod.sound.."/monsterkill.wav\"");
               msg ("©000000255"..player(killer,"name").." made a MO-O-O-O-ONSTERKILL-ILL-ILL!@C");
          else
               parse("sv_sound \""..quakeMod.sound.."/unstoppable.wav\"");
               msg ("©000000255"..player(killer,"name").." is UNSTOPPABLE! "..level.." KILLS!@C");
          end
	end
end



--********--
--*Return*--
--********--
return quakeMod.name




