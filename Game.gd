extends Node2D

func _ready():
	Global.reset()
	$Camera2D/GameOver.visible = false

func process_game_over():
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()

func is_player_dead():
	var player_pos = $Player.global_position
	
	# Died by falling
	if player_pos.y > $BuildingSpawner.global_position.y + 700:
		return true
	
	return false

func do_game_over():
	if Global.game_over:
		return
	
	Global.game_over = true
	print("dead")
	$DeathSound.play()
	yield(get_tree().create_timer(1.0), "timeout")
	$Camera2D/GameOver.visible = true

func move_camera(delta: float):
	var camera_pos = $Camera2D.global_position
	var player_pos = $Player.global_position
	
	#TODO: increase camera speed over time, but set a limit so players can go infinite
	#camera_pos.x += 100 * delta
	if player_pos.x > camera_pos.x:
		camera_pos.x = lerp(camera_pos.x, player_pos.x, 2.0*delta)
		
	camera_pos.y = lerp(camera_pos.y, player_pos.y, 5.0*delta)
	
	$Camera2D.global_position = camera_pos

func _process(delta):
	if Global.game_over:
		process_game_over()
		return
	
	move_camera(delta)

	if is_player_dead():
		do_game_over()

func _on_VisibilityNotifier2D_screen_exited():
	do_game_over()
