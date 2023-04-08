extends Node

var enemy_scene = preload("res://Enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.connect("timeout", func():
		var instance = enemy_scene.instantiate()
		instance.target = $"../Player"
		get_parent().add_child(instance)
		instance.position = get_random_spawn_position()
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_random_spawn_position() -> Vector2:
	var x = $"../Player".position.x + [randf_range(-150, -80), randf_range(150, 80)].pick_random()
	var y = $"../Player".position.y + [randf_range(-150, -80), randf_range(150, 80)].pick_random()
	return Vector2(x, y)
