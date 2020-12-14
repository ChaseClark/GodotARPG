extends KinematicBody2D

export var ACCELERATION: int = 500
export var MAX_SPEED: int = 80
export var FRICTION: int = 500
export var ROLL_SPEED: int = 125

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE

var velocity: Vector2 = Vector2.ZERO
var roll_vector: Vector2 = Vector2.DOWN # start down to match blend positoins
var stats = PlayerStats

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var swordHitbox = $SwordPosition/SwordHitBox
onready var sword_collision = $SwordPosition/SwordHitBox/CollisionShape2D
onready var hurtbox = $HurtBox
onready var blink_animation_player = $BlinkAnimationPlayer
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	stats.connect("dead", self, "queue_free")
	if !sword_collision.disabled:
		sword_collision.disabled = true
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector=input_vector.normalized()

	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		animationState.travel("Run")		
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	move()
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func move():
	velocity = move_and_slide(velocity)
	
func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()
	
func attack_animation_finished():
	state = MOVE
	
func roll_animation_finished():
	velocity = Vector2.ZERO
	state = MOVE


func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(0.5)
	hurtbox.create_hit_effect()
	var player_hurt_sound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(player_hurt_sound)


func _on_HurtBox_invincibility_started():
	blink_animation_player.play("start")


func _on_HurtBox_invincibility_ended():
	blink_animation_player.play("stop")
