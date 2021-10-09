extends StaticBody2D

func get_size_in_pixels() -> Vector2:
	return $CollisionShape2D.get_shape().get_extents()*2
