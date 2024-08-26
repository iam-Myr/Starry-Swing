extends Node2D

@onready var size = Vector2(7000,5000)
 

# Called when the node enters the scene tree for the first time.
func _ready():
	var constellations_list = get_children()
	
	# Remove garbage before constellations
	#constellations_list.remove_at(0)
	#constellations_list.remove_at(0)
	
	# Let every constellation know how many stars it has
	for constel in constellations_list:
		constel.total_stars = constel.get_node("Stars").get_child_count()
		var line = constel.get_child(1)
		line.width = 2
		line.default_color = "e1e1e10c"
		line.default_color.a = 0.05

	# Set Polaris Scale
	$UMi/Stars/Polaris.scale = Vector2(2,2)
