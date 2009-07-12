newMod("parser")

--Admin - Command "@parse"

function adm_parse_admin(p, typ, cmd)
	msg2(p, "Server parsed: "..cmd)
end

--Hooks

function hook_init_parser()
	print(parser.name.." Initiated")
end

return parser.name
