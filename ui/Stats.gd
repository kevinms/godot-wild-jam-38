extends Node2D

func _process(delta):
	$Score.text = str(Global.score)

	$Grid/Distance.text = str(Global.distance)
	$Grid/Food.text = str(Global.food)
	$Grid/Clean.text = str(Global.clean)
