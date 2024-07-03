extends Node3D
class_name Level


var human_player = preload("res://scenes/players/human_player.tscn")
var network_player = preload("res://scenes/players/network_player.tscn")

var jeep = preload("res://scenes/vehicles/jeep.tscn")

@export var track: Path3D # all levels will have a track node named 'track'
@export var checkpoint: Area3D # lap counter/checkpoint

@export var track_initial_direction: Marker3D # initial forward direction of track


# Called when the node enters the scene tree for the first time.
func _ready():
	checkpoint.body_entered.connect(_on_checkpoint_body_entered)
	
	# Spawn all players from room
	spawn_players()

func _process(delta):
	spawn_players() # in-game spawn

func spawn_players():
	var children_names: Array[String] = []
	for child in self.get_children():
		children_names.append(child.name)
	
	for player_name in Room.data['players']:
		if not (player_name in children_names):
			if player_name == Room.human_player.name:
				add_child(Room.human_player)
				Room.human_player.vehicle.global_position = checkpoint.global_position + Vector3(randf_range(-4, 4), 2, randf_range(-4, 4))
				Room.human_player.vehicle.rotation.y = track_initial_direction.rotation.y
			else:
				var player := network_player.instantiate()
				player.name = player_name
				player.set_vehicle(
					load(Room.data['players'][player_name]['vehicle']).instantiate()
					)
				add_child(player)
				player.vehicle.global_position = checkpoint.global_position + Vector3(randf_range(-4, 4), 2, randf_range(-4, 4))
				player.vehicle.rotation.y = track_initial_direction.rotation.y

func _on_checkpoint_body_entered(body):
	if not (body is Vehicle3D): return
	var player = body.get_parent()
	player.trigger_next_lap(get_track_length())



func get_track_length():
	return track.curve.get_baked_length()
