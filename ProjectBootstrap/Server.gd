extends Node

var _clients = {}
	
func handle_incoming_network_command(command_type, sender_id, data):
	if sender_id in _clients.keys() and _clients[sender_id].get_game():
		return _clients[sender_id].get_game().call(command_type, sender_id, data)
	else:
		return self.call(command_type, sender_id, data)
