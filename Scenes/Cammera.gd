extends Camera2D

var zoom_speed = Vector2(0.1,0.1)
var min_zoom = Vector2(0.1,0.1)
var max_zoom = Vector2(2,2)

func _input(event):
	if event.is_action_pressed("zoom in"):
		zoom = clamp(zoom - zoom_speed, min_zoom, max_zoom)
	if event.is_action_pressed("zoom out"):
		zoom = clamp(zoom + zoom_speed, min_zoom, max_zoom)
