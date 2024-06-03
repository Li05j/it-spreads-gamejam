extends Node2D

const C = preload("res://utility/constants.gd")
const TurretScene = preload("res://scenes/turret/turret.tscn")
const LaserScene = preload("res://scenes/turret/laser.tscn")
const BeaconScene = preload("res://scenes/beacon/beacon.tscn")

var active_button = null

var gold = C.INITIAL_GOLD # Initial gold value
var gold_gen = C.INITIAL_GOLD_GEN
var economy_upgrade_price = C.INITIAL_ECONOMY_UPGRADE_PRICE

var time_elapsed = 0 # seconds

var object_map: Dictionary = {} # This stores the instance of the child, either a beacon, turret or enemy.

@onready var win_lose_dialog = $winlosepopup
@onready var new_enemy_dialog = $newEnemySpawned

@onready var timer = $Timer
@onready var control_panel_vbox = $canvas/controlPanel/VBox
@onready var tilemap = $tilemap
@onready var placement_map = PlacementMap.new(C.MAP_WIDTH, C.MAP_HEIGHT, tilemap)

@onready var xl = 0
@onready var xr = C.MAP_WIDTH * tilemap.tile_set.tile_size.x
@onready var yl = 0
@onready var yr = C.MAP_HEIGHT * tilemap.tile_set.tile_size.y

var enemy_count = 0
var new_enemy_flag = 0

func _ready():
	timer.wait_time = C.GOLD_UPDATE_INTERVAL
	set_process_input(true)
	update_gold_label(gold)
	update_gold_gen_label(C.INITIAL_GOLD_GEN)
	update_economy_upgrade_button_text(C.INITIAL_ECONOMY_UPGRADE_PRICE)
	update_time_elapsed_label()
	
	spawn_initial_enemy(Vector2(7,5))
	spawn_initial_enemy(Vector2(6,13))
	spawn_initial_enemy(Vector2(16,9))
	timer.start()
	
#func _process(delta):
	#pass

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == 1:
			var global_mouse_pos = get_global_mouse_position()
			print("Mouse button pressed at position: ", global_mouse_pos)
			var tilemap_position = get_tilemap_position(global_mouse_pos)
			if active_button == control_panel_vbox.get_node("buildTurretButton"):
				spawn_turret(tilemap_position)
			elif active_button == control_panel_vbox.get_node("buildLaserButton"):
				spawn_laser(tilemap_position)
			elif active_button == control_panel_vbox.get_node("buildBeaconButton"):
				spawn_beacon(tilemap_position)
				
		if event.button_index == 2:
			reset_active_button()
			
func _draw():
	var rect = Rect2(xl, yl, xr, yr)
	draw_rect(rect, Color.SLATE_GRAY, true)

func spawn_turret(click_position):
	var click_coords = get_tilemap_coord(click_position)
	if !check_affordable("turret"):
		return # Player cannot afford turret
	
	if check_occupied(click_position):
		return # player cannot place turret on occupied tile

	if not placement_map.check_placement_range(click_coords):
		return # player cannot place turret out of placement range
	
	var turret_instance = TurretScene.instantiate() # Create an instance of the turret
	if turret_instance:
		add_child(turret_instance)  # Add it to the Main scene tree
		#map[click_position] = true
		object_map[click_position] = turret_instance
		placement_map.update_range(click_coords, C.TURRET_PLACEMENT_RADIUS) # update placement radius
		turret_instance.turret_init(click_position, object_map, placement_map)
		# TODO: gold setter + signal
		gold -= C.TURRET_PRICE
		update_gold_label(gold) # Update gold display
		print("Spawned turret at position: ", click_position)
	else:
		print("Failed to create turret instance.")
		
func spawn_laser(click_position):
	var click_coords = get_tilemap_coord(click_position)
	if !check_affordable("laser"):
		return # Player cannot afford turret
	
	if check_occupied(click_position):
		return # player cannot place turret on occupied tile

	if not placement_map.check_placement_range(click_coords):
		return # player cannot place turret out of placement range
	
	var laser_instance = LaserScene.instantiate() # Create an instance of the turret
	if laser_instance:
		add_child(laser_instance)  # Add it to the Main scene tree
		#map[click_position] = true
		object_map[click_position] = laser_instance
		placement_map.update_range(click_coords, C.LASER_PLACEMENT_RADIUS) # update placement radius
		laser_instance.turret_init(click_position, object_map, placement_map)
		# TODO: gold setter + signal
		gold -= C.LASER_PRICE
		update_gold_label(gold) # Update gold display
		print("Spawned laser turret at position: ", click_position)
	else:
		print("Failed to create turret instance.")
		
func spawn_beacon(click_position):
	var coords = get_tilemap_coord(click_position)
	if !check_affordable("beacon"):
		return # player cannot afford beacon
	
	if check_occupied(click_position):
		return # player cannot place turret on occupied tile

	if not placement_map.check_placement_range(coords):
		return # player cannot place outside of placement range

	var beacon_instance = BeaconScene.instantiate()
	add_child(beacon_instance)

	#map[click_position] = { "type": "beacon", "value": "100" } # TODO: change depending on how map is stored
	object_map[click_position] = beacon_instance
	beacon_instance.beacon_init(click_position, object_map, placement_map)
	placement_map.update_range(coords, C.BEACON_PLACEMENT_RADIUS) # update placement radius
	# TODO: gold setter + signal
	gold -= C.BEACON_PRICE
	update_gold_label(gold) # update gold display
	print("Spawned beacon at position: ", click_position)
	
func check_affordable(item):
	match item:
		"turret":
			if gold >= C.TURRET_PRICE:
				return true;
		"beacon":
			if gold >= C.BEACON_PRICE:
				return true;
		"laser":
			if gold >= C.LASER_PRICE:
				return true;
	return false
	
func spawn_initial_enemy(loc):
	var initial_position = loc # Temporary enemy location
	#if tilemap == null:
		#print("TileMap is null")
	#else:
		#print("TileMap found")
		
	var world_pos = tilemap.map_to_local(initial_position)
	var enemy_instance = preload("res://scenes/enemy/enemy.tscn").instantiate()
	enemy_instance.enemy_init(world_pos, object_map, placement_map)
	add_child(enemy_instance)
	enemy_count += 1
	
func update_economy_upgrade_button_text(price):
	control_panel_vbox.get_node("upgradeEconomy").text = "Upgrade Economy: $" + str(price)

func update_gold_label(gold):
	control_panel_vbox.get_node("goldDisplay").text = "Gold: $" + str(gold)
	
func update_gold_gen_label(rate):
	control_panel_vbox.get_node("goldGenDisplay").text = "Gold Gen /s: $" + str(rate)
	
func update_time_elapsed_label():
	control_panel_vbox.get_node("timeElapsed").text = "Time: " + str(time_elapsed)
			
func _on_build_turret_button_pressed():
	set_active_button(control_panel_vbox.get_node("buildTurretButton"))

func _on_build_beacon_button_pressed():
	set_active_button(control_panel_vbox.get_node("buildBeaconButton"))
	
func _on_build_laser_button_pressed():
	set_active_button(control_panel_vbox.get_node("buildLaserButton"))
	
func _on_upgrade_economy_pressed():
	if gold >= economy_upgrade_price:
		gold -= economy_upgrade_price
		economy_upgrade_price = ceil(economy_upgrade_price * C.UPGRADE_PRICE_INCREASE_RATE)
		gold_gen += C.GOLD_GEN_INCREASE
		update_gold_label(gold)
		update_gold_gen_label(gold_gen)
		update_economy_upgrade_button_text(economy_upgrade_price)
		
func set_active_button(button):
	if active_button == button:
		active_button.modulate = Color(1, 1, 1)
		active_button.release_focus()
		active_button = null
		print("Building Nothing.")
	else:
		if active_button != null:
			active_button.modulate = Color(1, 1, 1)
		active_button = button
		active_button.modulate = Color(0.5, 0.5, 0.5)
		
func reset_active_button():
	if active_button != null:
		active_button.modulate = Color(1, 1, 1)
		active_button = null
		print("Building Nothing.")
	
func get_tilemap_position(pos):
	return $tilemap.map_to_local($tilemap.local_to_map(pos))

func get_tilemap_coord(pos):
	return $tilemap.local_to_map(pos)
	
func check_occupied(pos):
	return pos in object_map and object_map[pos] != null

func _on_timer_timeout():
	gold += gold_gen
	update_gold_label(gold) # Update gold display
	time_elapsed += 1
	update_time_elapsed_label()
	
	if new_enemy_flag == 0 && time_elapsed >= C.NEW_WAVE_INTERVAL:
		new_enemy_flag += 1
		spawn_initial_enemy(Vector2(25,25))
		show_new_enemy_dialog()
	
func check_loss(enemy):
	if xl > enemy.global_position.x or \
	xr < enemy.global_position.x or \
	yl > enemy.global_position.y or \
	yr < enemy.global_position.y:
		# TODO: process loss
		print("YOU LOSE")
		show_win_lose_dialog("YOU LOSE")
		get_tree().paused = true
		
func check_win():
	if enemy_count == 0:
		# TODO: process win
		print("YOU WIN")
		show_win_lose_dialog("YOU WIN")
		get_tree().paused = true

func show_win_lose_dialog(message):
	win_lose_dialog.get_node("Label").text = message
	win_lose_dialog.popup_centered()
	
func show_new_enemy_dialog():
	new_enemy_dialog.popup_centered()

func _on_winlosepopup_close_requested():
	get_tree().quit()
	
func _on_winlosepopup_confirmed():
	win_lose_dialog.hide()
	get_tree().paused = false
	get_tree().quit()

func _on_new_enemy_spawned_about_to_popup():
	get_tree().paused = true

func _on_new_enemy_spawned_canceled():
	get_tree().paused = false
	
