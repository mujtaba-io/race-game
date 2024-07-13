extends Node3D
class_name Level


@export var track: Path3D # all levels will have a track node named 'track'
@export var checkpoint: Area3D # lap counter/checkpoint


var _players: Array[Player]
var _number_laps: int


const MAX_RACE_COUNTDOWN := 1 # How many seconds after which race begins
var race_countdown: float = MAX_RACE_COUNTDOWN
var is_race_started: bool = false


var level_ui: Control


# Constructor
func with_data(players: Array[Player], number_laps: int):
	self._players = players
	self._number_laps = number_laps
	return self


# Called when the node enters the scene tree for the first time.
func _ready():
	checkpoint.body_entered.connect(_on_checkpoint_body_entered)
	(checkpoint as Area3D).collision_mask = 0b1111111111111111 # Make it scan all collision layers
	spawn_players() # Spawn all players from 
	pause_players_process()
	
	level_ui = SceneManager.load_scene("res://Levels/UI/LevelUI.tscn")
	add_child(level_ui)


func spawn_players():
	var index: int = 0
	for player in _players:
		player.vehicle.position = get_tree().get_nodes_in_group("spawn_points")[index].global_position
		player.vehicle.look_at_from_position(player.vehicle.position, player.vehicle.position - get_track_direction(checkpoint.global_position), Vector3.UP)
		
		if player is AIPlayer:
			player.set_track(track)
		add_child(player)
		
		index += 1


func _on_checkpoint_body_entered(body):
	if not (body is Vehicle3D): return
	var player := body.get_parent() as Player
	
	if (player.get_distance_traveled() / (player.lap + 1)) >= 0.88 * get_track_length():
			player.next_lap()
			if player.lap >= _number_laps:
				player.finished = true


func get_track_length():
	return track.curve.get_baked_length()


func get_track_direction(at_position: Vector3):
	var offset := track.curve.get_closest_offset( at_position )
	var point_1 := track.curve.sample_baked( offset, true )
	var point_2 := track.curve.sample_baked( offset + 0.5, true )
	var direction : Vector3 = ( point_2 - point_1 ).normalized()
	return direction



func _process(delta):
	if not is_race_started:
		if race_countdown < 0:
			is_race_started = true
			resume_players_process()
	else:
		if race_countdown < -1:
			level_ui.visible = false
	race_countdown -= delta
	
	if race_countdown > 0:
		level_ui.set_countdown_text(str(floor(race_countdown + 1)))
	else:
		level_ui.set_countdown_text("GO!")


func pause_players_process():
	for p in get_tree().get_nodes_in_group("players"):
		p.set_process(false)
		p.set_physics_process(false)


func resume_players_process():
	for p in get_tree().get_nodes_in_group("players"):
		p.set_process(true)
		p.set_physics_process(true)
