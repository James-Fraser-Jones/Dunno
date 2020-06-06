tool
extends Node2D

export var nav_radius: int = 0
export var run: bool = false setget runH
export var reset_origin: bool = false setget resetH

func runH(_b):
	if Engine.is_editor_hint():
		bake_nav()
		
func resetH(_b):
	if Engine.is_editor_hint():
		reset_origin()

func reset_origin() -> void:
	var polygons2Ds = get_children()
	for polygon2D in polygons2Ds:
		var polygon = polygon2D.get_polygon()
		for i in range(polygon.size()):
			polygon.set(i, polygon[i] + polygon2D.position)
			polygon2D.set_polygon(polygon)
		polygon2D.position = Vector2.ZERO

func bake_nav() -> void:
	var nav: NavigationPolygon = NavigationPolygon.new()
	nav.add_outline(PoolVector2Array([Vector2(0, 0), Vector2(2048, 0), Vector2(2048, 2048), Vector2(0, 2048)]))
	var polygons = get_children()
	for polygon2D in polygons:
		var polygon = polygon2D.get_polygon()
		var new_poly = Geometry.offset_polygon_2d(polygon, nav_radius, Geometry.JOIN_SQUARE)[0]
		nav.add_outline(new_poly)
	nav.make_polygons_from_outlines()
	ResourceSaver.save("resources/Nav-" + String(nav_radius) + ".tres", nav)

#static func get_difference_path(path: PoolVector2Array, path_closed: bool) -> PoolVector2Array:
#	var difference_path: PoolVector2Array = PoolVector2Array()
#	for i in range(path.size()-1):
#		difference_path.append(path[i+1]-path[i])
#	if path_closed:
#		difference_path.append(path[0]-path[path.size()-1])
#	return difference_path
#	
#static func get_exterior_angles(difference_path: PoolVector2Array) -> Array:
#	var angles = []
#	for i in range(difference_path.size() + 1):
#		angles.append(difference_path[posmod(i-1, difference_path.size())].angle_to(difference_path[posmod(i, difference_path.size())]))
#	return angles
#	
#static func fold_array(arr: Array, fun, def):
#	var acc = def
#	for i in range(arr.size()):
#		acc = fun.call_func(acc, arr[i])
#	return acc
#	
#static func add(x: float, y: float) -> float:
#	return x + y
