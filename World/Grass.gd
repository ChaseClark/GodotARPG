extends Node2D

var GrassEffect = load("res://Effects/GrassEffect.tscn")

func create_grass_effect():
	var grass_effect = GrassEffect.instance()
	var world = owner # or  get_tree().current_scene
	grass_effect.global_position = global_position
	world.add_child(grass_effect)	
	
func _on_HurtBox_area_entered(area):
	create_grass_effect()
	queue_free()
