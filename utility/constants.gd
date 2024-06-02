extends Node

const GOLD_UPDATE_INTERVAL = 1.0
# Tilemap size, basically game field size.
const MAP_WIDTH = 24
const MAP_HEIGHT = 24

const INITIAL_GOLD = 40
const GOLD_PER_INTERVAL = 1

# Purchasables
const TURRET_PRICE = 25
const BEACON_PRICE = 10
const TURRET_PLACEMENT_RADIUS = 1 # turret placement radius increase
const BEACON_PLACEMENT_RADIUS = 3 # beacon placement radius increase

# Enemy spread
const TICKS_TILL_SPREAD = 10
const TICKS_UPDATE_INTERVAL = 1.0 # 1 second interval by default
const MAX_TICK = 30

# Turret shoot constants
const TURRET_TICK_INTERVAL = 0.55
const TURRET_SHOOT_RANGE = 3
const TURRET_DAMAGE = 1
const TICKS_TILL_SHOOT = 1

# Beacons
# const GOLD_GENERATE_INTERVAL = 1.0

# Economy
const INITIAL_GOLD_GEN = 1
const GOLD_GEN_INCREASE = 1
const INITIAL_ECONOMY_UPGRADE_PRICE = 15
const UPGRADE_PRICE_INCREASE_RATE = 1.1
