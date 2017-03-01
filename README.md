# Minetest : Chat Modes (`chat_modes`)

***----- incomplete -----***

A Minetest mod to enable multiple chat modes.

By default, `chat_modes` is not active. Set `chat_modes.active = true` to activate it. This allows Chat Modes to be incuded in a subgame and not affect singleplayer mode, or be obtrusive to servers that do not want to include its functionality by default.

Players hoping to use the `chat_modes` commands need to have both the `shout` and `cmodeswitch` privileges.

Players without shout will not be able to send messages at all, as per the default chat behaviour, nor will they be able to mute the chat.

Players with `shout`, but without `cmodeswitch`, will only be able to use the default mode, as configured in `minetest.conf`

## Default Modules

A few modules are provided by default, annd active by default if `chat_modes.active` is set to true:

* `shout` -- this allows the player to broadacast a message to all connected players, just like in normal chat.
* `proximity` -- this module sends a message to players within the proximity of the sending player
* `channel` -- this module sends messages only to players who are in the shout channel. A player can only be in one channel at a time.
	* There is a `moderators` channel which only players with `basic_privs` can access, to allow moderators to chat.

It is possible to disable these modules by specifying a comma-separated list to `chat_modes.available`.

By default, this is set to

	chat_modes.available = shout,proximity,channel

By setting `chat_modes.available = ` (that is, a blank string) the default modules are turned off. Only mods that register any extra modes will be active.

## Usage

Any player with the `shout` privilege can deafen themselves

* `/deaf`
	* This commands toggles the player's `deaf` mode.
	* If deaf mode is on, they do not receive chat messages, regardless of their chat mode.

Players with both the `shout` and `cmodeswitch` privileges has access to the following commands:

* `/chatmode MODE [ARGUMENTS ...]`
	* this sets a new chat mode. Some chat modes can take extra arguments, others not.
* `/chatmodes`
	* this lists the chat modes available, with a description

Players with the `basic_privs` privilege have access to moderator messaging

* `/assignchatmode PLAYERNAME MODE [ARGUMENTS]`
	* Assigns a chat mode to a given player
	* (**not yet implemented**)
* `/wall GLOBALMESSAGE`
	* Send message to all connected players, regardless of their `deaf` status

## API

See the [API documentation](API.md) for details on how to leverage the `chat_modes` API.

Any mod can register a handler with Chat Modes, as long as it specifies `chat_modes` in its `depends.txt` file.
