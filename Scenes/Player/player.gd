extends CharacterBody2D

# Constants for movement and grappling mechanics
const SWING_SPEED = 700           # Speed of the character while swinging on the rope
const SPEED = 50
@export var ROPE_LENGTH = 300 # (circle radius)
const MAX_VERTICAL_VELOCITY = 500
const GRAVITY = 880

# Nodes and variables
var grappling: bool = false       # Boolean to check if the character is currently grappling
var grappled_body: CelestialBody    # Position of the point where the grapple hooks
var prev_pos: Vector2 = position  # Previous position of the character (used in Verlet integration)
var closest_object 
var closest_distance 
var input_dir = Vector2.ZERO
var total_forces
var new_pos

@onready var star_detector = $StarDetector  # Reference to the Line2D node

signal player_grappling(anchor)
signal player_released

func _ready():
	$StarDetector/StarDetectorCircle.shape.radius = ROPE_LENGTH

func spawn_at(star):
	grappling = true
	grappled_body = star
	position = Vector2(star.global_position.x, star.global_position.y + 50)

func _input(event):
	if event.is_action_released("grapple"):
		grappling = false  # Stop grappling when the grapple button is released
		player_released.emit()

func verlet_integration(prev_pos: Vector2, forces: Vector2, delta: float) -> Vector2:
	var accel = forces  # Acceleration based on applied forces
	return 2 * position - prev_pos + accel * pow(delta, 2) 

func constrain_rope(pos: Vector2, max_rope_length: float) -> Vector2:
	var rope_vector = pos - grappled_body.global_position  # Vector from the grapple anchor to the character's current position
	if rope_vector.length() > max_rope_length:  # If the rope is stretched beyond its maximum length
		rope_vector = rope_vector.normalized() * max_rope_length  # Limit the length to the maximum allowed
		return grappled_body.global_position + rope_vector  # Return the constrained position
	return pos  # Return the original position if within the rope length limit

func _process(delta):
	# Flip Character
	var direction = Input.get_vector("left","right","up","down")
	if direction.x != 0:
		$Player_Img.flip_h = !direction.x < 0 

func _physics_process(delta: float):
	# Get the input direction from the player
	input_dir.x = Input.get_action_strength("right") - Input.get_action_strength("left")  # Determine left/right movement
	var direction = input_dir.normalized()  # Normalize the direction vector

	if Input.is_action_just_pressed("grapple") and not grappling:
		closest_object = find_closest_object(direction)
					
		if closest_object:
			grappling = true
			grappled_body = closest_object  # Set the grapple anchor to the hit position
			player_grappling.emit(closest_object)

	if grappling:
		total_forces = direction * SWING_SPEED + Vector2(0, GRAVITY)  # Apply swinging force and gravity
		new_pos = verlet_integration(prev_pos, total_forces, delta)  # Calculate the new position
		var rope_length = position.distance_to(grappled_body.global_position)
		new_pos = constrain_rope(new_pos, rope_length)  # Constrain the position within the rope length
	else:
		total_forces = Vector2(0, GRAVITY)
		#nongrapple_physics(direction, delta)
		new_pos = verlet_integration(prev_pos, total_forces, delta)  # Calculate the new position
	
	var velocity_value = (new_pos - position) / delta  # Update velocity based on the new position
	
	# Protection against teleport (BAD)
	if new_pos.distance_to(position) > 50:
		#player_released.emit()
		#grappling = false
		velocity_value = velocity
	
	velocity = velocity_value  # Update velocity based on the new position
	velocity.y = clamp(velocity.y, -MAX_VERTICAL_VELOCITY, MAX_VERTICAL_VELOCITY)
	prev_pos = position  # Update the previous position
	move_and_slide()  
	
	#print(velocity)

func find_closest_object(direction):
	# Check the closest object within the area
	closest_object = null
	closest_distance = INF
	
	# Iterate over overlapping bodies
	for body in star_detector.get_overlapping_bodies():
		# Compute direction vector from player to body
		var to_body = body.global_position - global_position
			
		# Check if the body is in the direction the player is looking and above player
		if body.global_position.y < global_position.y + 20 and direction.dot(to_body) >= 0:
			var distance = global_position.distance_to(body.global_position)
				
			if global_position.distance_to(body.global_position) < closest_distance:
				closest_distance = distance
				closest_object = body
	return closest_object


