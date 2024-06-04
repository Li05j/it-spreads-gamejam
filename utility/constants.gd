extends Node

const GLOBAL_GAME_INTERVAL = 0.1

# Tilemap size, basically game field size.
const MAP_WIDTH = 36
const MAP_HEIGHT = 36

# Camera:
const ZOOM_STEP = 0.1
const MIN_ZOOM = 0.25
const MAX_ZOOM = 2.0

# Enemy
const TICKS_TILL_SPREAD = 10
const TICKS_BASE_UPDATE_INTERVAL = 3.0
const TICKS_INTERVAL_REDUCE_RATE = 0
const MIN_TICK_INTERVAL = 3.0
const MAX_TICK = 20

const NEW_WAVE_INTERVAL = 210

# Turret shoot constants
const TURRET_PRICE = 50
const TURRET_TICK_INTERVAL = 0.25
const TURRET_PLACEMENT_RADIUS = 1 # turret placement radius increase
const TURRET_SHOOT_RANGE = 3
const TURRET_DAMAGE = 2
const TURRET_TICKS_TILL_SHOOT = 7

const LASER_PRICE = 175
const LASER_TICK_INTERVAL = 0.1
const LASER_PLACEMENT_RADIUS = 1 # turret placement radius increase
const LASER_SHOOT_RANGE = 5
const LASER_DAMAGE = 1
const LASER_TICKS_TILL_SHOOT = 3

# Beacons
const BEACON_PRICE = 30
const BEACON_PLACEMENT_RADIUS = 4 # beacon placement radius increase

# Economy
const GOLD_UPDATE_INTERVAL = 1.0
const INITIAL_GOLD = 50
const INITIAL_GOLD_GEN = 5
const GOLD_GEN_INCREASE = 2
const INITIAL_ECONOMY_UPGRADE_PRICE = 70
const UPGRADE_PRICE_INCREASE_RATE = 1.05
const UPGRADE_PRICE_INCREASE_VAL = 5
