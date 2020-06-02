extends Camera2D

#Environment Variables
export var scroll_threshold: float = 70
export var camera_speed: float = 800
export var normalize: bool = true

export var zoom_inc: float = .1
export var zoom_falloff: float = 5

#State Variables
var zoom_left: float = 0

func _physics_process(delta: float) -> void:
	#Panning
	var root: Viewport = get_node("/root")
	var mouse_position: Vector2 = root.get_mouse_position()
	var viewport_size: Vector2 = root.size
	
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
	self.global_translate(udlr * delta * camera_speed)
	
	#Zoom
	if Input.is_action_just_released("wheel_up"):
		zoom_left += zoom_inc
	elif Input.is_action_just_released("wheel_down"):
		zoom_left -= zoom_inc
	var zoom_chunk: float = zoom_left * zoom_falloff * delta
	zoom -= Vector2(zoom_chunk, zoom_chunk)
	zoom_left -= zoom_chunk
	
