extends Player
class_name HumanPlayer

func _physics_process(delta):
	# follow vehicle
	$origin.global_transform.origin = vehicle.global_transform.origin
	
	# reset accelreation, brake, steering
	vehicle.reset_vehicle_controls(delta)
	
	if Input.is_action_pressed("forward"):
		vehicle.acclerate()
	if Input.is_action_pressed("back"):
		vehicle.reverse()
	if Input.is_action_pressed("right"):
		vehicle.steer_right(delta)
	if Input.is_action_pressed("left"):
		vehicle.steer_left(delta)
	
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)



func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var mouse_delta = event.relative
		$origin.rotate_y(deg_to_rad(-mouse_delta.x * 0.2))
		$origin/pivot.rotate_x(deg_to_rad(mouse_delta.y * 0.2))

