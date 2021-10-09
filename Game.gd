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
	var building = building_scene.instance()
	buildingSize = building.get_size_in_pixels()
	
	print(buildingSize)
	for i in range(2):
		randomly_place_building()

func _process(delta):
	$Camera2D.global_position.x += 100 * delta
	$Camera2D.global_position.y = $Player.global_position.y
	
	var screenEdge = $Camera2D.get_camera_screen_center() + get_viewport().size / 2
	#screenEdge = $Camera2D.get_camera_screen_center()
	if pos < screenEdge:
		randomly_place_building()
