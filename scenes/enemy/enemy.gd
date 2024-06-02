extends Node2D

const TICKS_TILL_SPREAD = 5
const TICK_FRAME = 1.0 # 1 second interval by default

@onready var timer = $Timer
@onready var label = $Label

# Ticks until spread
var ticks = 0

func _ready():
	timer.wait_time = TICK_FRAME
	label.text = str(ticks)
	timer.start()

func _on_timer_timeout():
	ticks += 1
	label.text = str(ticks)
	print("ticks... ", ticks)
	if ticks >= TICKS_TILL_SPREAD:
		spread()
		ticks = 0

func spread():
	var tilemap = get_parent().get_node("tilemap")
	var pos = tilemap.local_to_map(global_position)

	for adj_pos in tilemap.get_surrounding_cells(pos):
		# NOTE: We might not need check occupied because enemy instantly kills turrets anyways.
		#if check_occupied(tilemap, adj_pos):  # Check if tile is empty, not working yet though
			#continue
		var new_enemy = preload("res://scenes/enemy/enemy.tscn").instantiate()
		new_enemy.global_position = tilemap.map_to_local(adj_pos)
		get_parent().add_child(new_enemy)

#func check_occupied(tilemap, pos):
	#var source_id = tilemap.get_cell_source_id(0, pos)
	#var atlas_coords = tilemap.get_cell_atlas_coords(0, pos)
	#var alternative_id = tilemap.get_cell_alternative_tile(0, pos)
#
	#return source_id != -1 or atlas_coords != Vector2i(-1, -1) or alternative_id != -1
