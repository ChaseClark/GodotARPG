extends Node2D

var GrassEffect = load("res://Effects/GrassEffect.tscn")

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		var grass_effect = GrassEffect.instance()
		var world = get_tree().current_scene
		grass_effect.global_position = global_position
		world.add_child(grass_effect)
		queue_free()
