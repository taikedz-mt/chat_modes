
-- Channel mode

local allchannels = {} -- channel_name --> list of players
local playerschannel = {} -- playername --> channel_name

chat_modes.register("channel", {
	help = "Send messages to a specific channel only.",

	register = function(playername, params)
		local channelname = params[1]
		local channelplayers = allchannels[ channelname ]

		channelplayers[playername] = minetest.get_player_by_name(playername)
		playerschannel[playername] = channelname
	end,

	deregister = function(playername)
		local channelplayers = allchannels[playername]

		channelplayers[playername] = nil
		playerschannel[playername] = nil
	end,

	getPlayers = function(playername, message)
		local targetplayers = {}
		
		for _,player in pairs(allchannels[ playerschannel[playername] ]) do
			targetplayers[#targetplayers] = player
		end

		return targetplayers
	end
})
