
# base calss for all controllers

extends Node
class_name Player

# controller must have a name - player's name
var player_name: String

# controller must be child of whatever it controls
var vehicle: Vehicle3D


# sent to global script using get_car_state()
var player_state: Dictionary = {
	'vehicle_name': '',
	'position': var_to_str(Vector3.ZERO),
	'rotation': var_to_str(Vector3.ZERO),
	
	'lap': 0,
	'race_start_time': null,
	'race_end_time': null,
}


# when added to scene tree
func _ready():
	vehicle = get_parent()
	player_state['vehicle_name'] = vehicle.vehicle_name


# only call this if player state should be derived from actual physics player
# for network player, state will be pulled from internet server
func update_player_state():
	player_state = {
		'vehicle_name': vehicle.vehicle_name,
		'position': var_to_str(vehicle.position),
		'rotation': var_to_str(vehicle.rotation),
		
		'lap': vehicle.lap,
		'race_start_time': null,
		'race_end_time': null,
	}
