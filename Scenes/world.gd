extends Node2D

const WORLD_DIMENSIONS = Vector2(1280, 720)

@onready var player: CharacterBody2D = $Player
@onready var rope: Line2D = $Rope
@onready var camera: Camera2D = $Player/Camera2D
@onready var chosen_star: StaticBody2D = $StarMap2/UrsaMinor/Stars/Polaris # Start with spawnpoint
@onready var prev_chosen_star: StaticBody2D = $StarMap2/UrsaMinor/Stars/Polaris

var random_spawn: bool = false
var player_grappling: bool = true
var zoom_speed = Vector2(0.1,0.1)
var min_zoom = Vector2(1,1)
var max_zoom = Vector2(2,2)


func _ready():
	if random_spawn: 
		chosen_star = $StarMap2/Rogues.get_children().pick_random()
	player.spawn_at(chosen_star)
	chosen_star.get_chosen()
	
	create_background_grid($BG/BGSprite)

func _process(delta):
	player.position = player.position.posmodv(get_viewport_rect().size)
	#$Comet.position = $Comet.position.posmodv(get_viewport_rect().size)
	
	if player_grappling:
		rope.points = [player.get_node("GrappleMarker").global_position, chosen_star.global_position]
	else:
		rope.points = []
	

func _input(event):
	if event.is_action_pressed("zoom in"):
		camera.zoom = clamp(camera.zoom - zoom_speed, min_zoom, max_zoom)
	if event.is_action_pressed("zoom out"):
		camera.zoom = clamp(camera.zoom + zoom_speed, min_zoom, max_zoom)

	
func _on_player_player_grappling(star):
	player_grappling = true
	chosen_star = star
	chosen_star.get_chosen()
	
	if chosen_star.constellation != prev_chosen_star.constellation and prev_chosen_star.constellation:
		prev_chosen_star.constellation.fail()

	if chosen_star.constellation and not chosen_star.constellation.is_unlocked:
		chosen_star.constellation.const_star_activated(chosen_star)

func _on_player_player_released():
	player_grappling = false
	chosen_star.remove_chosen()
	prev_chosen_star = chosen_star

# Function to create 8 background sprites around the given node
func create_background_grid(background_sprite: Sprite2D):
	# Get the size of the background sprite
	var sprite_size = WORLD_DIMENSIONS
	
	# Loop through the grid positions (-1, 0, 1) for both x and y directions
	for x_offset in [-1, 0, 1]:
		for y_offset in [-1, 0, 1]:
			# Skip the center position (0, 0) to avoid duplicating the original sprite
			if x_offset == 0 and y_offset == 0:
				continue

			# Create a new instance of the sprite
			var new_sprite = background_sprite.duplicate()

			# Set the position of the new sprite based on the offset
			new_sprite.position = background_sprite.position + Vector2(x_offset, y_offset) * sprite_size
			new_sprite.name = "BG_" + str(x_offset) + str(y_offset)
			# Add the new sprite as a child of the background sprite's parent
			background_sprite.get_parent().add_child(new_sprite)

		

