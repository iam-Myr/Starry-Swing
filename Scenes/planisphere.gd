extends Node2D

const OFFSET: int = 3 # 3 hour ofsset for UTC +3
const rotation_speed_per_second: float = 0.0041666666666667 # 360.0 / (24 * 60 * 60) 

func _process(delta):
	self.rotation_degrees -= rotation_speed_per_second * delta

func _ready():
	# Initialize the chart with the current date and time
	set_initial_rotation()
	
	# Set Polaris Scale
	%Polaris.scale = Vector2(1,1)
	
	# Has to run even when the game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS

func set_initial_rotation():
	self.rotation_degrees = 0
	
	# Find elapsed seconds
	var current_date = Time.get_datetime_dict_from_system()
	# Define the start of the year (January 1st, 00:00:00)
	var start_of_year = {
		"year": current_date["year"],
		"month": 1,
		"day": 1,
		"hour": 0,
		"minute": 0,
		"second": 0
	}

	# Get the Unix timestamp of the start of the year
	var offset_seconds = OFFSET * 3600
	var total_seconds = Time.get_unix_time_from_system() - Time.get_unix_time_from_datetime_dict(start_of_year) + offset_seconds
	var total_days = floor(total_seconds / (60*60*24)) 
	var day_seconds = current_date["hour"] * 3600 + current_date["minute"] * 60 + current_date["second"]


	var total_days2 = (current_date["month"]-1) * 30 + current_date["day"] -1
	var degrees = fmod(total_days2 + day_seconds * rotation_speed_per_second, 360.0)
	self.rotation_degrees = -degrees


