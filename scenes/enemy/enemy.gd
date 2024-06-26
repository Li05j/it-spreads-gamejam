extends Node2D

class_name Enemy

const C = preload("res://utility/constants.gd")

@onready var tick_timer = $tickTimer
@onready var status_timer = $statusTimer
@onready var label = $Label

# Get object_map dictionary from main scene
var object_map = null
var placement_map = null

# Ticks until spread
var ticks = 1

func _ready():
	status_timer.wait_time = C.GLOBAL_GAME_INTERVAL
	status_timer.start()
	tick_timer.wait_time = C.TICKS_BASE_UPDATE_INTERVAL
	tick_timer.start()

	$Sprite2D.self_modulate.a = 0.05
	
func _on_status_timer_timeout():
	label.text = str(ticks)

func _on_tick_timer_timeout():
	ticks += 1
	if ticks >= C.TICKS_TILL_SPREAD:
		spread()
		if ticks >= C.MAX_TICK:
			ticks = C.MAX_TICK
			
	label.text = str(ticks)
	var opacity = min(1.0, ticks * (1.0 / C.MAX_TICK))
	$Sprite2D.self_modulate.a = opacity
	
	var new_wait_time = C.TICKS_BASE_UPDATE_INTERVAL - get_parent().enemy_count * C.TICKS_INTERVAL_REDUCE_RATE
	new_wait_time = max(new_wait_time, C.MIN_TICK_INTERVAL)
	tick_timer.wait_time = new_wait_time

func spread():
	var tilemap = get_parent().get_node("tilemap")
	var map_pos = tilemap.local_to_map(global_position)

	for adj_pos in tilemap.get_surrounding_cells(map_pos):
		var world_pos = tilemap.map_to_local(adj_pos)
		
		if check_occupied(world_pos) == true:
			var obj = object_map[world_pos]
			if obj is Enemy:
				continue # We do not create another enemy on top of an existing one.
			if obj is Turret:
				placement_map.update_range(adj_pos, C.TURRET_PLACEMENT_RADIUS, true)
			elif obj is Laser:
				placement_map.update_range(adj_pos, C.LASER_PLACEMENT_RADIUS, true)
			elif obj is Beacon:
				placement_map.update_range(adj_pos, C.BEACON_PLACEMENT_RADIUS, true)
					
			obj.queue_free()
			object_map.erase(adj_pos)
			print("Turret/Beacon destroyed at position: ", adj_pos)
		
		var new_enemy = preload("res://scenes/enemy/enemy.tscn").instantiate()
		new_enemy.enemy_init(world_pos, object_map, placement_map)
		get_parent().add_child(new_enemy)
		get_parent().enemy_count += 1
		get_parent().check_loss(new_enemy)
		
func enemy_init(world_pos, object_map_ref, placement_map_ref):
	global_position = world_pos
	object_map = object_map_ref
	placement_map = placement_map_ref
	object_map[world_pos] = self
	
func set_map_reference(ref):
	object_map = ref
	
func check_occupied(pos):
	if object_map != null:
		return pos in object_map and object_map[pos] != null
	print("Error: map is not passed properly - it is null somehow.")
	
func take_damage(damage):
	var dmg_number = min(ticks, damage)
	ticks -= damage
	if ticks <= 0:
		object_map.erase(global_position)
		get_parent().enemy_count -= 1
		get_parent().check_win()
		queue_free()
	return dmg_number
