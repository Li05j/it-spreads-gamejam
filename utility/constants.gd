extends Node

# Tilemap size, basically game field size.
const MAP_WIDTH = 50
const MAP_HEIGHT = 50

# Camera:
const ZOOM_STEP = 0.1
const MIN_ZOOM = 0.25
const MAX_ZOOM = 2.0

# Enemy spread
const TICKS_TILL_SPREAD = 10
const TICKS_BASE_UPDATE_INTERVAL = 4
const TICKS_INTERVAL_REDUCE_RATE = 0.01
const MIN_TICK_INTERVAL = 0.75
const MAX_TICK = 30

# Turret shoot constants
const TURRET_PRICE = 100
const TURRET_TICK_INTERVAL = 0.55
const TURRET_PLACEMENT_RADIUS = 1 # turret placement radius increase
const TURRET_SHOOT_RANGE = 3
const TURRET_DAMAGE = 1
const TICKS_TILL_SHOOT = 1

# Beacons
const BEACON_PRICE = 30
const BEACON_PLACEMENT_RADIUS = 3 # beacon placement radius increase

# Economy
const GOLD_UPDATE_INTERVAL = 1.0
const INITIAL_GOLD = 100
const INITIAL_GOLD_GEN = 5
const GOLD_GEN_INCREASE = 1
const INITIAL_ECONOMY_UPGRADE_PRICE = 50
const UPGRADE_PRICE_INCREASE_RATE = 1.1
