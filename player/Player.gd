extends KinematicBody2D

const MAX_SPEED = 200
const ACCELERATION = 550 #450
const JUMP_SPEED = 400 #300
const WALL_JUMP_SPEED = 300
const GRAVITY = 800
const FRICTION = 15
const AIR_FRICTION = 10

var velocity = Vector2.ZERO

func get_input_dir():
	var dir = Vector2.ZERO
	
	if Input.is_action_pressed("left"):
		dir += Vector2.LEFT
	if Input.is_action_pressed("right"):
		dir += Vector2.RIGHT
	
	return dir.normalized()

func _process(delta):
	if Input.is_action_just_pressed("fire"):
		print("grapple!")
		$GrappleGun.fire()
	if Input.is_action_just_released("fire"):
		$GrappleGun.release()
	
	var dir = get_input_dir()
	
	# Friction
	if dir == Vector2.ZERO:
		if is_on_floor():
			velocity.x -= FRICTION * delta * velocity.x
		else:
			if !$GrappleGun.is_attached():
				#velocity.x -= AIR_FRICTION * delta * velocity.x
				pass
	
	velocity += ACCELERATION * delta * dir
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	
	# Instant max speed
	#velocity.x = dir.x * MAX_SPEED
	
	velocity.y += GRAVITY * delta
	
	# Spring
	#velocity += $GrappleGun.compute_spring_force() * delta
	
	# Rope
	velocity += $GrappleGun.compute_rope_force(velocity)
	#if $GrappleGun.is_attached():
	#	velocity *= 1.01
	
	velocity = move_and_slide(velocity, Vector2.UP, true)
	
	if is_on_wall() and !$GrappleGun.is_attached():
		velocity.y = 0
	
	# Jump
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			print("on ground")
			velocity.y -= JUMP_SPEED
			$JumpSound.play()
		elif is_on_wall():
			print("on wall")
			var wall_normal = Vector2.RIGHT
			if $RayCastRight1.is_colliding() or $RayCastRight2.is_colliding() or $RayCastRight3.is_colliding():
				print("right wall")
				wall_normal = Vector2.LEFT
			var jump_dir = Vector2.UP + wall_normal * 0.3
			velocity = WALL_JUMP_SPEED * jump_dir
			$JumpSound.play()
