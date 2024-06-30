extends Node3D
class_name Level


@export var track: Path3D # all levels will have a track node named 'track'
@export var checkpoint: Area3D # lap counter/checkpoint


# Called when the node enters the scene tree for the first time.
func _ready():
	checkpoint.body_entered.connect(_on_checkpoint_body_entered)
	
	# Spawn all players from room
	spawn_players()


func spawn_players():
	for player in Room.players:
		if not (player in self.get_children()):
			add_child(player)
			player.vehicle.global_position = checkpoint.global_position + Vector3(randf_range(-2, 2), 2, randf_range(-2, 2))


func _on_checkpoint_body_entered(body):
	if not (body is Vehicle3D): return
	var player = body.get_parent()
	player.trigger_next_lap(get_track_length())



func get_track_length():
	return track.curve.get_baked_length()
