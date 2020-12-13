extends Node

export (int) var max_health = 1
# use setget instead of putting the health check in the process func
onready var health = max_health setget set_health

signal dead

func set_health(value):
	health = value
	if health <= 0:
		emit_signal('dead')
