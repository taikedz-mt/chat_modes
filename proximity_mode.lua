-- Proximity mode

local playerproximitypref = {} -- playername --> (int) max message distance

local maxproximity = tonumber(minetest.setting_get("chat_modes.maxproximity") ) or 50

chat_modes.register_mode("chat_modes:proximity", {
	help = "Send messages to players within a certain distance",

	register = function(playername, params)
		local proxpref = tonumber(params[1]) or maxproximity
		if proxpref > maxproximity then
			proxpref = maxproximity
		end

		playerproximitypref[playername] = proxpref
	end,

	deregister = function(playername)
		playerproximitypref[playername] = nil
	end,

	getPlayers = function(playername, message)
		local targetplayers = {}
		local thisplayer = minetest.get_player_by_name(playername)
		
		for _,player in pairs(minetest.get_connected_players() ) do
			if vector.distance(player:getpos(), thisplayer:getpos() ) <= playerproximitypref[playername] then
				chat_modes.dodebug("Found "..player:get_player_name() )
				targetplayers[#targetplayers+1] = player
			end
		end

		return targetplayers
	end
})
