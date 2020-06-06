extends KinematicBody2D

#Evironment variables
export var player_speed: float = 400

#State variables
var path: PoolVector2Array = PoolVector2Array()
var path_length: float = 0
var progress: float = 0

var target: Vector2

#References
onready var nav: Navigation2D = get_node("/root/Main2D/Navigation2D")

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("right_click"):
		target = get_global_mouse_position()
	if (target - position).length() < 10: 
		position = target
	if target: move_and_slide((target - position).normalized() * player_speed)
	#rotation =
	#	path = nav.get_simple_path(position, get_global_mouse_position(), true)
	#	path_length = vector_array_length(path)
	#	progress = 0
	#	
	#if !path.empty():
	#	if position == path[path.size() - 1]: #you've arrived at your destination
	#		path = PoolVector2Array()
	#		path_length = 0
	#		progress = 0
	#	else: #move a bit 
	#		progress += (player_speed / path_length) * delta
	#		var new_pos: Vector2 = interpolate_vector_array(progress, path, path_length)
	#		var new_rot: float = (new_pos - position).angle() + PI/2
	#		position = new_pos
	#		rotation = new_rot

#Takes a progress value between 0 and 1
#And a PoolVector2Array produced by Navigation2D's "get_simple_path" method
#And the length of the path through the points in this array (can be obtained with "vector_array_length" method below)
#Returns a point along the path through these points with distance from first point proportional to "progress" value
func interpolate_vector_array(progress: float, arr: PoolVector2Array, arr_length: float) -> Vector2:
	#Handle edge cases first
	progress = clamp(progress, 0, 1)
	if progress == 0:
		return arr[0]
	elif progress == 1:
		return arr[arr.size() - 1]
	
	var current_vector: Vector2
	var proportional_length: float
	for i in range(arr.size()-1):
		current_vector = arr[i+1] - arr[i]
		proportional_length = current_vector.length() / arr_length
		if progress > proportional_length:
			progress -= proportional_length
		else:
			return arr[i] + current_vector * (progress / proportional_length)

	return Vector2(-1, -1) #This should never happen

#Takes a PoolVector2Array produced by Navigation2D's "get_simple_path" method
#Returns the cumulative length of the path through all points in the array
func vector_array_length(arr: PoolVector2Array) -> float:
	var length: float = 0
	for i in range(arr.size()-1):
			length += arr[i].distance_to(arr[i+1])
	return length
