tool
extends Node2D

export var target: NodePath
export var offset_width: float = 1
export var run: bool = false setget handler

func handler(_b):
	if Engine.is_editor_hint():
		var node: Polygon2D = get_node(target)
		node.set_polygon(offset_polygon(node.get_polygon(), offset_width))
		
func path_points_to_vectors(path: PoolVector2Array, path_closed: bool) -> PoolVector2Array:
	var vec_path: PoolVector2Array = PoolVector2Array()
	for i in range(path.size()-1):
		vec_path.append(path[i+1]-path[i])
	if path_closed:
		vec_path.append(path[0]-path[path.size()-1])
	return vec_path
		
func poly_points_clockwise(poly: PoolVector2Array) -> bool:
	var vec_path: PoolVector2Array = path_points_to_vectors(poly, true)
	var rotation: float = 0
	for i in range(vec_path.size()):
		rotation += vec_path[i].angle_to(vec_path[posmod(i+1, vec_path.size())])
	return rotation >= 0
		
func offset_polygon(poly: PoolVector2Array, offset: float) -> PoolVector2Array:
	var cw: bool = poly_points_clockwise(poly)
	var poly_size: int = poly.size()
	var new_poly: PoolVector2Array = poly
	var vec: Vector2
	var prev_vec: Vector2
	var next_vec: Vector2
	var dir: Vector2
	var mag: float
	for i in range(poly_size):
		vec = poly[i]
		prev_vec = poly[posmod(i - (1 if cw else -1), poly_size)]
		next_vec = poly[posmod(i + (1 if cw else -1), poly_size)]
		dir = ((vec - prev_vec).normalized() + (vec - next_vec).normalized()).normalized()
		mag = offset/sin((vec - prev_vec).normalized().angle_to(dir))
		new_poly.set(i, new_poly[i] - dir*mag)
	return new_poly
	
