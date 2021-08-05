extends Node

var _name
var _players = []

func get_name():
	return _name
	
func set_name(name):
	_name = name

func get_players():
	return _players

func add_player(player):
	player.set_game(self)
	_players.append(player)


