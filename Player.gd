extends MeshInstance

export var player_speed: float = 35

var old_pos: Vector2 = Vector2(0,0)
var new_pos: Vector2 = Vector2(0,0)
var total_distance: float = 0
var distance: float = 0

const ray_length = 1000
		
func _physics_process(delta):
	if Input.is_action_just_pressed("right_click"):
		#Get refs
		var root: Viewport = get_node("/root")
		var mouse_position: Vector2 = root.get_mouse_position()
		var panning_camera: Camera = get_node("/root/Main/Panning_Camera")
		#Calculate vectors
		var from: Vector3 = panning_camera.project_ray_origin(mouse_position)
		var to: Vector3 = panning_camera.project_ray_normal(mouse_position) * ray_length
		#Create ray and add to the scene
		var ray: RayCast = RayCast.new()
		root.add_child(ray)
		#Cast ray and get collision
		ray.translation = from
		ray.cast_to = to
		ray.force_raycast_update()
		if ray.is_colliding():
			old_pos = Vector2(self.translation.x, self.translation.z)
			new_pos = Vector2(ray.get_collision_point().x, ray.get_collision_point().z)
			total_distance = (new_pos - old_pos).length()
			distance = 0
		#Remove ray
		root.remove_child(ray)
		ray.free()
	
	if old_pos != new_pos:
		distance += player_speed*delta/total_distance
		distance = clamp(distance, 0, 1)
		var trans = old_pos + (new_pos - old_pos)*distance
		self.translation = Vector3(trans.x, 1.5, trans.y)
		if distance == 1:
			total_distance = 0
			distance = 0
			old_pos = new_pos
