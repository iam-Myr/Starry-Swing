extends Node2D

var is_unlocked: bool = false
var unlocking_mode: bool = false
var stars_unlocked = []
var total_stars = 0
@export var label: String

func const_star_activated(star):
	if not is_unlocked and star not in stars_unlocked:
		unlocking_mode = true
		stars_unlocked.append(star)
		star.get_node("ConstLight").enabled = true
		
		# Check if all stars are grabbed
		if stars_unlocked.size() == total_stars:
			unlock_constellation()
	# Also start timer
	$Timer.start()

func fail():
	# Flush everything
	unlocking_mode = false
	for star in stars_unlocked:
		star.get_node("ConstLight").enabled = false
	stars_unlocked = []

func _on_timer_timeout():
	fail()

func unlock_constellation():
	is_unlocked = true
	unlocking_mode = false
	
	# Visual Feedback
	for star in stars_unlocked:
		star.get_node("ConstLight").enabled = false
	
	$Line2D.default_color.a = 0.4





