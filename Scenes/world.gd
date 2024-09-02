extends Node2D


@onready var starmap = $Planisphere
@onready var WORLD_DIMENSIONS = Vector2(7500,7500)

@onready var player: CharacterBody2D = $Player
@onready var rope: Line2D = $Rope
@onready var camera: Camera2D = $Player/Camera2D
@onready var chosen_celestial: CelestialBody = starmap.get_node("%Polaris") # Start with spawnpoint
@onready var prev_chosen_celestial: CelestialBody = starmap.get_node("%Polaris")

var player_grappling: bool = true

func _ready():
	player.spawn_at(chosen_celestial)
	chosen_celestial.get_chosen()
	
	#create_background_grid($BG)

func _process(delta):
	#player.position = player.position.posmodv(WORLD_DIMENSIONS)
	#$Comet.position = $Comet.position.posmodv(WORLD_DIMENSIONS)
	#player.position = wrap_position(player.position, WORLD_DIMENSIONS)
	
	if player_grappling:
		rope.points = [player.get_node("GrappleMarker").global_position, chosen_celestial.global_position]
	else:
		rope.points = []



func _on_player_player_grappling(star):
	player_grappling = true
	chosen_celestial = star
	chosen_celestial.get_chosen()
	
	# Fail constellation: If player grapples another constellation's star
	if prev_chosen_celestial.constellation and chosen_celestial.constellation != prev_chosen_celestial.constellation:
		prev_chosen_celestial.constellation.fail()

	if chosen_celestial.constellation: 
		if not chosen_celestial.constellation.is_unlocked:
			chosen_celestial.constellation.const_star_activated(chosen_celestial)
		else:
			$UI.show_label(chosen_celestial.constellation.constellation_name)

func _on_player_player_released():
	player_grappling = false
	chosen_celestial.remove_chosen()
	prev_chosen_celestial = chosen_celestial
	
	# Hide Label
	$UI.hide_label()
	

# Function to create 8 background sprites around the given node
func create_background_grid(bg: Node2D):
	# Get the size of the background sprite
	var sprite_size = WORLD_DIMENSIONS
	
	# Loop through the grid positions (-1, 0, 1) for both x and y directions
	for x_offset in [-1, 0, 1]:
		for y_offset in [-1, 0, 1]:
			# Skip the center position (0, 0) to avoid duplicating the original sprite
			if x_offset == 0 and y_offset == 0:
				continue

			# Create a new instance of the sprite
			var new_bg = bg.duplicate()

			# Set the position of the new sprite based on the offset
			new_bg.position = bg.position + Vector2(x_offset, y_offset) * sprite_size
			new_bg.name = "BG_" + str(x_offset) + str(y_offset)
			# Add the new sprite as a child of the background sprite's parent
			add_child(new_bg)

		

