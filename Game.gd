extends Node2D

onready var building_scene = preload("res://buildings/Building.tscn")

func spawn_building(pos: Vector2):
	var building = building_scene.instance()
	
	building.global_position = pos
	add_child(building)


onready var base_pos = $SpawnLocation.global_position
onready var pos = base_pos
var buildingSize: Vector2

func randomly_place_building():
	var xscale = rand_range(1.0, 3.0)
	pos.x += buildingSize.x * xscale
	pos.y = base_pos.y + rand_range(-100, 100)
	
	spawn_building(pos)

func _ready():
	Global.reset()
	$Camera2D/GameOver.visible = false
	
	var building = building_scene.instance()
	buildingSize = building.get_size_in_pixels()
	
	print(buildingSize)
	for i in range(2):
		randomly_place_building()

func process_game_over():
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()

func is_player_dead():
	var player_pos = $Player.global_position
	
	# Died by falling
	if player_pos.y > $SpawnLocation.global_position.y + 200:
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

func _process(delta):
	if Global.game_over:
		process_game_over()
		return
	
	$Camera2D.global_position.x += 100 * delta
	$Camera2D.global_position.y = $Player.global_position.y
	
	var screenEdge = $Camera2D.get_camera_screen_center() + get_viewport().size / 2
	#screenEdge = $Camera2D.get_camera_screen_center()
	if pos < screenEdge:
		randomly_place_building()

	if is_player_dead():
		do_game_over()

func _on_VisibilityNotifier2D_screen_exited():
	do_game_over()
