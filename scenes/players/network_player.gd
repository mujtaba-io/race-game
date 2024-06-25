extends Player


# BUG: if player_state is initially null, it gives error as
# it take ssome time for server to update proper state
# until then, local clients have to deal with it.
# BEST SOLUTION IS TO add controler only after its
# player_state is correctly updated

# odify car values from internet-modified vehicle-state-dict


func _process(delta):
	
	if is_physics_processing() or vehicle.is_physics_processing():
		set_physics_process(false) # disable physics for ntwork player
		vehicle.set_physics_process(false)
	
	# update current player state from global
	player_state = global_script.pull_player_state(player_name)
	
	print("LOCAL PLAYER STATE"+str(player_state))
	
	if not (player_state as Dictionary).is_empty():
		# reset accelreation, brake, steering
		vehicle.position = str_to_var(player_state['position'])
		vehicle.rotation = str_to_var(player_state['rotation'])

