extends Node2D

enum Team {BLUE, RED}
enum Lane {TOP, MID, BOT}
enum Action {IDLE, MOVING, ATTACKING}

func lane_to_string(lane) -> String:
	var name: String
	match lane:
		Lane.TOP: name = "Top"
		Lane.MID: name = "Mid"
		Lane.BOT: name = "Bot"
	return name

#implementation variables
var path_dist_inc: float
var path_goal_dist: float
var path: PathFollow2D
var path_goal: Vector2

#environment variables
export var team: int = Team.BLUE
export var lane: int = Lane.TOP
var action: int = Action.IDLE
var speed: float = 200.0
var max_health: float = 100

#state variables
var current_health: float = max_health

func _ready() -> void:
	if team == Team.BLUE:
		set_modulate(Color.blue)
		path_dist_inc = 512
	else:
		set_modulate(Color.red)
		path_dist_inc = -512
	path = get_node("/root/Main/ArenaDrawTool/" + lane_to_string(lane)).get_child(0)
	path.unit_offset = 0 if team == Team.BLUE else 1
	position = path.position
	new_path_goal()
	action = Action.MOVING
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("right_click"):
		position = get_global_mouse_position()
	
	if action == Action.MOVING:
		var diff: Vector2 = path_goal - position
		var mag: float = speed * delta
		var length: float = diff.length()
		if length <= mag:
			position = path_goal
			mag -= length
			new_path_goal()
			diff = path_goal - position
		position += diff.normalized() * mag
		$Sprite.rotation = diff.angle()
		
func new_path_goal():
	path_goal_dist += path_dist_inc
	path.offset = path_goal_dist
	path_goal = path.position
