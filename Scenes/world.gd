extends Node2D

@onready var player = $Player
@onready var rope = $Rope
signal warped_player
@onready var chosen_star = $Player
var player_grappling = false

func _process(delta):
	player.position = player.position.posmodv(get_viewport_rect().size)
	if player_grappling:
		rope.points = [player.position, chosen_star.position]
	else:
		rope.points = []



func _on_player_player_grappling(star):
	player_grappling = true
	chosen_star = star
	chosen_star.get_chosen()


func _on_player_player_released():
	player_grappling = false
	chosen_star.remove_chosen()
