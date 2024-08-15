extends CharacterBody2D

var speed = 500
var can_grapple: bool = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
		#Input
	var direction = Input.get_vector("left","right","up","down")
	velocity = direction * speed 
	move_and_slide()

	#grappling hook input
	if Input.is_action_just_pressed("grapple") and can_grapple:
		print("grapple")
		can_grapple = false
		$Timer.start()

func _on_timer_timeout():
	can_grapple = true
