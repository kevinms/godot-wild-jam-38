extends Node2D

onready var building_scenes = [
	preload("res://buildings/Building1.tscn"),
	preload("res://buildings/Building2.tscn"),
	preload("res://buildings/Building3.tscn"),
	preload("res://buildings/Building4.tscn"),
	preload("res://buildings/Building5.tscn"),
	preload("res://buildings/Building6.tscn"),
]
var building_sizes = []

onready var balloon_scene = preload("res://balloon/Balloon.tscn")

export(NodePath) var camera_path
onready var camera: Camera2D = get_node(camera_path)

onready var base_pos = global_position
onready var pos = base_pos

func randomly_place_balloons(base):
	var balloon = balloon_scene.instance()
	var balloon_pos = base
	balloon_pos.y += rand_range(-300, -500)
	
	add_child(balloon)
	balloon.global_position = balloon_pos

func randomly_place_building():
	var index = randi() % building_scenes.size()
	var building = building_scenes[index].instance()
	var building_size = building.get_size_in_pixels()
	
	var xscale = rand_range(1.0, 2.0)
	pos.x += building_size.x * xscale
	pos.y = base_pos.y + rand_range(-200, 200)
	
	randomly_place_balloons(pos + Vector2(0, -building_size.y/2))
	
	# Spawn
	add_child(building)
	building.global_position = pos

func _ready():
	#var building = building_scenes[0].instance()
	#building_sizes.append(building.get_size_in_pixels())
	#print(building_sizes[0])
	
	for i in range(2):
		randomly_place_building()

func _process(delta):
	var screenEdge = camera.get_camera_screen_center() + get_viewport().size / 2
	#screenEdge = $Camera2D.get_camera_screen_center()
	if pos < screenEdge:
		randomly_place_building()
