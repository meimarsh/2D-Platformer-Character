extends Node

var player1_health = 100.0
var player1_maxhealth = 100.0
var player2_health = 400.0
var player2_maxhealth = 400.0


func _unhandled_input(event):
	if event.is_action_pressed("quit"):
		get_tree().quit()
