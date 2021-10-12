extends Area2D

var has_player = false

func _process(delta):
	if !has_player:
		return
	
	if Input.is_action_just_pressed("jump"):
		Global.level_mode = 0
		get_tree().change_scene("res://Game.tscn")

func _on_Door_body_entered(body):
	print("entered")
	has_player = true

func _on_Door_body_exited(body):
	print("exited")
	has_player = false
