extends Camera

#Environment Variables
export var scroll_threshold: float = 70
export var camera_speed: float = 40
export var normalize: bool = true

export var zoom_speed: float = 2
export var zoom_falloff: float = 4

export var fov_speed: float = 5

#State Variables
var zoom: float = 0

func _physics_process(delta: float) -> void:
	#Collect variables
	var root: Viewport = get_node("/root")
	var mouse_position: Vector2 = root.get_mouse_position()
	var viewport_size: Vector2 = root.size
	#Calculate panning vector
	var udlr: Vector2 = Vector2(0,0)
	if mouse_position.x < scroll_threshold:
		udlr.x = mouse_position.x/scroll_threshold - 1
	elif viewport_size.x - mouse_position.x < scroll_threshold:
		udlr.x = 1 - (viewport_size.x - mouse_position.x)/scroll_threshold
	if mouse_position.y < scroll_threshold:
		udlr.y = mouse_position.y/scroll_threshold - 1
	elif viewport_size.y - mouse_position.y < scroll_threshold:
		udlr.y = 1 - (viewport_size.y - mouse_position.y)/scroll_threshold
	if normalize and udlr.length() > 1:
		udlr = udlr.normalized()
	#Calculate zoom
	if Input.is_action_just_released("wheel_up"):
		zoom += zoom_speed
	elif Input.is_action_just_released("wheel_down"):
		zoom -= zoom_speed
	var zoom_chunk: float = zoom * zoom_falloff * delta	
	zoom -= zoom_chunk
	#Apply pan and zoom
	self.global_translate(Vector3(udlr.x, 0, udlr.y) * delta * camera_speed)
	self.translate(Vector3(0, 0, -zoom_chunk))
	
	#For changing FOV
	var lr: int = 0
	if Input.is_key_pressed(KEY_O):
		lr -= 1
	if Input.is_key_pressed(KEY_P):
		lr += 1
	if lr != 0:
		self.fov += fov_speed*delta*lr
		print(self.fov)
