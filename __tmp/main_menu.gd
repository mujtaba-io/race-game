extends Control

var ip_input: LineEdit
var join_button: Button
var create_room_button: Button

# lobby ui
var lobby: Panel
var close_lobby_button: Button
var lobby_players_list: ItemList
var join_red_button: Button
var join_blue_button: Button
var start_game_button: Button

signal open_lobby

# Called when the node enters the scene tree for the first time.
func _ready():
	ip_input = $VBoxContainer/ip_input
	join_button = $VBoxContainer/join_button
	create_room_button = $VBoxContainer/create_room_button
	
	# lobby ui
	lobby = $lobby
	close_lobby_button = $lobby/close_lobby_button
	lobby_players_list = $lobby/VBoxContainer/players_list
	join_red_button = $lobby/VBoxContainer/HBoxContainer/join_red_button
	join_blue_button = $lobby/VBoxContainer/HBoxContainer/join_blue_button
	start_game_button = $lobby/start_game_button
	
	lobby.visible = false
	
	global.player_connected.connect(on_player_connected)
	global.player_disconnected.connect(on_player_disconnected)
	global.server_disconnected.connect(on_server_disconnected)
	
	open_lobby.connect(on_open_lobby)


func _process(delta):
	if multiplayer.multiplayer_peer:
		if not (multiplayer.multiplayer_peer.get_connection_status() == multiplayer.multiplayer_peer.CONNECTION_CONNECTED or multiplayer.multiplayer_peer.get_connection_status() == multiplayer.multiplayer_peer.CONNECTION_CONNECTING):
			lobby.visible = false
			global.remove_multiplayer_peer()
	else:
		lobby.visible = false


func _on_join_button_pressed():
	var server_ip: String = ip_input.text
	var error = global.join_game(server_ip)
	if error == null:
		open_lobby.emit()


func _on_create_room_button_pressed():
	var error = global.create_game()
	if error == null:
		open_lobby.emit()


func _on_join_red_button_pressed():
	global.select_team.rpc("red")


func _on_join_blue_button_pressed():
	global.select_team.rpc("blue")


# reset multiplayer state to null
func _on_close_lobby_button_pressed():
	lobby.visible = false
	lobby_players_list.clear()
	global.remove_multiplayer_peer()




# in lobby

func on_player_connected(peer_id, player_info):
	lobby_players_list.add_item(player_info['name'] + ' @' + str(peer_id))
	print("PLAYER @"+ str(peer_id) +" CONNECTED :)")

func on_player_disconnected(peer_id):
	var delete_item_id = -1
	for i in lobby_players_list.item_count:
		if lobby_players_list.get_item_text(i).contains(str(peer_id)):
			delete_item_id = i
	lobby_players_list.remove_item(delete_item_id)
	print("PLAYER @"+ str(peer_id) +" DISCONNECTED :(")

func on_server_disconnected():
	lobby.visible = false
	global.remove_multiplayer_peer()
	print("SERVER DISCONNECTED :(")


func on_open_lobby():
	lobby.visible = true
	if not multiplayer.multiplayer_peer.get_unique_id() == 1:
		start_game_button.disabled = true
		start_game_button.text = "Server must start"











func _on_start_game_button_pressed():
	global.load_game.rpc("res://world.tscn")
	print(global.players)
