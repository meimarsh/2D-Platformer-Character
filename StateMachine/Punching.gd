extends Node

onready var SM = get_parent()
onready var player = get_node("../..")

func _ready():
	yield(player, "ready")

func start():
	player.set_animation("Punching")
	player.moves = []

func physics_process(_delta):
	if not player.animating:
		var punch = player.get_node("Attack/Punch")
		if punch.is_colliding():
			var enemy = punch.get_collider()
			if enemy.has_method("damage"):
				enemy.damage(player.light_punch)
		SM.set_state("Idle")
