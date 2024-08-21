extends CelestialBody

@onready var particles = $Particles
@onready var light = $Light
var is_chosen = false

func get_chosen():
	is_chosen = true
	the_chosen_one(is_chosen)

func remove_chosen():
	is_chosen = false
	$ChosenTimer.start()

func the_chosen_one(is_chosenn):
	particles.emitting = is_chosenn
	light.enabled = is_chosenn

func _on_chosen_timer_timeout():
	if not is_chosen:
		the_chosen_one(false)
