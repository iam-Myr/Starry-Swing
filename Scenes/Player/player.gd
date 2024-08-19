extends CharacterBody2D

# Constants for movement and grappling mechanics
const SWING_SPEED = 700           # Speed of the character while swinging on the rope
const SPEED = 50
const ROPE_LENGTH = 150 # (circle radius)
const MAX_VERTICAL_SPEED = 300   # Cap acceleration
const MAX_HORIZONTAL_SPEED = 800

# Nodes and variables
var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity") - 100  # Gravity value from project settings
var grappling: bool = false       # Boolean to check if the character is currently grappling
var grapple_anchor: Vector2       # Position of the point where the grapple hooks
var prev_pos: Vector2 = position  # Previous position of the character (used in Verlet integration)

var closest_object = null
var closest_distance = INF
var input_dir = Vector2.ZERO

@onready var star_detector = $StarDetector  # Reference to the Line2D node

signal player_grappling(anchor)
signal player_released

var direction  = 1

func _ready():
	$StarDetector/StarDetectorCircle.shape.radius = ROPE_LENGTH

func spawn(star):
	visible = true
	grappling = true
	grapple_anchor = star.position
	position = Vector2(star.position.x, star.position.y + 50)

func _input(event):
	if event.is_action_released("grapple"):
		grappling = false  # Stop grappling when the grapple button is released
		player_released.emit()

func verlet_integration(prev_pos: Vector2, forces: Vector2, delta: float) -> Vector2:
	var accel = forces  # Acceleration based on applied forces
	return 2 * position - prev_pos + accel * pow(delta,2)  # Calculate the new position

func constrain_rope(pos: Vector2, max_rope_length: float) -> Vector2:
	var rope_vector = pos - grapple_anchor  # Vector from the grapple anchor to the character's current position
	if rope_vector.length() > max_rope_length:  # If the rope is stretched beyond its maximum length
		rope_vector = rope_vector.normalized() * max_rope_length  # Limit the length to the maximum allowed
		return grapple_anchor + rope_vector  # Return the constrained position
	return pos  # Return the original position if within the rope length limit

func _process(delta):
	# Flip Character
	var direction = Input.get_vector("left","right","up","down")
	if direction.x != 0:
		$Player_Img.flip_h = direction.x < 0 

func _physics_process(delta: float):
	# Get the input direction from the player
	input_dir.x = Input.get_action_strength("right") - Input.get_action_strength("left")  # Determine left/right movement
	var direction = input_dir.normalized()  # Normalize the direction vector

	if Input.is_action_just_pressed("grapple") and not grappling:
		# Check the closest object within the area
		closest_object = null
		closest_distance = INF
	
		# Iterate over overlapping bodies
		for body in star_detector.get_overlapping_bodies():
			# Compute direction vector from player to body
			var to_body = body.position - position
			
			# Check if the body is in the direction the player is looking
			if direction.dot(to_body) >= 0:
				var distance = position.distance_to(body.position)
				
				if distance < closest_distance:
					closest_distance = distance
					closest_object = body
		if closest_object:
			grappling = true
			grapple_anchor = closest_object.position  # Set the grapple anchor to the hit position
			player_grappling.emit(closest_object)

	if grappling:
		var total_forces = direction * SWING_SPEED + Vector2(0, GRAVITY)  # Apply swinging force and gravity
		var new_pos = verlet_integration(prev_pos, total_forces, delta)  # Calculate the new position

		var rope_length = position.distance_to(grapple_anchor)  # Calculate the current rope length
		new_pos = constrain_rope(new_pos, rope_length)  # Constrain the position within the rope length

		velocity = (new_pos - position) / delta  # Update velocity based on the new position
		prev_pos = position  # Update the previous position
		move_and_slide()  # Move the character according to the updated velocity
		
	else:
		# If not grappling, fall due to gravity
		velocity.x += direction.x * 0.1
		velocity.x = lerp(velocity.x,direction.x*SPEED, 0.001)
		velocity.x = clamp(velocity.x, -MAX_HORIZONTAL_SPEED, MAX_HORIZONTAL_SPEED)

		
		velocity.y += GRAVITY * delta  # Apply gravity to the y-velocity
		velocity.y = clamp(velocity.y, -MAX_VERTICAL_SPEED, MAX_VERTICAL_SPEED)  # Cap vertical speed
		
		move_and_slide()  
		prev_pos = position  
		
		"""
		var alignment = direction.dot(Vector2(velocity.x,0).normalized())
		var speed_modifier = max(50,alignment) * 1.1
		var total_forces = direction * SWING_SPEED * speed_modifier
		total_forces += Vector2(0,GRAVITY)
		var new_pos = verlet_integration(prev_pos,total_forces,delta)
			
		#var nextVelocity = new_pos - transform.origin
		velocity = (new_pos - transform.origin) / delta
	"""
	#print(abs(velocity.x))
