extends Panel

func _ready():
	var player = get_node("../Player");
	player.connect("player_health_reduced", self, "on_health_reduced")
	player.connect("dangerous_tile_changed", self, "on_dangerous_tile_changed")

func on_health_reduced(health):
	var label = get_node("Health")
	label.text = String(round(health)) + "%"

func on_dangerous_tile_changed(tile_name):
	var label = get_node("DangerousTile")
	label.text = tile_name
