extends CharacterBody2D

@export var target: Node2D
var speed = 50

signal enemy_exploded

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !target:
		return
	
	var target_direction = target.position - position
	var collision_info = move_and_collide(target_direction.normalized() * speed * delta)
	if collision_info:
		var collision_source = collision_info.get_collider().name
		emit_signal("enemy_exploded", collision_source)
		queue_free()
