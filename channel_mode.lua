
-- Channel mode

local allchannels = {} -- channel_name --> list of players
local playerschannel = {} -- playername --> channel_name

-- Define a special moderator channel that cannot be joined by regular players
local moderatorchannel = minetest.setting_get("chat_modes.channels.moderator") or "moderators"

local function channelcheck(playername, params)
	if #params < 1 then
		minetest.chat_send_player("Please specify a channel name")
		return false
	end
	if params[1] == moderatorchannel then
		return minetest.get_player_privs(playername, {basic_privs=true})
	else
		return true
	end
end

chat_modes.register_mode("channel", {
	help = "Send messages to a specific channel only.",

	can_register = function(playername, params)
		if not channelcheck(playername, params) then
			return false
		end

		return true
	end,

	register = function(playername, params)
		if not channelcheck(playername, params) then
			return false
		end

		local channelname = params[1]
		local channelplayers = allchannels[ channelname ] or {}

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
