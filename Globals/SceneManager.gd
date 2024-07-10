extends Node

"""
!! USAGE:

APPROACH 1:

var level = SceneManager.load_scene("mylevel_path")
level.xyz
SceneManager.switch_scene(level)

APPROACH 2 (if function to be called dfrom scene):
SceneManager.switch_scene(
	SceneManager.load_scene("mylevel_path").with_data(myvar1, myvar2)
)
"""


var _current_scene: Node


func _ready():
	_current_scene = get_tree().current_scene


func load_scene(scene_path: String):
	var new_scn = load(scene_path).instantiate() # load new scene
	return new_scn


func switch_scene(new_scene: Node):
	if _current_scene: # if old exists
		_current_scene.queue_free() # remove it
	_current_scene = new_scene
	get_tree().root.add_child(new_scene)

