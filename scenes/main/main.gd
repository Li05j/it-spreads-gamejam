extends Control

const C = preload("res://utility/constants.gd")
const TurretScene = preload("res://scenes/turret/turret.tscn")
const BeaconScene = preload("res://scenes/beacon/beacon.tscn")

var active_button = null
var gold = C.INITIAL_GOLD # Initial gold value

var object_map: Dictionary = {} # This stores the instance of the child, either a beacon, turret or enemy.

@onready var control_panel_vbox = $canvas/controlPanel/VBox
@onready var tilemap = $tilemap
@onready var placement_map = PlacementMap.new(C.MAP_WIDTH, C.MAP_HEIGHT, tilemap)

func _ready():
	set_process_input(true)
	control_panel_vbox.get_node("goldDisplay").text = str(gold)
	spawn_initial_enemy()
	
#func _process(delta):
	#pass

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		# NOTE: use get_global_mouse_position instead of event.global_position
		var global_mouse_pos = get_global_mouse_position()
		print("Mouse button pressed at position: ", global_mouse_pos)
		var tilemap_position = get_tilemap_position(global_mouse_pos)
		if active_button == control_panel_vbox.get_node("buildTurretButton"):
			spawn_turret(tilemap_position)
		elif active_button == control_panel_vbox.get_node("buildBeaconButton"):
			spawn_beacon(tilemap_position)

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
		turret_instance.position = click_position
		# TODO: gold setter + signal
		gold -= C.TURRET_PRICE
		control_panel_vbox.get_node("goldDisplay").text = str(gold) # Update gold display
		print("Spawned turret at position: ", click_position)
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
	beacon_instance.position = click_position
	placement_map.update_range(coords, C.BEACON_PLACEMENT_RADIUS) # update placement radius
	# TODO: gold setter + signal
	gold -= C.BEACON_PRICE
	$canvas/controlPanel/VBox/goldDisplay.text = str(gold) # update gold display
	print("Spawned beacon at position: ", click_position)
	
func check_affordable(item):
	match item:
		"turret":
			if gold >= C.TURRET_PRICE:
				return true;
		"beacon":
			if gold >= C.BEACON_PRICE:
				return true;
	return false
	
func spawn_initial_enemy():
	var initial_position = Vector2(5, 5) # Temporary enemy location
	if tilemap == null:
		print("TileMap is null")
	else:
		print("TileMap found")
		
	var world_pos = tilemap.map_to_local(initial_position)
	var enemy_instance = preload("res://scenes/enemy/enemy.tscn").instantiate()
	enemy_instance.enemy_init(world_pos, object_map, placement_map)
	add_child(enemy_instance)
	
func _on_build_turret_button_pressed():
	set_active_button(control_panel_vbox.get_node("buildTurretButton"))

func _on_build_beacon_button_pressed():
	set_active_button(control_panel_vbox.get_node("buildBeaconButton"))
		
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
	
func get_tilemap_position(pos):
	return $tilemap.map_to_local($tilemap.local_to_map(pos))

func get_tilemap_coord(pos):
	return $tilemap.local_to_map(pos)
	
func check_occupied(pos):
	return pos in object_map and object_map[pos] != null
#
## Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
