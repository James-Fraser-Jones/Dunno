extends Node2D

export var debug_window: bool = false

func _ready() -> void:
	if debug_window:
		OS.window_borderless = false
		OS.window_size = Vector2(1024, 600)

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
