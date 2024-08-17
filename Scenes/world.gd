extends Node2D

var starmap_scene: PackedScene = preload("res://Scenes/star_map.tscn")
var grapple_scene: PackedScene = preload("res://Scenes/grapple.tscn")

signal is_grappling

# Define boundaries for teleportation
var boundary_left: float = 0  # Adjust as needed
var boundary_right: float = 1250  # Adjust as needed
var boundary_top: float = -5  # Adjust as needed
var boundary_bottom: float = 850 # Adjust as needed

# Called when the node enters the scene tree for the first time.
func _ready():
	var new_starmap = starmap_scene.instantiate()
	new_starmap.connect("stars_spawned", Callable(self, "_on_stars_spawned"))
	add_child(new_starmap)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_player_out_of_bounds()

func check_player_out_of_bounds():
	if $Player.position.x < boundary_left:
		$Player.position.x = boundary_right
	elif $Player.position.x > boundary_right:
		$Player.position.x = boundary_left

	if $Player.position.y < boundary_top:
		$Player.position.y = boundary_bottom
	elif $Player.position.y > boundary_bottom:
		$Player.position.y = boundary_top

func _on_stars_spawned(stars_container):
	# Connect each star's body_entered signal to _on_star_body_entered
	for star in stars_container.get_children():
		star.connect("body_entered", Callable(self, "_on_star_body_entered"))

func _on_star_body_entered(star, body):
	if body.is_in_group("grapple_segments"):
		print(star, body)
		$Grapple/EndingPinjoint.node_b = star.get_path()
		is_grappling.emit()

func _on_player_grapple_signal(direction):
	print("grapple")
	
	# Remove Previous Grapple
	remove_child($Grapple)
	
	# Change Player direction
	$Player/Player_Img.flip_h = $Player.position.x > get_global_mouse_position().x
	
	var new_grapple = grapple_scene.instantiate() 
	new_grapple.name = "Grapple"
	new_grapple.position = $Player.position + Vector2(-5, -20) # offset
	new_grapple.rotation = direction.angle() - 90
	
	add_child(new_grapple)
	
	# Connect Grapple to Player
	var pin_joint = $Grapple/StartingPinjoint
	pin_joint.node_a = $Player.get_path()

	# Despawn
	await get_tree().create_timer(2.0).timeout
	remove_child(new_grapple)
