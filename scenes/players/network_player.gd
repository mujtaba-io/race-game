extends Player


# odify car values from internet-modified vehicle-state-dict
func _physics_process(delta):
	
	# update current player state from global
	player_state = global_script.pull_player_state(player_name)
	
	# reset accelreation, brake, steering
	vehicle.position = player_state['position']
	vehicle.rotation = player_state['rotation']

