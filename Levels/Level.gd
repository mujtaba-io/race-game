extends Node3D
class_name Level


@export var track: Path3D # all levels will have a track node named 'track'
@export var checkpoint: Area3D # lap counter/checkpoint


@export var track_initial_direction: Marker3D # initial forward direction of track


var _players: Array[Player]
var _number_laps: int


func with_data(players: Array[Player], number_laps: int):
	self._players = players
	self._number_laps = number_laps
	return self


# Called when the node enters the scene tree for the first time.
func _ready():
	checkpoint.body_entered.connect(_on_checkpoint_body_entered)
	spawn_players() # Spawn all players from 


func spawn_players():
	for player in _players:
		player.vehicle.position = checkpoint.global_position + Vector3(randf_range(-4, 4), 2, randf_range(-4, 4))
		player.vehicle.rotation.y = track_initial_direction.rotation.y
		add_child(player)


func _on_checkpoint_body_entered(body):
	if not (body is Vehicle3D): return
	var player = body.get_parent()
	player.next_lap()


func get_track_length():
	return track.curve.get_baked_length()


