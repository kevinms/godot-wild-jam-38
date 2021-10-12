extends Node2D

func _process(delta):
	$Score.text = str(Global.score)

	$Grid/Distance.text = str(int((Global.distance - Global.playerStartingPosition)/12))+ " ft"
	$Grid/Food.text = str(Global.food)
	$Grid/Clean.text = str(Global.clean)

func _on_MainMenu_pressed():
	get_tree().change_scene("res://ui/MainMenu.tscn")

func _on_Retry_pressed():
	get_tree().reload_current_scene()
