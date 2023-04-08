extends Sprite2D

@export var health = 100
@export var speed = 200
@export var environment_damage_decay = 10

var tile_map: TileMap
var random_env_damage_timer: Timer
var active_tile = 0
var tile_being_stood_on = 0
var is_moving = false

signal player_health_changed
signal active_tile_changed

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	tile_map = $"../TileMap"
	random_env_damage_timer = $RandomEnvDamageTimer
	random_env_damage_timer.connect("timeout", randomize_active_tile)
	initialize_state()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_movement(delta)
	process_environment_damage(delta)
	
func initialize_state():
	active_tile = round(randf_range(0,3))
	set_color(get_tile_name(active_tile))
	emit_signal("active_tile_changed", get_tile_name(active_tile))

func process_movement(delta):
	is_moving = false
	
	if Input.is_action_pressed("move_left"):
		position += Vector2.LEFT * speed * delta
		flip_h = true
		is_moving = true
	if Input.is_action_pressed("move_right"):
		position += Vector2.RIGHT * speed * delta
		flip_h = false
		is_moving = true
	if Input.is_action_pressed("move_up"):
		position += Vector2.UP * speed * delta
		is_moving = true
	if Input.is_action_pressed("move_down"):
		position += Vector2.DOWN * speed * delta
		is_moving = true
	
	if is_moving:
		$AnimationPlayer.play("move")
	else:
		$AnimationPlayer.stop(true)

func process_environment_damage(delta):
	var tile = tile_map.get_cell_source_id(0, tile_map.local_to_map(position))
	if tile != active_tile:
		health -=  environment_damage_decay * delta
		emit_signal("player_health_changed", health)

func randomize_active_tile():
	active_tile = round(randf_range(0,3))
	var active_tile_name = get_tile_name(active_tile)
	emit_signal("active_tile_changed", active_tile_name)
	set_color(active_tile_name)
	random_env_damage_timer.start(randf_range(2,4))

func get_tile_name(tile_index):
	return ["Yellow", "Red", "Blue", "Green"][tile_index]

func set_color(tile_name):
	match tile_name:
		"Yellow": 
			material.set_shader_parameter("red", 0.85)
			material.set_shader_parameter("green", 0.55)
			material.set_shader_parameter("blue", 0.35)
		"Red":
			material.set_shader_parameter("red", 1.0)
			material.set_shader_parameter("green", 0.3)
			material.set_shader_parameter("blue", 0.9)
		"Blue":
			material.set_shader_parameter("red", 0.0)
			material.set_shader_parameter("green", 0.0)
			material.set_shader_parameter("blue", 1.0)
		"Green":
			material.set_shader_parameter("red", 0.0)
			material.set_shader_parameter("green", 0.7)
			material.set_shader_parameter("blue", 0.3)
		_:
			material.set_shader_parameter("red", 0.0)
			material.set_shader_parameter("green", 0.0)
			material.set_shader_parameter("blue", 0.0)
