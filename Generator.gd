extends Node2D

# Constants for the world size
const WORLD_HEIGHT = 5000
var WORLD_WIDTH = 7000

# Coordinate range constants
const LONG_RANGE = 360
const LAT_RANGE = 180

# Scaling factors
var x_scale = WORLD_WIDTH / LONG_RANGE
var y_scale = WORLD_HEIGHT / LAT_RANGE

# Paths to the scenes
@onready var star_scene = preload("res://Scenes/Star.tscn")
@onready var constellation_scene = preload("res://Scenes/consellation.tscn")

# Path to the JSON file
const JSON_FILE_PATH = "res://constellations.json"

func _ready():
	_load_and_parse_json()
	#$Player.position = Vector2(WORLD_WIDTH, WORLD_WIDTH/2)

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
			#print(constellation.constellation_name)
			constellation.constellation_name = String(feature["properties"]["name"])
			print(constellation.constellation_name)
			add_child(constellation)  # Add Constellation to the scene tree
			
			# Create a node for stars inside the Constellation
			var stars_node = Node2D.new()
			stars_node.name = "Stars"
			
			if geometry["type"] == "MultiLineString":
				for line_coords in geometry["coordinates"]:
					_create_lines_and_stars(line_coords, stars_node, constellation)
			elif geometry["type"] == "LineString":
				_create_lines_and_stars(geometry["coordinates"], stars_node, constellation)

func _create_lines_and_stars(coordinates: Array, stars_node: Node, constellation: Node):
	var line = Line2D.new()
	line.default_color = Color(1, 1, 1)  # White color
	line.width = 2  # Set line width
	
	constellation.add_child(line)  # Add the line to the Constellation node
	constellation.add_child(stars_node)
	
	for coord in coordinates:
		var pixel_coord = geo_to_pixel(coord[0], coord[1])
		line.add_point(pixel_coord)
		_create_star(pixel_coord, stars_node)

func _create_star(position: Vector2, stars_node: Node):
	var star_instance = star_scene.instantiate() as Star
	star_instance.position = position
	stars_node.add_child(star_instance)  # Add the star to the Stars node

func geo_to_pixel(longitude: float, latitude: float) -> Vector2:
	var x = (longitude + 180) * x_scale
	var y = (90 - latitude) * y_scale
	return Vector2(x, y)
