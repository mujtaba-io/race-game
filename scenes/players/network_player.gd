extends Player
class_name NetworkPlayer


func _process(delta):
	Room.get_player_data(self.name)
	update_variables()


func update_variables():
	# ONLY CALLED ON NETWORK PLAYER
	vehicle.name = data['vehicle']
	vehicle.position = str_to_var(data['position'])
	vehicle.rotation = str_to_var(data['rotation'])
	lap = data['lap']
	timer = data['timer']
	finished = data['finished']
