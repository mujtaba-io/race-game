
# base calss for all controllers

extends Node
class_name Player

# controller must have a name - player's name
var player_name: String
var player_number: int = 0 # to avoid spawn-in-same-position conflict

# controller must be child of whatever it controls
var vehicle: Vehicle3D

var current_lap: int = 0
# time it took to complete race
var race_timer: float = 0.0


# sent to global script using get_car_state()
var player_state: Dictionary = {
	'vehicle_name': '',
	'position': var_to_str(Vector3.ZERO),
	'rotation': var_to_str(Vector3.ZERO),
	
	'lap': 0,
	'time_elapsed': 0.0, # time elapsed since race_start_time (see global room state)
	'spawn_point': 0, # number asigned by server to player used for spawning in correct position
	"finished": false, # is finished racing
}


# when added to scene tree
func _ready():
	vehicle = get_parent()
	player_state['vehicle_name'] = vehicle.vehicle_name


var time_elapsed: float = 0.0
func _process(delta):
	time_elapsed += delta
	player_state['time_elapsed'] = time_elapsed
	update_distance_traveled(delta)


# only call this if player state should be derived from actual physics player
# for network player, state will be pulled from internet server
func update_player_state():
	player_state['vehicle_name'] = vehicle.vehicle_name
	player_state['position'] = var_to_str(vehicle.position)
	player_state['rotation'] = var_to_str(vehicle.rotation)
	player_state['lap'] = current_lap
	player_state['time_elapsed'] = time_elapsed
	
	# NEVER SEND IT TO SERVER, instead pull from server only once at lobby
	# player_state['spawn_point'] = NEVER ASSIGN IT ON CLIENT SIDE, PULL FROM SERVER



var distance_traveled: float = 0.0 # total distance traveled by player
var last_player_position: Vector3 = Vector3.ZERO
func update_distance_traveled(delta):
	# find length ot vector between last and current position
	var distance = vehicle.position.distance_to(last_player_position)
	last_player_position = vehicle.position # update last position
	distance_traveled += distance

func get_distance_traveled():
	return distance_traveled
