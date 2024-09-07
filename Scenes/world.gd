extends Node2D


@onready var starmap = %Planisphere
@onready var player: CharacterBody2D = $Player
@onready var rope: Line2D = %Rope
@onready var camera: Camera2D = $Player/PlayerCamera
@onready var chosen_celestial: CelestialBody = starmap.get_node("%Polaris") # Start with spawnpoint
@onready var prev_chosen_celestial: CelestialBody = starmap.get_node("%Polaris")

var player_grappling: bool = true
signal player_teleported

func _ready():
	player.spawn_at(chosen_celestial)
	chosen_celestial.get_chosen()
	
	Globals.WORLD_SIZE = $Control.size
	camera.update_center()
	#create_background_grid($BG)

func _process(delta):
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
		
func _on_area_2d_body_exited(body):
	if body == player:
		player.position = player.position.posmodv(Globals.WORLD_SIZE)
		player_teleported.emit()
