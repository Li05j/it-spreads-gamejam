class_name EnemyManager extends Node

var enemyTiles = [] # tiles occupied by enemies
var enemySources = [] # tiles that can spread

var map = null

func use_tilemap(tilemap):
	map = tilemap

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
		var tile = map.tile_size * direction + source
		if is_spreadable(tile): enemyTiles[tile] += 10

func is_spreadable(tile):
	pass
