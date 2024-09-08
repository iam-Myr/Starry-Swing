extends AudioStreamPlayer

func play_sound(folder_name,index, pitch_change):
	# Create the file path string
	var sound_string = "res://Assets/Audio/" + folder_name + "/" + str(index) + ".wav"
	
	# Load the sound resource dynamically at runtime
	var sound = ResourceLoader.load(sound_string)
	
	if sound:  # Check if the sound was loaded successfully
		# Play random sound pitch
		if pitch_change:
			pitch_scale = randf_range(0.9, 1.3)
		stream = sound
		play()
	else:
		print("Failed to load sound:", sound_string)

