extends Node

# globals
var our_player_name: String
var room_pin: String

"""
STRUCTURE OF STATE DICT:
var room_state: Dictionary = {
	'players': {
		'e4gve_uid': {
			'name': x,
			'position': x,
			.. more car variables
		},
		'5gfggd_uid': {
			'name': y,
			'position': y,
			.. more car variables
		},
		... more players
	},
	'game': {
		'admin_name': one f player names,
		'state': 'in_lobby'/'in_game'/'loading_level'/'checking_winners',
		'map': selected-level-map,
	},
}
"""

var room_state : Dictionary = {
	'players': {},
	'game': {
		'map': '',
		'state': '', # in_lobby/ready/in_game
		'admin': '',
		'time_left': '',
	},
}


func push_player_state(player_name: String, new_state: Dictionary):
	# update locally (unnecessary as it will be overrided by server changes)
	# + we dont giv fuk to our state here, it is to send to server only
	room_state['players'][player_name] = new_state
	# then update server with new state
	fetch('/room/'+room_pin, {
		'player_name': player_name,
		'player_state': new_state,
	})
	

func pull_player_state(player_name: String):
	# fetch player state from server
	# NETWORK PLAYER MUST NEVER UPDATE ITS STATE TO SERVER
	fetch('/room/'+room_pin, {})# MAKE GET REQUEST
	# for now, send old state, but when response will arrive,
	# next requests will return refreshed data
	return room_state['players'][player_name]



func _ready():
	# Create an HTTP request node and connect its completion signal.
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)


func join_room():
	# api:- name:state for player to be put in rooms:players
	fetch_unique('/join/' + room_pin, {
		'player_name': our_player_name,
	})


func trigger_start_game():
	fetch_unique(
		"/start/"+room_pin,
		{"player_name": our_player_name} # who gave the command (must be admin)
		)


#>
#>
#>


# PROTOCOL: ALWAYS START endpoint WITH / AND END WITHOUT SLASH (/get, /post, /pin)
var domain: String = "http://127.0.0.1:7860" #!! never end with slash
var http_request: HTTPRequest
var is_requesting: bool = false

func fetch(endpoint: String, data: Dictionary):
	if is_requesting:
		return
	
	var uri := domain + endpoint + '/'
	print(uri)
	# Perform a GET request. The URL below returns JSON as of writing.
	is_requesting = true
	if data.is_empty():
		var error = http_request.request(uri, ['Content-Type: application/json'])
		if error != OK:
			push_error("An error occurred in the HTTP request.")
	else:
		var body = JSON.new().stringify(data)
		var error = http_request.request(uri, ['Content-Type: application/json'], HTTPClient.METHOD_POST, body)
		if error != OK:
			push_error("An error occurred in the HTTP request.")

# Called when the HTTP request is completed.
func _http_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()

	# Will print the user agent string used by the HTTPRequest node (as recognized by httpbin.org).
	print(response)
	# TODO: WRITE RESPNSE TO state to be able to work on it
	
	if response != null:
		# TODO: MUST NOT UPDATE STATE OF CURRENT HUMAN PLAYER
		room_state = response
	
	is_requesting = false






# called when we have to call unrelated request from normal
#series of state updating requests. - creates a separate
# httprequest object for this.

func fetch_unique(endpoint: String, data: Dictionary):
	var http_request_unique: HTTPRequest = HTTPRequest.new()
	add_child(http_request_unique)
	http_request_unique.request_completed.connect(self._unique_http_request_completed)
	var uri := domain + endpoint + '/'
	print(uri)
	# Perform a GET request. The URL below returns JSON as of writing.
	if data.is_empty():
		var error = http_request_unique.request(uri, ['Content-Type: application/json'])
		if error != OK:
			push_error("An error occurred in the HTTP request.")
	else:
		var body = JSON.new().stringify(data)
		var error = http_request_unique.request(uri, ['Content-Type: application/json'], HTTPClient.METHOD_POST, body)
		if error != OK:
			push_error("An error occurred in the HTTP request.")

# Called when the HTTP request is completed.
func _unique_http_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()

	# Will print the user agent string used by the HTTPRequest node (as recognized by httpbin.org).
	print(response)
	# TODO: WRITE RESPNSE TO state to be able to work on it
	
	if response != null:
		room_state = response

