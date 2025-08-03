extends Node

var current_tracks: int = 0
var current_trains: int = 0

var stat_time_elapsed: float = 0
var stat_loads_completed: int = 0
var stat_tracks_placed: int = 0
var stat_trains_placed: int = 0
var stat_trains_distance_moved: int = 0

var level_ups = 0

signal player_data_changed

func reset_game() -> void:
	current_tracks = 30
	current_trains = 1
	level_ups = 0
	
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
		+ (stat_tracks_placed * 5) \
		- (stat_trains_placed * 100) \
		+ (stat_loads_completed * 200)

func handle_build() -> void:
	current_tracks -= 1
	stat_tracks_placed += 1
	player_data_changed.emit()
	
func handle_level_up() -> void:
	level_ups += 1
	player_data_changed.emit()

func handle_make_train() -> void:
	current_trains -= 1
	stat_trains_placed += 1
	player_data_changed.emit()
	
func handle_recycle_trains() -> void:
	current_trains += 1
	player_data_changed.emit()

func handle_recycle() -> void:
	current_tracks += 1
	player_data_changed.emit()
