#@tool
extends Node2D

# Constants for the world size
const WORLD_HEIGHT = 5000
var WORLD_WIDTH = 5000  # Make it equal to WORLD_HEIGHT for a circular projection

# Paths to the scenes
@onready var star_scene = preload("res://Scenes/Star.tscn")
@onready var constellation_scene = preload("res://Scenes/consellation.tscn")

# Path to the JSON file
const JSON_FILE_PATH = "res://constellations.json"

# Dictionary to track existing stars by position
var existing_stars = {}

# Load the stars in the editor
func _ready():
	_load_and_parse_json()

func _load_and_parse_json():
	var file_access = FileAccess.open(JSON_FILE_PATH, FileAccess.READ)
	if file_access:
		var json_data = file_access.get_as_text()
		file_access.close()
		
		var json = JSON.new()
		var error = json.parse(json_data)
		if error == OK:
			var data = json.get_data()
			_create_constellations(data)
		else:
			print("Failed to parse JSON: ", json.get_error_message())
	else:
		print("Failed to open JSON file.")

func _create_constellations(data):
	if data.has("type") and data["type"] == "FeatureCollection":
		for feature in data["features"]:
			var geometry = feature["geometry"]
			
			# Create an instance of the Constellation scene and set its name
			var constellation = constellation_scene.instantiate() as Constellation
			constellation.name = feature["id"]
			constellation.constellation_name = String(feature["properties"]["name"])
			add_child(constellation)  # Add Constellation to the scene tree
			
			var stars_node = constellation.get_node("Stars")
			if geometry["type"] == "MultiLineString":
				for line_coords in geometry["coordinates"]:
					_create_lines_and_stars(line_coords, stars_node, constellation)
			elif geometry["type"] == "LineString":
				_create_lines_and_stars(geometry["coordinates"], stars_node, constellation)

func _create_lines_and_stars(coordinates: Array, stars_node: Node, constellation: Node):
	var line = constellation.get_node("Line")
	line.default_color = Color(1, 1, 1)  # White color
	line.width = 2  # Set line width
	
	for coord in coordinates:
		var pixel_coord = geo_to_pixel(coord[0], coord[1])
		
		# Check if the star already exists at this position
		if not existing_stars.has(pixel_coord):
			line.add_point(pixel_coord)
			_create_star(pixel_coord, stars_node)
			existing_stars[pixel_coord] = true  # Mark this position as having a star
		else:
			# Optional: handle the case where the star already exists
			print("Star at position %s already exists!" % pixel_coord)

func _create_star(position: Vector2, stars_node: Node):
	var star_instance = star_scene.instantiate() as Star
	star_instance.position = position
	stars_node.add_child(star_instance)  # Add the star to the Stars node

func geo_to_pixel(longitude: float, latitude: float) -> Vector2:
	# Convert latitude and longitude to radians
	var lat_rad = deg_to_rad(latitude)
	var long_rad = deg_to_rad(longitude)

	# Calculate the radius of the circle based on the latitude
	var radius = (90 - latitude) / 90 * (WORLD_HEIGHT / 2)  # Scale to half the world height

	# Calculate x and y positions using polar coordinates
	var x = radius * sin(long_rad)
	var y = radius * cos(long_rad)

	# Shift the coordinates to the center of the circle
	var center_x = WORLD_WIDTH / 2
	var center_y = WORLD_HEIGHT / 2

	return Vector2(center_x + x, center_y - y)
