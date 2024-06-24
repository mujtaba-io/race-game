extends Control

func _process(delta):
	if global_script.room_state['game']['state'] == 'in_lobby':
		get_tree().change_scene_to_file("res://scenes/main_menu/lobby.tscn")

func _on_button_pressed():
	var pin:String = $VBoxContainer/LineEdit.text
	var player_name:String = $VBoxContainer/name.text
	
	global_script.our_player_name = player_name
	global_script.room_pin = pin.to_lower().strip_edges().strip_escapes()
	
	global_script.join_room()
	
