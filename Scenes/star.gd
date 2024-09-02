extends CelestialBody
class_name Star

@onready var particles = $Particles
@onready var light = $Light
var is_chosen = false

func _ready():
	#Random Scale
	var rand_scale = randf_range(0.5,0.7)
	self.scale = Vector2(rand_scale,rand_scale)
	
	# I have to do this ugliness to fix a bug where the star nodes are greyed out
	process_mode = Node.PROCESS_MODE_INHERIT

func get_chosen():
	is_chosen = true
	the_chosen_one(is_chosen)

func remove_chosen():
	is_chosen = false
	$ChosenTimer.start()

func _on_chosen_timer_timeout():
	if not is_chosen:
		the_chosen_one(false)

func the_chosen_one(is_chosenn):
	particles.emitting = is_chosenn
	light.enabled = is_chosenn
