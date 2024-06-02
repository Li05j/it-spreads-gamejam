extends Node2D

class_name Enemy

const TICKS_TILL_SPREAD = 5
const TICK_FRAME = 1.0 # 1 second interval by default
const MAX_TICK = 20

@onready var timer = $Timer
@onready var label = $Label

# Get map dictionary from main scene
var map = null

# Ticks until spread
var ticks = 0

func _ready():
	timer.wait_time = TICK_FRAME
	label.text = str(ticks)
	$Sprite2D.self_modulate.a = 0.05
	timer.start()

func _on_timer_timeout():
	ticks += 1
	if ticks >= TICKS_TILL_SPREAD:
		spread()
		if ticks >= MAX_TICK:
			ticks = MAX_TICK
			
	label.text = str(ticks)
	var opacity = min(1.0, ticks * 0.1)
	$Sprite2D.self_modulate.a = opacity

func spread():
	var tilemap = get_parent().get_node("tilemap")
	var pos = tilemap.local_to_map(global_position)

	for adj_pos in tilemap.get_surrounding_cells(pos):
		var local_pos = tilemap.map_to_local(adj_pos)
		
		if check_occupied(local_pos) == true:
			var obj = map[local_pos]
			if obj != null:
				if obj is Enemy:
					continue
				if obj is Turret or obj is Beacon:
					print("Destroying ", obj)
					obj.queue_free()
					map.erase(adj_pos)
					print("Destroyed at position: ", adj_pos)
		
		var new_enemy = preload("res://scenes/enemy/enemy.tscn").instantiate()
		new_enemy.global_position = local_pos
		new_enemy.set_map_reference(map)
		get_parent().add_child(new_enemy)
		map[local_pos] = new_enemy
		
func set_map_reference(ref):
	map = ref
	
	
func check_occupied(pos):
	if map != null:
		return pos in map and map[pos] != null
	print("Error: map is not passed properly - it is null somehow.")
	
#func check_occupied(tilemap, pos):
	#var tile_data = tilemap.get_cell_tile_data(-1, Vector2(pos.x, pos.y))
	#print("Looking at this tile: ", Vector2(pos.x, pos.y))
	#print("What is in the tile? ", tile_data)
	#return tile_data != null  # Check if the tile data exists

