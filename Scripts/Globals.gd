extends Node

signal world_size_changed

var WORLD_SIZE = Vector2.ZERO:
	get:
		return WORLD_SIZE
	set(value):
		WORLD_SIZE = value
		world_size_changed.emit()
