extends KinematicBody2D

const MAX_DISTANCE = 250
const SPEED = 600

var dir: Vector2
var gun: Node2D

var attached: bool = false
var attached_length: float = 0

signal hook_missed

func release():
	print("hook: released")
	queue_free()

func _process(delta):
	$Line2D.clear_points()
	$Line2D.add_point(to_local(gun.global_position))
	$Line2D.add_point(to_local(global_position))
	$Line2D.width = 20
	
	if attached:
		return
	
	var distance = (global_position - gun.global_position).length()
	if distance > MAX_DISTANCE:
		print("hook: max distance")
		emit_signal("hook_missed")
		return
	
	var collided = move_and_collide(dir * SPEED * delta)
	
	if collided != null:
		$HitSound.play()
		attached = true
		attached_length = (global_position - gun.global_position).length()
