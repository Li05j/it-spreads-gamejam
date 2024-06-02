extends Node2D

class_name Turret

const TURRET_RANGE = 3

@onready var targets = [] # targets sorted by distance
@onready var tilemap: TileMap = get_parent().get_node("tilemap")
@onready var coords = tilemap.local_to_map(global_position)

func update_targets(target_map):
	for dx in range(-TURRET_RANGE, TURRET_RANGE + 1):
		for dy in range(-TURRET_RANGE, TURRET_RANGE + 1):
			var dist = abs(dx) + abs(dy)
			if dist > TURRET_RANGE: continue
			var target_coords = coords + Vector2i(dx, dy)
			if target_coords in target_map and \
			map_has_enemy_at_coords(target_map, target_coords):
				sorted_add(dist, target_map[target_coords])
	
func shoot():
	if len(targets) == 0:
		return
	var target = targets[0] # shoot closest
	draw_line(global_position, target.global_position, Color(255, 0, 100))
	
func map_has_enemy_at_coords(target_map, target_coords):
	# TODO: change based on target_map implementation
	return target_map[target_coords]
	
func sorted_add(new_dist, new_target):
	for i in range(len(targets)):
		var target = targets[i]
		if get_dist(target) >= new_dist:
			targets.insert(i, new_target)
			break

func get_dist(target):
	# TODO: find better way of storing?
	var dist = abs(tilemap.local_to_map(target.global_position) - coords)
	print_debug(dist)
	return dist
		
