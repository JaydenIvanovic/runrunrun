extends Panel

func _ready():
	var player = get_node("../Player");
	player.connect("player_health_reduced", self, "on_health_reduced")
	player.connect("active_tile_changed", self, "on_active_tile_changed")
	var restart_button = get_node("../GameOverMessage/Button")
	restart_button.connect("pressed", self, "restart_game")

func on_health_reduced(health):
	var label = get_node("Health")
	label.text = String(round(health)) + "%"
	if health <= 0:
		show_game_over_screen()

func on_active_tile_changed(tile_name):
	var label = get_node("ActiveTile")
	label.text = tile_name

func show_game_over_screen():
	get_tree().paused = true
	var game_over_message = get_node("../GameOverMessage")
	game_over_message.show()

func restart_game():
	get_tree().paused = false
	get_tree().reload_current_scene()
