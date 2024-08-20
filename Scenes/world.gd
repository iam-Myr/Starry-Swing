extends Node2D

@onready var player = $Player
@onready var rope = $Rope
signal warped_player
@onready var chosen_star = $StarMap/Stars/Polaris #Start with spawnpoint
var player_grappling = true

func _ready():
	player.spawn(chosen_star)
	chosen_star.get_chosen()
	
	create_background_grid($BG/MainBGSprite)

func _process(delta):
	player.position = player.position.posmodv(get_viewport_rect().size)
	if player_grappling:
		rope.points = [player.global_position, chosen_star.global_position]
	else:
		rope.points = []

func _on_player_player_grappling(star):
	player_grappling = true
	chosen_star = star
	chosen_star.get_chosen()

func _on_player_player_released():
	player_grappling = false
	chosen_star.remove_chosen()


# Function to create 8 background sprites around the given node
func create_background_grid(background_sprite: Sprite2D):
	# Get the size of the background sprite
	var sprite_size = background_sprite.get_rect().size
	print(sprite_size)

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

		

