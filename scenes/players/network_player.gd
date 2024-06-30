extends Player
class_name NetworkPlayer


func _process(delta):
	update_variables()


func update_variables():
	# ONLY CALLED ON NETWORK PLAYER
	vehicle.name = data['vehicle_name']
	vehicle.position = str_to_var(data['position'])
	vehicle.rotation = str_to_var(data['rotation'])
	lap = data['lap']
	timer = data['time_elapsed']
	finished = data['finished']


# ONLY CALLED ON NETWORK PLAYER
func update_data_dict(new_data_dict: Dictionary):
	data['vehicle_name'] = new_data_dict['vehicle_name']
	data['position'] = new_data_dict['position']
	data['rotation'] = new_data_dict['rotation']
	data['lap'] = new_data_dict['lap']
	data['time_elapsed'] = new_data_dict['time_elapsed']
	data['finished'] = new_data_dict['finished']
