extends KinematicBody2D

const GRAVITY = 800

var popped = false
var velocity = Vector2.ZERO
export(bool) var respawn = false

onready var initial_position = global_position
onready var initial_collision_layer = $BalloonArea.collision_layer
onready var initial_collision_mask = $BalloonArea.collision_mask

func reset():
	$"balloon-cloth".visible = true
	#$BalloonArea.monitoring = true
	#$BalloonArea.monitorable = true
	$BalloonArea.collision_layer = initial_collision_layer
	$BalloonArea.collision_mask = initial_collision_mask
	popped = false
	$AnimationTree.set("parameters/transition/current",0)
	global_position = initial_position
	velocity = Vector2.ZERO

func _process(delta):
	if popped:
		velocity += Vector2.DOWN * GRAVITY * delta
		velocity = move_and_slide(velocity, Vector2.UP, false)
		if get_slide_count() > 0:
			$AnimationTree.set("parameters/transition/current",1)
		#collision = move_and_collide(velocity)

func _on_BalloonArea_body_entered(body: Node):
	print("body entered: ", body.name)
	
	if !body.is_in_group("hook"):
		return
	
	$"balloon-cloth".visible = false
	#$BalloonArea.monitoring = false
	#$BalloonArea.monitorable = false
	$BalloonArea.collision_layer = 0
	$BalloonArea.collision_mask = 0
	popped = true
	
	$PopSound.play()
	
	if respawn:
		yield(get_tree().create_timer(3.0), "timeout")
		reset()
