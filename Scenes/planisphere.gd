extends Node2D

@onready var chart = $Chart
const OFFSET = 3
var rotation_speed_per_second: float = 360.0 / (24 * 60 * 60) 

func _process(delta):
	chart.rotation_degrees -= rotation_speed_per_second * delta

func _ready():
	# Initialize the chart with the current date and time
	set_initial_rotation()
	#set_initial_rotation1()

func set_initial_rotation():
	chart.rotation_degrees = 0
	
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
	chart.rotation_degrees = -degrees


func set_initial_rotation1():
	# Reset the chart's rotation to 0
	#chart.rotation = 0
	
	var current_date = Time.get_datetime_dict_from_system()
	var month = current_date["month"]
	var day = current_date["day"]
	var hour = current_date["hour"]
	var minute = current_date["minute"]
	var second = current_date["second"]
	
	# Precomputed cumulative days at the start of each month for non-leap years
	var cumulative_days = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334]
	
	# Total days passed in the year up to the start of the current month + current day
	var total_days = cumulative_days[month - 1] + day
	
	# Calculate total seconds passed in the current day
	var total_seconds = hour * 3600 + minute * 60 + second
	print(total_seconds)
	
	# Calculate degrees based on total days and time
	var degrees = total_days + (rotation_speed_per_second * total_seconds)
	
	# Apply modulo 360 to ensure the degrees wrap correctly
	#degrees = fmod(degrees, 360.0)
	
	# Print the calculated degrees for debugging
	print("Calculated degrees: ", -degrees)
	
	# Convert degrees to radians and set the chart's initial rotation
	#chart.rotation = -deg_to_rad(degrees)
