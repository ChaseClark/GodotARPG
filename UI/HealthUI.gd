extends Control

var stats = PlayerStats
var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts

onready var heart_ui_full = $HeartUIFull
onready var heart_ui_empty = $HeartUIEmpty


func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if heart_ui_full:
		heart_ui_full.rect_size.x = hearts * int(heart_ui_full.texture.get_width())
	if hearts <= 0:
		heart_ui_full.hide()

func set_max_hearts(value):
	max_hearts = max(value,1)
	self.hearts = min(hearts, max_hearts)
	if heart_ui_empty:
		heart_ui_empty.rect_size.x = max_hearts * int(heart_ui_empty.texture.get_width())
	
func _ready():
	self.max_hearts = stats.max_health
	self.hearts = stats.health
	stats.connect("health_changed",self,"set_hearts")
	stats.connect("max_health_changed",self,"set_max_hearts")
