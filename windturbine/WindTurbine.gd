extends Node2D

const SPEED = 1.3*TAU

func _process(delta):
	$Blade.rotate(SPEED * delta)

func _on_Blade_body_entered(body):
	print(body)
	Global.emit_signal("windturbine_hit")
	$HitSound.play()
	
	$Tween.interpolate_property(self, "scale:x", 1.1, 1.0, 0.2, Tween.TRANS_CUBIC)
	$Tween.interpolate_property($Blade/Blade, "modulate", Color(1,0,0,1), Color(1,1,1,1), 0.2, Tween.TRANS_CUBIC)
	$Tween.start()
	
	#Global.emit_signal("player_died")
