extends Node2D

func _ready():
	#visible = false
	Global.connect("update_billboard", self, "display")

onready var initial_pos = $Board.position

func display(text, time = 4.0):
	$Board/Text.text = text
	
	# Reset things
	#visible = true
	#$Tween.reset_all()
	$Tween.remove_all()
	modulate.a = 0.0
	scale = Vector2.ONE
	
	
	# Animate
	$Tween.interpolate_property(self, "modulate:a", 0.0, 1.0, 0.1, Tween.TRANS_LINEAR)
	$Tween.interpolate_property($Board, "position", initial_pos + Vector2.LEFT*1000, initial_pos, 0.5, Tween.TRANS_LINEAR)
	$Tween.start()
	yield(get_tree().create_timer(time), "timeout")
	$Tween.interpolate_property(self, "modulate:a", 1.0, 0.0, 0.5, Tween.TRANS_LINEAR)
	$Tween.interpolate_property(self, "scale:x", 1.0, 0.0, 0.5, Tween.TRANS_LINEAR)
	$Tween.start()
