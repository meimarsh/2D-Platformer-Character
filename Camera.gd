extends Camera2D

var VP = null

func _ready():
	position = Vector2(1400,300)
	VP = get_viewport().get_size()

func _process(_delta):
	var player1 = get_node_or_null("/root/Game/Player1")
	var player2 = get_node_or_null("/root/Game/Player2")
	if player1 != null and player2 != null:
		var distance = (player2.position - player1.position)
		var s = clamp(abs(distance.x) / (VP.x*0.75), 1, 1000)
		zoom = Vector2(s,s)
		position = distance/2 + player1.position
