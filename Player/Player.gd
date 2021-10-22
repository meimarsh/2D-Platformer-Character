extends KinematicBody2D

onready var SM = $StateMachine

var velocity = Vector2.ZERO
var jump_power = Vector2.ZERO
var direction = 1

export var gravity = Vector2(0,30)

export var move_speed = 20
export var max_move = 300

export var jump_speed = 100
export var max_jump = 1000

export var leap_speed = 100
export var max_leap = 1000

var moving = false
var is_jumping = false
var should_direction_flip = true # whether or not player controls (left/right) can flip the player sprite
var animating = false

export var light_punch = 10
export var med_punch = 20
export var heavy_punch = 30

export var light_kick = 15
export var med_kick = 25
export var heavy_kick = 40

var Enemy = null

var moves = []

var c_left = ""
var c_right = ""
var c_jump = ""
var c_crouch = ""
var c_light_punch = ""
var c_light_kick = ""

var enemy_path = ""



func _ready():
	if name == "Player1":
		c_left = "left_1"
		c_right = "right_1"
		c_jump = "jump_1"
		c_crouch = "crouch_1"
		c_light_punch = "light_punch_1"
		c_light_kick = "light_kick_1"
		enemy_path = "/root/Game/Player2"
		collision_layer = 0b000001
		$Attack/Punch.collision_mask = 0b111110
		$Attack/Kick.collision_mask = 0b111110
	if name == "Player2":
		c_left = "left_2"
		c_right = "right_2"
		c_jump = "jump_2"
		c_crouch = "crouch_2"
		c_light_punch = "light_punch_2"
		c_light_kick = "light_kick_2"
		enemy_path = "/root/Game/Player1"
		collision_layer = 0b100000
		$Attack/Punch.collision_mask = 0b011111
		$Attack/Kick.collision_mask = 0b011111
		$AnimatedSprite.modulate = Color(0.5,0.5,1.0,1.0)


func _physics_process(_delta):
	velocity.x = clamp(velocity.x,-max_move,max_move)
	
	if Enemy == null:
		Enemy = get_node_or_null(enemy_path)
	if Enemy != null and is_on_floor():
		var dir = Enemy.position.x - position.x
		if dir < 0 and not $AnimatedSprite.flip_h: 
			$AnimatedSprite.flip_h = true
			$Attack.scale.x = -1
			$CollisionShape2D.position.x = 15.25
		if dir > 0 and $AnimatedSprite.flip_h: 
			$AnimatedSprite.flip_h = false
			$Attack.scale.x = 1
			$CollisionShape2D.position.x = -15.25
	elif should_direction_flip and is_on_floor():
		if direction < 0 and not $AnimatedSprite.flip_h: $AnimatedSprite.flip_h = true
		if direction > 0 and $AnimatedSprite.flip_h: $AnimatedSprite.flip_h = false
		
func is_moving():
	if Input.is_action_pressed(c_left) or Input.is_action_pressed(c_right):
		return true
	return false

func move_vector():
	return Vector2(Input.get_action_strength(c_right) - Input.get_action_strength(c_left),1.0)

func _unhandled_input(event):
	if event.is_action_pressed(c_left):
		direction = -1
	if event.is_action_pressed(c_right):
		direction = 1

func set_animation(anim):
	animating = true
	if $AnimatedSprite.animation == anim: return
	if $AnimatedSprite.frames.has_animation(anim): $AnimatedSprite.play(anim)
	else: $AnimatedSprite.play()

func is_on_floor():
	var fl = $Floor.get_children()
	for f in fl:
		if f.is_colliding():
			return true
	return false

func die():
	queue_free()

func damage(d):
	if name == "Player1":
		Global.player1_health -= d
	if name == "Player2":
		Global.player2_health -= d

func _on_AnimatedSprite_animation_finished():
	animating = false
