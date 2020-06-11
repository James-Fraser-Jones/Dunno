tool
extends Node2D

export var arena_size: float = 8192
export var arena_color: Color = Color(0,0.5,0)

export var river_width: float = 1024
export var river_color: Color = Color(0,0,1)

export var lane_width: float = 1024
export var lane_curve: float = 2048
export var lane_color: Color = Color(0.7,0.7,0)
export var corner_color: Color = Color(0,0,0)

export var base_radius: float = 2400
export var team1_color: Color = Color(0.5, 0.5, 1)
export var team2_color: Color = Color(1, 0.5, 0.5)

export var fountain_radius: float = 512
export var fountain_color: Color = Color(0.75,0.75,0.75)

export var path_radius: float = 1024
	
export var draw: bool = false setget drawH
export var make_paths: bool = false setget make_paths

func drawH(_b):
	if Engine.is_editor_hint():
		update()
		
func _draw() -> void:
	#arena
	draw_rect(Rect2(Vector2(0,0), Vector2(arena_size, arena_size)), arena_color)
	#river
	var r: float = river_width/sqrt(2)
	var river_poly: Array = [Vector2(0,0), Vector2(r,0), Vector2(arena_size,arena_size-r), Vector2(arena_size,arena_size), Vector2(arena_size-r,arena_size), Vector2(0,r)]
	draw_polygon(PoolVector2Array(river_poly), PoolColorArray([river_color]))
	#mid
	var m: float = lane_width/sqrt(2)
	var mid_poly: Array = [Vector2(0,arena_size), Vector2(0,arena_size-m), Vector2(arena_size-m,0), Vector2(arena_size,0), Vector2(arena_size,m), Vector2(m,arena_size)]
	draw_polygon(PoolVector2Array(mid_poly), PoolColorArray([lane_color]))
	#top
	draw_rect(Rect2(Vector2(0, 0), Vector2(lane_width, lane_curve)), corner_color)
	draw_rect(Rect2(Vector2(0, lane_curve), Vector2(lane_width, arena_size-lane_curve)), lane_color)
	draw_rect(Rect2(Vector2(0, 0), Vector2(lane_curve, lane_width)), corner_color)
	draw_rect(Rect2(Vector2(lane_curve, 0), Vector2(arena_size-lane_curve, lane_width)), lane_color)
	draw_circle_arc_poly(Vector2(lane_curve, lane_curve), lane_curve-lane_width, lane_curve, 270, 360, lane_color)
	#bottom
	draw_rect(Rect2(Vector2(arena_size-lane_curve, arena_size-lane_width), Vector2(lane_curve,lane_width)), corner_color)
	draw_rect(Rect2(Vector2(0, arena_size-lane_width), Vector2(arena_size-lane_curve,lane_width)), lane_color)
	draw_rect(Rect2(Vector2(arena_size-lane_width, arena_size-lane_curve), Vector2(lane_width,lane_curve)), corner_color)
	draw_rect(Rect2(Vector2(arena_size-lane_width, 0), Vector2(lane_width,arena_size-lane_curve)), lane_color)
	draw_circle_arc_poly(Vector2(arena_size-lane_curve, arena_size-lane_curve), lane_curve-lane_width, lane_curve, 90, 180, lane_color)
	#bases
	draw_circle_arc_poly(Vector2(0,arena_size), 0, base_radius, 0, 90, team1_color)
	draw_circle_arc_poly(Vector2(arena_size, 0), 0, base_radius, 180, 270, team2_color)
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

func make_paths(_b) -> void:
	for node in get_children():
		remove_child(node)
	
	#https://stackoverflow.com/questions/1734745/how-to-create-circle-with-b%C3%A9zier-curves
	var magic_number: float = 0.552284749831
		
	var top_curve: Curve2D = Curve2D.new()
	top_curve.add_point(Vector2(lane_width/2, arena_size - lane_width/2 - path_radius))
	top_curve.add_point(Vector2(lane_width/2, lane_curve), Vector2.ZERO, Vector2(0, -(lane_curve-lane_width/2)*magic_number))
	top_curve.add_point(Vector2(lane_curve, lane_width/2), Vector2(-(lane_curve-lane_width/2)*magic_number, 0), Vector2.ZERO)
	top_curve.add_point(Vector2(arena_size - lane_width/2 - path_radius, lane_width/2))
	add_curve("Top", top_curve)
	
	var mid_curve: Curve2D = Curve2D.new()
	var mr: float = path_radius/sqrt(2)
	mid_curve.add_point(Vector2(lane_width/2 + mr, arena_size - lane_width/2 - mr))
	mid_curve.add_point(Vector2(arena_size - lane_width/2 - mr, lane_width/2 + mr))
	add_curve("Mid", mid_curve)
	
	var bot_curve: Curve2D = Curve2D.new()
	bot_curve.add_point(Vector2(lane_width/2 + path_radius, arena_size - lane_width/2))
	bot_curve.add_point(Vector2(arena_size - lane_curve, arena_size - lane_width/2), Vector2.ZERO, Vector2((lane_curve-lane_width/2)*magic_number, 0))
	bot_curve.add_point(Vector2(arena_size - lane_width/2, arena_size - lane_curve), Vector2(0, (lane_curve-lane_width/2)*magic_number), Vector2.ZERO)
	bot_curve.add_point(Vector2(arena_size - lane_width/2, lane_width/2 + path_radius))
	add_curve("Bot", bot_curve)
	
func add_curve(name: String, curve: Curve2D):
	var path: Path2D = Path2D.new()
	path.set_curve(curve)
	path.name = name
	add_child(path)
	path.set_owner(get_tree().get_edited_scene_root())
	var follow: PathFollow2D = PathFollow2D.new()
	path.add_child(follow)
	follow.set_owner(get_tree().get_edited_scene_root())
