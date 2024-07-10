extends VehicleBody3D
class_name Vehicle3D


@export var vehicle_name: String = 'Vehicle'
@export var max_steering_angle: float = 0.5 # radians
@export var max_engine_force: float = 800 # max_engine_force
@export var max_brake: float = 10 # max_engine_force


func _ready():
	self.add_to_group("vehicles")


# should introduce levels/gearsa?
func acclerate():
	engine_force = max_engine_force


func reverse():
	engine_force = -max_engine_force


func steer_right(delta):
	steering = lerp(steering, -max_steering_angle, 25.0 * delta)

func steer_left(delta):
	steering = lerp(steering, max_steering_angle, 25.0 * delta)


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
