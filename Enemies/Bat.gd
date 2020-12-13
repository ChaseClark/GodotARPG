extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

enum {
	IDLE,
	WANDER,
	CHASE,
}

onready var stats = $Stats
onready var detection_zone = $PlayerSelectionZone
onready var animated_sprite = $AnimatedSprite
onready var hurtbox = $HurtBox
onready var soft_collision = $SoftCollision
onready var wander_controller = $WanderController

export var acceleration = 300
export var max_speed = 50
export var friction = 200


var velocity = Vector2.ZERO
var knockback: Vector2 = Vector2.ZERO
var state = CHASE

func _ready():
	state = pick_random_state([IDLE,WANDER])

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, friction * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			seek_player()
			if wander_controller.get_time_left() == 0:
				state = pick_random_state([IDLE,WANDER])
				wander_controller.start_wander_timer(rand_range(1,3))
		WANDER:
			if wander_controller.get_time_left() == 0:
				state = pick_random_state([IDLE,WANDER])
				wander_controller.start_wander_timer(rand_range(1,3))
			var direction_vector = global_position.direction_to(wander_controller.target_position)
			velocity = velocity.move_toward(direction_vector * max_speed, acceleration * delta)
			
			if global_position.distance_to(wander_controller.target_position) <= 4:
				state = pick_random_state([IDLE,WANDER])
				wander_controller.start_wander_timer(rand_range(1,3))
			animated_sprite.flip_h = velocity.x	< 0
		CHASE:
			var player = detection_zone.player
			if player: # != null
				var direction_vector = global_position.direction_to(player.global_position)
				velocity = velocity.move_toward(direction_vector * max_speed, acceleration * delta)
			else:
				state = IDLE
			animated_sprite.flip_h = velocity.x	< 0
			
	if soft_collision.is_colliding():
		velocity += soft_collision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)

func seek_player():
	if detection_zone.can_see_player():
		state = CHASE
	
func pick_random_state(state_list: Array):
	state_list.shuffle()
	return state_list.pop_front()
			
func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 120
	hurtbox.create_hit_effect()
	
func _on_Stats_dead():
	# animation
	queue_free()
	var enemy_death_effect = EnemyDeathEffect.instance()
	enemy_death_effect.global_position = global_position
	get_parent().add_child(enemy_death_effect)
