extends StaticBody2D

@onready var particles = $Particles
@onready var light = $Light

signal body_entered(star, body)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_chosen():
	particles.emitting = true
	light.enabled = true

func remove_chosen():
	particles.emitting = false
	light.enabled = false
