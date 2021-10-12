extends AudioStreamPlayer

export(bool) var modulate_pitch = false
export(bool) var use_library = true

var library = []

func register_sound(sound):
	library.append(sound)

func play(from_position: float = 0.0):
	if modulate_pitch:
		pitch_scale = rand_range(1.0, 1.1)
	
	if use_library:
		if library.size() <= 0:
			push_error("Attempting to play from empty library")
			return
		
		var index = randi() % library.size()
		stream = library[index]
	
	.play(from_position)
