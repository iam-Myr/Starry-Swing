extends CharacterBody2D

signal grapple_signal

var speed = 500
var can_grapple: bool = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Input
	var direction = Input.get_vector("left","right","up","down")
	velocity = direction * speed 
	move_and_slide()
	
	# lip
	if direction.x != 0:
		$Player_Img.flip_h = direction.x < 0

	#grappling hook input
	if Input.is_action_just_pressed("grapple") and can_grapple:
		grapple_signal.emit()
		can_grapple = false
		$LassoTimer.start()
	
	

func _on_timer_timeout():
	can_grapple = true
