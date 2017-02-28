
-- The default-default mode - just get all connected players
chat_modes.register("shout", {
	help = "Send all messages to all players",
	register = function() end,
	deregister() = function() end,
	getPlayers = function()
		return minetest.get_connected_players()
	end
})
