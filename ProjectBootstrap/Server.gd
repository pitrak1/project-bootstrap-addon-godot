extends Node

var _constants

var _player_scene
var _players = {}

var _games_scene
var _games = {}

func _ready():
	_constants = get_node("/root/Constants")
	_player_scene = load(_constants.player_scene)
	_game_scene = load(_constants.game_scene)
	
func handle_incoming_network_command(command_type, sender_id, data):
	if sender_id in _players.keys() and _players[sender_id].get_game():
		return _players[sender_id].get_game().call(command_type, sender_id, data)
	else:
		return self.call(command_type, sender_id, data)

func __create_player(id, name, host=false):
	var player = _player_scene.instance()
	player.set_name(name)
	player.set_host(host)
	player.set_id(id)
	_players[id] = player
	return player
	
func __create_game(name):
	var game = _game_scene.instance()
	game.set_name(name)
	_games[name] = game
	return game

func register_player(id, data):
	var result = { "response_type": "return", "response": {} }
	if id in _players.keys():
		result["response"]["status"] = "invalid_player_name"
	else:
		result["response"]["status"] = "success"
		var player = __create_player(id, data["player_name"])
	return result
	
func create_game(id, data):
	var result = { "response_type": "return", "response": {} }
	if data["game_name"] in _games.keys():
		result["response"]["status"] = "invalid_game_name"
	else:
		result["response"]["status"] = "success"
		var game = __create_game(data["game_name"])
	return result

func join_game(id, data):
	var result = { "response_type": "return", "response": {} }
	if not data["game_name"] in _games.keys():
		result["response"]["status"] = "invalid_game_name"
	elif not id in _players.keys():
		result["response"]["status"] = "invalid_player_name"
	else:
		result["response"]["status"] = "success"
		_games[data["game_name"]].add_player(_players[id])
		_players[id].set_host(data["host"])
		var game = __create_game(data["game_name"])
	return result
	
func register_player_and_create_game(id, data):
	var result = { "response_type": "return", "response": {} }
	if id in _players.keys():
		result["response"]["status"] = "invalid_player_name"
	elif data["game_name"] in _games.keys():
		result["response"]["status"] = "invalid_game_name"
	else:
		result["response"]["status"] = "success"
		var player = __create_player(id, data["player_name"], true)
		var game = __create_game(data["game_name"])
		game.add_player(player)
	return result

func register_player_and_join_game(id, data):
	var result = { "response_type": "return", "response": {} }
	if id in _players.keys():
		result["response"]["status"] = "invalid_player_name"
	elif not data["game_name"] in _games.keys():
		result["response"]["status"] = "invalid_game_name"
	else:
		result["response"]["status"] = "success"
		var player = __create_player(id, data["player_name"], false)
		_games[data["game_name"]].add_player(player)
	return result