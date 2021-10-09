extends Node

var game_over = false

var score = 19
var distance = 10349
var food = 89
var clean = 4

func reset():
	game_over = false
	
	#score = 0
	#distance = 0
	#food = 0
	#clean = 0

func get_camera() -> Camera2D:
	var camera: Camera2D = get_node("/root/Game/Camera2D")
	return camera
