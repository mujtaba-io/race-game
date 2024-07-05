extends Player
class_name NetworkPlayer


func _process(delta):
	# REMOVE PLAYER IF NOT IN FRESH DATA FROM SERVER (they left the game and now server has removed them)
	if self.name not in Room.data['players']:
		self.queue_free()
		return
	
	data = Room.get_player_data(self.name) # MUST ASSIGN NEW DATA TO data
	update_variables()


func update_variables():
	# ONLY CALLED ON NETWORK PLAYER
	vehicle.name = data['vehicle']
	vehicle.position = str_to_var(data['position'])
	vehicle.rotation = str_to_var(data['rotation'])
	lap = data['lap']
	timer = data['timer']
	finished = data['finished']
