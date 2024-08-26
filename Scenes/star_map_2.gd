extends Node2D

#@onready var size = Vector2(7000,5000)
@onready var size = Vector2(2075,1595)
 

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set Polaris Scale
	$UMi/Stars/Polaris.scale = Vector2(2,2)
