extends Area2D

export (bool) var show_hit = true

const HitEffect = preload("res://Effects/HitEffect.tscn")

func _on_HurtBox_area_entered(area):
	if not show_hit:
		return
		
	var hit_effect = HitEffect.instance()
	var main = get_tree().current_scene
	hit_effect.global_position = global_position
	main.add_child(hit_effect)
