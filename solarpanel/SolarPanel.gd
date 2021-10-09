extends Area2D

var clean = false

func get_size_in_pixels() -> Vector2:
	return $CollisionShape2D.get_shape().get_extents()*2

func _ready():
	$CleanSound.register_sound(preload("res://sfx/Cleaning1.mp3"))
	$CleanSound.register_sound(preload("res://sfx/Cleaning2.mp3"))
	$CleanSound.register_sound(preload("res://sfx/Cleaning3.mp3"))
	$CleanSound.register_sound(preload("res://sfx/Cleaning4.mp3"))
	$CleanSound.register_sound(preload("res://sfx/Cleaning5.mp3"))

func _on_SolarPanel_body_entered(body):
	if clean:
		return
	clean = true
	
	Global.clean += 1
	$CleanSound.play()
