--************************--
--*Global Initializations*--
--************************--

users = {} -- Returns a list of users indexed by username and contains {id, password, privilege}
priv = {}
admins = {} -- Indexed by username and contains {[privilege] = privilege}
cmd_priv = {} -- Indexed by command type and contains privilege mask
cmd_prefix = {} -- Indexed by prefix text and contains {cmd, admin}

util = {}
priv_cmd = {}
playeruid = {}
userpid = {}

--conf_dir = "settings/"
--core_dir = "core/"
--mods_dir = "mods/"

lastUser = 0
--modules = {} --Modules list, legacy system, obsolete
