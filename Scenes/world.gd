extends Node2D

@onready var player = $Player
@onready var rope = $Rope
signal warped_player
@onready var anchor = $Player
var player_grappling = false


func _process(delta):
	#check_player_out_of_bounds()
	player.position = player.position.posmodv(get_viewport_rect().size)
	if player_grappling:
		rope.points = [player.position, anchor.position]
	else:
		rope.points = []

func check_player_out_of_bounds():
	var screen_size = get_viewport_rect().size
	var position_changed = false
	
	# Check X bounds
	if player.global_position.x < 0:
		player.global_position.x += screen_size.x
		position_changed = true
	elif player.global_position.x > screen_size.x:
		player.global_position.x -= screen_size.x
		position_changed = true
	
	# Check Y bounds
	if player.global_position.y < 0:
		player.global_position.y += screen_size.y
		position_changed = true
	elif player.global_position.y > screen_size.y:
		player.global_position.y -= screen_size.y
		position_changed = true
	
	# Emit signal only if the position has changed
	if position_changed:
		warped_player.emit()


func _on_player_player_grappling(anchr):
	player_grappling = true
	anchor = anchr
	#print(anchor)


func _on_player_player_released():
	player_grappling = false
