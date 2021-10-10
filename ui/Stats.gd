extends Node2D

func _process(delta):
	$Score.text = str(Global.score)

	$Grid/Distance.text = str(int((Global.distance - Global.playerStartingPosition)/12))+ " ft"
	$Grid/Food.text = str(Global.food)
	$Grid/Clean.text = str(Global.clean)
