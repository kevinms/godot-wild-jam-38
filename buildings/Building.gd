extends StaticBody2D

onready var panel_scene = preload("res://solarpanel/SolarPanel.tscn")

func get_size_in_pixels() -> Vector2:
	return $CollisionShape2D.get_shape().get_extents()*2

func _ready():
	var building_size = get_size_in_pixels()
	
	var panel = panel_scene.instance()
	var panel_size = panel.get_size_in_pixels()
	panel.queue_free()
	
	var panel_half_size = panel_size / 2
	
	# Distribute the panels across the width at the height
	var start = -building_size / 2 + Vector2(0, -panel_half_size.y)
	var end = start + Vector2(building_size.x - panel_size.x, 0)
	
	var per_panel = panel_size.x * 1.3
	var panel_count = building_size.x / per_panel
	var margin = fmod(building_size.x, per_panel) / 2
	
	for i in range(panel_count):
		var pos = start
		pos.x += margin + per_panel*i + per_panel/2
		panel = panel_scene.instance()
		add_child(panel)
		panel.position = pos
