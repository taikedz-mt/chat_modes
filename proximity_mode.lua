-- Proximity mode

local playerproximitypref = {} -- playername --> (int) max message distance

local maxproximity = int(minetest.setting_get("chat_modes.maxproximity") ) or 50

chat_modes.register_mode("proximity", {
	help = "Send messages to players within a certain distance",

	register = function(playername, params)
		local proxpref = int(params[1]) or maxproximity
		if proxpref > maxproximity then
			proxpref = maxproximity
		end

		playerpxoimitypref[playername] = proxpref
	end,

	deregister = function(playername)
		playerpxoimitypref[playername] = nil
	end,

	getPlayers = function(playername, message)
		local targetplayers = {}
		local thisplayer = minetest.get_player_by_name(playername)
		
		for _,player in pairs(minetest.get_connected_players() ) do
			if vector.distance(player:getpos(), thisplayer:getpos() ) <= playerpxoimitypref[playername] then
				targetplayers[#targetplayers] = player
			end
		end

		return targetplayers
	end
})
