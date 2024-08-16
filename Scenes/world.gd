extends Node2D

var starmap_scene:PackedScene = preload("res://Scenes/star_map.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var new_starmap = starmap_scene.instantiate()
	new_starmap.connect("stars_spawned", Callable(self, "_on_stars_spawned"))
	add_child(new_starmap)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_stars_spawned(stars_container):
	# Connect each star's body_entered signal to _on_star_body_entered
	for star in stars_container.get_children():
		star.connect("body_entered", Callable(self, "_on_star_body_entered"))
		
func _on_star_body_entered(body):
	# If body is lasso tip
	print("contact")

func _on_player_grapple_signal():
	print("grapple")
