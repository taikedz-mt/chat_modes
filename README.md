# Minetest : Chat Modes (`chat_modes`)

***NOT yet COMPLETED***

A Minetest mod to enable multiple chat modes.

Players hoping to use the `chat_modes` commands need to have both the `shout` and `cmodeswitch` privileges.

Players without shout will not be able to send messages at all.

Players with `shout`, but without `cmodeswitch`, will only be able to use the default mode, as configured in `minetest.conf`

## Default Modules

A few modules are provided by default:

* `shout` -- this is the default module, which allows the player to broadacast a message to all connected players.
* `proximity` -- this module sends a message to players within the proximity of the sending player
* `channel` -- this module sends messages only to players who are in the shout channel. A player can only be in one channel at a time.

It is possible to disable these modules by specifying a comma-separated list to `chat_modes.available`.

By default, this is set to

	chat_modes.available = shout,proximity,channel

## Usage

Any player who has both the `shout` and `cmodeswitch` privileges has access to the following commands:

* `/chatmode MODE [ARGUMENTS ...]`
	* this sets a new chat mode. Some chat modes can take extra arguments, others not.
* `/chatmodes`
	* this lists the chat modes available, with a description

Players with `chatadmin` privilege have an additional command:

* `/assignchatmode PLAYERNAME MODE [ARGUMENTS]`
	* Assigns a chat mode to a given player

## API

Other mods can implement additional chat modes.

You can implement a new chat mode by calling

	chat_modes.register(modename, modedef)

* `modename` - the name of the mode, as will be supplied to the `/chatmode` as first argument
* `modedef` - a table containing the mode definition

### `modedef` definition

The mode definition must include the following table fields:

* `help` -- brief summary of the options
* `register(playername, params)` -- a handler function that is called any time a user switches chat modes. It is expected that the handler will register the player as having activated the mode, according to its parameters.
* `deregister(playername, params)` -- a handler function that is called any time a user switches chat modes. It is expected that the handler will remove the player from the list of players registered against this mode, according to its parameters.
* `getPlayers(playername, message)` --  a handler function that returns a list of players. This function is responsible for determining which players should receive the message.

### Example of `modedef`

The following (fairly pointless) module will send a mesasge to some players, depending on an inverse probability. It does not check for the validity of the parameter passed during registration.

	local probplayers = {}

	chat_modes.register("maybesay", {
		help = "<prob> -- send a message to all, with a probability <prob> of sending the message at all.",

		register = function(playername, params)
			probplayers[playername] = int(params)
		end,

		deregister = function(playername, params)
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


