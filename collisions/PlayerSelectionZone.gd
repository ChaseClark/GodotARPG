extends Area2D

var player = null

func _on_PlayerSelectionZone_body_entered(body):
	player = body

func _on_PlayerSelectionZone_body_exited(body):
	player = null


func can_see_player() -> bool:
	return player != null
