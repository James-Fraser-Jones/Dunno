extends KinematicBody2D

#const target: Vector2 = Vector2(1291, 466)
const minion_speed: float = 100.0
const threshold: float = 80.0

var max_health: float = 100

func _physics_process(_delta: float) -> void:
	var target = get_global_mouse_position()
	var dir: Vector2 = target - position
	move_and_slide(Vector2.ZERO)
	#if dir.length() > threshold:
	#	move_and_slide(dir.normalized() * minion_speed)
