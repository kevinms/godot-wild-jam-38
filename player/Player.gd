extends KinematicBody2D

const MAX_SPEED = 200
const MAX_SHAKE_SPEED = 1500
const ACCELERATION = 550 #450
const JUMP_SPEED = 400 #300
const WALL_JUMP_SPEED = 500
const GRAVITY = 800
const FRICTION = 15
const AIR_FRICTION = 10

const NUM_AIR_JUMPS = 1
var air_jumps_left = NUM_AIR_JUMPS

var velocity = Vector2.ZERO

onready var camera = Global.get_camera()

func get_input_dir():
	var dir = Vector2.ZERO
	
	if Input.is_action_pressed("left"):
		dir += Vector2.LEFT
		$Node2D.scale.x = -1
	elif Input.is_action_pressed("right"):
		dir += Vector2.RIGHT
		$Node2D.scale.x = 1
	
	if !Input.is_action_just_pressed("jump") and is_on_floor():
		if Input.is_action_pressed("left"):
				$AnimationTree.set("parameters/action/current",1)
		elif Input.is_action_pressed("right"):
				$AnimationTree.set("parameters/action/current",1)
		else:
				$AnimationTree.set("parameters/action/current",0)
	if !is_on_floor() and !is_on_wall():
		$AnimationTree.set("parameters/action/current",2)
	
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
	
	# Only apply input acceleration if velocity is below max
	# Or, if apply in the opposite direction of acceleration
	if abs(velocity.x) < MAX_SPEED or sign(velocity.x) != sign(dir.x):
		#print("accelerating: ", velocity.x)
		var scale_accel = 2.0 if $GrappleGun.is_attached() else 1.0
		velocity += ACCELERATION * scale_accel * delta * dir
	# Blanket clamping messes up the grappling hook
	#velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	
	# Instant max speed
	#velocity.x = dir.x * MAX_SPEED
	
	velocity.y += GRAVITY * delta
	
	# Rope
	velocity += $GrappleGun.compute_rope_force(velocity)
	
	# Spring
	velocity += $GrappleGun.compute_spring_force() * 10.0 * delta
	
	velocity = move_and_slide(velocity, Vector2.UP, true)
	
	if get_slide_count() > 0:
		air_jumps_left = NUM_AIR_JUMPS
	
	shake_camera()
	
	if is_on_wall() and !$GrappleGun.is_attached():
		velocity.y = 0
		$AnimationTree.set("parameters/action/current",3)
	
	# Jump
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			$AnimationTree.set("parameters/action/current",2)
			print("on ground")
			# Straight up
			#velocity.y -= JUMP_SPEED
			# Up and to the dir
			velocity += (dir*0.3 + Vector2.UP).normalized() * JUMP_SPEED
			$JumpSound.play()
			#camera.add_trauma(0.2)
		elif is_on_wall():
			$AnimationTree.set("parameters/action/current",4)
			print("on wall")
			var wall_normal = Vector2.RIGHT
			if $RayCastRight1.is_colliding() or $RayCastRight2.is_colliding() or $RayCastRight3.is_colliding():
				print("right wall")
				wall_normal = Vector2.LEFT
			var jump_dir = Vector2.UP + wall_normal * 0.3
			velocity = WALL_JUMP_SPEED * jump_dir
			$JumpSound.play()
			#camera.add_trauma(0.2)
		elif Input.is_action_just_pressed("jump") and air_jumps_left > 0:
			$AnimationTree.set("parameters/action/current",2)
			print("on air")
			velocity.y = min(0, velocity.y) - JUMP_SPEED
			$JumpSound.play()
			air_jumps_left -= 1
			
			



			
	

var was_in_air = false
var was_velocity: Vector2
func shake_camera():
	if get_slide_count() > 0:
	#if is_on_floor():
		if was_in_air:
			camera.add_trauma(was_velocity.length() / MAX_SHAKE_SPEED)
		was_in_air = false
	else:
		was_in_air = true
	was_velocity = velocity
