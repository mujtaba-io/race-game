extends Node3D
class_name Level

# instead use library/dict of all preloaded stuff and use from there
var human_player_scn = preload("res://scenes/players/human_player.tscn")
var network_player_scn = preload("res://scenes/players/network_player.tscn")
var vehicle_scn = preload("res://scenes/cars/jeep.tscn")


# list of all players (whether human, network or AI)
var players: Dictionary  = {}


@export var track: Path3D # all levels will have a track node named 'track'

# Called when the node enters the scene tree for the first time.
func _ready():
	for player_name in global_script.room_state['players']:
		if player_name == global_script.our_player_name:
			var human_player = human_player_scn.instantiate()
			human_player.player_name = player_name
			var vehicle = vehicle_scn.instantiate()
			vehicle.add_child(human_player)
			add_vehicle_to_correct_spawn_point(vehicle)
			self.add_child(vehicle)
			players[player_name] = human_player # to access vehicle, always get_parent() of player
		else:
			var network_player = network_player_scn.instantiate()
			network_player.player_name = player_name
			var vehicle = vehicle_scn.instantiate()
			vehicle.add_child(network_player)
			add_vehicle_to_correct_spawn_point(vehicle)
			self.add_child(vehicle)
			players[player_name] = network_player
	
	track = $track



func _process(delta):
	on_new_player_added()


func on_new_player_added():
	for player_name in global_script.room_state['players']:
		var player_state = global_script.room_state['players'][player_name]
		if player_name not in players:
			if player_name == global_script.our_player_name:
				var human_player = human_player_scn.instantiate()
				var vehicle = vehicle_scn.instantiate()
				vehicle.add_child(human_player)
				add_vehicle_to_correct_spawn_point(vehicle)
				self.add_child(vehicle)
				players[player_name] = human_player # to access vehicle, always get_parent() of player
			else:
				var network_player = network_player_scn.instantiate()
				var vehicle = vehicle_scn.instantiate()
				vehicle.add_child(network_player)
				add_vehicle_to_correct_spawn_point(vehicle)
				self.add_child(vehicle)
				players[player_name] = network_player


# THIS FUNCTION MUST BE CALLED AFTER SERVER HAS ASSIGNED SPAWN POINT!!!
# HOPEFULLY, SERVER DOES AFTER JOINING LOBBY
func add_vehicle_to_correct_spawn_point(vehicle):
	vehicle.position = $track/lap_counter.position
	+ Vector3(randf_range(-2, 2), 2, randf_range(-2, 2))



# total distance of track
func get_total_track_distance():
	return track.curve.get_baked_length()




func get_player_from_body(body) -> Player:
	for player_name in players:
		if players[player_name].get_parent() == body:
			return players[player_name]
	return null


# TODO: DOES NOT WORK, MAKE IT WORK.. JUST LOGIC WRITTEN FILHAL
# whenever a cer enters it, it has completed a lap
func _on_lap_counter_body_entered(body):
	#check if player distance traveled is at least 0.8 of total track distance
	# if yes, increment lap counter
	# if lap counter is equal to total laps, set player_state['finished'] = true
	var player = get_player_from_body(body) # GET PLAYER FROM vehicle
	# either the body is not player or player does not exist:
	if player == null: return
	
	var player_state = global_script.room_state['players'][player.player_name]

	if player_state['finished'] == false:
		var distance_traveled = player.get_distance_traveled()
		var total_track_distance = get_total_track_distance()
		if distance_traveled >= 0.8 * total_track_distance:
			player_state['lap'] += 1
			print("LAP OF PLAYER "+str(player.player_name)+" NCREMENTED TO"+ str(player_state['lap']))
			if player_state['lap'] >= global_script.room_state['game']['total_laps']:
				player_state['finished'] = true
				print("PLAYER "+str(player.player_name)+"  FINISHED THE RAEC.")
