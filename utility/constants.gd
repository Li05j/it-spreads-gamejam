extends Node

const INITIAL_GOLD = 500

# Tilemap size, basically game field size.
const MAP_WIDTH = 64
const MAP_HEIGHT = 64

# Purchasables
const TURRET_PRICE = 50
const BEACON_PRICE = 10
const TURRET_PLACEMENT_RADIUS = 1 # turret placement radius increase
const BEACON_PLACEMENT_RADIUS = 2 # beacon placement radius increase

# Enemy spread
const TICKS_TILL_SPREAD = 5
const TICK_FRAME = 1.0 # 1 second interval by default
const MAX_TICK = 20
