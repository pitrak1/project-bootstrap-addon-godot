# Project Bootstrap Addon for Godot

A Godot addon to provide common functionality for multiplayer games.  Currently supports a state machine and networking.

## Installation

- Copy the `ProjectBootstrap` folder from this repo into your `addons` subdirectory.
- Create a `Constants.gd` file in your project.
	- This must contain at least two values:
		- `ip_address`: The IP address or DNS lookup for your server.
		- `port`: The port for the service to communicate through.
	- Feel free to add more values to this file for your own purposes.
- Add three values to your AutoLoad in your Project Settings with Singleton enabled.  These entries should be listed in the order below.
	- `Constants` loaded from `Constants.gd`
	- `StateMachine` loaded from `res://addons/ProjectBootstrap/StateMachine.gd`
	- `Network` loaded from `res://addons/ProjectBootstrap/Network.gd`
- You probably also want to add the `ProjectBootstrap` folder to your `.gitignore`.

## Usage	

### State Machine

#### Setting the State

- Get the StateMachine node: `__state_machine = get_node("/root/StateMachine")`
- Set the state to a scene: `__state_machine.set_state("res://client/debug/DebugState.tscn")`

#### Getting the State

`__state_machine.current_state`

#### Keeping Context Between States

In order to keep values between states, a Singleton should be added, like we did in the Installation section.  Add another script to use as a global context above the other Singletons added in the Installation section.

### Networking

In order to use the networking features, your Project Export Preset should have `client` or `server` in its features list.

#### Client Side

To allow networking to work, we need to define states in certain ways.
- Your states should be scenes based off of a Node2D node.
- Your root nodes of your state scenes should have a script of the same name attached.
- The script should extend the `State.gd` file in this repository.
- Your root node should have at least three children:
	- A CanvasLayer called `UICanvasLayer`
	- A Label called `LoadingLabel` as a child of the `UICanvasLayer`
	- A Camera2D called `Camera2D`
	- Note: The way to use this system is to create everything you want to move with the camera (UI elements) as Control nodes and as children of the `UICanvasLayer` node, and anything you do not want to move with the camera (game elements) as Node2D nodes and not as children of the `UICanvasLayer` node. Additionally, the base `State` script will show and hide the `LoadingLabel` as appropriate based on network requests.

If states are defined this way, client networking works as follows:
- `send_network_command` will send a request to the server, with the first argument being the command name and the second argument being an object where you can put data that may be required on the server side.
- `<command_name>_response` will be called when a server response is sent for a particular command, with the first argument being the data returned from the server.  A good convention is to at least have a `status` key in that object.
- The `LoadingLabel` will be shown once a request is sent and hidden again once the request completes.
- If the state needs to respond to a particular command from the server initiated by another client (for instance, another player joining the lobby), the same methodology should be used.  A server command of a certain name will be sent to all clients, and a client should have the `<command_name>_response` method defined.

#### Server Side

The `Server.gd` file should be extended by your own server scene.  It's recommended to follow these guidelines:
- Build the `_clients` variable in the `Server.gd` script as a map from a client's network ID to a Client object representing them.
- Have the Client object have a `get_game()` method that will return the game the client is currently a part of (if at all).
- Have the Client object have a `get_id()` method that will return their network ID

With these two in place, a network request from a client will call a method with the same name as the command name.  The first argument will be the ID of the sending client, and the second will be the data they sent along.  If the client is currently associated with a game, the method will be called on the game object.  If not, the method will be called on the server object.

These methods should return an object with three keys:
- `response`: the actual data to return to the client
- `response_type`: this should be either `return` to only respond to the client who sent the command or `broadcast` to send the response to every player in the `players` key
- `players`: the clients to send the `response` to if the `response_type` is set to broadcast

The intricacies of everything that needs to be done on the server side will involve a lot more, but hopefully, this is a good starting point.