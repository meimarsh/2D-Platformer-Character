extends Node

func _unhandled_input(event):
	if event.is_action_pressed("quit"):
		get_tree().quit()


var score = 0
var lives = 5

func increase_score(s):
	score += s

var save_data = {
	"general": {
		"score":0
	},
	"player": {
		"position":Vector2.ZERO
	}
}
