extends Node2D

var bar_red = preload("res://assets/barHorizontal_red.bmp")
var bar_green = preload("res://assets/barHorizontal_green.bmp")
var bar_yellow = preload("res://assets/barHorizontal_yellow.bmp")

onready var healthbar = $HealthBar

func _ready():
	if get_parent() and get_parent().get("max_health"):
		healthbar.max_value = get_parent().max_health

func update_healthbar(value):
	healthbar.texture_progress = bar_green
	if value < healthbar.max_value * 0.7:
		healthbar.texture_progress = bar_yellow
	if value < healthbar.max_value * 0.35:
		healthbar.texture_progress = bar_red
	healthbar.value = value
