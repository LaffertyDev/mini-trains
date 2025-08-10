extends Control
class_name GuiController

func _process(_delta: float) -> void:
	#%label_time.text = str(PlayerData.stat_time_elapsed).pad_decimals(1)
	%label_score.text = str(PlayerData.compute_score())
	%label_tracks_placed.text = str(PlayerData.stat_tracks_placed)
	%label_trains_placed.text = str(PlayerData.stat_trains_placed)
	%label_distance.text = str(PlayerData.stat_trains_distance_moved)
	%label_loads.text = str(PlayerData.stat_loads_completed)


func sync_gui(animate: bool):
	%rail_label.text = str(PlayerData.current_tracks)
	%train_label.text = str(PlayerData.current_trains)
	
	if animate:
		var rail_tween_color = get_tree().create_tween()
		rail_tween_color.tween_property(%rail_label, "modulate", Color.RED, 0.3).set_trans(Tween.TRANS_LINEAR)
		rail_tween_color.tween_property(%rail_label, "modulate", Color.WHITE, 0.7).set_trans(Tween.TRANS_LINEAR)
		
		var rail_tween_size = get_tree().create_tween()
		rail_tween_size.tween_property(%rail_label, "scale", Vector2(1.3, 1.3), 0.3).set_trans(Tween.TRANS_LINEAR)
		rail_tween_size.tween_property(%rail_label, "scale", Vector2(1, 1), 0.3).set_trans(Tween.TRANS_LINEAR)
		
		var train_tween_color = get_tree().create_tween()
		train_tween_color.tween_property(%train_label, "modulate", Color.RED, 0.3).set_trans(Tween.TRANS_LINEAR)
		train_tween_color.tween_property(%train_label, "modulate", Color.WHITE, 0.7).set_trans(Tween.TRANS_LINEAR)

		var train_tween_size = get_tree().create_tween()
		train_tween_size.tween_property(%train_label, "scale", Vector2(1.3, 1.3), 0.3).set_trans(Tween.TRANS_LINEAR)
		train_tween_size.tween_property(%train_label, "scale", Vector2(1, 1), 0.3).set_trans(Tween.TRANS_LINEAR)

func handle_pause():
	%pause_label.show()
	%pause_texture.show()
	
func handle_unpause():
	%pause_label.hide()
	%pause_texture.hide()
