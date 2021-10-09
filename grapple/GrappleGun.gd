extends Sprite

onready var hook_scene = preload("res://grapple/Hook.tscn")
var hook = null

const SPRING_CONSTANT = 20
const MAX_FORCE = 2000

func compute_force() -> Vector2:
	if hook == null or !hook.hooked:
		return Vector2.ZERO
	
	var displacement = hook.global_position - global_position
	var f = SPRING_CONSTANT * displacement
	
	if f.length() > MAX_FORCE:
		f = displacement.normalized() * MAX_FORCE
	
	return f

func fire():
	if hook != null:
		return
	
	hook = hook_scene.instance()
	#get_parent().add_child(hook)
	var root = get_node("/root/Game")
	root.add_child(hook)
	
	hook.dir = (get_global_mouse_position() - global_position).normalized()
	hook.gun = self
	hook.global_position = global_position
	
	hook.connect("hook_missed", self, "on_hook_missed")

func release():
	if hook == null:
		return
	hook.release()
	hook = null

func on_hook_missed():
	release()

func _process(delta):
	pass
