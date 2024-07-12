extends Control


var label: Label

func _ready():
	label = $Panel/Label


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
