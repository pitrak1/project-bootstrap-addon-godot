extends Camera2D

const __constants_script = preload("res://Constants.gd")

var __constants

func _ready():
	__constants = get_node("/root/Constants")
	self.position = __constants.starting_camera_position
	
func _process(_delta):
	var factor = Vector2()
	if Input.is_action_just_pressed("game_right"):
		factor.x += __constants.camera_pan_increment
	if Input.is_action_just_pressed("game_left"):
		factor.x -= __constants.camera_pan_increment
	if Input.is_action_just_pressed("game_up"):
		factor.y -= __constants.camera_pan_increment
	if Input.is_action_just_pressed("game_down"):
		factor.y += __constants.camera_pan_increment
	
	if factor.length():
		self.position += factor
		
	if Input.is_action_just_pressed("game_zoom_out"):
		self.zoom -= Vector2(
			__constants.camera_zoom_factor, 
			__constants.camera_zoom_factor
		)
	if Input.is_action_just_pressed("game_zoom_in"):
		self.zoom += Vector2(
			__constants.camera_zoom_factor, 
			__constants.camera_zoom_factor
		)