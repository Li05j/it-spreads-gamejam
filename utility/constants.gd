extends Node

const GAME_TIMER_INTERVAL = 1.0 # 1 second interval by default

# Tilemap size, basically game field size.
const MAP_WIDTH = 64
const MAP_HEIGHT = 64

const INITIAL_GOLD = 500
const GOLD_PER_INTERVAL = 5

# Purchasables
const TURRET_PRICE = 50
const BEACON_PRICE = 10
const TURRET_PLACEMENT_RADIUS = 1 # turret placement radius increase
const BEACON_PLACEMENT_RADIUS = 2 # beacon placement radius increase

# Enemy spread
const TICKS_TILL_SPREAD = 5
const MAX_TICK = 20

# Turret shoot constants
const TURRET_SHOOT_RANGE = 3
const TURRET_DAMAGE = 50
const TICKS_TILL_SHOOT = 1
