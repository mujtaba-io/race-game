extends Control



var _level_list: ItemList
var _vehicle_list: ItemList
var _laps: LineEdit



var _selected_level_resource_path: String
var _selected_vehicle_resource_path: String
var _number_laps: int = 3

var _players: Array[Player] = []


func _ready():
	_level_list = $levels
	_vehicle_list = $vehicles
	_laps = $laps
	
	_fill_levels_and_vehicles()



# Display levels and vehicles in their respective dropdowns
func _fill_levels_and_vehicles():
	if _level_list.item_count > 0: return # TO NOT REPEAR-WRITE EVERYTHING
	for level in AssetManager.levels:
		_level_list.add_item(level)
	
	for vehicle in AssetManager.vehicles:
		_vehicle_list.add_item(vehicle)



func _on_levels_item_selected(index: int):
	var key = _level_list.get_item_text(index)
	_selected_level_resource_path = AssetManager.levels[key]



func _on_vehicles_item_selected(index: int):
	var key = _vehicle_list.get_item_text(index)
	_selected_vehicle_resource_path = AssetManager.vehicles[key]



func _on_start_game_button_pressed():
	var _number_laps = int(_laps.text)
	
	var _tmp_human_player = SceneManager.load_scene("res://Players/HumanPlayer.tscn").with_data(
		SceneManager.load_scene(_selected_vehicle_resource_path)
	)
	_tmp_human_player.vehicle.collision_layer = pow(2, 2 - 1)
	_players.append(_tmp_human_player)
	
	# TMP TEST CREATE AI PLAYERS ###############################################
	for i in range(4):
		var ai_player = SceneManager.load_scene("res://Players/AIPlayer.tscn").with_data(
				SceneManager.load_scene(AssetManager.vehicles[AssetManager.vehicles.keys().pick_random()])
			)
		ai_player.vehicle.collision_layer = pow(2, (i+3) - 1)
		_players.append(
			ai_player
		)
	##########################################################
	
	SceneManager.switch_scene(
		SceneManager.load_scene(_selected_level_resource_path).with_data(
			_players, _number_laps
		)
	)

