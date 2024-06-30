extends Node3D
class_name Level


var human_player = preload("res://scenes/players/human_player.tscn")
var network_player = preload("res://scenes/players/network_player.tscn")

var jeep = preload("res://scenes/vehicles/jeep.tscn")

@export var track: Path3D # all levels will have a track node named 'track'
@export var checkpoint: Area3D # lap counter/checkpoint


# Called when the node enters the scene tree for the first time.
func _ready():
	checkpoint.body_entered.connect(_on_checkpoint_body_entered)
	
	# Spawn all players from room
	spawn_players()


func spawn_players():
	var children_names: Array[String] = []
	for child in self.get_children():
		children_names.append(child.name)
	
	for player_name in Room.data['players']:
		if not (player_name in children_names): # ! BUG: 	its children's name; not children itself
			if player_name == Room.human_player_name:
				var player := human_player.instantiate()
				player.name = player_name
				player.set_vehicle(jeep.instantiate())
				add_child(player)
				player.vehicle.global_position = checkpoint.global_position + Vector3(randf_range(-2, 2), 2, randf_range(-2, 2))
			else:
				var player := network_player.instantiate()
				player.name = player_name
				player.set_vehicle(jeep.instantiate())
				add_child(player)
				player.vehicle.global_position = checkpoint.global_position + Vector3(randf_range(-2, 2), 2, randf_range(-2, 2))


func _on_checkpoint_body_entered(body):
	if not (body is Vehicle3D): return
	var player = body.get_parent()
	player.trigger_next_lap(get_track_length())



func get_track_length():
	return track.curve.get_baked_length()
