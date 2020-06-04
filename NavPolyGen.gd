tool
extends NavigationPolygonInstance

export var P_Scale: float = 1
export var Generate: bool = false setget handler

func handler(_b):
	if Engine.is_editor_hint():
		print("Hello World")
