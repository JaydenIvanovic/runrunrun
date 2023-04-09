extends Panel

func _ready():
	var player = $"../Player"
	
	EventBus.player_health_changed.connect(func(health):
		var label = $Health
		label.text = str(round(health)) + "%"
		if health <= 0:
			get_tree().paused = true
			var game_over_message = $"../GameOverMessage"
			game_over_message.show()
	)
	
	EventBus.active_tile_changed.connect(func(tile_name):
		var label = $ActiveTile
		label.text = tile_name
	)
	
	var restart_button = $"../GameOverMessage/Button"
	restart_button.connect("pressed", func():
		get_tree().paused = false
		get_tree().reload_current_scene()
	)
