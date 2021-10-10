extends Node

var game_over = false

var score = 0
var distance = 0
var food = 0
var clean = 0
var playerStartingPosition = 0

signal player_died
signal windturbine_hit

func reset():
	game_over = false
	
	score = 0
	distance = 0
	food = 0
	clean = 0

func get_camera() -> Camera2D:
	var camera: Camera2D = get_node("/root/Game/Camera2D")
	return camera
