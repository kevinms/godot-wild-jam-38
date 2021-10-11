extends Node2D


func _ready():
	Global.reset()
	Global.connect("windturbine_hit", self, "on_windturbine_hit")
	$Camera2D/GameOver.visible = false
	Global.playerStartingPosition = int($Player.position.x)


func process_game_over():
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()

func is_player_dead():
	var player_pos = $Player.global_position
	
	# Died by falling
	if player_pos.y > $LevelSpawner.global_position.y + 1200:
		return true
	
	return false

func do_game_over():
	if Global.game_over:
		return
	
	print_stray_nodes()
	
	Global.game_over = true
	print("dead")
	$DeathSound.play()
	yield(get_tree().create_timer(1.0), "timeout")
	$Camera2D/GameOver.visible = true

func move_camera(delta: float):
	var view_size = Vector2(ProjectSettings.get("display/window/size/width"), ProjectSettings.get("display/window/size/height"))
	
	var camera_pos = $Camera2D.global_position
	var player_pos = $Player.global_position
	
	# Look farther ahead based on player's velocity
	#player_pos.x += clamp($Player.velocity.x*0.8, -view_size.x/4, view_size.x/4)
	player_pos.x += view_size.x/5
	
	#TODO: increase camera speed over time, but set a limit so players can go infinite
	camera_pos.x += 200 * delta
	if player_pos.x > camera_pos.x:
		#camera_pos.x = lerp(camera_pos.x, player_pos.x, 3.0*delta)
		camera_pos.x = lerp(camera_pos.x, player_pos.x, 6.0*delta)
		
	camera_pos.y = lerp(camera_pos.y, player_pos.y, 5.0*delta)
	
	$Camera2D.global_position = camera_pos
	
	#var cloud_camera_offset = camera_pos / get_viewport().size
	var cloud_camera_offset = camera_pos / view_size
	
	$Camera2D/CloudsBack.material.set_shader_param("camera_offset", cloud_camera_offset)
	$Camera2D/CloudsFront.material.set_shader_param("camera_offset", cloud_camera_offset)

func _process(delta):
	if Global.game_over:
		process_game_over()
		return
		
	Global.distance = int($Player.position.x)
	
	move_camera(delta)

	if is_player_dead():
		do_game_over()

func _on_VisibilityNotifier2D_screen_exited():
	do_game_over()

func on_windturbine_hit():
	do_game_over()
