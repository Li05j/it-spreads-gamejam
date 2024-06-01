extends Node2D

# Preload the turret scene
var TurretScene = preload("res://scenes/turret/turret.tscn")

func _ready():
	set_process_input(true)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		print("Mouse button pressed at position: ", event.position)
		spawn_turret(event.position)

func spawn_turret(click_position):
	print("Spawning turret at position: ", click_position)
	var turret_instance = TurretScene.instantiate() # Create an instance of the turret
	add_child(turret_instance)  # Add it to the scene tree
	turret_instance.position = click_position

#
## Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
