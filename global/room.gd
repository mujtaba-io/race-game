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
var human_player_name: String = ''

# CALLED BY HUMAN PLAYER - WILL REQUEST TO SERVER, WHIHC IN TURN WILL UPDATE ENTIRE Room.data DICT
func set_player_data(human_player_data: Dictionary):
	var req_data := {
		'name': human_player_name,
		'data': human_player_data,
	}
	Backyard.fetch("/setplayerdata/"+pin, req_data)


# CALLED BY NETWORK PLAYER TO GET ITS DATA FROM UPDATED ROOM data
func get_player_data(network_player_name: String) -> Dictionary:
	return data['players'][network_player_name]

#>
#>




func join_room(_pin:String, _name:String):
	pin = _pin
	human_player_name = _name
	
	data['admin'] = human_player_name
	data['state'] = 'in_lobby'
	data['players'][human_player_name] = {}
	
	var req_data = {
		'name': human_player_name,
		'room': data
		} # Send room data to server
	Backyard.fetch_unique('/joinroom/'+pin, req_data)


func start_game():
	var req_data = {
		'name': human_player_name,
	}
	Backyard.fetch_unique('/startgame/'+pin, req_data)


