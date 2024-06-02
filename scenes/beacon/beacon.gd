extends Node2D

class_name Beacon

const C = preload("res://utility/constants.gd")

@onready var timer = $Timer

var object_map = null
var placement_map = null

#func _ready():
	#timer.wait_time = C.GOLD_GENERATE_INTERVAL
	#timer.start()

func beacon_init(world_pos, object_map_ref, placement_map_ref):
	global_position = world_pos
	object_map = object_map_ref
	placement_map = placement_map_ref
	object_map[world_pos] = self

#func _on_timer_timeout():
	#get_parent().gold += C.GOLD_PER_INTERVAL
