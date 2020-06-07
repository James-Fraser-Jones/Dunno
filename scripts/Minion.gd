extends KinematicBody2D

enum Team {BLUE, RED}
enum Lane {TOP, MID, BOT}

func lane_to_string(lane) -> String:
	var name: String
	match lane:
		Lane.TOP: name = "Top"
		Lane.MID: name = "Mid"
		Lane.BOT: name = "Bot"
	return name

#implementation variables
var path_goal_dist: float = 0
var path_dist_inc: float = 128
var path: PathFollow2D
var path_goal: Vector2

#environment variables
export var team = Team.BLUE
export var lane = Lane.MID
var minion_speed: float = 200.0
var minion_turn_speed: float = 10 / PI
var max_health: float = 100

#state variables
var current_health: float = max_health

func _ready() -> void:
	path = get_node("/root/Main/" + lane_to_string(lane)).get_child(0)
	path.unit_offset = 0
	if team == Team.RED:
		path.unit_offset = 1
		path_dist_inc = -path_dist_inc
		$Sprite.modulate = Color(1,0,0)
	position = path.position
	new_path_goal()
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("right_click"):
		position = get_global_mouse_position()
	
	var diff: Vector2 = path_goal - position
	var mag: float = minion_speed * delta
	var length: float = diff.length()
	if length <= mag:
		position = path_goal
		mag -= length
		new_path_goal()
		diff = path_goal - position
	position += diff.normalized() * mag
	#move_and_collide(diff.normalized() * mag)
	
	var rot_diff: float = Vector2(cos(rotation - PI/2), sin(rotation - PI/2)).angle_to(diff)
	var rot_mag: float = minion_turn_speed * delta
	rotate(clamp(rot_diff, -rot_mag, rot_mag))
		
func new_path_goal():
	path_goal_dist += path_dist_inc
	path.offset = path_goal_dist
	path_goal = path.position			

