
local function getnextplayers(messageparts)
	local includes = {}

	-- Consume until found new player names
	while messageparts[1] and messageparts[1]:sub(1,1) ~= '@' do
		table.remove(messageparts, 1)
	end

	-- Get the next set of names
	while messageparts[1] and messageparts[1]:sub(1,1) == '@' do
		local token = table.remove(messageparts, 1)
		includes[#includes+1] = token:sub(2, #token)
	end

	return {includes=includes, mparts=messageparts}
end

local function playping(playername)
	-- TODO - implement sound
	return
end

-- Returns the target if it does not exist in the set
-- else returns nil
local function needstarget(targetset, target)
	for _,testtarget in pairs(targetset) do
		if testtarget == target then
			return target
		end
	end
end

chat_modes.register_interceptor("chat_modes:atreply", function(sender, message, targets)
	if minetest.setting_getbool("chat_modes.no_at_replies") == false then
		return targets
	end

	local messageparts = message:split(" ")

	local includes = {"triggerone"}
	local private = false
	local newtargets = {}

	-- Players mentioned at start of message
	-- Only send to them
	while messageparts[1] and messageparts[1]:sub(1,1) == '@' do
		local token = table.remove(messageparts, 1)
		local tname = token:sub(2, #token)

		local targetplayer = needstarget(targets, minetest.get_player_by_name(tname) )
		if targetplayer then
			newtargets[#newtargets+1] = targetplayer
			playping(tname)
		end
		private = true
	end
	if private then
		return newtargets
	end

	while includes[1] do -- hence "triggerone" to do it at least once
		local nextin = getnextplayers(messageparts)
		includes = nextin.includes
		messageparts = nextin.mparts

		for _,pname in pairs(includes) do
			local targetplayer = needstarget(targets, minetest.get_player_by_name(tname) )
			if targetplayer then
				newtargets[#newtargets+1] = targetplayer
				playping(tname)
			end
		end
	end

	for _,residualplayer in pairs(targets) do
		local targetplayer = needstarget(newtargets, residualplayer )
		if targetplayer then
			newtargets[#newtargets+1] = targetplayer
		end
	end

	return newtargets
end)

