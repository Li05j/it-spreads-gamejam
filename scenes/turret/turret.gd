extends Node2D

class_name Turret

const C = preload("res://utility/constants.gd")

@onready var targets: Array[Enemy] = [] # targets sorted by distance
@onready var tilemap: TileMap = get_parent().get_node("tilemap")
@onready var timer = $Timer

var coords = null
var object_map = null
var placement_map = null
var ticks = 0
var shoot_target = null

func _ready():
	timer.wait_time = C.TURRET_TICK_INTERVAL
	timer.start()

func turret_init(world_pos, object_map_ref, placement_map_ref):
	global_position = world_pos
	object_map = object_map_ref
	placement_map = placement_map_ref
	object_map[world_pos] = self
	coords = tilemap.local_to_map(self.global_position)

func update_targets():
	var new_targets: Array[Enemy] = []
	for i in range(len(targets)):
		# clean up targets
		if is_instance_valid(targets[i]):
			new_targets.append(targets[i])
	targets = new_targets
	for dx in range(-C.TURRET_SHOOT_RANGE, C.TURRET_SHOOT_RANGE + 1):
		for dy in range(-C.TURRET_SHOOT_RANGE, C.TURRET_SHOOT_RANGE + 1):
			var dist = abs(dx) + abs(dy)
			if dist > C.TURRET_SHOOT_RANGE: continue
			var new_xy = coords + Vector2i(dx, dy)
			var new_pos = tilemap.map_to_local(new_xy)
			if new_pos in object_map and \
			map_has_enemy_at_coords(object_map, new_pos):
				sorted_add(dist, object_map[new_pos])
	
func shoot():
	if len(targets) == 0:
		shoot_target = null
		return
	var target: Enemy = targets[0] # shoot closest
	print("Shooting at ", target.global_position)
	shoot_target = Vector2i(target.global_position) # in case target is destroyed
	var dmg_num = target.take_damage(C.TURRET_DAMAGE)
	queue_redraw()
	
func _draw():
	if shoot_target: 
		var start_point = to_local(global_position)
		var end_point = to_local(shoot_target)
		draw_line(start_point, end_point, Color.RED, 2)
	
func map_has_enemy_at_coords(target_map, target_coords):
	# check if coord is not free
	var cur_instance = target_map[target_coords]
	return is_instance_valid(cur_instance) and cur_instance is Enemy
	
func sorted_add(new_dist, new_target):
	for i in range(len(targets)):
		var target: Enemy = targets[i]
		if not is_instance_valid(target):
			continue
		if get_dist(target) >= new_dist:
			targets.insert(i, new_target)
			break
	targets.append(new_target)

func get_dist(target):
	var target_coords = tilemap.local_to_map(target.global_position)
	var dist = abs(target_coords.x - coords.x) + abs(target_coords.y - coords.y)
	return dist
		
func _on_timer_timeout():
	ticks += 1
	
	update_targets()
	if ticks >= C.TICKS_TILL_SHOOT:
		shoot()
		ticks = 0
