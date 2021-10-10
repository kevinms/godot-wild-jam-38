extends Area2D

var clean = false

func get_size_in_pixels() -> Vector2:
	#return $CollisionShape2D.get_shape().get_extents()*2
	var size = $AnimatedSprite.frames.get_frame("default", 0).get_size() * $AnimatedSprite.scale
	print(size)
	return size

func _ready():
	$CleanSound.register_sound(preload("res://sfx/Cleaning1.mp3"))
	$CleanSound.register_sound(preload("res://sfx/Cleaning2.mp3"))
	$CleanSound.register_sound(preload("res://sfx/Cleaning3.mp3"))
	$CleanSound.register_sound(preload("res://sfx/Cleaning4.mp3"))
	$CleanSound.register_sound(preload("res://sfx/Cleaning5.mp3"))
	
	$AnimatedSprite.frame = 0

func _on_SolarPanel_body_entered(body):
	if clean:
		return
	clean = true
	
	Global.clean += 1
	$CleanSound.play()
	$AnimatedSprite.frame = 1
	$AnimationPlayer.play("sheen")
	$Particles2D.emitting = true
