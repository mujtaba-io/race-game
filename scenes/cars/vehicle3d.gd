extends VehicleBody3D
class_name Vehicle3D

@export var vehicle_name: String = 'Car'
@export var max_steering_angle: float = 0.5 # radians
@export var max_engine_force: float = 800 # max_engine_force
@export var max_brake: float = 10 # max_engine_force

var lap: int = 0#R
var win_time: Time = null#R


# should introduce levels/gearsa?
func acclerate():
	engine_force = max_engine_force


func reverse():
	engine_force = -max_engine_force


func steer_right(delta):
	steering = lerp(steering, -0.5, 25.0 * delta) # -0.5 


func steer_left(delta):
	steering =  lerp(steering, 0.5, 25.0 * delta) # 0.5


func apply_brake():
	brake = max_brake


# >
# >
# >


# must reset values after user has stopped pushing acclerate pedal
func reset_vehicle_controls(delta):
	engine_force = 0
	steering = lerp(steering, 0.0, 10.0 * delta)
	brake = 0
