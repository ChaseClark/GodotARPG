extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn")

onready var timer = $InvincibilityTimer

var invincible: bool = false setget set_invincible

signal invincibility_started
signal invincibility_ended

func set_invincible(value):
	invincible = value
	if invincible:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)
	
	
func create_hit_effect():
	var hit_effect = HitEffect.instance()
	var main = get_tree().current_scene
	hit_effect.global_position = global_position
	main.add_child(hit_effect)


func _on_InvincibilityTimer_timeout():
	self.invincible = false # self calls the setter func


func _on_HurtBox_invincibility_ended():
	set_deferred("monitorable", false)


func _on_HurtBox_invincibility_started():
	set_deferred("monitorable", true) # cycles so that we can get hit by the bat multiple times
