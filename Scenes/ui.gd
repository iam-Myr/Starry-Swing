extends CanvasLayer

@onready var constellation_name_label = $ConstellationNameContainer/HBoxContainer/ConstellationName
@onready var date_label = $DateContainer/Date

func _process(delta):
	var date = Time.get_datetime_string_from_system()
	date = date.replace("T", "   ")
	date_label.text = date
	

func show_label(constellation_name):
	constellation_name_label.text = constellation_name
	$ConstellationNameContainer.visible = true

func hide_label():
	$ConstellationNameContainer.visible = false


