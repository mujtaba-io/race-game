extends Node


func _ready():
	# Create an HTTP request node and connect its completion signal.
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)



func _process(delta):
	if Room.state != '':
		var req_data = {
			'name': Room.get_human_player().name,
			'data': Room.get_human_player().get_data_dict(),
		}
		fetch('/updateplayerdata/' + Room.pin, req_data)


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
	
	if response != null:
		# TODO: MUST NOT UPDATE STATE OF CURRENT HUMAN PLAYER
		Room.data = response
	
	is_requesting = false






# called when we have to call unrelated request from normal
#series of state updating requests. - creates a separate
# httprequest object for this.

func fetch_unique(endpoint: String, data: Dictionary):
	var http_request_unique: HTTPRequest = HTTPRequest.new()
	add_child(http_request_unique)
	http_request_unique.request_completed.connect(self._unique_http_request_completed)
	var uri := domain + endpoint + '/'
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
	
	if response != null:
		Room.data = response
