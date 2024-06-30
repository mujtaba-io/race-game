extends Panel

var lobby_players_list: ItemList
var this_player = Room.get_human_player() # whoever is the human player here

# Called when the node enters the scene tree for the first time.
func _ready():
	lobby_players_list = $VBoxContainer/players_list


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for player in Room.players:
		var player_found = false
		
		for i in lobby_players_list.get_item_count():
			if lobby_players_list.get_item_text(i) == player.name:
				player_found = true
		if not player_found:
			lobby_players_list.add_item(player.name)
	
	if Room.admin ==  this_player.name:
		$start_game_button.visible = true
	else:
		$start_game_button.visible = false
	
	if Room.state == 'in_game':
		get_tree().change_scene_to_file("res://scenes/levels/level.tscn")


func _on_start_game_button_pressed():
	Room.start_game()

