extends Camera2D

const zoom_speed = Vector2(0.05,0.05)
const min_zoom = Vector2(0.15,0.15)
const max_zoom = Vector2(2,2)

const CENTER_THRESHOLD = Vector2(0.15,0.15)
var CENTER_COORDS

func _ready():
	var tween = create_tween()
	tween.tween_property(self, "zoom", Vector2(1,1), 3).from(Vector2(0.7,0.7))
	
	# Connect signal for getting world size
	Globals.connect("world_size_changed", update_center)

func update_center():
	CENTER_COORDS = Vector2(Globals.WORLD_SIZE.x/2, Globals.WORLD_SIZE.y/2)

func _input(event):
	if event.is_action_pressed("zoom in"):
		zoom = clamp(zoom + zoom_speed, min_zoom, max_zoom)
		if zoom > CENTER_THRESHOLD:
			global_position =  get_parent().global_position
	if event.is_action_pressed("zoom out"):
		zoom = clamp(zoom - zoom_speed, min_zoom, max_zoom)
		if zoom <= CENTER_THRESHOLD:
			var tween = create_tween()
			tween.tween_property(self, "global_position", CENTER_COORDS, 0.2)
			#global_position =  CENTER_COORDS 
