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
onready var windturbine_scene = preload("res://windturbine/WindTurbine.tscn")
onready var door_scene = preload("res://ui/Door.tscn")

var objects = []
var level_complete = false

export(NodePath) var camera_path
onready var camera: Camera2D = get_node(camera_path)

onready var base_pos = global_position
onready var pos = base_pos

func add_child(node: Node, legible_unique_name: bool = false):
	.add_child(node)
	
	# Keep track of new objects
	objects.append(node)
	
	# Free old objects
	while objects.size() > 30:
		objects.pop_front().queue_free()

func randomly_place_balloons(pos: Vector2, miny=-200, maxy=-300) -> Node2D:
	var balloon = balloon_scene.instance()
	var balloon_pos = pos
	balloon_pos.y += rand_range(miny, maxy)
	
	add_child(balloon)
	balloon.global_position = balloon_pos
	
	return balloon

var till_next_door = 0
func should_spawn_door():
	if !level_complete or Global.level_mode > 1:
		return
	
	if till_next_door <= 0:
		till_next_door = 10
		return true
	
	till_next_door -= 1
	return false

func spawn_building(pos: Vector2, windturbine: bool) -> Node2D:
	var index = randi() % building_scenes.size()
	var building = building_scenes[index].instance()
	var building_size = building.get_size_in_pixels()
	
	# Door to next level
	var spawn_door = false
	var door_pos = Vector3.ZERO
	if should_spawn_door():
		spawn_door = true
		door_pos = pos
		#Note: defer creating door, but check here so windturbine isn't created
	
	# Turbine
	elif windturbine:
		var turbine = windturbine_scene.instance()
		add_child(turbine)
		turbine.global_position = pos
	
	pos.y += building_size.y / 2
	
	add_child(building)
	building.global_position = pos
	
	# Add the door last so it's rendered on top
	if spawn_door:
		var door = door_scene.instance()
		door.level_mode = Global.level_mode + 1
		add_child(door)
		door.global_position = door_pos + Vector2.UP * 50
	
	return building

#func randomly_place_building():
#	var index = randi() % building_scenes.size()
#	var building = building_scenes[index].instance()
#	var building_size = building.get_size_in_pixels()
#
#	var xscale = rand_range(1.0, 2.0)
#	pos.x += building_size.x * xscale
#	pos.y = base_pos.y + rand_range(-200, 200)
#
#	randomly_place_balloons(pos + Vector2(0, -building_size.y/2))
#
#	# Spawn
#	add_child(building)
#	building.global_position = pos

var noise = OpenSimplexNoise.new()
func get_noisy_altitude(x: float) -> float:
	var amplitude = 1.0
	var frequency = 0.2
	var y = amplitude * noise.get_noise_1d(x * frequency)
	y *= 200.0
	print("amplitude: ", y)
	return y


const TURBINE_THRESHOLD = 500
const TURBINE_INCREASE_OVER_DIST = 10000

var BALLONCHAIN_INTERVAL = 6
var till_balloon_chain = 0
func is_time_for_balloon_chain():
	if Global.level_mode == 2:
		BALLONCHAIN_INTERVAL = 2
	
	till_balloon_chain -= 1
	if till_balloon_chain <= 0:
		till_balloon_chain = BALLONCHAIN_INTERVAL
		return true
	return false

func spawn_balloon_chain(num_balloons: int):
	print("spawn balloon chain!!!!!!!!!!")
	# Spawn chain of balloons
	for i in range(num_balloons):
		pos.x += rand_range(700, 900)
		randomly_place_balloons(pos, -230, -260)

func generate_object():
	var object = null
	
	if Global.level_mode > 0 and is_time_for_balloon_chain():
		spawn_balloon_chain(floor(rand_range(3, 4)))
		return
	
	var xoff = rand_range(200, 1000)
	
	if xoff > 800:
		object = randomly_place_balloons(pos + Vector2(xoff/2, 0))
	
	pos.y = global_position.y - get_noisy_altitude(pos.x)
	pos.x += xoff #TODO: take into account old and new building sizes
	#pos.x += rand_range(200, 200)
	
	var has_turbine = false
	if pos.x > TURBINE_THRESHOLD: #TODO: make this like 10k+
		#TODO: increase chance of turbine as pos.x increases, but still limit it
		var chance = lerp(0.1, 0.3, (pos.x - TURBINE_THRESHOLD) / TURBINE_INCREASE_OVER_DIST)
		if randf() < chance:
			has_turbine = true
	
	object = spawn_building(pos, has_turbine)

func check_level_complete():
	if level_complete:
		return
	match Global.level_mode:
		0:
			if Global.get_feet() > 2000:
				level_complete = true
				Global.update_billboard("Easy Mode Complete", 4.0)
				#$Camera2D/Billboard.display("Easy Mode Complete", 4.0)
		1:
			if Global.get_feet() > 2000:
				level_complete = true
				Global.update_billboard("Hard Mode Complete", 4.0)
				#$Camera2D/Billboard.display("Hard Mode Complete", 4.0)
		2:
			if Global.get_feet() > 2000:
				level_complete = true
				Global.update_billboard("Spidey Mode Complete", 4.0)

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
	
	check_level_complete()
	
	if pos < screenEdge:
		#randomly_place_building()
		generate_object()
