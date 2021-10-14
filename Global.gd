extends Node

var game_over = false

var score = 0
var distance = 0
var food = 0
var clean = 0
var level_mode = 0
var playerStartingPosition = 0
var player_moved = false

signal player_died
signal windturbine_hit

# Args: (text, seconds)
signal update_billboard

func reset():
	game_over = false
	
	score = 0
	distance = 0
	food = 0
	clean = 0
	playerStartingPosition = 0
	player_moved = false

func update_billboard(text, seconds):
	emit_signal("update_billboard", text, seconds)

func get_feet():
	return (Global.distance - Global.playerStartingPosition) / 12

func get_player() -> Node:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() <= 0:
		push_error("No players?!")
		return null
	return players[0]

func get_camera() -> Camera2D:
	var camera: Camera2D = get_node("/root/Game/Camera2D")
	if camera == null:
		camera = get_tree().get_root().find_node("Camera2D", true, false)
	return camera

func get_base_node() -> Node:
	var root = get_tree().get_root()
	var node = root.find_node("Game", true, false)
	if node == null:
		node = root.find_node("MainMenu", true, false)
	return node
