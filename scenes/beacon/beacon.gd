extends Node2D

class_name Beacon

var object_map = null
var placement_map = null

func beacon_init(world_pos, object_map_ref, placement_map_ref):
	global_position = world_pos
	object_map = object_map_ref
	placement_map = placement_map_ref
	object_map[world_pos] = self

# # Called when the node enters the scene tree for the first time.
# func _ready():
# 	pass # Replace with function body.


# # Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
# 	pass
