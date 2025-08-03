extends Area2D
class_name Station

func take_cargo() -> void:
	GlobalAudio.play_sound_cargo_dropoff()
	PlayerData.stat_loads_completed += 1
	PlayerData.broadcast_change(false)
	
	var game_controller = get_tree().get_nodes_in_group("game_controller")[0]
	game_controller.on_load_dropoff()
	
