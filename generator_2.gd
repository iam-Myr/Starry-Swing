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

# Path to the SVG file
const SVG_FILE_PATH = "res://constellations_svg.svg"

func _ready():
	_load_and_parse_svg()
	#$Player.position = Vector2(WORLD_WIDTH, WORLD_WIDTH/2)

func _load_and_parse_svg():
	var constellations = []
	
	var file = FileAccess.open(SVG_FILE_PATH, FileAccess.READ)
	if file:
		var svg_content = file.get_as_text()
		file.close()
		
		# Parse the SVG content
		var xml = XMLParser.new()
		xml.open_buffer(svg_content.to_utf8_buffer())
		
		while xml.read() == OK:
			if xml.get_node_type() == XMLParser.NODE_ELEMENT and xml.get_node_name() == "path":
				var path_data = xml.get_named_attribute_value("d")
				if path_data != "":
					constellations.append(path_data)
		
		_create_constellations(constellations)
	else:
		print("Failed to open SVG file.")

func _create_constellations(constellations: Array):
	for path_data in constellations:
		var constellation_name = "Constellation_" + str(constellations.find(path_data))
		
		# Create an instance of the Constellation scene and set its name
		var constellation = constellation_scene.instantiate()
		constellation.name = constellation_name
		add_child(constellation)  # Add Constellation to the scene tree
		
		# Create a node for stars inside the Constellation
		var stars_node = Node2D.new()
		stars_node.name = "Stars"
		
		# Process the path data to create lines and stars
		_create_lines_and_stars(path_data, stars_node, constellation)

func _create_lines_and_stars(path_data: String, stars_node: Node, constellation: Node):
	var line = Line2D.new()
	line.default_color = Color(1, 1, 1)  # White color
	line.width = 2  # Set line width
	
	constellation.add_child(line)  # Add the line to the Constellation node
	constellation.add_child(stars_node)
	
	var commands = path_data.split("L")
	for command in commands:
		var coord_pair = command.replace("M", "").strip_edges().split(",")
		if coord_pair.size() == 2:
			var x = coord_pair[0].to_float()
			var y = coord_pair[1].to_float()
			var pixel_coord = svg_coord_to_pixel(Vector2(x, y))
			line.add_point(pixel_coord)
			_create_star(pixel_coord, stars_node)

func _create_star(position: Vector2, stars_node: Node):
	var star_instance = star_scene.instantiate()
	star_instance.position = position
	stars_node.add_child(star_instance)  # Add the star to the Stars node

func svg_coord_to_pixel(svg_coord: Vector2) -> Vector2:
	var x = svg_coord.x * (WORLD_WIDTH / 864)  # Scaling based on SVG width
	var y = svg_coord.y * (WORLD_HEIGHT / 432)  # Scaling based on SVG height
	return Vector2(x, y)
