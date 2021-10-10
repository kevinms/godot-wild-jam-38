extends KinematicBody2D

const MAX_DISTANCE = 550
const SPEED = 900

var dir: Vector2
var gun: Node2D

var attached: bool = false
var attached_length: float = 0
var attached_pos: Vector2
var attached_node: Node2D = null
var attached_node_pos: Vector2

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
		var offset = attached_node.global_position - attached_node_pos
		global_position = attached_pos + offset
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
		attached_pos = global_position
		attached_length = (global_position - gun.global_position).length()
		attached_node = collided.collider
		attached_node_pos = attached_node.global_position
