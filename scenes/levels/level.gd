extends Node3D
class_name Level

# instead use library/dict of all preloaded stuff and use from there
var human_player_scn = preload("res://scenes/players/human_player.tscn")
var network_player_scn = preload("res://scenes/players/network_player.tscn")
var vehicle_scn = preload("res://scenes/cars/jeep.tscn")


# list of all players (whether human, network or AI)
var players: Dictionary  = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	for player_name in global_script.room_state['players']:
		if player_name == global_script.our_player_name:
			var human_player = human_player_scn.instantiate()
			human_player.player_name = player_name
			var vehicle = vehicle_scn.instantiate()
			vehicle.add_child(human_player)
			self.add_child(vehicle)
			players[player_name] = human_player # to access vehicle, always get_parent() of player
		else:
			var network_player = network_player_scn.instantiate()
			network_player.player_name = player_name
			var vehicle = vehicle_scn.instantiate()
			vehicle.add_child(network_player)
			self.add_child(vehicle)
			players[player_name] = network_player


func _process(delta):
	on_new_player_added()


func on_new_player_added():
	for player_name in global_script.room_state['players']:
		if player_name in players:
			if player_name == global_script.our_player_name:
				var human_player = human_player_scn.instantiate()
				var vehicle = vehicle_scn.instantiate()
				vehicle.add_child(human_player)
				self.add_child(vehicle)
				players[player_name] = human_player # to access vehicle, always get_parent() of player
			else:
				var network_player = network_player_scn.instantiate()
				self.add_child(network_player)
				players[player_name] = network_player

