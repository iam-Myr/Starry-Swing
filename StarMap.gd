extends Node2D

var star_scene:PackedScene = preload("res://Scenes/star.tscn")
const STAR_NUMBER = 20
signal stars_spawned(stars_container)

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_stars(STAR_NUMBER, $StarMarkers)
	# Emit signal containing the stars
	stars_spawned.emit($Stars)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawn_stars(star_number, star_marker_node):
	var star_markers_list = star_marker_node.get_children()
	if star_number > star_markers_list.size():
		star_number = star_markers_list.size()
		
	for i in range(star_number):
		var selected_marker = star_markers_list[randi() % star_markers_list.size()]
		star_markers_list.erase(selected_marker) 
			
		var new_star = star_scene.instantiate() as Node2D
		new_star.position = selected_marker.position
			
		$Stars.add_child(new_star)

