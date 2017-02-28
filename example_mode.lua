
-- EXAMPLE
-- Copy this file to your mod and adjust it as required

local examplemode = {}

chat_modes.register("example", {
	help = "example",

	register = function(playername, params)
		examplemode[playername] = true
	end,

	deregister = function(playername)
		examplemode[playername] = nil
	end,

	getPlayers = function(playername, message)
		local targetplayers = {}
		local thisplayer = minetest.get_player_by_name(playername)
		
		-- INSERT LOGIC HERE

		return targetplayers
	end
})
