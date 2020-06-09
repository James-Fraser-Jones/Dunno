extends KinematicBody2D

#enums
enum Team {BLUE, RED, NEUTRAL}
enum Type {MELEE, RANGED}
enum Action {IDLE, MOVING, ATTACKING}

#environment variables
var team: int
var type: int

var max_speed: float
var max_turn_speed: float
var max_level: int

var size_radius: float

var health_base: float
var health_per_level: float
var damage_base: float
var damage_per_level: float
var attack_speed_base: float
var attack_speed_per_level: float

#references
onready var nav: Navigation2D = get_node("/root/Main/Navigation2D")

#state variables
var level: int = 1
var action: int = 0
var health: float = health_base + level * health_per_level
var damage: float = damage_base + level * damage_per_level
var attack_speed: float = attack_speed_base + level * attack_speed_per_level

var nav_path: PoolVector2Array = PoolVector2Array()

func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	match action:
		Action.IDLE:
			pass
		Action.MOVING:
			#move towards target
			pass
		Action.ATTACKING:
			pass

func move_pathfind(desired: Vector2) -> void:
	nav_path = nav.get_simple_path(position, desired) #TODO: set NavigationPolygonInstance based on size_radius

func move_linear(desired: Vector2, delta: float) -> void:
	move_and_collide((desired - position).normalized() * max_speed * delta) #TODO: implement collision behavior


