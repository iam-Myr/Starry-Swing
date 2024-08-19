extends StaticBody2D

@onready var particles = $Particles
@onready var light = $Light

func get_chosen():
	the_chosen_one(true)

func remove_chosen():
	the_chosen_one(false)

func the_chosen_one(is_chosen):
	particles.emitting = is_chosen
	light.enabled = is_chosen
