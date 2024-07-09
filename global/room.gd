extends Node


var network_player = preload("res://scenes/players/network_player.tscn")
var jeep = preload("res://scenes/vehicles/jeep.tscn")


var data: Dictionary = {
	'pin': '', # Room pin
	'level': '', # Path of the level scene
	'laps': 0, # Number of laps
	'admin': '', # Admin player name
	'state': '', # Room state (in_lobby/in_game)
	'players': {
		# Player data
		# 'name': {
		# 	'position': Vector3,
		# 	'rotation': Vector3,
		# 	'vehicle': String,
		# 	'lap': int,
		# 	'timer': float,
		# 	'finished': bool,
		# }
	}, # Players in the room
}

var pin: String
var human_player: HumanPlayer

# CALLED BY HUMAN PLAYER - WILL REQUEST TO SERVER, WHIHC IN TURN WILL UPDATE ENTIRE Room.data DICT
func set_player_data(human_player_data: Dictionary):
	var req_data := {
		'name': human_player.name,
		'data': human_player_data,
	}
	Backyard.fetch("/setplayerdata/"+pin, req_data)


# CALLED BY NETWORK PLAYER TO GET ITS DATA FROM UPDATED ROOM data
func get_player_data(network_player_name: String) -> Dictionary:
	return data['players'][network_player_name]

#>
#>




func join_room(_pin:String, _human_player: HumanPlayer):
	pin = _pin
	human_player = _human_player
	
	data['admin'] = human_player.name
	data['state'] = 'in_lobby'
	data['laps'] = 3 # default 3 laps
	data['players'][human_player.name] = {}
	
	var req_data = {
		'name': human_player.name,
		'player_data': human_player.data,
		'room_data': data
		} # Send room data to server
	Backyard.fetch_unique('/joinroom/'+pin, req_data)


func start_game():
	var req_data = {
		'name': human_player.name,
	}
	Backyard.fetch_unique('/startgame/'+pin, req_data)



func set_level(resource_path: String):
	data['level'] = resource_path
	Backyard.fetch_unique("/changelevel/"+pin, {'level': data['level']})



func reset():
	Backyard.fetch_unique('/leaveroom/'+pin, { 'name': human_player.name })
	human_player.queue_free()
	pin = ''


#> #>

# Every client will be calling it according to their own 6 elapsed seconds,
# so in reality, updates will be more frequent with more clients connected
const SERVER_ROOM_RESET_TIME = 6 # TRIGER SERVER RESET AFTER 3 SECONDS
var server_reset_tmp_time = 0
func _process(delta):
	if server_reset_tmp_time < 0:
		server_reset_tmp_time = SERVER_ROOM_RESET_TIME
		Backyard.fetch_unique('/resetroom/'+pin, {})
	server_reset_tmp_time -= delta


func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		reset() # leave room on quit
		get_tree().quit() # default behavior
