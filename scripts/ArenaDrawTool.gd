tool
extends Node2D

export var arena_size: float = 2048

export var river_width: float = 200
export var river_color: Color = Color(0,0,1)

export var lane_width: float = 200
export var lane_curve: float = 500
export var lane_color: Color = Color(1,1,0)

export var base_radius: float = 600
export var base_color: Color = Color(0,1,1)

export var fountain_radius: float = 128
export var fountain_color: Color = Color(1,1,1)
	
export var draw: bool = false setget drawH

func drawH(_b):
	if Engine.is_editor_hint():
		update()
		
func _draw() -> void:
	#river
	var r: float = river_width/sqrt(2)
	var river_poly: Array = [Vector2(0,0), Vector2(r,0), Vector2(arena_size,arena_size-r), Vector2(arena_size,arena_size), Vector2(arena_size-r,arena_size), Vector2(0,r)]
	draw_polygon(PoolVector2Array(river_poly), PoolColorArray([river_color]))
	#mid
	var m: float = lane_width/sqrt(2)
	var mid_poly: Array = [Vector2(0,arena_size), Vector2(0,arena_size-m), Vector2(arena_size-m,0), Vector2(arena_size,0), Vector2(arena_size,m), Vector2(m,arena_size)]
	draw_polygon(PoolVector2Array(mid_poly), PoolColorArray([lane_color]))
	#top
	draw_circle_arc_poly(Vector2(lane_curve, lane_curve), lane_curve-lane_width, lane_curve, 270, 360, lane_color)
	draw_rect(Rect2(Vector2(0, lane_curve), Vector2(lane_width, arena_size-lane_curve)), lane_color)
	draw_rect(Rect2(Vector2(lane_curve, 0), Vector2(arena_size-lane_curve, lane_width)), lane_color)
	#bottom
	draw_circle_arc_poly(Vector2(arena_size-lane_curve, arena_size-lane_curve), lane_curve-lane_width, lane_curve, 90, 180, lane_color)
	draw_rect(Rect2(Vector2(0, arena_size-lane_width), Vector2(arena_size-lane_curve,lane_width)), lane_color)
	draw_rect(Rect2(Vector2(arena_size-lane_width, 0), Vector2(lane_width,arena_size-lane_curve)), lane_color)
	#bases
	draw_circle_arc_poly(Vector2(0,arena_size), 0, base_radius, 0, 90, base_color)
	draw_circle_arc_poly(Vector2(arena_size, 0), 0, base_radius, 180, 270, base_color)
	#fountains
	draw_circle(Vector2(0, arena_size), fountain_radius, fountain_color)
	draw_circle(Vector2(arena_size, 0), fountain_radius, fountain_color)
	

func draw_circle_arc_poly(center, inner_radius, outer_radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()
	var colors = PoolColorArray([color])
	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * outer_radius)
	if inner_radius > 0:
		for j in range(nb_points + 1):
			var angle_point = deg2rad(angle_from + (nb_points - j) * (angle_to - angle_from) / nb_points - 90)
			points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * inner_radius)
	else:
		points_arc.push_back(center)
	draw_polygon(points_arc, colors)
