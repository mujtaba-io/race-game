extends Control


@onready var label: Label = $panel/label

@onready var level = get_parent() # LEVEL MUST BE ITS PARENT

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	display_all_players()
	
	if Room.human_player.finished or Input.is_action_pressed("ui_home"):
		visible = true
	else:
		visible = false
	
	if Room.data['state'] == 'in_lobby':
		get_tree().change_scene_to_file("res://scenes/main_menu/lobby.tscn")


# Display player names and their timer. Sort timers in ascending order and display them.
func display_all_players():
	var players = Room.data['players']
	var players_sorted = []
	for player_name in players:
		players_sorted.append([player_name, players[player_name]['timer']])
	
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


# If player just doesnt wanna play
func _on_back_to_main_menu_pressed():
	Room.reset()
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
