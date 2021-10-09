extends AudioStreamPlayer

var library = []

func register_sound(sound):
	library.append(sound)

func play(from_position: float = 0.0):
	if library.size() <= 0:
		return
	
	var index = randi() % library.size()
	stream = library[index]
	
	.play(from_position)
