
-- Channel mode

local allchannels = {} -- channel_name --> list of players
local playerschannel = {} -- playername --> channel_name

-- Define a special moderator channel that cannot be joined by regular players
local moderatorchannel = minetest.setting_get("chat_modes.channels.moderator") or "moderators"

chat_modes.register("channel", {
	help = "Send messages to a specific channel only.",

	can_register = function(playername, params)
		if params[1] == moderatorchannel then
			return minetest.get_player_privs(playername, {basic_privs=true})
		else
			return true
		end
	end,

	register = function(playername, params)
		if params[1] == moderatorchannel then
			if not minetest.get_player_privs(playername, {basic_privs=true}) then
				return false
			end
		end

		local channelname = params[1]
		local channelplayers = allchannels[ channelname ]

		channelplayers[playername] = minetest.get_player_by_name(playername)
		playerschannel[playername] = channelname

		return true
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
