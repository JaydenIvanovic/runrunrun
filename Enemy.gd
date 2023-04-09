extends CharacterBody2D

@export var target: Node2D
var speed = 50
var flashing_distance = 100
var timer : Timer = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !target:
		return
	maybe_handle_collision(delta)
	maybe_play_flashing_animation()
	
func maybe_handle_collision(delta: float):
	var target_direction = target.position - position
	var collision_info = move_and_collide(target_direction.normalized() * speed * delta)
	if collision_info:
		var collision_source = collision_info.get_collider().name
		EventBus.enemy_exploded.emit(collision_source)
		queue_free()

func maybe_play_flashing_animation():
	if position.distance_to(target.position) <= flashing_distance:
		if timer:
			return
		timer = Timer.new()
		timer.connect("timeout", func():
			if $Sprite.material.get_shader_parameter("red") < 0.1:
				print_debug("white")
				$Sprite.material.set_shader_parameter("red", 0.85)
				$Sprite.material.set_shader_parameter("green", 0.85)
				$Sprite.material.set_shader_parameter("blue", 0.85)
			else:
				print_debug("black")
				$Sprite.material.set_shader_parameter("red", 0)
				$Sprite.material.set_shader_parameter("green", 0)
				$Sprite.material.set_shader_parameter("blue", 0)
		)
		self.add_child(timer)
		timer.start(0.25)
	else:
		if timer:
			timer.stop()
			self.remove_child(timer)
			timer = null
			$Sprite.material.set_shader_parameter("red", 0)
			$Sprite.material.set_shader_parameter("green", 0)
			$Sprite.material.set_shader_parameter("blue", 0)
		
		
