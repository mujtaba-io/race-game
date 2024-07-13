extends Control


var stats: Control
var label: Label

func _ready():
	stats = $Stats
	stats.visible = false
	
	label = $Stats/Panel/Label

# Display player names and their timer. Sort timers in ascending order and display them.
func display_all_players():
	# sort all_players array by players[i].timer value in ascending order
	var players_sorted = []
	for player in get_tree().get_nodes_in_group("players"):
		players_sorted.append([player.name, player.timer])
	
	# Sort the players_sorted list by the timer values (second element of each sublist) without using lambda
	var n = players_sorted.size()
	for i in range(n - 1):
		for j in range(n - i - 1):
			if players_sorted[j][1] > players_sorted[j + 1][1]:
				# Swap the elements
				var temp = players_sorted[j]
				players_sorted[j] = players_sorted[j + 1]
				players_sorted[j + 1] = temp

	var text = "Player name        Finish time\n"
	for player in players_sorted:
		text += player[0] + "        " + str(player[1]) + "\n"
	
	# Assuming label is a pre-defined object with a text attribute
	label.text = text



func _on_back_to_main_menu_button_pressed():
	SceneManager.switch_scene(
		SceneManager.load_scene("res://MainMenu/MainMenu.tscn")
	)



# INPUT TOUCH ETC RELATED
var initial_mouse_pos: Vector2 = Vector2()
var _is_accelerator_pressed: bool = false


# Function to get the position of the input
func get_input_position():
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		return get_viewport().get_mouse_position()
	return null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input_pos = get_input_position()
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		# If the mouse button is pressed and initial_mouse_pos is not set, store the initial position
		if initial_mouse_pos == Vector2():
			initial_mouse_pos = input_pos
		elif ($Controls/Steering.transform * $Controls/Steering.get_rect()).has_point(initial_mouse_pos):
			# Calculate the horizontal drag distance
			var horizontal_drag_distance = input_pos.x - initial_mouse_pos.x
			# Rotate the sprite based on the horizontal drag distance
			$Controls/Steering.rotation += horizontal_drag_distance * 0.01
			# Clamp the rotation
			$Controls/Steering.rotation = clamp($Controls/Steering.rotation, -0.5, 0.5)
			# Update the initial position for the next frame
			initial_mouse_pos = input_pos
	else:
		# If the mouse button is not pressed, reset the initial position and gradually reset the rotation
		initial_mouse_pos = Vector2()
		$Controls/Steering.rotation = lerp_angle($Controls/Steering.rotation, 0, delta * 25)


	if ($Controls/Accelerator.transform * $Controls/Accelerator.get_rect()).has_point(initial_mouse_pos):
		_is_accelerator_pressed = true
	else:
		_is_accelerator_pressed = false


func is_accelerator_pressed():
	return _is_accelerator_pressed

func get_steering_angle() -> float:
	return $Controls/Steering.rotation * -1
