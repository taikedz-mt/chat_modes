chat_modes = {}
chat_modes.heuristics = {} -- mode => mode_definition_table

--[[
	/chatmode shout
	/chatmode channel mychannel
	/chatmode proximity [distance]


----

	/chatmode MODENAME [MODEPARAMS]

---

	/chamodes list

List the registered modes
--]]

-- Keep track of what mode players are in
local playermodes = {} -- playername => heuristic name

function chat_modes.register_mode(modename, mdef)
	chat_modes[modename] = mdef
end

minetest.register_chatcommand("chatmode", {
	params = "<chatmode>",
	description = "Set a new chat mode",
	privs = {shout = true, cmodeswitch = true},
	func = function(playername, arguments)
		local oldmodedef = chat_modes.heuristics[ playermodes[playername] ]
		local newmodename = arugments -- FIXME - need to extract modename

		oldmodedef.deregsiter(playername)
		playermodes[playername] = newmodename
		chat_modes.heuristics[newmodename].register(playername, arguments) -- FIXME remove modename from arguments
	end
})

minetest.register_chatcommand("chatmodes", {
	description = "List available chat modes",
	privs = {shout = true, cmodeswitch = true},
	func = function(playername, params)
		for modename,modedef in pairs(chat_modes.heuristics) do
			minetest.chat_send_player(playername, modename..": "..str(modedef.help) )
		end
	end,
})

minetest.register_on_chat_message(function(playername, message)
	local modedef = chat_modes.heuristics[ playermodes[playername] ]
	local valid_players = modedef.getplayers(playername, message)

	for _,theplayer in pairs(valid_players.players) do
		minetest.chat_send_player(theplayer:get_player_name(), message)
	end

	if valid_players.public then
		if irc then
			-- Normal mode sends to all
			-- We should also send to IRC
		end
	end
end)

if minetest.setting_getbool("chat_modes.default") then
	dofile(minetest.get_modpath("chat_modes").."/default_modes.lua" )
end

