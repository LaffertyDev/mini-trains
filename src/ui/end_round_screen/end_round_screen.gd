extends Node

func _ready() -> void:
	%stat_time.text = str(PlayerData.stat_time_elapsed).pad_decimals(1)
	%stat_loads.text = str(PlayerData.stat_loads_completed)
	%stat_trains_placed.text = str(PlayerData.stat_trains_placed)
	%stat_tracks_placed.text = str(PlayerData.stat_tracks_placed)
	%stat_distance.text = str(PlayerData.stat_trains_distance_moved)
	%stat_score.text = str(PlayerData.compute_score())
	
	GlobalAudio.cancel_sound_doom_completely() # just in case

func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_file("res://src/game.tscn")
