extends CelestialBody

var INIT_VELOCITY = Vector2(150,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	self.velocity = INIT_VELOCITY
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += self.velocity * delta

func get_chosen():
	self.velocity.x += 250
	
func remove_chosen():
	self.velocity= INIT_VELOCITY
