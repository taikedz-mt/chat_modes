-- Keep track of players who have deafened themselves
local deafplayers = {}

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

chat_modes.register_interceptor("deaf mode", function(sender, message, targets)
	local newtargets = {}

	for _,player in pairs(targets) do
		if not deafplayers[player:get_player_name()] then
			newtargets[#newtargets+1] = player
		end
	end

	return newtargets
end)
