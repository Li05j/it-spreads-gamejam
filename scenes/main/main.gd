extends Control

const INITIAL_GOLD = 500
const TURRET_PRICE = 50
const BEACON_PRICE = 10

# Preload the turret scene
var TurretScene = preload("res://scenes/turret/turret.tscn")

var active_button = null
var gold = INITIAL_GOLD # Initial gold value

var map: Dictionary = {}
var enemyManager: Array = []

func _ready():
	set_process_input(true)
	$controlPanel/VBox/goldDisplay.text = str(gold)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		print("Mouse button pressed at position: ", event.position)
		var tilemap_position = get_tilemap_position(event.position)
		if active_button == $controlPanel/VBox/buildTurretButton:
			spawn_turret(tilemap_position)
		elif active_button == $controlPanel/VBox/buildBeaconButton:
			spawn_beacon(tilemap_position)

func spawn_turret(click_position):
	if !check_afforadble("turret"):
		return # Player cannot afford turret
	
	if check_occupied(click_position):
		return # player cannot place turret on occupied tile
	
	var turret_instance = TurretScene.instantiate() # Create an instance of the turret
	if turret_instance:
		add_child(turret_instance)  # Add it to the Main scene tree
		map[click_position] = true
		turret_instance.position = click_position
		gold -= TURRET_PRICE
		$controlPanel/VBox/goldDisplay.text = str(gold) # Update gold display
		print("Spawned turret at position: ", click_position)
	else:
		print("Failed to create turret instance.")
		
func spawn_beacon(click_position):
	print("TODO: beacon not yet impelemented.")
	
func check_afforadble(item):
	match item:
		"turret":
			if gold >= TURRET_PRICE:
				return true;
		"beacon":
			if gold >= BEACON_PRICE:
				return true;
	return false
	

func _on_build_turret_button_pressed():
	set_active_button($controlPanel/VBox/buildTurretButton)
	#if active_button == $controlPanel/buildTurretButton:
		#active_button = null
		#print("Building nothing.")
	#else:
		#active_button = $controlPanel/buildTurretButton
		#print("Building turret.")

func _on_build_beacon_button_pressed():
	set_active_button($controlPanel/VBox/buildBeaconButton)
	#if active_button == $controlPanel/VBox/buildBeaconButton:
		#active_button = null
		#print("Building nothing.")
	#else:
		#active_button = $controlPanel/VBox/buildBeaconButton.press
		#print("Building beacon.")
		
func set_active_button(button):
	if active_button == button:
		active_button.modulate = Color(1, 1, 1)
		active_button.release_focus()
		active_button = null
		print("Building Nothing.")
		return
	
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
