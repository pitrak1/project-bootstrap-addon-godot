extends Node2D

var __state_machine
var __constants

func _ready():
	randomize()
	__state_machine = get_node("/root/StateMachine")
	__constants = get_node("/root/Constants")
	
	if OS.has_feature("server"):
		__start_server()
	elif OS.has_feature("client"):
		__start_client()
	else:
		__start_client()
		
func __start_client():
	__state_machine.set_state(__constants.client_start_state)

func __start_server():
	__state_machine.set_state(__constants.server_start_state)
