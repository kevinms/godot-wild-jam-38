extends Node2D

const SPEED = 1.3*TAU

func _process(delta):
	$Blade.rotate(SPEED * delta)

func _on_Blade_body_entered(body):
	print(body)
	Global.emit_signal("windturbine_hit")
	#Global.emit_signal("player_died")
