extends Area2D

var has_player = false
export(int) var level_mode = 0

var collapsing = false

func _ready():
	#$AnimationPlayer.play("worble")
	#$AnimationPlayer.stop(true)
	#$AnimationPlayer.seek(0, true)
	
	$AnimationPlayer.play_backwards("worble")
	
	match level_mode:
		0:
			$HelpDifficulty.text = "Easy"
		1:
			$HelpDifficulty.text = "Hard"
		2:
			$HelpDifficulty.text = "Spidey"

func _process(delta):
	if !has_player:
		return
	
	if !collapsing and Input.is_action_just_pressed("jump"):
		Global.level_mode = level_mode
		collapsing = true
		$AnimationPlayer.stop(true)
		$AnimationPlayer.play("collapse")
		$CollapseSound.play()
		
		# Mess up the player
		Global.game_over = true
		var player = Global.get_player()
		player.portal_warp()
		$Tween.interpolate_property(player, "global_position", player.global_position, global_position, 0.4, Tween.TRANS_LINEAR)
		$Tween.interpolate_property(player, "modulate:a", 1.0, 0.0, 0.6, Tween.TRANS_LINEAR)
		$Tween.start()
		
		yield($AnimationPlayer, "animation_finished")
		get_tree().change_scene("res://Game.tscn")

func _on_Door_body_entered(body):
	if collapsing:
		return
	has_player = true
	$AnimationPlayer.play("worble")
	$WorbleSound.play()

func _on_Door_body_exited(body):
	if collapsing:
		return
	has_player = false
	$AnimationPlayer.play_backwards("worble")
