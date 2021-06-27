extends Node2D

var _network

func _ready():
	_network = get_node("/root/Network")
	console.log("Entered state " + self.name)
	$UICanvasLayer/LoadingLabel.visible = false
	$Camera2D.make_current()
	
func send_network_command(command_type, data):
	console.log("Sending " + command_type + " command...")
	_network.client_handle_outgoing_network_command(command_type, data)
	$UICanvasLayer/LoadingLabel.visible = true
	
func on_receive_network_response(command_type, data):
	console.log("Handling " + command_type + " response with status " + data['status'] + "...")
	self.call(command_type + "_response", data)
	$UICanvasLayer/LoadingLabel.visible = false
