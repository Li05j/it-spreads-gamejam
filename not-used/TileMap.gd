extends TileMap

@export var turret_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	if event is InputEventMouseButton:
		self.on_click()
		
func on_click():
	var mouse_pos = get_local_mouse_position()
	var tile_coord = local_to_map(mouse_pos)
	
	var turret_tile = turret_scene.instantiate()
	set_cell(turret_tile, tile_coord) # TODO fix this
