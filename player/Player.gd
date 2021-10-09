extends KinematicBody2D

const MAX_SPEED = 200
const ACCELERATION = 450
const JUMP_SPEED = 400 #300
const GRAVITY = 800
const FRICTION = 15

var velocity = Vector2.ZERO

func get_input_dir():
	var dir = Vector2.ZERO
	
	if Input.is_action_pressed("left"):
		dir += Vector2.LEFT
	if Input.is_action_pressed("right"):
		dir += Vector2.RIGHT
	
	return dir.normalized()

func _process(delta):
	var dir = get_input_dir()
	
	# Friction
	if dir == Vector2.ZERO:
		if is_on_floor():
			velocity.x -= FRICTION * delta * velocity.x
		else:
			# Air friction?
			pass
	
	velocity += ACCELERATION * delta * dir
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	
	# Instant max speed
	#velocity.x = dir.x * MAX_SPEED
	
	velocity.y += GRAVITY * delta
	
	velocity = move_and_slide(velocity, Vector2.UP, true)

	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y -= JUMP_SPEED
			$JumpSound.play()
		if is_on_wall():
			#TODO: wall jump
			pass
