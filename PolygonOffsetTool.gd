tool
extends Node2D

export var target: NodePath
export var offset_width: float = 1
export var run: bool = false setget handler

func handler(_b):
	if Engine.is_editor_hint():
		var node: Polygon2D = get_node(target)
		node.set_polygon(offset_polygon(node.get_polygon(), offset_width))
		
func offset_polygon(poly: PoolVector2Array, offset: float) -> PoolVector2Array:
	var poly_size: int = poly.size()
	var new_poly: PoolVector2Array = poly
	var ac_vec: Vector2
	var vec: Vector2
	var c_vec: Vector2
	var dir: Vector2
	var mag: float
	for i in range(poly_size):
		vec = poly[i]
		ac_vec = poly[posmod(i+1, poly_size)]
		c_vec = poly[posmod(i-1, poly_size)]
		dir = ((vec - ac_vec).normalized() + (vec - c_vec).normalized()).normalized()
		mag = offset/sin((vec - ac_vec).normalized().angle_to(dir))
		new_poly.set(i, new_poly[i] + dir*mag)
	return new_poly
