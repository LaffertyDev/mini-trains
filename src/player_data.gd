extends Node

var current_tracks_horizontal: int = 0
var current_tracks_vertical: int = 0
var current_tracks_junctions_90: int = 0
var current_tracks_junctions_x: int = 0
var current_trains: int = 0

var stat_time_elapsed: float = 0
var stat_loads_completed: int = 0
var stat_tracks_placed: int = 0
var stat_trains_placed: int = 0
var stat_trains_distance_moved: int = 0

signal player_data_changed

func reset_game() -> void:
	current_tracks_horizontal = 5
	current_tracks_vertical = 5
	current_tracks_junctions_x = 3
	current_tracks_junctions_90 = 3
	current_trains = 1
	
	stat_time_elapsed = 0
	stat_loads_completed = 0
	stat_tracks_placed = 0
	stat_trains_placed = 0
	stat_trains_distance_moved = 0
	
func _process(delta: float) -> void:
	stat_time_elapsed += delta
	
func compute_score() -> int:
	return \
		int(floor((stat_time_elapsed * 10))) \
		+ stat_trains_distance_moved \
		+ (stat_tracks_placed * 10) \
		+ (stat_trains_placed * 100) \
		+ (stat_loads_completed * 10)

func handle_build(build_type: Constants.BuildOptions) -> void:
	match build_type:
		Constants.BuildOptions.RAIL_VERTICAL:
			PlayerData.current_tracks_vertical -= 1
			stat_tracks_placed += 1
		Constants.BuildOptions.RAIL_HORIZONTAL:
			PlayerData.current_tracks_horizontal -= 1
			stat_tracks_placed += 1
		Constants.BuildOptions.RAIL_JUNCTION_X:
			PlayerData.current_tracks_junctions_x -= 1
			stat_tracks_placed += 1
		Constants.BuildOptions.RAIL_JUNCTION_90:
			PlayerData.current_tracks_junctions_90 -= 1
			stat_tracks_placed += 1
		Constants.BuildOptions.TRAIN:
			PlayerData.current_trains -= 1
			stat_trains_placed += 1
	player_data_changed.emit()

func handle_recycle(piece: Constants.GridType) -> void:
	match piece:
		Constants.GridType.RAIL_VERTICAL:
			current_tracks_vertical += 1
		Constants.GridType.RAIL_HORIZONTAL:
			current_tracks_horizontal += 1
		Constants.GridType.RAIL_JUNCTION_X:
			current_tracks_junctions_x += 1
		Constants.GridType.RAIL_JUNCTION_90:
			current_tracks_junctions_90 += 1
	player_data_changed.emit()
