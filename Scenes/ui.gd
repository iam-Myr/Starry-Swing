extends CanvasLayer

@onready var label = $MarginContainer/HBoxContainer/Label

func show_label(constellation_name):
	label.text = constellation_name
	$MarginContainer.visible = true

func hide_label():
	$MarginContainer.visible = false


