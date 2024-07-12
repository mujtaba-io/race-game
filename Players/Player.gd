
# RULE: PLAYER MUST BE A PARENT OF 1 VEGICLE

extends Node
class_name Player

var lap: int = 0
var timer: float = 0.0
var finished: bool = false
var distance_traveled: float = 0.0

@export var vehicle: Vehicle3D


# Constructor
func with_data(_vehicle: Vehicle3D) -> Player:
	set_vehicle(_vehicle)
	return self # IMPORTANT



func set_vehicle(_vehicle: Vehicle3D):
	if vehicle: # if it already attached
		remove_child(vehicle) # Remove it else 2 vehicles will be there in level
	self.vehicle = _vehicle
	self.add_child(_vehicle)


func get_vehicle():
	return self.vehicle


# when added to scene tree
func _ready():
	self.add_to_group("players") # all Player instances



func _physics_process(delta):
	update_distance_traveled()
	update_timer(delta)


func _process(delta):
	pass


var _last_player_position: Vector3 = Vector3.ZERO #tmp
func update_distance_traveled():
	# find length ot vector between last and current position
	var distance = vehicle.position.distance_to(_last_player_position)
	_last_player_position = vehicle.position # update last position
	distance_traveled += distance


func get_distance_traveled():
	return distance_traveled


func update_timer(delta: float):
	if not finished:
		timer += delta


func next_lap():
	if not finished:
		lap += 1
		print("debug: lap " + str(lap))
