extends Control

var jeep = preload("res://scenes/vehicles/jeep.tscn")
var human_player = preload("res://scenes/players/human_player.tscn")

func _process(delta):
	# if room state turned to lobby, change the scene to lobby
	if Room.state == 'in_lobby':
		get_tree().change_scene_to_file("res://scenes/main_menu/lobby.tscn")

func _on_button_pressed():
	var pin: String = $VBoxContainer/LineEdit.text.to_lower().strip_edges().strip_escapes()
	var player_name: String = $VBoxContainer/name.text
	
	var player := human_player.instantiate()
	player.name = player_name
	player.set_vehicle(jeep.instantiate())

	
	# vAttempt to join room pin with player - if success, room status will turn to in-lobby
	# Else nothing will happen
	Room.join_room(pin, player)
	
	
