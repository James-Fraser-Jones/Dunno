extends Node2D

const MeleeMinion: PackedScene = preload("res://scenes/MeleeMinion.tscn")

export var lane: int
export var level: int
export var team: int

var wave_spacing: float = 5
var wave_time: float = 0

onready var root: Viewport = get_tree().get_root()

func _physics_process(delta: float) -> void:
	wave_time += delta
	if wave_time >= wave_spacing:
		wave_time -= wave_spacing
		spawn_wave()
		
func spawn_wave():
	var top_blue_minion: Node = MeleeMinion.instance()
	var mid_blue_minion: Node = MeleeMinion.instance()
	var bot_blue_minion: Node = MeleeMinion.instance()
	var top_red_minion: Node = MeleeMinion.instance()
	var mid_red_minion: Node = MeleeMinion.instance()
	var bot_red_minion: Node = MeleeMinion.instance()
	top_blue_minion.team = 0
	top_blue_minion.lane = 0
	mid_blue_minion.team = 0
	mid_blue_minion.lane = 1
	bot_blue_minion.team = 0
	bot_blue_minion.lane = 2
	top_red_minion.team = 1
	top_red_minion.lane = 0
	mid_red_minion.team = 1
	mid_red_minion.lane = 1
	bot_red_minion.team = 1
	bot_red_minion.lane = 2
	root.add_child(top_blue_minion)
	root.add_child(mid_blue_minion)
	root.add_child(bot_blue_minion)
	root.add_child(top_red_minion)
	root.add_child(mid_red_minion)
	root.add_child(bot_red_minion)
