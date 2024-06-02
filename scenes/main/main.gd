extends Control

const INITIAL_GOLD = 500
const TURRET_PRICE = 50
const BEACON_PRICE = 10

# Preload the turret scene
var TurretScene = preload("res://scenes/turret/turret.tscn")
const BeaconScene = preload("res://scenes/beacon/beacon.tscn")

var active_button = null
var gold = INITIAL_GOLD # Initial gold value

var map: Dictionary = {}

@onready var control_panel_vbox = $canvas/controlPanel/VBox
@onready var tilemap = $tilemap

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
	if !check_affordable("turret"):
		return # Player cannot afford turret
	
	if check_occupied(click_position):
		return # player cannot place turret on occupied tile
	
	var turret_instance = TurretScene.instantiate() # Create an instance of the turret
	if turret_instance:
		add_child(turret_instance)  # Add it to the Main scene tree
		map[click_position] = true
		turret_instance.position = click_position
		# TODO: gold setter + signal
		gold -= TURRET_PRICE
		control_panel_vbox.get_node("goldDisplay").text = str(gold) # Update gold display
		print("Spawned turret at position: ", click_position)
	else:
		print("Failed to create turret instance.")
		
func spawn_beacon(pos):
	if !check_afforadble("beacon"):
		return # player cannot afford beacon
	
	if check_occupied(pos):
		return # player cannot place turret on occupied tile

	var beacon_instance = BeaconScene.instantiate()
	add_child(beacon_instance)
	map[pos] = { "type": "beacon", "value": "100" } # TODO: change depending on how map is stored
	beacon_instance.position = pos
	# TODO: gold setter + signal
	gold -= BEACON_PRICE
	$canvas/controlPanel/VBox/goldDisplay.text = str(gold) # update gold display
	print("Spawned beacon at position: ", pos)
	
func check_affordable(item):
	match item:
		"turret":
			if gold >= TURRET_PRICE:
				return true;
		"beacon":
			if gold >= BEACON_PRICE:
				return true;
	return false
	
func spawn_initial_enemy():
	if tilemap == null:
		print("TileMap is null")
	else:
		print("TileMap found")
	var center_tile = Vector2(5, 5)
	var world_pos = tilemap.map_to_local(center_tile)
	var enemy_instance = preload("res://scenes/enemy/enemy.tscn").instantiate()
	enemy_instance.global_position = world_pos
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
	
func check_occupied(pos):
	return pos in map and map[pos] != null
#
## Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
