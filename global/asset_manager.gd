extends Node


# Access: levels['level1'] = resource_path
var levels: Dictionary = {
}

# Access: vehicles['vehicle1'] = resource_path
var vehicles: Dictionary = {
}


# INTERNAT USE ONLY
@export var _levels: Array[Resource] = []
@export var _vehicles: Array[Resource] = []

func _ready():
	for level in _levels:
		var level_name = get_file_name(level.resource_path)
		AssetManager.levels[level_name] = level.resource_path
	for vehicle in _vehicles:
		var vehicle_name = get_file_name(vehicle.resource_path)
		AssetManager.vehicles[vehicle_name] = vehicle.resource_path
	
	# Delete _levels and _vehicles to clear memory
	_levels = []
	_vehicles = []



func get_file_name(filePath: String) -> String:
	var slashIndex = filePath.rfind("/")
	var dotIndex = filePath.rfind(".")
	if slashIndex != -1 and dotIndex != -1:
		return filePath.substr(slashIndex + 1, dotIndex - slashIndex - 1)
	else:
		return ""
