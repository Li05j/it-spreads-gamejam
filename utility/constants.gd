extends Node

const GAME_TIMER_INTERVAL = 1.0 # 1 second interval by default

# Tilemap size, basically game field size.
const MAP_WIDTH = 24
const MAP_HEIGHT = 24

const INITIAL_GOLD = 50
const GOLD_PER_INTERVAL = 2

# Purchasables
const TURRET_PRICE = 20
const BEACON_PRICE = 20
const TURRET_PLACEMENT_RADIUS = 1 # turret placement radius increase
const BEACON_PLACEMENT_RADIUS = 3 # beacon placement radius increase

# Enemy spread
const TICKS_TILL_SPREAD = 10
const MAX_TICK = 30

# Turret shoot constants
const TURRET_TICK_INTERVAL = 0.6
const TURRET_SHOOT_RANGE = 3
const TURRET_DAMAGE = 1
const TICKS_TILL_SHOOT = 1
