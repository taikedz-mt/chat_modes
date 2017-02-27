
-- The default-default mode - just get all player names and send message to all
chat_modes.register("shout", function()
	return {
		public = true,
		players = conplayers,
	}
end)

-- Channel mode

local playerchannels = {}

chat_modes.register("channel", function(params)
	local channelname = params
	-- Switch to a channel
	if not playerchannels[channelname] then
		playerchannels[channelname] = {}
	end


end)
