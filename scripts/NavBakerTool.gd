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
		reset_ori()

func reset_ori() -> void:
	var polygons2Ds = get_children()
	for polygon2D in polygons2Ds:
		var polygon = polygon2D.get_polygon()
		for i in range(polygon.size()):
			polygon.set(i, polygon[i] + polygon2D.position)
			polygon2D.set_polygon(polygon)
		polygon2D.position = Vector2.ZERO

#have to delete existing resource first
func bake_nav() -> void:
	var nav: NavigationPolygon = NavigationPolygon.new()
	nav.add_outline(PoolVector2Array([Vector2(0, 0), Vector2(2048, 0), Vector2(2048, 2048), Vector2(0, 2048)]))
	var polygons = get_children()
	for polygon2D in polygons:
		var polygon = polygon2D.get_polygon()
		var new_poly = Geometry.offset_polygon_2d(polygon, nav_radius, Geometry.JOIN_SQUARE)[0]
		nav.add_outline(new_poly)
	nav.make_polygons_from_outlines()
	var result = ResourceSaver.save("resources/Nav-" + String(nav_radius) + ".tres", nav)
	if result == OK: print("File saved successfully")
