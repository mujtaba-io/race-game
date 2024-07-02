
# RULE: PLAYER MUST BE A PARENT OF 1 VEGICLE

extends Node
class_name Player

var lap: int = 0
var timer: float = 0.0

var distance_traveled: float = 0.0
@export var vehicle: Vehicle3D

var finished: bool = false

func set_vehicle(_vehicle: Vehicle3D):
	if vehicle: # if it already attached
		remove_child(vehicle) # Remove it else 2 vehicles will be there in level
	self.vehicle = _vehicle
	self.add_child(_vehicle)
	
	data['vehicle'] = _vehicle.name # ! CHEAP-BUG SOLUTION?: To solve the null-assign-to-name wwhen not added to tree but state is shared.


func get_vehicle():
	return self.vehicle


# when added to scene tree
func _ready():
	self.add_to_group("players") # all Player instances



func _process(delta):
	update_distance_traveled()


var _last_player_position: Vector3 = Vector3.ZERO #tmp
func update_distance_traveled():
	# find length ot vector between last and current position
	var distance = vehicle.position.distance_to(_last_player_position)
	_last_player_position = vehicle.position # update last position
	distance_traveled += distance


func get_distance_traveled():
	return distance_traveled


# HANDLE WIN SITUATION IF LAP > MAX LAPS
func trigger_next_lap(track_length: float):
	if (get_distance_traveled() / (lap + 1)) >= 0.75 * track_length:
		lap += 1
		print("lap: "+str(lap))




#>
#>


# player's data
var data: Dictionary = {
	'vehicle': '', # Name/ScenePath of vehicle
	'position': var_to_str(Vector3.ZERO),
	'rotation': var_to_str(Vector3.ZERO),
	
	'lap': 0,
	'timer': 0.0, # time elapsed since start of race
	"finished": false, # is finished racing
}

func get_data_dict():
	return data


func set_data_dict(new_data: Dictionary):
	data = new_data
