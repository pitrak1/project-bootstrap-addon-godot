extends Node

# https://docs.godotengine.org/en/stable/getting_started/step_by_step/singletons_autoload.html
var current_state = null

func set_state(path):
	call_deferred("_deferred_set_state", path)
	
func _deferred_set_state(path):
	if current_state != null:
		current_state.free()

	var scene = ResourceLoader.load(path)
	current_state = scene.instance()

	get_tree().get_root().add_child(current_state)
	get_tree().set_current_scene(current_state)
