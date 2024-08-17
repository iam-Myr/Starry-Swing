extends CharacterBody2D

signal grapple_signal(direction)
var gravity: float = 10

var speed = 500
var can_grapple: bool = true
var is_grappling: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Input
	var direction = Input.get_vector("left","right","up","down")
	# Horizontal movement
	velocity.x = direction.x * speed
	
	# Apply gravity
	velocity.y += gravity * delta
	
	
	# Move the player and handle collisions
	move_and_slide()

		
func _input(event):
	if Input.is_action_just_pressed("grapple") and can_grapple:
		var specific_player_direction = (get_global_mouse_position() - self.position).normalized()
		grapple_signal.emit(specific_player_direction)
		can_grapple = false
		$GrappleTimer.start()
	
		
func _on_timer_timeout():
	can_grapple = true



func _on_world_is_grappling():
	is_grappling = true
