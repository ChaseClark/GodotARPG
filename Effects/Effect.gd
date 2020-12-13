extends AnimatedSprite

func _ready():
	connect("animation_finished",self,"animation_finished")
	frame = 0
	play("animate")

func animation_finished():
	queue_free()
