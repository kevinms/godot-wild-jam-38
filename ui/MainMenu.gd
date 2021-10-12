extends Node2D

onready var starting_player_pos = $Player.global_position

func _ready():
	Global.reset()
	Global.connect("windturbine_hit", self, "on_windturbine_hit")

func reset():
	Global.reset()
	$DeathSound.play()
	$Player.reset()
	$Player.global_position = $PlayerSpawn.global_position

func _process(delta):
	move_camera(delta)
	
	if is_player_dead():
		reset()

func is_player_dead():
	var player_pos = $Player.global_position
	
	# Died by falling
	if player_pos.y > starting_player_pos.y + 1200:
		return true
	
	return false

func move_camera(delta: float):
	var view_size = Vector2(ProjectSettings.get("display/window/size/width"), ProjectSettings.get("display/window/size/height"))
	
	var camera_pos = $Camera2D.global_position
	var player_pos = $Player.global_position

	camera_pos.x = lerp(camera_pos.x, player_pos.x, 6.0*delta)
	camera_pos.y = lerp(camera_pos.y, player_pos.y, 5.0*delta)
	
	$Camera2D.global_position = camera_pos
	var cloud_camera_offset = camera_pos / view_size
	
	$Camera2D/CloudsBack.material.set_shader_param("camera_offset", cloud_camera_offset)
	$Camera2D/CloudsFront.material.set_shader_param("camera_offset", cloud_camera_offset)

func on_windturbine_hit():
	yield(get_tree().create_timer(0.6), "timeout")
	reset()
