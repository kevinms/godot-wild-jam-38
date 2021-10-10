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

var objects = []

export(NodePath) var camera_path
onready var camera: Camera2D = get_node(camera_path)

onready var base_pos = global_position
onready var pos = base_pos

func randomly_place_balloons(pos) -> Node2D:
	var balloon = balloon_scene.instance()
	var balloon_pos = pos
	balloon_pos.y += rand_range(-200, -300)
	
	add_child(balloon)
	balloon.global_position = balloon_pos
	
	return balloon

func spawn_building(pos: Vector2) -> Node2D:
	var index = randi() % building_scenes.size()
	var building = building_scenes[index].instance()
	var building_size = building.get_size_in_pixels()
	
	pos.y += building_size.y / 2
	
	add_child(building)
	building.global_position = pos
	
	return building

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

const octaves = 1
const lacunarity = 2.0
const gain = 200.0

var noise = OpenSimplexNoise.new()
func get_fbm_altitude(x: float) -> float:
	var y = 0.0
	var amplitude = 0.5
	var frequency = 1.0
	
	for i in range(octaves):
		y += amplitude * noise.get_noise_1d(pos.x / 20.0 * frequency)
		frequency *= lacunarity
		amplitude *= gain
	
	return 0.0

func get_noisy_altitude(x: float) -> float:
	var amplitude = 2.0
	var frequency = 0.2
	var y = amplitude * noise.get_noise_1d(x * frequency)
	y *= 200.0
	print("amplitude: ", y)
	return y

func generate_object():
	var object = null
	
	var xoff = rand_range(200, 1000)
	
	if xoff > 800:
		object = randomly_place_balloons(pos + Vector2(xoff/2, 0))
	
	pos.y = global_position.y - get_noisy_altitude(pos.x)
	pos.x += xoff #TODO: take into account old and new building sizes
	#pos.x += rand_range(200, 200)
	
	object = spawn_building(pos)
	
	objects.append(object)

func _ready():
	#var building = building_scenes[0].instance()
	#building_sizes.append(building.get_size_in_pixels())
	#print(building_sizes[0])
	
	for i in range(2):
		generate_object()
		#randomly_place_building()

func _process(delta):
	var view_size = Vector2(ProjectSettings.get("display/window/size/width"), ProjectSettings.get("display/window/size/height"))
	#var view_size = get_viewport().size
	
	var screenEdge = camera.get_camera_screen_center() + view_size / 2
	#screenEdge = $Camera2D.get_camera_screen_center()
	
	if pos < screenEdge:
		#randomly_place_building()
		generate_object()
