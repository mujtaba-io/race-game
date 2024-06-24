extends Panel

var lobby_players_list: ItemList

# Called when the node enters the scene tree for the first time.
func _ready():
	lobby_players_list = $VBoxContainer/players_list


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for player in global_script.room_state['players']:
		var player_found = false
		
		for i in lobby_players_list.get_item_count():
			if lobby_players_list.get_item_text(i) == player:
				player_found = true
		if not player_found:
			lobby_players_list.add_item(player)
	
	# if we are admin
	if global_script.room_state['game']['admin'] ==  global_script.our_player_name:
		$start_game_button.visible = true
	else:
		$start_game_button.visible = false
	
	if global_script.room_state['game']['state'] == 'in_game':
		# instead do based on game_state[game][selected-level]
		get_tree().change_scene_to_file("res://scenes/levels/prototype.tscn")
	
	# keep joining foom, for keep-alive purpose and to keep itself updated of
	# server changes
	keep_alive_lobby_connection(delta)


const max_timer__keep_alive_lobby_connection = 0.4
var timer__keep_alive_lobby_connection = 0.0
func keep_alive_lobby_connection(delta):
	timer__keep_alive_lobby_connection += delta
	if timer__keep_alive_lobby_connection > max_timer__keep_alive_lobby_connection:
		timer__keep_alive_lobby_connection = 0.0
		global_script.join_room()


func _on_start_game_button_pressed():
	# only if we are admin, we can start, else button will be disabled
	global_script.trigger_start_game()
	
