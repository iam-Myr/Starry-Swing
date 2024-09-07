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

func get_chosen(sound_index):
	is_chosen = true
	particles.emitting = true
	light.enabled = true
	
	play_sound(sound_index)

func remove_chosen():
	is_chosen = false
	$ChosenTimer.start()

func _on_chosen_timer_timeout():
	if not is_chosen:
		particles.emitting = false
		light.enabled = false

func play_sound(index):
	
	index = index % 2 #As many sounds
	
	# Create the file path string
	var sound_string = "res://Assets/Sounds/" + str(index) + ".wav"
	
	# Load the sound resource dynamically at runtime
	var sound = ResourceLoader.load(sound_string)
	
	if sound:  # Check if the sound was loaded successfully
		# Play random sound pitch
		#$Sound.pitch_scale = randf_range(0.5, 1.5)
		$Sound.stream = sound
		$Sound.play()
	else:
		print("Failed to load sound:", sound_string)

	
