extends Node2D

var paused = false

#TODO: switch from custom mouse cursor to always centered cursor
#onready var cursor = preload("res://assets/cursor/cursor.png")

func _ready():
	#Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, Vector2(16,16))
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

func pause():
	print('pause')
	get_tree().paused = true
	show()
	#Input.set_custom_mouse_cursor(null, Input.CURSOR_ARROW, Vector2(16,16))
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func play():
	print("play")
	get_tree().paused = false
	hide()
	#Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, Vector2(16,16))
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		print("hello")
		if !is_visible():
			pause()
		else:
			play()

func _on_Resume_pressed():
	play()

func _on_MainMenu_pressed():
	get_tree().change_scene("res://ui/MainMenu.tscn")
	get_tree().paused = false

func _on_Quit_pressed():
	get_tree().quit()
