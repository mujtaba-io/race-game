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


# In some cases, when data needs to be fetched without POST dota
func update_data(updated_data: Dictionary = {}):
	Backyard.fetch("/room/"+pin, {})



func set_level(resource_path: String):
	data['level'] = resource_path
	Backyard.fetch_unique("/changelevel/"+pin, {'level': data['level']})


#> #>

var tmp = 1
var tmp_ = 0
func _process(delta):
	if tmp_ < 0:
		tmp_ = tmp
		for player in data['players']:
			print("vehicle of player " + player +" is :"+str(data['players'][player]))
	tmp_ -= delta
