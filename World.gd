extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("restart_level"):
		reload()
	
func reload() -> void:
	get_tree().reload_current_scene()
	PlayerStats.health = PlayerStats.max_health
