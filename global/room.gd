extends Node


var network_player = preload("res://scenes/players/network_player.tscn")
var jeep = preload("res://scenes/vehicles/jeep.tscn")

# A room that player has joined. All player data is stored here.

"""
var data: Dictionary = {
	'pin': '', # Room pin
	'level': '', # Path of the level scene
	'laps': 0, # Number of laps
	'admin': '', # Admin player name
	'state': '', # Room state (in_lobby/in_game)
	'players': {
		# Player data
		# 'player_name': {
		# 	'position': Vector3,
		# 	'rotation': Vector3,
		# 	'vehicle': String,
		# 	'lap': int,
		# 	'timer': float,
		# 	'finished': bool,
		# }
	}, # Players in the room
}



func set_player_data(player_name: String, new_data: Dictionary):
	# Update player data
	data['players'][player_name] = new_data


func get_player_data(player_name: String) -> Dictionary:
	# Get player data
	return data['players'][player_name]


func set_room_attribute(attribute: String, value):
	#If attribute is not in the data, show error
	if data.has(attribute):
		data[attribute] = value
	else:
		print('Error: Attribute "'+ str(attribute) +'" not found in room data')


func get_room_attribute(attribute: String):
	if data.has(attribute):
		return data[attribute]
	else:
		print('Error: Attribute "'+ str(attribute) +'" not found in room data')
		return null

"""




var pin: String = '' # Room pin
var level: String = '' # Path of the level scene
var laps: int = 0 # Number of laps
var admin: String = '' # Admin player name
var state: String = '' # Room state (in_lobby/in_game)

# Actual Player() instances go here
var players: Array[Player] = [] # Players in the room
var human_player: HumanPlayer # current human player in room


const IN_LOBBY: int = 100
const IN_GAME: int  = 200


#>
#>


func _process(delta):
	update_room_variables()
	print((data['players']as Dictionary).size())
	"""
	# Make requests to server per-frame !TODO
	# For now, mimic server locally: NOW IT HAS BEEN CHAGNED TO INT
	if players.size() == 1:
		admin = players[0].name
	if players.size() > 0 and state == -1:
		state = IN_LOBBY
	"""


# If player already exists in the room, update its value to new value
func set_human_player(player: HumanPlayer):
	for i in range(players.size()):
		if players[i].name == player.name:
			players[i] = player # If already exists, refresh
			data['players'][player.name] = player.get_data_dict()
			return
	# If player does not exist, add it to the room
	players.append(player)
	data['players'][player.name] = player.get_data_dict()


# Get current human player in the room
func get_human_player():
	return human_player


func join_room(_pin:String, player:HumanPlayer):
	pin = _pin
	human_player = player
	set_human_player(player)
	
	var req_data = { 'data': data } # Send room data to server
	Backyard.fetch_unique('/joinroom/'+pin, req_data)


func start_game():
	var req_data = {
		'name': get_human_player().name,
	}
	Backyard.fetch_unique('/startgame/'+pin, req_data)


#>
#>

var data: Dictionary = {
	'pin': '', # Room pin
	'level': '', # Path of the level scene
	'laps': 0, # Number of laps
	'admin': '', # Admin player name
	'state': '', # Room state (in_lobby/in_game)
	'players': {
		# Player data
		# 'player_name': {
		# 	'position': Vector3,
		# 	'rotation': Vector3,
		# 	'vehicle': String,
		# 	'lap': int,
		# 	'timer': float,
		# 	'finished': bool,
		# }
	}, # Players in the room
}

func get_data_dict():
	return data

func update_room_variables():
	pin = data['pin']
	level = data['level']
	laps = data['laps']
	admin = data['admin']
	state = data['state']

	for player_name in data['players']:
		if player_name == Room.get_human_player().name:
			continue
			for player in players: # For existing players
				if player.name == player_name:
					player.update_data_dict(data['players'][player_name])
					break
	
	# If player does not exist in players, but exists in data['players']
	# Then add it to players or update its state if already added
	for player in players:
		if player.name == Room.get_human_player().name: continue
		for player_name in data['players']:
			if player_name == player.name:
				break # ! TODO: BREAK OR UPDATE STATE???
			else:
				var _network_player = network_player.instantiate()
				var _vehicle = jeep.instantiate()
				_network_player.add_child(_vehicle)
				players.append(_network_player) # Add _network_player to players
				
