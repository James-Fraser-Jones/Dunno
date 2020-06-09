extends KinematicBody2D

enum Team {BLUE, RED, NEUTRAL}
enum Type {MELEE, RANGED}

#environment variables
var team: int
var type: int
var max_speed: float
var max_turn_speed: float
var max_health: float
var size_radius: float

#references
onready var nav: Navigation2D = get_node("/root/Main/Navigation2D")

#state variables
var level: int = 1
var health: float = max_health
var nav_path: PoolVector2Array = PoolVector2Array()

func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	pass

func move_pathfind(desired: Vector2) -> void:
	nav_path = nav.get_simple_path(position, desired) #TODO: set NavigationPolygonInstance based on size_radius

func move_steer(desired: Vector2) -> Vector2:
	return desired #TODO: implement obstacle avoidance steering behavior

func move_linear(desired: Vector2, delta: float) -> void:
	move_and_collide((desired - position).normalized() * max_speed * delta) #TODO: implement collision behavior


