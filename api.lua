-- Namespace global variable

chat_modes = {}

-- Privs

minetest.register_privilege("cmodeswitch", "Player can switch their chat mode.")

-- ================================
-- Main vairables

local heuristics = {} -- modestring => mode_definition_table

-- Keep track of what mode players are in
local playermodes = {} -- playername => modestring

-- Keep track of players who have deafened themselves
local deafplayers = {}

local defaultmode = minetest.setting_get("chat_modes.mode") or "shout"


-- ================================
-- Public API

function chat_modes.register_mode(modename, mdef)
	chat_modes[modename] = mdef
end

-- Send a player chat, unless the player has set themselves ass deaf
function chat_modes.chatsend(player, message)
	if type(player) ~= "string" then
		player = player:get_player_name()
	end

	if not deafplayers[player] then
		minetest.chat_send_player(player, message)
	end
end

-- ================================
-- General chat utilities

minetest.register_chatcommand("deaf", {
	description = "Toggle deaf status. If you are deaf (Deaf mode 'on'), you do not receive any chat messages.",
	privs = {shout = true},
	func = function(playername, args)
		if deafplayers[playername] then
			deafplayers[playername] = nil
			minetest.chat_send_player(playername, "Deaf mode OFF")
		else
			deafplayers[playername] = true
			minetest.chat_send_player(playername, "Deaf mode ON")
		end
	end,
})

-- Send message to all, named after the UNIX command of the same name
minetest.register_chatcommand("wall", {
	params = "<compulsory message>",
	description = "Send a message to all players, regardless of chat mode or deaf status - for moderators.",
	privs = {shout = true, basic_privs = true},
	func = function(playername, message)
		minetest.chat_send_all("GLOBAL MESSAGE FROM MODERATOR "..playername..": "..message)
	end,
})

-- ================================
-- Command registration

minetest.register_chatcommand("assignchatmode", {
	privs = {basic_privs = true},
	params = "<player> <chatmode>",
	description = "Set a player's chat mode",
	func = function(playername, params)
		-- TODO
	end
})

minetest.register_chatcommand("chatmode", {
	params = "<chatmode>",
	description = "Set a new chat mode",
	privs = {shout = true, cmodeswitch = true},
	func = function(playername, arguments)
		local oldmodedef = heuristics[ playermodes[playername] ]

		local argsarray = arguments:split(" ")
		local newmodename = table.remove(argsarray, 1)
		local newmodedef = heuristics[newmodename]

		if not newmodedef then
			minetest.chat_send_player(playername, "No such mode.")
			return
		end

		-- ====

		oldmodedef.deregsiter(playername)
		playermodes[playername] = newmodename
		newmodedef.register(playername, argsarray)
	end
})

minetest.register_chatcommand("chatmodes", {
	description = "List available chat modes",
	privs = {shout = true, cmodeswitch = true},
	func = function(playername, params)
		for modename,modedef in pairs(heuristics) do
			minetest.chat_send_player(playername, modename..": "..str(modedef.help) )
		end
	end,
})

-- ================================
-- Interception

minetest.register_on_chat_message(function(playername, message)
	local modedef = heuristics[ playermodes[playername] ]
	local valid_players = modedef.getplayers(playername, message)

	for _,theplayer in pairs(valid_players.players) do
		chat_modes.chatsend(theplayer:get_player_name(), message)
	end
end)

-- ================================
-- Player management

minetest.register_on_playerleave(function(player) -- FIXME verify
	playermodes[player:get_player_name()] = nil
end)

minetest.register_on_playerjoin(function(player) -- FIXME verify
	playermodes[player:get_player_name()] = defaultmode
end)

-- ================================
-- Load defaults

local defaultmodes = minetest.setting_get("chat_modes.defaults")
if defaultmodes then
	for _,modename in pairs(defaultmodes:split(",")) do
		dofile(minetest.get_modpath("chat_modes").."/"..modename.."_mode.lua" )
	end
else
	dofile(minetest.get_modpath("chat_modes").."/shout_mode.lua" )
end

