tool
extends Node2D

export var color: Color = Color.white setget colorH
export var offset: Vector2 = Vector2.ZERO setget offsetH
export var radius: float = 0 setget radiusH

func colorH(c):
	color = c
	update()
	
func offsetH(o):
	offset = o
	update()

func radiusH(r):
	radius = r
	update()

func _draw() -> void:
	draw_circle(position + offset, radius, color)
