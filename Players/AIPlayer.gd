
# AIPlayer keeps itself alighed with the track. Track dependenciy is
# resolved by Level.gd during AIPlayer's initialization.

extends Player
class_name AIPlayer


var track: Path3D

func set_track(_track: Path3D):
	track = _track
	return self


func _ready():
	super()


func _process(delta):
	super(delta)


func _physics_process(delta):
	super(delta)
	
	follow_direction(
		get_nearest_direction(track.curve, vehicle.global_transform.origin)
		 + (track.curve.get_closest_point(vehicle.global_transform.origin) - vehicle.global_transform.origin).normalized() / 4.0
		)
	
	if not (vehicle.steering > 0.3 or vehicle.steering < -0.3):
		vehicle.acclerate(vehicle.max_engine_force * 1.3)
	else:
		vehicle.acclerate(vehicle.max_engine_force / 4)


func get_nearest_direction(curve : Curve3D, point : Vector3) -> Vector3:
	var offset := curve.get_closest_offset( point )
	var point_1 := curve.sample_baked( offset, true )
	var point_2 := curve.sample_baked( offset + 0.5, true )
	var direction : Vector3 = ( point_2 - point_1 ).normalized()
	return direction


func follow_direction(direction: Vector3):
	var steering_target = vehicle.global_transform.origin + direction
	var fwd = vehicle.linear_velocity.normalized()
	var target_vector = (steering_target - vehicle.global_transform.origin)
	vehicle.steering = fwd.cross(target_vector.normalized()).y
