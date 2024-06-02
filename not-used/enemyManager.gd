class_name EnemyManager extends Node

const ENEMY_MAX_VALUE = 100 # maximum presence of enemy in a tile

var enemyTiles = {} # tiles occupied by enemies
var enemySources = [] # tiles that can spread

var map = null
var tilemap = null
var container = null

func _init(map, tilemap, container):
	self.map = map
	self.tilemap = tilemap
	self.container = container

func run_iteration(delta):
	for source in enemySources:
		spread(source)

func spread(source):
	# TODO: spread in 4 directions if possible
	# if spread reaches 100, add to sources list
	var adjacent_list = [
		Vector2(-1, 0), 
		Vector2(1, 0), 
		Vector2(0, -1), 
		Vector2(0, 1)
	]
	for direction in adjacent_list:
		var tile = map.tile_size * direction + source # TODO: hmm
		if is_spreadable(tile): 
			enemyTiles[tile] = max(ENEMY_MAX_VALUE, enemyTiles[tile] + 10)
		if enemyTiles[tile] == 100:
			enemySources.append(tile)
		# TODO: we need to draw new enemies after this update
		

func is_spreadable(tile):
	# TODO: implement spreadable check
	if tile in map:
		return map[tile].type == "enemy"
	else:
		return true
