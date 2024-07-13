extends Player
class_name HumanPlayer

var player_ui: Node

var _is_moving_fast: bool = false
var _is_reversing: bool = false
var _is_forwarding: bool = false


func _ready():
	super() # Call base class's _ready()
	player_ui = SceneManager.load_scene("res://Players/UI/PlayerUI.tscn")
	player_ui.visible = false # initially invisible
	add_child(player_ui)
	
	$origin.global_transform.origin = vehicle.global_transform.origin

	# rotate orogin so camera is behind vehicle - get vehicle's -z axis
	$origin.rotation.y = vehicle.rotation.y


func _physics_process(delta):
	super(delta) # Call super class's _physics_process()
	# follow vehicle
	$origin.global_transform.origin = vehicle.global_transform.origin
	
	# reset accelreation, brake, steering
	vehicle.reset_vehicle_controls(delta)
	
	if vehicle.get_linear_velocity().length() > 0.3:
		_is_moving_fast = true
	else:
		_is_moving_fast = false
	
	if Input.is_action_pressed("forward"):
		vehicle.acclerate(vehicle.max_engine_force)
	
	if Input.is_action_pressed("back"):
		vehicle.acclerate(-vehicle.max_engine_force)
	
	if Input.is_action_pressed("right"):
		vehicle.steer(
			lerp(vehicle.steering, -vehicle.max_steering_angle, 25.0 * delta / (1+(vehicle.get_linear_velocity().length() / 50)))
			)
	
	if Input.is_action_pressed("left"):
		vehicle.steer(
			lerp(vehicle.steering, vehicle.max_steering_angle, 25.0 * delta / (1+(vehicle.get_linear_velocity().length() / 50)))
		)




func _input(event):
	
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var mouse_delta = event.relative
		$origin.rotate_y(deg_to_rad(-mouse_delta.x * 0.2))
		$origin/pivot.rotate_x(deg_to_rad(mouse_delta.y * 0.2))



func _process(delta):
	super(delta)
	player_ui.display_all_players()
	if finished or Input.is_action_pressed("ui_home"):
		player_ui.visible = true
	else:
		player_ui.visible = false
