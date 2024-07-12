
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
	
	
	#vehicle.acclerate()
	#vehicle.steer_right(delta)
	vehicle.linear_velocity = get_nearest_direction(track.curve, vehicle.global_position)*40



func get_nearest_direction(curve : Curve3D, point : Vector3) -> Vector3:
	var offset := curve.get_closest_offset( point )
	var point_1 := curve.sample_baked( offset, true )
	var point_2 := curve.sample_baked( offset + 0.5, true )
	var direction : Vector3 = ( point_2 - point_1 ).normalized()
	return direction
