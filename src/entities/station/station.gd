extends Area2D
class_name Station

var random = RandomNumberGenerator.new()

func take_cargo() -> void:
	if random.randi() % 100 > 75:
		PlayerData.current_trains += 1
	else:
		PlayerData.current_tracks += 20
	PlayerData.player_data_changed.emit()
