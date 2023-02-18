extends Sprite

export var health = 100
export var speed = 200
export var environment_damage_decay = 10

var tile_map: TileMap
var random_env_damage_timer: Timer
var dangerous_tile = 0.0

signal player_health_reduced
signal dangerous_tile_changed

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	tile_map = get_node("../TileMap")
	random_env_damage_timer = get_node("../RandomEnvDamageTimer")
	random_env_damage_timer.connect("timeout", self, 'on_random_env_damage_timeout')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_movement(delta)
	process_environment_damage(delta)
	
func process_movement(delta):
	if Input.is_action_pressed("move_left"):
		position += Vector2.LEFT * speed * delta
		flip_h = true
	if Input.is_action_pressed("move_right"):
		position += Vector2.RIGHT * speed * delta
		flip_h = false
	if Input.is_action_pressed("move_up"):
		position += Vector2.UP * speed * delta
	if Input.is_action_pressed("move_down"):
		position += Vector2.DOWN * speed * delta

func process_environment_damage(delta):
	var tile = tile_map.get_cellv(tile_map.world_to_map(position))
	if tile == dangerous_tile:
		health -=  environment_damage_decay * delta
		emit_signal("player_health_reduced", health)

func on_random_env_damage_timeout():
	dangerous_tile = round(rand_range(0,3))
	emit_signal("dangerous_tile_changed", get_tile_name(dangerous_tile))
	random_env_damage_timer.start(rand_range(1,4))

func get_tile_name(tile_index):
	return ["Yellow", "Red", "Blue", "Green"][tile_index]
