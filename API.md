# `chat_modes` API

Other mods can implement additional chat modes.

You can implement a new chat mode by calling

	chat_modes.register(modename, modedef)

* `modename` - the name of the mode, as will be supplied to the `/chatmode` as first argument
* `modedef` - a table containing the mode definition

## `modedef` definition

The mode definition must include the following table fields:

* `help`
	* brief summary of the options
* `register(playername, params_array)`
	* a handler function that is called any time a user switches chat modes. It is expected that the handler will register the player as having activated the mode, according to its parameters.
* `deregister(playername)`
	* a handler function that is called any time a user switches chat modes. It is expected that the handler will remove the player from the list of players registered against this mode.
* `getPlayers(playername, message)`
	* a handler function that returns a list of players.
	* This function is responsible for determining which players should receive the message.
	* The message content is provided for extra flexibility.

## Example file

An example file is provided in `example_mode.lua`

You can copy this file to your own mod to make use of `chat_modes`'s facilities.

## Example of `modedef`

The following (fairly pointless) module will send a mesasge to some players, depending on an inverse probability. It does not check for the validity of the parameter passed during registration.

	local probplayers = {}

	chat_modes.register("maybesay", {
		help = "<prob> -- send a message to all, with a probability <prob> of sending the message at all.",

		register = function(playername, params)
			probplayers[playername] = int(params[1]) or 10
		end,

		deregister = function(playername)
			probplayers[playername] = nil
		end,

		getPlayers = function(playername, message)
			local targetplayers = {}

			for _,player in pairs(minetest.get_connected_players() ) do
				if player:get_player_name() == playername then
					continue
				end

				if math.random(1, probplayers[playername] ) == 1 then
					targetplayers[#targetplayers] = player
				end
			end

			return targetplayers
		end,
	})


