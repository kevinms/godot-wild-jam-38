extends Node2D

var paused = false

#TODO: switch from custom mouse cursor to always centered cursor
onready var cursor = preload("res://ui/cursor.png")

func _ready():
	#Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, Vector2(1,1))
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Panel/Settings/Fullscreen.pressed = OS.window_fullscreen
	$Panel/Settings/Volume.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	
	hide()

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

func toggle():
	if !is_visible():
		pause()
	else:
		play()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		print("hello")
		toggle()

func _on_Resume_pressed():
	play()

func _on_Volume_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)

func _on_Fullscreen_toggled(button_pressed):
	OS.window_fullscreen = button_pressed
