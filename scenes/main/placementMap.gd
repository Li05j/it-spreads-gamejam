extends Node2D
class_name PlacementMap

const PlacementTile = preload("res://scenes/placementTile/placementTile.tscn")

var width: int
var height: int
var map: Array
var tilemap: TileMap

func _init(width, height, tilemap):
	self.width = width
	self.height = height
	self.tilemap = tilemap
	self.map = []
	for i in range(width):
		var row = []
		for j in range(height):
			row.append(0)
		self.map.append(row)
	# TODO: starting placement
	self.map[0][0] = 1
	add_placement_tile(Vector2i(0,0))

func in_range_2d(x: int, y: int):
	return 0 <= x and x < self.width and 0 <= y and y < self.height

# update all cells with Manhattan distance <= r to (x,y)
func update_range(p: Vector2i, r: int):
	var x = p.x
	var y = p.y
	for dx in range(-r, r+1):
		for dy in range(-r, r+1):
			if abs(dx) + abs(dy) > r: continue 
			var cur_x = x + dx
			var cur_y = y + dy
			if in_range_2d(cur_x, cur_y):
				self.map[cur_x][cur_y] = 1
				add_placement_tile(Vector2i(cur_x, cur_y))

func check_placement_range(p: Vector2i):
	return in_range_2d(p.x, p.y) and self.map[p.x][p.y] == 1
	
func add_placement_tile(p: Vector2i):
	var tile_instance = PlacementTile.instantiate()
	tile_instance.global_position = tilemap.map_to_local(p)
	tilemap.add_child(tile_instance)
	

# # Called when the node enters the scene tree for the first time.
# func _ready():
# 	pass # Replace with function body.


# # Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
# 	pass
