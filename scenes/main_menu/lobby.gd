extends Panel

@onready var lobby_players_list := $VBoxContainer/players_list

@onready var levelList := $admin_controls/levels
@onready var vehicleList := $admin_controls/vehicles

# Called when the node enters the scene tree for the first time.
func _ready():
	fill_levels_and_vehicles()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	Room.set_player_data(Room.human_player.data) # Update room data so new players wiull be updated to all other players
	
	for player_name in Room.data['players']:
		var player_found = false
		
		for i in lobby_players_list.get_item_count():
			if lobby_players_list.get_item_text(i) == player_name:
				player_found = true
		if not player_found:
			lobby_players_list.add_item(player_name)
	
	fill_levels_and_vehicles() # WHY NOT WORKS IN READY?
	
	if Room.data['admin'] ==  Room.human_player.name:
		$admin_controls.visible = true
	else:
		$admin_controls.visible = false
	
	
	if Room.data['state'] == 'in_game':
		get_tree().change_scene_to_file(Room.data['level'])


func _on_start_game_button_pressed():
	Room.start_game()



# Display levels and vehicles in their respective dropdowns
func fill_levels_and_vehicles():
	print(AssetManager.levels)
	if levelList.item_count > 0: return # TO NOT REPEAR-WRITE EVERYTHING
	for level in AssetManager.levels:
		levelList.add_item(level)

	for vehicle in AssetManager.vehicles:
		vehicleList.add_item(vehicle)

func _on_levels_item_selected(index: int):
	var key = levelList.get_item_text(index)
	Room.set_level(AssetManager.levels[key]) # SHOUDL INIT HERE?

func _on_vehicles_item_selected(index: int):
	var key = vehicleList.get_item_text(index)
	Room.human_player.set_vehicle(
		load(AssetManager.vehicles[key]).instantiate()
		) # SHOULD INIT HERE?

