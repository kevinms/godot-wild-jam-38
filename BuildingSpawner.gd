extends Node2D

onready var building_scene = preload("res://buildings/Building.tscn")
var buildingSize: Vector2

export(NodePath) var camera_path
onready var camera: Camera2D = get_node(camera_path)

onready var base_pos = global_position
onready var pos = base_pos

func spawn_building(pos: Vector2):
	var building = building_scene.instance()
	add_child(building)
	
	building.global_position = pos

func randomly_place_building():
	var xscale = rand_range(1.0, 3.0)
	pos.x += buildingSize.x * xscale
	pos.y = base_pos.y + rand_range(-300, 300)
	
	spawn_building(pos)

func _ready():
	var building = building_scene.instance()
	buildingSize = building.get_size_in_pixels()
	
	print(buildingSize)
	for i in range(2):
		randomly_place_building()

func _process(delta):
	var screenEdge = camera.get_camera_screen_center() + get_viewport().size / 2
	#screenEdge = $Camera2D.get_camera_screen_center()
	if pos < screenEdge:
		randomly_place_building()
