extends KinematicBody2D

const MAX_SPEED = 200
const MAX_SHAKE_SPEED = 1500
const ACCELERATION = 550 #450
const JUMP_SPEED = 400
const WALL_JUMP_SPEED = 500
const GRAVITY = 800
const FRICTION = 15
const AIR_FRICTION = 10

const NUM_AIR_JUMPS = 1
var air_jumps_left = NUM_AIR_JUMPS

var velocity = Vector2.ZERO
var freeze = false

onready var camera = Global.get_camera()
onready var GrappleGun = $Node2D/GrappleGun
onready var puff_scene = preload("res://player/CloudPuff.tscn")

func _ready():
	#$JumpSound.register_sound(preload("res://sfx/Jump1.mp3"))
	#$JumpSound.register_sound(preload("res://sfx/Jump2.mp3"))
	#$JumpSound.register_sound(preload("res://sfx/Jump3.mp3"))
	#$JumpSound.register_sound(preload("res://sfx/Jump4.mp3"))
	#$JumpSound.register_sound(preload("res://sfx/Jump5.mp3"))
	
	Global.connect("windturbine_hit", self, "on_windturbine_hit")

func on_windturbine_hit():
	velocity = (Vector2.RIGHT + Vector2.UP) * 1000.0
	$AnimationTree.set("parameters/action/current",8)

func spawn_cloud_puff():
	var puff = puff_scene.instance()
	#Global.get_base_node().add_child(puff)
	#puff.global_position = $PuffSpawn.global_position
	$PuffSpawn.add_child(puff)

func portal_warp():
	freeze = true
	reset()
	$AnimationTree.set("parameters/action/current",8)

func reset():
	velocity = Vector2.ZERO
	air_jumps_left = NUM_AIR_JUMPS

func get_input_dir():
	var dir = Vector2.ZERO
	
	if Global.game_over:
		return dir
	
	if Input.is_action_pressed("left"):
		dir += Vector2.LEFT
		$Node2D.scale.x = -1
	elif Input.is_action_pressed("right"):
		dir += Vector2.RIGHT
		$Node2D.scale.x = 1
	
	if dir.length() > 0.0:
		Global.player_moved = true
	
	if !Input.is_action_just_pressed("jump") and is_on_floor():
		if Input.is_action_pressed("left"):
				$AnimationTree.set("parameters/action/current",1)
		elif Input.is_action_pressed("right"):
				$AnimationTree.set("parameters/action/current",1)
		else:
				$AnimationTree.set("parameters/action/current",0)
	if !is_on_floor() and !is_on_wall():
		if velocity.y < 0: 
			$AnimationTree.set("parameters/action/current",2)
		if velocity.y > 0: 
			$AnimationTree.set("parameters/action/current",6)
	
	return dir.normalized()

func _process(delta):
	if freeze:
		return
	
	if Input.is_action_just_pressed("fire"):
		print("grapple!")
		GrappleGun.fire()
	if Input.is_action_just_released("fire"):
		GrappleGun.release()
	
	var dir = get_input_dir()
	
	# Friction
	if dir == Vector2.ZERO:
		if is_on_floor():
			velocity.x -= FRICTION * delta * velocity.x
		else:
			if !GrappleGun.is_attached():
				#velocity.x -= AIR_FRICTION * delta * velocity.x
				pass
	
	# Only apply input acceleration if velocity is below max
	# Or, if apply in the opposite direction of acceleration
	if abs(velocity.x) < MAX_SPEED or sign(velocity.x) != sign(dir.x):
		#print("accelerating: ", velocity.x)
		var scale_accel = 2.0 if GrappleGun.is_attached() else 1.0
		velocity += ACCELERATION * scale_accel * delta * dir
	# Blanket clamping messes up the grappling hook
	#velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	
	# Instant max speed
	#velocity.x = dir.x * MAX_SPEED
	
	velocity.y += GRAVITY * delta
	
	# Rope
	velocity += GrappleGun.compute_rope_force(velocity)
	
	# Spring
	velocity += GrappleGun.compute_spring_force() * 10.0 * delta
	
	velocity = move_and_slide(velocity, Vector2.UP, true)
	
	if get_slide_count() > 0:
		air_jumps_left = NUM_AIR_JUMPS
	
	shake_camera()
	
	if is_on_wall() and !GrappleGun.is_attached():
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
			spawn_cloud_puff()
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
			spawn_cloud_puff()
			#camera.add_trauma(0.2)
		elif Input.is_action_just_pressed("jump") and air_jumps_left > 0:
			$AnimationTree.active = false
			$AnimationTree.active = true
			$AnimationTree.set("parameters/action/current",2)
			print("on air")
			velocity.y = min(0, velocity.y) - JUMP_SPEED
			$JumpSound.play()
			#spawn_cloud_puff()
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
